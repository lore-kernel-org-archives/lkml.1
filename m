Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYIIVLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYIIVLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYIIVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:11:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32751 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYIIVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=HDgTJijgPJRaibsdT0ElflHt9KhFj3aNTzhTiNnXcMdvhf3lxuHSHwyOoLKiOHvpOP
         oKHlo+U0CEWb0mG8WUZUq4Zb7el35ZPWfAFZLoBJbPretOr+9WTLbHRoYLkTe85+L5Nu
         UNrWGUDBbvjeFd+520BSCsz/DnDp1kUXJ02e8=
Message-ID: <48C6E660.8010800@gmail.com>
Date: Tue, 09 Sep 2008 23:10:56 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: invalid tests on unsigned
References: <48C685F6.8020108@gmail.com>
In-Reply-To: <48C685F6.8020108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> Using spatch I have found the following occurrences where there is
> an invalid test on an unsigned.
> 
> Some may be not seriously, but just redundant, others may indicate
> an incorrect assumption (that the variable can be negative).
> I haven't found time to sort out these.
> 
> If I have time I will write patches, but feel free to write one
> yourself if you want.
> 
> Roel
> 
> What is shown below is not meant as patch, just for reporting.


Some more (not yet reported):

----[ drivers/video/atmel_lcdfb.c, unsigned long ]----
--- drivers/video/atmel_lcdfb.c	2008-08-07 17:53:08.000000000 +0200
@@ -843,7 +843,7 @@ static int __init atmel_lcdfb_probe(stru
 	}
 
 	sinfo->irq_base = platform_get_irq(pdev, 0);
-	if (sinfo->irq_base < 0) {
 		dev_err(dev, "unable to get irq
");
 		ret = sinfo->irq_base;
 		goto stop_clk;
----[ drivers/video/aty/radeon_base.c, __u32 ]----
--- drivers/video/aty/radeon_base.c	2008-08-07 17:53:08.000000000 +0200
@@ -819,9 +819,9 @@ static int radeonfb_check_var (struct fb
 	if (v.xres_virtual < v.xres)
 		v.xres = v.xres_virtual;
 
-	if (v.xoffset < 0)
                 v.xoffset = 0;
-        if (v.yoffset < 0)
                 v.yoffset = 0;
          
         if (v.xoffset > v.xres_virtual - v.xres)
----[ drivers/video/fbmem.c, __u32 ]----
--- drivers/video/fbmem.c	2008-08-07 17:53:08.000000000 +0200
@@ -1083,7 +1083,7 @@ fb_ioctl(struct inode *inode, struct fil
 			return - EFAULT;
 		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
 		    return -EINVAL;
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
 #ifdef CONFIG_KMOD
 		if (!registered_fb[con2fb.framebuffer])
----[ drivers/video/fsl-diu-fb.c, __u32 ]----
--- drivers/video/fsl-diu-fb.c	2008-08-07 17:53:08.000000000 +0200
@@ -551,10 +551,10 @@ static int fsl_diu_check_var(struct fb_v
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 
-	if (var->xoffset < 0)
 		var->xoffset = 0;
 
-	if (var->yoffset < 0)
 		var->yoffset = 0;
 
 	if (var->xoffset + info->var.xres > info->var.xres_virtual)
@@ -908,7 +908,7 @@ static int fsl_diu_pan_display(struct fb
 	    (info->var.yoffset == var->yoffset))
 		return 0;	/* No change, do nothing */
 
-	if (var->xoffset < 0 || var->yoffset < 0
 	    || var->xoffset + info->var.xres > info->var.xres_virtual
 	    || var->yoffset + info->var.yres > info->var.yres_virtual)
 		return -EINVAL;
----[ drivers/video/intelfb/intelfbdrv.c, __u32 ]----
--- drivers/video/intelfb/intelfbdrv.c	2008-07-19 23:16:53.000000000 +0200
@@ -1324,9 +1324,9 @@ static int intelfb_check_var(struct fb_v
 		break;
 	}
 
-	if (v.xoffset < 0)
 		v.xoffset = 0;
-	if (v.yoffset < 0)
 		v.yoffset = 0;
 
 	if (v.xoffset > v.xres_virtual - v.xres)
----[ drivers/video/omap/omapfb_main.c, u_int ]----
--- drivers/video/omap/omapfb_main.c	2008-08-07 17:53:08.000000000 +0200
@@ -276,7 +276,7 @@ static int _setcolreg(struct fb_info *in
 		if (r != 0)
 			break;
 
-		if (regno < 0) {
 			r = -EINVAL;
 			break;
 		}
----[ drivers/video/sm501fb.c, unsigned ]----
--- drivers/video/sm501fb.c	2008-08-07 17:53:09.000000000 +0200
@@ -172,7 +172,7 @@ static int sm501_alloc_mem(struct sm501f
 		if (fbi && ptr < fbi->fix.smem_len)
 			return -ENOMEM;
 
-		if (ptr < 0)
 			return -ENOMEM;
 
 		break;
----[ drivers/watchdog/wdt285.c, unsigned ]----
--- drivers/watchdog/wdt285.c	2008-08-31 16:16:33.000000000 +0200
@@ -161,7 +161,7 @@ static long watchdog_ioctl(struct file *
 			break;
 
 		/* Arbitrary, can't find the card's limits */
-		if (new_margin < 0 || new_margin > 60) {
 			ret = -EINVAL;
 			break;
 		}
----[ fs/adfs/inode.c, sector_t ]----
--- fs/adfs/inode.c	2008-07-19 23:16:53.000000000 +0200
@@ -28,7 +28,7 @@ static int
 adfs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh,
 	       int create)
 {
-	if (block < 0)
 		goto abort_negative;
 
 	if (!create) {
----[ fs/befs/linuxvfs.c, sector_t ]----
--- fs/befs/linuxvfs.c	2008-08-07 17:53:09.000000000 +0200
@@ -127,7 +127,7 @@ befs_get_block(struct inode *inode, sect
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   inode->i_ino, block);
 
-	if (block < 0) {
 		befs_error(sb, "befs_get_block() was asked for a block "
 			   "number less than zero: block %ld in inode %lu",
 			   block, inode->i_ino);
----[ fs/ext4/ialloc.c, ext4_group_t ]----
--- fs/ext4/ialloc.c	2008-08-07 17:53:09.000000000 +0200
@@ -351,7 +351,7 @@ find_close_to_parent:
 			goto found_flexbg;
 		}
 
-		if (best_flex < 0 ||
 		    (flex_group[i].free_blocks >
 		     flex_group[best_flex].free_blocks &&
 		     flex_group[i].free_inodes))
----[ fs/hugetlbfs/inode.c, unsigned long ]----
--- fs/hugetlbfs/inode.c	2008-08-07 17:53:09.000000000 +0200
@@ -281,7 +281,7 @@ static ssize_t hugetlbfs_read(struct fil
 			 */
 			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
 		}
-		if (ret < 0) {
 			if (retval == 0)
 				retval = ret;
 			if (page)
----[ fs/udf/super.c, sector_t ]----
--- fs/udf/super.c	2008-08-07 17:53:10.000000000 +0200
@@ -721,7 +721,7 @@ static sector_t udf_scan_anchors(struct 
 	 *  however, if the disc isn't closed, it could be 512 */
 
 	for (i = 0; i < ARRAY_SIZE(last); i++) {
-		if (last[i] < 0)
 			continue;
 		if (last[i] >= sb->s_bdev->bd_inode->i_size >>
 				sb->s_blocksize_bits)
----[ fs/ufs/inode.c, sector_t ]----
--- fs/ufs/inode.c	2008-07-19 23:16:54.000000000 +0200
@@ -56,7 +56,7 @@ static int ufs_block_to_path(struct inod
 
 
 	UFSD("ptrs=uspi->s_apb = %d,double_blocks=%ld 
",ptrs,double_blocks);
-	if (i_block < 0) {
 		ufs_warning(inode->i_sb, "ufs_block_to_path", "block < 0");
 	} else if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
@@ -440,7 +440,7 @@ int ufs_getfrag_block(struct inode *inod
 	lock_kernel();
 
 	UFSD("ENTER, ino %lu, fragment %llu
", inode->i_ino, (unsigned long long)fragment);
-	if (fragment < 0)
 		goto abort_negative;
 	if (fragment >
 	    ((UFS_NDADDR + uspi->s_apb + uspi->s_2apb + uspi->s_3apb)
