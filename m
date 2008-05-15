Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbYEOSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbYEOSyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYEOSyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:54:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53304 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYEOSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:53:59 -0400
To: ajones@riverbed.com
CC: a.p.zijlstra@chello.nl, mszeredi@suse.cz, akpm@linux-foundation.org,
       kay.sievers@vrfy.org, greg@kroah.com, trond.myklebust@fys.uio.no,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20080514144030.GD6458@ajones-laptop.nbttech.com> (message from
	Arthur Jones on Wed, 14 May 2008 07:40:30 -0700)
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com>
Message-Id: <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 20:53:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> About 1 in 4 times, when turning the power back
> on for a drive, I get the BUG reported below.  The
> drives are not mounted, just sitting there getting
> power cycled (the test looks to make sure they are
> being seen by the scsi subsystem and udev).

> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
> > IP: [<ffffffff802694e3>] read_ahead_kb_show+0x1b/0x2d

I suspect this is because there's a race between the show/store
functions and dev_set_drvdata() in bdi_register().

Could you try this patch to verify that this is indeed the problem?

This is not meant as a final solution, I'm sure Greg or Kay can help
find a better solution.

Thanks,
Miklos


Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2008-05-14 12:49:33.000000000 +0200
+++ linux-2.6/mm/backing-dev.c	2008-05-15 20:37:55.000000000 +0200
@@ -15,6 +15,7 @@ static struct class *bdi_class;
 #include <linux/seq_file.h>
 
 static struct dentry *bdi_debug_root;
+static DEFINE_MUTEX(bdi_dev_mutex);
 
 static void bdi_debug_init(void)
 {
@@ -84,11 +85,19 @@ static inline void bdi_debug_unregister(
 }
 #endif
 
+static struct backing_dev_info *dev_get_bdi(struct device *dev)
+{
+	mutex_lock(&bdi_dev_mutex);
+	mutex_unlock(&bdi_dev_mutex);
+
+	return dev_get_drvdata(dev);
+}
+
 static ssize_t read_ahead_kb_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	struct backing_dev_info *bdi = dev_get_bdi(dev);
 	char *end;
 	unsigned long read_ahead_kb;
 	ssize_t ret = -EINVAL;
@@ -107,7 +116,7 @@ static ssize_t read_ahead_kb_store(struc
 static ssize_t name##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *page)	\
 {									\
-	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
+	struct backing_dev_info *bdi = dev_get_bdi(dev);		\
 									\
 	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
 }
@@ -117,7 +126,7 @@ BDI_SHOW(read_ahead_kb, K(bdi->ra_pages)
 static ssize_t min_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	struct backing_dev_info *bdi = dev_get_bdi(dev);
 	char *end;
 	unsigned int ratio;
 	ssize_t ret = -EINVAL;
@@ -135,7 +144,7 @@ BDI_SHOW(min_ratio, bdi->min_ratio)
 static ssize_t max_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	struct backing_dev_info *bdi = dev_get_bdi(dev);
 	char *end;
 	unsigned int ratio;
 	ssize_t ret = -EINVAL;
@@ -184,6 +193,7 @@ int bdi_register(struct backing_dev_info
 	if (!name)
 		return -ENOMEM;
 
+	mutex_lock(&bdi_dev_mutex);
 	dev = device_create(bdi_class, parent, MKDEV(0, 0), name);
 	if (IS_ERR(dev)) {
 		ret = PTR_ERR(dev);
@@ -195,6 +205,7 @@ int bdi_register(struct backing_dev_info
 	bdi_debug_register(bdi, name);
 
 exit:
+	mutex_unlock(&bdi_dev_mutex);
 	kfree(name);
 	return ret;
 }


