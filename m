Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0BLSmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:42:25 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55190 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0BLSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:42:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RPHCdcBwNdgchkjAvoaCdC3LP9fU9LI3VBfL0wtz9Z0U5xI+SvkmoQ98bS8E1itq79
         1YccErU7leqTdB+GCYzTHDffs4PjJNC2dqL95ewqG0YDw6yuSnqziiOrqH7i4jSzjgCB
         cftCMJJNChJxqYLbgsdcwcD3nTv3jCbI1Lnoc=
Subject: [PATCH 2.6.32.7] ext4: number of blocks for fiemap
From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: surbhi.palande@canonical.com, linux-kernel@vger.kernel.org,
       474597@bugs.launchpad.net
In-Reply-To: <4B701793.9010005@canonical.com>
References: <1257360161.22057.16.camel@michlmayr>
	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
	 <1257371050.13852.28.camel@michlmayr>  <4B701793.9010005@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 19:42:16 +0100
Message-ID: <1266000136.4310.36.camel@michlmayr>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
fs/ext4/extents.c:ext4_fiemap rounds the length of the requested range
down to blocksize. This is not the true number of blocks that cover the
requested region. This problem is especially impressive if the user
requests only the first byte of a file: not a single extent will be
reported.

Solution:
Calculate the last byte of the region and round to blocksize. Then get
the number of blocks by subtracting last_blk - start_blk and adding 1
for the first block. (The variable last_blk is introduced just for
easier reading.) This patch will fix this.

I already suggested this patch some time ago, this is the same patch for
a more recent kernel version.

Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>

diff -rup linux-2.6.32.7/fs/ext4/extents.c linux-2.6.32.7-lm/fs/ext4/extents.c
--- linux-2.6.32.7/fs/ext4/extents.c	2010-01-29 00:06:20.000000000 +0100
+++ linux-2.6.32.7-lm/fs/ext4/extents.c	2010-02-11 21:26:40.000000000 +0100
@@ -3711,6 +3711,7 @@ int ext4_fiemap(struct inode *inode, str
 		__u64 start, __u64 len)
 {
 	ext4_lblk_t start_blk;
+	ext4_lblk_t last_blk;
 	ext4_lblk_t len_blks;
 	int error = 0;
 
@@ -3726,7 +3727,9 @@ int ext4_fiemap(struct inode *inode, str
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		/* the last byte in the range is (start + len - 1) */
+		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		len_blks = last_blk - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.




