Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbZKFWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbZKFWl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZKFWlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:22 -0500
Received: from kroah.org ([198.145.64.141]:56742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbZKFWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.565594071@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Junichi Nomura <j-nomura@ce.jp.nec.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [22/99] dm: dec_pending needs locking to save error value
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-dec_pending-needs-locking-to-save-error-value.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

commit f88fb981183e71daf40bbd84bc8251bbf7b59e19 upstream.

Multiple instances of dec_pending() can run concurrently so a lock is
needed when it saves the first error code.

I have never experienced actual problem without locking and just found
this during code inspection while implementing the barrier support
patch for request-based dm.

This patch adds the locking.
I've done compile, boot and basic I/O testings.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -47,6 +47,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *bio;
 	unsigned long start_time;
+	spinlock_t endio_lock;
 };
 
 /*
@@ -576,8 +577,12 @@ static void dec_pending(struct dm_io *io
 	struct mapped_device *md = io->md;
 
 	/* Push-back supersedes any I/O errors */
-	if (error && !(io->error > 0 && __noflush_suspending(md)))
-		io->error = error;
+	if (unlikely(error)) {
+		spin_lock_irqsave(&io->endio_lock, flags);
+		if (!(io->error > 0 && __noflush_suspending(md)))
+			io->error = error;
+		spin_unlock_irqrestore(&io->endio_lock, flags);
+	}
 
 	if (atomic_dec_and_test(&io->io_count)) {
 		if (io->error == DM_ENDIO_REQUEUE) {
@@ -1224,6 +1229,7 @@ static void __split_and_process_bio(stru
 	atomic_set(&ci.io->io_count, 1);
 	ci.io->bio = bio;
 	ci.io->md = md;
+	spin_lock_init(&ci.io->endio_lock);
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
 	if (unlikely(bio_empty_barrier(bio)))


