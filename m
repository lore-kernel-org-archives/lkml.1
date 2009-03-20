Return-Path: <linux-kernel-owner+w=401wt.eu-S1762710AbZCTXb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710AbZCTXb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761950AbZCTXYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:35 -0400
Received: from kroah.org ([198.145.64.141]:48603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762940AbZCTXYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:25 2009
Message-Id: <20090320222925.453417607@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 16/43] dm crypt: wait for endio to complete before destruction
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=dm-crypt-wait-for-endio-to-complete-before-destruction.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit b35f8caa0890169000fec22902290d9a15274cbd upstream.

The following oops has been reported when dm-crypt runs over a loop device.

...
[   70.381058] Process loop0 (pid: 4268, ti=cf3b2000 task=cf1cc1f0 task.ti=cf3b2000)
...
[   70.381058] Call Trace:
[   70.381058]  [<d0d76601>] ? crypt_dec_pending+0x5e/0x62 [dm_crypt]
[   70.381058]  [<d0d767b8>] ? crypt_endio+0xa2/0xaa [dm_crypt]
[   70.381058]  [<d0d76716>] ? crypt_endio+0x0/0xaa [dm_crypt]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<d0806530>] ? dec_pending+0x224/0x23b [dm_mod]
[   70.381058]  [<d08066e4>] ? clone_endio+0x79/0xa4 [dm_mod]
[   70.381058]  [<d080666b>] ? clone_endio+0x0/0xa4 [dm_mod]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<c02bad86>] ? loop_thread+0x380/0x3b7
[   70.381058]  [<c02ba8a1>] ? do_lo_send_aops+0x0/0x165
[   70.381058]  [<c013754f>] ? autoremove_wake_function+0x0/0x33
[   70.381058]  [<c02baa06>] ? loop_thread+0x0/0x3b7

When a table is being replaced, it waits for I/O to complete
before destroying the mempool, but the endio function doesn't
call mempool_free() until after completing the bio.

Fix it by swapping the order of those two operations.

The same problem occurs in dm.c with md referenced after dec_pending.
Again, we swap the order.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   17 ++++++++++-------
 drivers/md/dm.c       |   32 +++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 20 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -480,9 +480,12 @@ static int __noflush_suspending(struct m
 static void dec_pending(struct dm_io *io, int error)
 {
 	unsigned long flags;
+	int io_error;
+	struct bio *bio;
+	struct mapped_device *md = io->md;
 
 	/* Push-back supersedes any I/O errors */
-	if (error && !(io->error > 0 && __noflush_suspending(io->md)))
+	if (error && !(io->error > 0 && __noflush_suspending(md)))
 		io->error = error;
 
 	if (atomic_dec_and_test(&io->io_count)) {
@@ -492,25 +495,28 @@ static void dec_pending(struct dm_io *io
 			 * This must be handled before the sleeper on
 			 * suspend queue merges the pushback list.
 			 */
-			spin_lock_irqsave(&io->md->pushback_lock, flags);
-			if (__noflush_suspending(io->md))
-				bio_list_add(&io->md->pushback, io->bio);
+			spin_lock_irqsave(&md->pushback_lock, flags);
+			if (__noflush_suspending(md))
+				bio_list_add(&md->pushback, io->bio);
 			else
 				/* noflush suspend was interrupted. */
 				io->error = -EIO;
-			spin_unlock_irqrestore(&io->md->pushback_lock, flags);
+			spin_unlock_irqrestore(&md->pushback_lock, flags);
 		}
 
 		end_io_acct(io);
 
-		if (io->error != DM_ENDIO_REQUEUE) {
-			blk_add_trace_bio(io->md->queue, io->bio,
+		io_error = io->error;
+		bio = io->bio;
+
+		free_io(md, io);
+
+		if (io_error != DM_ENDIO_REQUEUE) {
+			blk_add_trace_bio(md->queue, io->bio,
 					  BLK_TA_COMPLETE);
 
-			bio_endio(io->bio, io->error);
+			bio_endio(bio, io_error);
 		}
-
-		free_io(io->md, io);
 	}
 }
 
@@ -518,6 +524,7 @@ static void clone_endio(struct bio *bio,
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
+	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
@@ -541,15 +548,14 @@ static void clone_endio(struct bio *bio,
 		}
 	}
 
-	dec_pending(tio->io, error);
-
 	/*
 	 * Store md for cleanup instead of tio which is about to get freed.
 	 */
 	bio->bi_private = md->bs;
 
-	bio_put(bio);
 	free_tio(md, tio);
+	bio_put(bio);
+	dec_pending(io, error);
 }
 
 static sector_t max_io_len(struct mapped_device *md,
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -568,19 +568,22 @@ static void crypt_inc_pending(struct dm_
 static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
+	struct bio *base_bio = io->base_bio;
+	struct dm_crypt_io *base_io = io->base_io;
+	int error = io->error;
 
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	if (likely(!io->base_io))
-		bio_endio(io->base_bio, io->error);
+	mempool_free(io, cc->io_pool);
+
+	if (likely(!base_io))
+		bio_endio(base_bio, error);
 	else {
-		if (io->error && !io->base_io->error)
-			io->base_io->error = io->error;
-		crypt_dec_pending(io->base_io);
+		if (error && !base_io->error)
+			base_io->error = error;
+		crypt_dec_pending(base_io);
 	}
-
-	mempool_free(io, cc->io_pool);
 }
 
 /*


