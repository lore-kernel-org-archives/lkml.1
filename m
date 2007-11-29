Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXK2LQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXK2LQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXK2LQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:16:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55644 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754955AbXK2LQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:16:14 -0500
To: a.p.zijlstra@chello.nl
CC: fengguang.wu@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Thu, 29 Nov 2007 12:10:24 +0100)
Subject: [patch 3/3] mm: bdi: allow to set a maximum to the bdi dirty limit
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
Message-Id: <E1IxhNK-00019G-NO@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 12:16:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[mszeredi@suse.cz]
- Fix parsing in max_ratio_store().
- Export bdi_set_max_ratio() to modules (for fuse)
- Limit bdi_dirty with bdi->max_ratio

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux/include/linux/backing-dev.h
===================================================================
--- linux.orig/include/linux/backing-dev.h	2007-11-27 20:55:54.000000000 +0100
+++ linux/include/linux/backing-dev.h	2007-11-27 20:56:02.000000000 +0100
@@ -52,6 +52,7 @@ struct backing_dev_info {
 	int dirty_exceeded;
 
 	unsigned int min_ratio;
+	unsigned int max_ratio, max_prop_frac;
 
 	struct device *dev;
 };
@@ -150,6 +151,7 @@ static inline unsigned long bdi_stat_err
 }
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
+int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 /*
  * Flags in backing_dev_info::capability
Index: linux/include/linux/proportions.h
===================================================================
--- linux.orig/include/linux/proportions.h	2007-11-27 12:45:32.000000000 +0100
+++ linux/include/linux/proportions.h	2007-11-27 20:55:56.000000000 +0100
@@ -78,6 +78,19 @@ void prop_inc_percpu(struct prop_descrip
 }
 
 /*
+ * Limit the time part in order to ensure there are some bits left for the
+ * cycle counter and fraction multiply.
+ */
+#define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
+
+#define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
+#define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
+
+void __prop_inc_percpu_max(struct prop_descriptor *pd,
+			   struct prop_local_percpu *pl, long frac);
+
+
+/*
  * ----- SINGLE ------
  */
 
Index: linux/lib/proportions.c
===================================================================
--- linux.orig/lib/proportions.c	2007-11-27 12:45:32.000000000 +0100
+++ linux/lib/proportions.c	2007-11-27 20:55:56.000000000 +0100
@@ -73,12 +73,6 @@
 #include <linux/proportions.h>
 #include <linux/rcupdate.h>
 
-/*
- * Limit the time part in order to ensure there are some bits left for the
- * cycle counter.
- */
-#define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
-
 int prop_descriptor_init(struct prop_descriptor *pd, int shift)
 {
 	int err;
@@ -273,6 +267,38 @@ void __prop_inc_percpu(struct prop_descr
 }
 
 /*
+ * identical to __prop_inc_percpu, except that it limits this pl's fraction to
+ * @frac/PROP_FRAC_BASE by ignoring events when this limit has been exceeded.
+ */
+void __prop_inc_percpu_max(struct prop_descriptor *pd,
+			   struct prop_local_percpu *pl, long frac)
+{
+	struct prop_global *pg = prop_get_global(pd);
+
+	prop_norm_percpu(pg, pl);
+
+	if (unlikely(frac != PROP_FRAC_BASE)) {
+		unsigned long period_2 = 1UL << (pg->shift - 1);
+		unsigned long counter_mask = period_2 - 1;
+		unsigned long global_count;
+		long numerator, denominator;
+
+		numerator = percpu_counter_read_positive(&pl->events);
+		global_count = percpu_counter_read(&pg->events);
+		denominator = period_2 + (global_count & counter_mask);
+
+		if (numerator > ((denominator * frac) >> PROP_FRAC_SHIFT))
+			goto out_put;
+	}
+
+	percpu_counter_add(&pl->events, 1);
+	percpu_counter_add(&pg->events, 1);
+
+out_put:
+	prop_put_global(pd, pg);
+}
+
+/*
  * Obtain a fraction of this proportion
  *
  *   p_{j} = x_{j} / (period/2 + t % period/2)
Index: linux/mm/backing-dev.c
===================================================================
--- linux.orig/mm/backing-dev.c	2007-11-27 20:55:54.000000000 +0100
+++ linux/mm/backing-dev.c	2007-11-27 20:55:56.000000000 +0100
@@ -68,6 +68,24 @@ static ssize_t min_ratio_store(struct de
 }
 BDI_SHOW(min_ratio, bdi->min_ratio)
 
+static ssize_t max_ratio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ratio;
+	ssize_t ret = -EINVAL;
+
+	ratio = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		ret = bdi_set_max_ratio(bdi, ratio);
+		if (!ret)
+			ret = count;
+	}
+	return ret;
+}
+BDI_SHOW(max_ratio, bdi->max_ratio)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
@@ -77,6 +95,7 @@ static struct device_attribute bdi_dev_a
 	__ATTR_RO(dirty_kb),
 	__ATTR_RO(bdi_dirty_kb),
 	__ATTR_RW(min_ratio),
+	__ATTR_RW(max_ratio),
 	__ATTR_NULL,
 };
 
@@ -136,6 +155,10 @@ int bdi_init(struct backing_dev_info *bd
 
 	bdi->dev = NULL;
 
+	bdi->min_ratio = 0;
+	bdi->max_ratio = 100;
+	bdi->max_prop_frac = PROP_FRAC_BASE;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-11-27 20:55:54.000000000 +0100
+++ linux/mm/page-writeback.c	2007-11-27 21:54:43.000000000 +0100
@@ -158,7 +158,7 @@ int dirty_ratio_handler(struct ctl_table
  */
 static inline void __bdi_writeout_inc(struct backing_dev_info *bdi)
 {
-	__prop_inc_percpu(&vm_completions, &bdi->completions);
+	__prop_inc_percpu_max(&vm_completions, &bdi->completions, bdi->max_prop_frac);
 }
 
 static inline void task_dirty_inc(struct task_struct *tsk)
@@ -252,17 +252,43 @@ int bdi_set_min_ratio(struct backing_dev
 	unsigned long flags;
 
 	spin_lock_irqsave(&bdi_lock, flags);
-	min_ratio -= bdi->min_ratio;
-	if (bdi_min_ratio + min_ratio < 100) {
-		bdi_min_ratio += min_ratio;
-		bdi->min_ratio += min_ratio;
-	} else
+	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
+	} else {
+		min_ratio -= bdi->min_ratio;
+		if (bdi_min_ratio + min_ratio < 100) {
+			bdi_min_ratio += min_ratio;
+			bdi->min_ratio += min_ratio;
+		} else {
+			ret = -EINVAL;
+		}
+	}
 	spin_unlock_irqrestore(&bdi_lock, flags);
 
 	return ret;
 }
 
+int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (max_ratio > 100)
+		return -EINVAL;
+
+	spin_lock_irqsave(&bdi_lock, flags);
+	if (bdi->min_ratio > max_ratio) {
+		ret = -EINVAL;
+	} else {
+		bdi->max_ratio = max_ratio;
+		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
+	}
+	spin_unlock_irqrestore(&bdi_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(bdi_set_max_ratio);
+
 /*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
@@ -360,6 +386,8 @@ get_dirty_limits(long *pbackground, long
 		bdi_dirty *= numerator;
 		do_div(bdi_dirty, denominator);
 		bdi_dirty += (dirty * bdi->min_ratio) / 100;
+		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
+			bdi_dirty = dirty * bdi->max_ratio / 100;
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
