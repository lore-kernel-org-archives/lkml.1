Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZKTQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZKTQk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZKTQk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:40:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:41526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZKTQkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:52 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH 03/15] osst: Update ppos instead of using file->f_pos
Date: Fri, 20 Nov 2009 17:40:33 +0100
Message-Id: <1258735245-25826-4-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

osst_read()/osst_write() modify file->f_pos directly instead of the ppos
given to them. The VFS later updates the file->f_pos and overwrites it
with the value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/scsi/osst.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 761ca9d..960e39c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -3586,7 +3586,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 		if (i == (-ENOSPC)) {
 			transfer = STp->buffer->writing;	/* FIXME -- check this logic */
 			if (transfer <= do_count) {
-				filp->f_pos += do_count - transfer;
+				*ppos += do_count - transfer;
 				count -= do_count - transfer;
 				if (STps->drv_block >= 0) {
 					STps->drv_block += (do_count - transfer) / STp->block_size;
@@ -3624,7 +3624,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 			goto out;
 		}
 
-		filp->f_pos += do_count;
+		*ppos += do_count;
 		b_point += do_count;
 		count -= do_count;
 		if (STps->drv_block >= 0) {
@@ -3646,7 +3646,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 		if (STps->drv_block >= 0) {
 			STps->drv_block += blks;
 		}
-		filp->f_pos += count;
+		*ppos += count;
 		count = 0;
 	}
 
@@ -3822,7 +3822,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
 			}
 			STp->logical_blk_num += transfer / STp->block_size;
 			STps->drv_block      += transfer / STp->block_size;
-			filp->f_pos          += transfer;
+			*ppos          += transfer;
 			buf                  += transfer;
 			total                += transfer;
 		}
-- 
1.6.4.2

