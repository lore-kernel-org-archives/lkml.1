Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXA3K16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXA3K16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXA3K11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:27:27 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39398 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbXA3K0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:22 -0500
Message-Id: <20070130102910.237262000@bull.net>
References: <20070130101143.296619000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 30 Jan 2007 11:11:47 +0100
From: Nadia.Derbey@bull.net
To: akpm@osdl.org, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 4/6] AKT - min and max kobjects
Content-Disposition: inline; filename=tunable_min_max_kobjects.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/06]


Introduces the kobjects associated to each tunable min and max value


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 include/linux/akt.h         |   14 ++++
 kernel/autotune/akt.c       |  148 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/autotune/akt_sysfs.c |   16 ++++
 3 files changed, 177 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc4/include/linux/akt.h
===================================================================
--- linux-2.6.20-rc4.orig/include/linux/akt.h	2007-01-29 15:32:48.000000000 +0100
+++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-29 15:47:40.000000000 +0100
@@ -60,9 +60,15 @@ struct tunable_kobject {
 /*
  * Structure used to describe the min / max values for a tunable inside the
  * auto_tune structure.
+ * The abs_value field is used to check that we are not:
+ *   . falling under the very 1st min value when updating the min value
+ *     through sysfs
+ *   . going over the very 1st max value when updating the max value
+ *     through sysfs
  */
 struct tunable_limit {
 	ulong value;
+	ulong abs_value;
 };
 
 
@@ -153,9 +159,11 @@ static inline int is_tunable_registered(
 		.threshold	= (_thresh),				\
 		.min	= {						\
 			.value		= (_min),			\
+			.abs_value	= (_min),			\
 		},							\
 		.max	= {						\
 			.value		= (_max),			\
+			.abs_value	= (_max),			\
 		},							\
 		.tun_kobj	= { .tun = NULL, },			\
 		.tunable	= (_tun),				\
@@ -169,7 +177,9 @@ static inline int is_tunable_registered(
 #define set_tunable_min_max(s, _min, _max)	\
 	do {					\
 		(s).min.value = _min;		\
+		(s).min.abs_value = _min;	\
 		(s).max.value = _max;		\
+		(s).max.abs_value = _max;	\
 	} while (0)
 
 
@@ -217,6 +227,10 @@ extern int unregister_tunable(struct aut
 extern int tunable_sysfs_setup(struct auto_tune *);
 extern ssize_t show_tuning_mode(struct auto_tune *, char *);
 extern ssize_t store_tuning_mode(struct auto_tune *, const char *, size_t);
+extern ssize_t show_tunable_min(struct auto_tune *, char *);
+extern ssize_t store_tunable_min(struct auto_tune *, const char *, size_t);
+extern ssize_t show_tunable_max(struct auto_tune *, char *);
+extern ssize_t store_tunable_max(struct auto_tune *, const char *, size_t);
 
 
 #else	/* CONFIG_AKT */
Index: linux-2.6.20-rc4/kernel/autotune/akt.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/autotune/akt.c	2007-01-29 15:42:55.000000000 +0100
+++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-29 15:50:31.000000000 +0100
@@ -28,6 +28,10 @@
  *              unregister_tunable         (exported)
  *              show_tuning_mode           (exported)
  *              store_tuning_mode          (exported)
+ *              show_tunable_min           (exported)
+ *              store_tunable_min          (exported)
+ *              show_tunable_max           (exported)
+ *              store_tunable_max          (exported)
  */
 
 #include <linux/init.h>
@@ -206,3 +210,147 @@ ssize_t store_tuning_mode(struct auto_tu
 
 	return strnlen(buffer, PAGE_SIZE);
 }
+
+
+/**
+ * show_tunable_min - Outputs the minimum value of a given tunable
+ * @tun_addr:	registered tunable structure to check
+ * @buf:	output buffer
+ *
+ * This is the get operation called by tunable_attr_show (i.e. when the file
+ * /sys/tunables/<tunable>/min is displayed).
+ * Outputs the current tunable minimum value
+ *
+ * Returns:	>0 - output string length (including the '\0')
+ *		<0 - failure
+ */
+ssize_t show_tunable_min(struct auto_tune *tun_addr, char *buf)
+{
+	ssize_t rc;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: tunable address is invalid\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	rc = snprintf(buf, PAGE_SIZE, "%lu\n", tun_addr->min.value);
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return rc;
+}
+
+
+/**
+ * store_tunable_min - Sets the minimum value of a given tunable
+ * @tun_addr:	registered tunable structure to set
+ * @buf:	input buffer
+ * @count:	input buffer length (including the '\0')
+ *
+ * This is the set operation called by tunable_attr_store (i.e. when a string
+ * is stored into /sys/tunables/<tunable>/min).
+ *
+ * Returns:	>0 - number of characters used from the input buffer
+ *		<0 - failure
+ */
+ssize_t store_tunable_min(struct auto_tune *tun_addr, const char *buf,
+			size_t count)
+{
+	ssize_t rc;
+	ulong new_value;
+
+	if (sscanf(buf, "%lu", &new_value) != 1)
+		return -EINVAL;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: tunable address is invalid\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	if (new_value >= tun_addr->min.abs_value &&
+					new_value < tun_addr->max.value) {
+		tun_addr->min.value = new_value;
+		rc = strnlen(buf, PAGE_SIZE);
+	} else
+		rc = -EINVAL;
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return rc;
+}
+
+
+/**
+ * show_tunable_max - Outputs the maximum value of a given tunable
+ * @tun_addr:	registered tunable structure to check
+ * @buf:	output buffer
+ *
+ * This is the get operation called by tunable_attr_show (i.e. when the file
+ * /sys/tunables/<tunable>/max is displayed).
+ * Outputs the current tunable maximum value
+ *
+ * Returns:	>0 - output string length (including the '\0')
+ *		<0 - failure
+ */
+ssize_t show_tunable_max(struct auto_tune *tun_addr, char *buf)
+{
+	ssize_t rc;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: tunable address is invalid\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	rc = snprintf(buf, PAGE_SIZE, "%lu\n", tun_addr->max.value);
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return rc;
+}
+
+
+/**
+ * store_tunable_max - Sets the maximum value of a given tunable
+ * @tun_addr:	registered tunable structure to set
+ * @buf:	input buffer
+ * @count:	input buffer length (including the '\0')
+ *
+ * This is the set operation called by tunable_attr_store (i.e. when a string
+ * is stored into /sys/tunables/<tunable>/max).
+ *
+ * Returns:	>0 - number of characters used from the input buffer
+ *		<0 - failure
+ */
+ssize_t store_tunable_max(struct auto_tune *tun_addr, const char *buf,
+			size_t count)
+{
+	ssize_t rc;
+	ulong new_value;
+
+	if (sscanf(buf, "%lu", &new_value) != 1)
+		return -EINVAL;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: tunable address is invalid\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	if (new_value <= tun_addr->max.abs_value &&
+					new_value > tun_addr->min.value) {
+		tun_addr->max.value = new_value;
+		rc = strnlen(buf, PAGE_SIZE);
+	} else
+		rc = -EINVAL;
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return rc;
+}
Index: linux-2.6.20-rc4/kernel/autotune/akt_sysfs.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/autotune/akt_sysfs.c	2007-01-29 15:39:05.000000000 +0100
+++ linux-2.6.20-rc4/kernel/autotune/akt_sysfs.c	2007-01-29 15:52:09.000000000 +0100
@@ -54,8 +54,16 @@ struct tunable_attribute tun_attr_##_nam
 static TUNABLE_ATTR(autotune, S_IWUSR | S_IRUGO, show_tuning_mode,
 		store_tuning_mode);
 
+static TUNABLE_ATTR(min, S_IWUSR | S_IRUGO, show_tunable_min,
+		store_tunable_min);
+
+static TUNABLE_ATTR(max, S_IWUSR | S_IRUGO, show_tunable_max,
+		store_tunable_max);
+
 static struct tunable_attribute *tunable_sysfs_attrs[] = {
 	&tun_attr_autotune,	/* to (de)activate auto tuning */
+	&tun_attr_min,		/* to play with the tunable min value */
+	&tun_attr_max,		/* to play with the tunable max value */
 	NULL,
 };
 
@@ -75,6 +83,8 @@ static int add_tunable_attrs(struct auto
  * @kobj:	tunable associated kobject
  * @attr:	tunable attribute to read. Can be one of:
  *			tun_attr_autotune
+ *			tun_attr_min
+ *			tun_attr_max
  * @buf:	output buffer
  *
  * Forwards any read call to the show method of the owning attribute
@@ -102,6 +112,8 @@ static ssize_t tunable_attr_show(struct 
  * @kobj:	tunable associated kobject
  * @attr:	tunable attribute to update. Can be one of:
  *			tun_attr_autotune
+ *			tun_attr_min
+ *			tun_attr_max
  * @buf:	input buffer
  * @count:	input buffer length (including the '\0')
  *
@@ -145,8 +157,10 @@ decl_subsys(tunables, &tunables_ktype, N
  * @tunable:	tunable structure to be registered
  *
  * Called by register_tunable()
- * The tunable is a kobject with 1 attributes:
+ * The tunable is a kobject with 3 attributes:
  *	autotune (rw): enables to (de)activate the auto tuning for the tunable
+ *	min (rw): enables to play with the min tunable value
+ *	max (rw): enables to play with the max tunable value
  *
  * Returns:	0 - successful
  *		<0 - failure

--
