Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZKMNAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZKMNAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZKMNAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:00:04 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:51547 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbZKMM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:59:53 -0500
Date: Fri, 13 Nov 2009 07:58:12 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [PATCH] make crypto unplug fix V3
Message-ID: <20091113125812.GB7891@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
	Sven Geggus <lists@fuchsschwanzdomain.de>,
	Karol Lewandowski <karol.k.lewandowski@gmail.com>,
	Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Rik van Riel <riel@redhat.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <1258054211-2854-1-git-send-email-mel@csn.ul.ie>
 <20091112202748.GC2811@think>
 <20091112220005.GD2811@think>
 <20091113024642.GA7771@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113024642.GA7771@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AFD57FC.00D3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is still likely to set your dm data on fire.  It is only meant for
testers that start with mkfs and don't have any valuable dm data.

It includes my patch from last night, along with changes to force dm to
unplug when its IO queues empty.

The problem goes like this:

Process: submit read bio
dm: put bio onto work queue
process: unplug
dm: work queue finds bio, does a generic_make_request

The end result is that we miss the unplug completely.  dm-crypt needs to
unplug for sync bios.  This patch also changes it to unplug whenever the
queue is empty, which is far from ideal but better than missing the
unplugs.

This doesn't completely fix io stalls I'm seeing with dm-crypt, but its
my best guess.  If it works, I'll break it up and submit for real to
the dm people.

-chris

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ed10381..729ae01 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -94,8 +94,12 @@ struct crypt_config {
 	struct bio_set *bs;
 
 	struct workqueue_struct *io_queue;
+	struct workqueue_struct *async_io_queue;
 	struct workqueue_struct *crypt_queue;
 
+	atomic_t sync_bios_in_queue;
+	atomic_t async_bios_in_queue;
+
 	/*
 	 * crypto related data
 	 */
@@ -679,11 +683,29 @@ static void kcryptd_io_write(struct dm_crypt_io *io)
 static void kcryptd_io(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->target->private;
+	int zero_sync = 0;
+	int zero_async = 0;
+	int was_sync = 0;
+
+	if (io->base_bio->bi_rw & (1 << BIO_RW_SYNCIO)) {
+		zero_sync = atomic_dec_and_test(&cc->sync_bios_in_queue);
+		was_sync = 1;
+	} else
+		zero_async = atomic_dec_and_test(&cc->async_bios_in_queue);
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_io_read(io);
 	else
 		kcryptd_io_write(io);
+
+	if ((was_sync && zero_sync) ||
+	    (!was_sync && zero_async &&
+	     atomic_read(&cc->sync_bios_in_queue) == 0)) {
+		struct backing_dev_info *bdi;
+		bdi = blk_get_backing_dev_info(io->base_bio->bi_bdev);
+		blk_run_backing_dev(bdi, NULL);
+	}
 }
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
@@ -691,7 +713,13 @@ static void kcryptd_queue_io(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_io);
-	queue_work(cc->io_queue, &io->work);
+	if (io->base_bio->bi_rw & (1 << BIO_RW_SYNCIO)) {
+		atomic_inc(&cc->sync_bios_in_queue);
+		queue_work(cc->io_queue, &io->work);
+	} else {
+		atomic_inc(&cc->async_bios_in_queue);
+		queue_work(cc->async_io_queue, &io->work);
+	}
 }
 
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
@@ -759,8 +787,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
 		/* Encryption was already finished, submit io now */
 		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, r, 0);
-
+			kcryptd_crypt_write_io_submit(io, r, 1);
 			/*
 			 * If there was an error, do not try next fragments.
 			 * For async, error is processed in async handler.
@@ -1120,6 +1147,15 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	} else
 		cc->iv_mode = NULL;
 
+	atomic_set(&cc->sync_bios_in_queue, 0);
+	atomic_set(&cc->async_bios_in_queue, 0);
+
+	cc->async_io_queue = create_singlethread_workqueue("kcryptd_async_io");
+	if (!cc->async_io_queue) {
+		ti->error = "Couldn't create kcryptd io queue";
+		goto bad_async_io_queue;
+	}
+
 	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
@@ -1139,6 +1175,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad_crypt_queue:
 	destroy_workqueue(cc->io_queue);
 bad_io_queue:
+	destroy_workqueue(cc->async_io_queue);
+bad_async_io_queue:
 	kfree(cc->iv_mode);
 bad_ivmode_string:
 	dm_put_device(ti, cc->dev);
@@ -1166,6 +1204,7 @@ static void crypt_dtr(struct dm_target *ti)
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
 	destroy_workqueue(cc->io_queue);
+	destroy_workqueue(cc->async_io_queue);
 	destroy_workqueue(cc->crypt_queue);
 
 	if (cc->req)
