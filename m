Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXF3D1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXF3D1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXF3D0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:26:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:20581 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbXF3D0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZyrRgaqgE4g0rGZZtbRt9wBsW1Kg4ci7GRNWEPO1PWKM/2hginXrluKVhlMbKHQwrey5yqwfpGc2m1cyFewKIKAtHf+6UHpOVvpHEehmvLIwtGpQGcc2XyhOBof2GqUwZR3bo23mRF5MAyEeFjcOow+yfbuydlSHoB0r7AifZYI=
Date: Sat, 30 Jun 2007 12:17:02 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/4] void unregister_blkdev - make void
Message-ID: <20070630031702.GB4131@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <20070630031013.GC4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630031013.GC4045@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put WARN_ON and fixed all callers of unregister_blkdev().
Now we can make unregister_blkdev return void.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 block/genhd.c      |    7 +------
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

Index: 2.6-mm/block/genhd.c
===================================================================
--- 2.6-mm.orig/block/genhd.c
+++ 2.6-mm/block/genhd.c
@@ -108,13 +108,11 @@ out:
 
 EXPORT_SYMBOL(register_blkdev);
 
-/* todo: make void - error printk here */
-int unregister_blkdev(unsigned int major, const char *name)
+void unregister_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n;
 	struct blk_major_name *p = NULL;
 	int index = major_to_index(major);
-	int ret = 0;
 
 	mutex_lock(&block_subsys_lock);
 	for (n = &major_names[index]; *n; n = &(*n)->next)
@@ -122,15 +120,12 @@ int unregister_blkdev(unsigned int major
 			break;
 	if (!*n || strcmp((*n)->name, name)) {
 		WARN_ON(1);
-		ret = -EINVAL;
 	} else {
 		p = *n;
 		*n = p->next;
 	}
 	mutex_unlock(&block_subsys_lock);
 	kfree(p);
-
-	return ret;
 }
 
 EXPORT_SYMBOL(unregister_blkdev);
Index: 2.6-mm/include/linux/fs.h
===================================================================
--- 2.6-mm.orig/include/linux/fs.h
+++ 2.6-mm/include/linux/fs.h
@@ -1553,7 +1553,7 @@ extern void putname(const char *name);
 
 #ifdef CONFIG_BLOCK
 extern int register_blkdev(unsigned int, const char *);
-extern int unregister_blkdev(unsigned int, const char *);
+extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
