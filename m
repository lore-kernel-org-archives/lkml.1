Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZKMCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZKMCsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZKMCsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:48:36 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:36533 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZKMCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:48:35 -0500
Date: Thu, 12 Nov 2009 21:46:42 -0500
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
Subject: Re: [PATCH 0/7] Reduce GFP_ATOMIC allocation failures, candidate
 fix V3
Message-ID: <20091113024642.GA7771@think>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112220005.GD2811@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AFCC899.018B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 05:00:05PM -0500, Chris Mason wrote:

[ ...]

> 
> The punch line is that the btrfs guy thinks we can solve all of this with
> just one more thread.  If we change dm-crypt to have a thread dedicated
> to sync IO and a thread dedicated to async IO the system should smooth
> out.

This is pretty likely to set your dm data on fire.  It's only for Mel
who starts his script w/mkfs.

It adds the second thread and more importantly makes sure the kcryptd
thread doesn't get stuck waiting for requests.

-chris

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ed10381..295ffeb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -94,6 +94,7 @@ struct crypt_config {
 	struct bio_set *bs;
 
 	struct workqueue_struct *io_queue;
+	struct workqueue_struct *async_io_queue;
 	struct workqueue_struct *crypt_queue;
 
 	/*
@@ -691,7 +692,10 @@ static void kcryptd_queue_io(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_io);
-	queue_work(cc->io_queue, &io->work);
+	if (io->base_bio->bi_rw & (1 << BIO_RW_SYNCIO))
+		queue_work(cc->io_queue, &io->work);
+	else
+		queue_work(cc->async_io_queue, &io->work);
 }
 
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
@@ -759,8 +763,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
 		/* Encryption was already finished, submit io now */
 		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, r, 0);
-
+			kcryptd_crypt_write_io_submit(io, r, 1);
 			/*
 			 * If there was an error, do not try next fragments.
 			 * For async, error is processed in async handler.
@@ -1120,6 +1123,12 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	} else
 		cc->iv_mode = NULL;
 
+	cc->async_io_queue = create_singlethread_workqueue("kcryptd_async_io");
+	if (!cc->async_io_queue) {
+		ti->error = "Couldn't create kcryptd io queue";
+		goto bad_async_io_queue;
+	}
+
 	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
@@ -1139,6 +1148,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad_crypt_queue:
 	destroy_workqueue(cc->io_queue);
 bad_io_queue:
+	destroy_workqueue(cc->async_io_queue);
+bad_async_io_queue:
 	kfree(cc->iv_mode);
 bad_ivmode_string:
 	dm_put_device(ti, cc->dev);
@@ -1166,6 +1177,7 @@ static void crypt_dtr(struct dm_target *ti)
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
 	destroy_workqueue(cc->io_queue);
+	destroy_workqueue(cc->async_io_queue);
 	destroy_workqueue(cc->crypt_queue);
 
 	if (cc->req)
