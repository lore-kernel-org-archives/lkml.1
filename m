Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZLGAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZLGAT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbZLGATy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:19:54 -0500
Received: from kroah.org ([198.145.64.141]:34703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbZLGANv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:57 2009
Message-Id: <20091207000657.501477590@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [095/119] md: revert incorrect fix for read error handling in raid1.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=md-revert-incorrect-fix-for-read-error-handling-in-raid1.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: NeilBrown <neilb@suse.de>

commit d0e260782c3702a009645c3caa02e381dab8798b upstream.

commit 4706b349f was a forward port of a fix that was needed
for SLES10.  But in fact it is not needed in mainline because
the earlier commit dd00a99e7a fixes the same problem in a
better way.
Further, this commit introduces a bug in the way it interacts with
the automatic read-error-correction.  If, after a read error is
successfully corrected, the same disk is chosen to re-read - the
re-read won't be attempted but an error will be returned instead.

After reverting that commit, there is the possibility that a
read error on a read-only array (where read errors cannot
be corrected as that requires a write) will repeatedly read the same
device and continue to get an error.
So in the "Array is readonly" case, fail the drive immediately on
a read error.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1643,11 +1643,12 @@ static void raid1d(mddev_t *mddev)
 					       r1_bio->sector,
 					       r1_bio->sectors);
 				unfreeze_array(conf);
-			}
+			} else
+				md_error(mddev,
+					 conf->mirrors[r1_bio->read_disk].rdev);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1 ||
-			    disk == r1_bio->read_disk) {
+			if ((disk=read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),


