Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYIEDYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYIEDYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYIEDYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:24:17 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:4354 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYIEDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:24:17 -0400
Date: Thu, 4 Sep 2008 23:24:11 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: snakebyte@gmx.de
Subject: __getblk infinite loop
Message-ID: <20080905032411.GB13208@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Eric Sesterhenn and I were puzzling over a lockup found by his fsfuzzer.

sb_bread() calls __getblk, which says:

/*
 * __getblk will locate (and, if necessary, create) the buffer_head
 * which corresponds to the passed block_device, block and size. The
 * returned buffer has its reference count incremented.
 *
 * __getblk() cannot fail - it just keeps trying.  If you pass it an
 * illegal block number, __getblk() will happily return a buffer_head
 * which represents the non-existent block.  Very weird.
 *
 * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
 * attempt is failing.  FIXME, perhaps?
 */

In fact the following will cause an infinite loop when mounting omfs 
loopback (on 32 bit x86 at least):

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index a95fe59..80eacc8 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -413,6 +413,15 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sector_t start;
 	int ret = -EINVAL;
 
+	if (1) {
+		sector_t foo = 0x1d4000004ULL;
+
+		sb_set_blocksize(sb, 2048);
+		bh = sb_bread(sb, foo);
+		brelse(bh);
+		goto end;
+	}
+
 	save_mount_options(sb, (char *) data);
 
 	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);

What's supposed to happen here?  I would have thought that sb_bread
would realize foo was outside the block dev and bail out, but instead
it just gets stuck.  Do I need to bounds-check anything passed to
sb_bread?

-- 
Bob Copeland %% www.bobcopeland.com

