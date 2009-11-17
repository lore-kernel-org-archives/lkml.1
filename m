Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZKQAFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZKQAFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZKQAFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:05:03 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51533 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZKQAFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:05:00 -0500
Date: Mon, 16 Nov 2009 16:04:49 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
       Nick Piggin <npiggin@suse.de>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: [PATCH] ext2: clear uptodate flag on super block I/O error
Message-ID: <20091116160449.3fc5e958@nehalam>
In-Reply-To: <20091113150719.9d31dde2.akpm@linux-foundation.org>
References: <20091111123340.703f5c86@nehalam>
	<200911112234.24180.elendil@planet.nl>
	<20091113144727.575cf038@nehalam>
	<20091113150719.9d31dde2.akpm@linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a WARN backtrace in mark_buffer_dirty() that occurs during
unmount when a USB or floppy device is removed. I reported this a kernel
regression, but looks like it might have been there for longer
than that.

The super block update from a previous operation has marked the buffer
as in error, and the flag has to be cleared before doing the update.
(Similar code already exists in ext4).

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/fs/ext2/super.c	2009-11-16 15:55:36.399078475 -0800
+++ b/fs/ext2/super.c	2009-11-16 15:59:49.814765923 -0800
@@ -1121,8 +1121,20 @@ static void ext2_sync_super(struct super
 static int ext2_sync_fs(struct super_block *sb, int wait)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
+	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
 
 	lock_kernel();
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * This happens if USB or floppy device is yanked out.
+		 * Maybe user put device back in so warn and update again.
+		 */
+		printk(KERN_ERR
+		       "EXT2-fs: previous I/O error to superblock detected\n");
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
+
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
