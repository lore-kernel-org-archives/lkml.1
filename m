Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXKGFG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXKGFG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXKGFGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:06:21 -0500
Received: from lixom.net ([66.141.50.11]:39421 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXKGFGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:06:20 -0500
Date: Tue, 6 Nov 2007 23:15:40 -0600
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fat: silence warning for 64KB PAGE_SIZE builds
Message-ID: <20071107051540.GB24266@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Annoying gcc warning:

fs/fat/inode.c: In function 'fat_fill_super':
fs/fat/inode.c:1222: warning: comparison is always false due to limited range of data type

logical_sector_size can never be more than 16 bits worth, but switching
it to an int silences gcc. It's a sanity check that can never fail with
64KB PAGE_SIZE but it seems like it'd still be useful for other page
sizes, so it's worth keeping:

        if (!is_power_of_2(logical_sector_size)
            || (logical_sector_size < 512)
            || (PAGE_CACHE_SIZE < logical_sector_size)) {
                if (!silent)
                        printk(KERN_ERR "FAT: bogus logical sector size %u\n",
                               logical_sector_size);
                brelse(bh);
                goto out_invalid;
        }


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 920a576..6aae680 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1158,7 +1158,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi;
-	u16 logical_sector_size;
+	int logical_sector_size;
 	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
 	int debug;
 	unsigned int media;
