Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYHAXVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYHAXVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYHAXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:20:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYHAXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:20:54 -0400
Subject: Re: mtdsuper.c BLOCK=n compile error
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080801225858.GM19682@cs181140183.pp.htv.fi>
References: <20080801223056.GK19682@cs181140183.pp.htv.fi>
	 <1217630912.3719.41.camel@shinybook.infradead.org>
	 <20080801225858.GM19682@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 00:20:51 +0100
Message-Id: <1217632851.3719.47.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 01:58 +0300, Adrian Bunk wrote:
> Still gives a compile error for the second bdput().

Er, why is the second bdput() there _anyway_?

[MTD] Fix !CONFIG_BLOCK compile for mtdsuper.c
    
As reported by Adrian Bunk, commit d5686b444ff3f72808d2b3fbd58672a86cdf38e7
(switch mtd and dm-table to lookup_bdev()) causes the following compile
error with CONFIG_BLOCK=n:
    
  CC      drivers/mtd/mtdsuper.o
drivers/mtd/mtdsuper.c: In function `get_sb_mtd':
drivers/mtd/mtdsuper.c:184: error: implicit declaration of function 'lookup_bdev'
drivers/mtd/mtdsuper.c:184: warning: assignment makes pointer from integer without a cast
drivers/mtd/mtdsuper.c:197: error: implicit declaration of function 'bdput'
make[3]: *** [drivers/mtd/mtdsuper.o] Error 1
    
Fix it by putting the block device lookup inside #ifdef CONFIG_BLOCK
    
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 9b6af7e..78114e3 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -125,8 +125,11 @@ int get_sb_mtd(struct file_system_type *fs_type,
int flags,
 	       int (*fill_super)(struct super_block *, void *, int),
 	       struct vfsmount *mnt)
 {
+#ifdef CONFIG_BLOCK
 	struct block_device *bdev;
-	int mtdnr, ret;
+	int ret;
+#endif
+	int mtdnr;
 
 	if (!dev_name)
 		return -EINVAL;
@@ -178,6 +181,7 @@ int get_sb_mtd(struct file_system_type *fs_type, int
flags,
 		}
 	}
 
+#ifdef CONFIG_BLOCK
 	/* try the old way - the hack where we allowed users to mount
 	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
 	 */
@@ -200,12 +204,13 @@ int get_sb_mtd(struct file_system_type *fs_type,
int flags,
 			     mnt);
 
 not_an_MTD_device:
+#endif /* CONFIG_BLOCK */
+
 	if (!(flags & MS_SILENT))
 		printk(KERN_NOTICE
 		       "MTD: Attempt to mount non-MTD device \"%s\"\n",
 		       dev_name);
-	bdput(bdev);
-	return ret;
+	return -EINVAL;
 }
 
 EXPORT_SYMBOL_GPL(get_sb_mtd);

-- 
dwmw2

