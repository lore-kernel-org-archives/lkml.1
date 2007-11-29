Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbXK2LOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbXK2LOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXK2LOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:14:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55638 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754610AbXK2LOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:14:21 -0500
To: a.p.zijlstra@chello.nl
CC: fengguang.wu@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Thu, 29 Nov 2007 12:10:24 +0100)
Subject: [patch 2/3] mm: bdi: allow to set a minimum to the bdi dirty limit
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
Message-Id: <E1IxhLW-00018l-3W@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 12:14:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[mszeredi@suse.cz]
Fix parsing in min_ratio_store()

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux/include/linux/backing-dev.h
===================================================================
--- linux.orig/include/linux/backing-dev.h	2007-11-26 17:24:19.000000000 +0100
+++ linux/include/linux/backing-dev.h	2007-11-26 17:24:39.000000000 +0100
@@ -51,6 +51,8 @@ struct backing_dev_info {
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
+	unsigned int min_ratio;
+
 	struct device *dev;
 };
 
@@ -147,6 +149,8 @@ static inline unsigned long bdi_stat_err
 #endif
 }
 
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
+
 /*
  * Flags in backing_dev_info::capability
  * - The first two flags control whether dirty pages will contribute to the
Index: linux/mm/backing-dev.c
===================================================================
--- linux.orig/mm/backing-dev.c	2007-11-26 17:24:19.000000000 +0100
+++ linux/mm/backing-dev.c	2007-11-26 17:24:39.000000000 +0100
@@ -50,6 +50,24 @@ static inline unsigned long get_dirty(st
 BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
 BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
 
+static ssize_t min_ratio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ratio;
+	ssize_t ret = -EINVAL;
+
+	ratio = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		ret = bdi_set_min_ratio(bdi, ratio);
+		if (!ret)
+			ret = count;
+	}
+	return ret;
+}
+BDI_SHOW(min_ratio, bdi->min_ratio)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
@@ -58,6 +76,7 @@ static struct device_attribute bdi_dev_a
 	__ATTR_RO(writeback_kb),
 	__ATTR_RO(dirty_kb),
 	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_RW(min_ratio),
 	__ATTR_NULL,
 };
 
@@ -199,3 +218,4 @@ long congestion_wait(int rw, long timeou
 }
 EXPORT_SYMBOL(congestion_wait);
 
+
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-11-26 17:24:19.000000000 +0100
+++ linux/mm/page-writeback.c	2007-11-26 17:24:40.000000000 +0100
@@ -241,6 +241,29 @@ static void task_dirty_limit(struct task
 }
 
 /*
+ *
+ */
+static DEFINE_SPINLOCK(bdi_lock);
+static unsigned int bdi_min_ratio;
+
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdi_lock, flags);
+	min_ratio -= bdi->min_ratio;
+	if (bdi_min_ratio + min_ratio < 100) {
+		bdi_min_ratio += min_ratio;
+		bdi->min_ratio += min_ratio;
+	} else
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&bdi_lock, flags);
+
+	return ret;
+}
+
+/*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
  *
@@ -325,7 +348,7 @@ get_dirty_limits(long *pbackground, long
 	*pdirty = dirty;
 
 	if (bdi) {
-		u64 bdi_dirty = dirty;
+		u64 bdi_dirty;
 		long numerator, denominator;
 
 		/*
@@ -333,8 +356,10 @@ get_dirty_limits(long *pbackground, long
 		 */
 		bdi_writeout_fraction(bdi, &numerator, &denominator);
 
+		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
 		bdi_dirty *= numerator;
 		do_div(bdi_dirty, denominator);
+		bdi_dirty += (dirty * bdi->min_ratio) / 100;
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
