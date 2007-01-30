Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbXA3K1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbXA3K1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbXA3K0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:26:53 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39408 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbXA3K0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:23 -0500
Message-Id: <20070130102910.682974000@bull.net>
References: <20070130101143.296619000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 30 Jan 2007 11:11:48 +0100
From: Nadia.Derbey@bull.net
To: akpm@osdl.org, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 5/6] AKT - per namespace tunables
Content-Disposition: inline; filename=per_namespace_tunables.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 05/06]


This patch introduces all that is needed to process per namespace tunables.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 include/linux/akt.h   |   12 ++++++
 kernel/autotune/akt.c |   94 +++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 83 insertions(+), 23 deletions(-)

Index: linux-2.6.20-rc4/include/linux/akt.h
===================================================================
--- linux-2.6.20-rc4.orig/include/linux/akt.h	2007-01-29 15:47:40.000000000 +0100
+++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-29 15:57:59.000000000 +0100
@@ -126,6 +126,7 @@ struct auto_tune {
  */
 #define AUTO_TUNE_ENABLE  0x01
 #define TUNABLE_REGISTERED  0x02
+#define TUNABLE_IPC_NS      0x04
 
 
 /*
@@ -171,6 +172,8 @@ static inline int is_tunable_registered(
 	}
 
 
+#define DECLARE_TUNABLE(s)	struct auto_tune s;
+
 #define DEFINE_TUNABLE(s, thr, min, max, tun, chk, type)		\
 	struct auto_tune s = TUNABLE_INIT(#s, thr, min, max, tun, chk, type)
 
@@ -182,6 +185,13 @@ static inline int is_tunable_registered(
 		(s).max.abs_value = _max;	\
 	} while (0)
 
+#define init_tunable_ipcns(ns, s, thr, min, max, tun, chk, type)	\
+	do {								\
+		DEFINE_TUNABLE(s, thr, min, max, tun, chk, type);	\
+		s.flags |= TUNABLE_IPC_NS;				\
+		ns->s = s;						\
+	} while (0)
+
 
 static inline void set_autotuning_routine(struct auto_tune *tunable,
 					auto_tune_fn fn)
@@ -236,7 +246,9 @@ extern ssize_t store_tunable_max(struct 
 #else	/* CONFIG_AKT */
 
 
+#define DECLARE_TUNABLE(s)
 #define DEFINE_TUNABLE(s, thresh, min, max, tun, chk, type)
+#define init_tunable_ipcns(ns, s, th, m, M, tun, chk, type)  do { } while (0)
 #define set_tunable_min_max(s, min, max)         do { } while (0)
 #define set_autotuning_routine(s, fn)            do { } while (0)
 
Index: linux-2.6.20-rc4/kernel/autotune/akt.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/autotune/akt.c	2007-01-29 15:50:31.000000000 +0100
+++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-29 16:02:10.000000000 +0100
@@ -32,6 +32,7 @@
  *              store_tunable_min          (exported)
  *              show_tunable_max           (exported)
  *              store_tunable_max          (exported)
+ *              get_ns_tunable             (static)
  */
 
 #include <linux/init.h>
@@ -43,6 +44,10 @@
 #define AKT_AUTO   1
 #define AKT_MANUAL 0
 
+static struct auto_tune *get_ns_tunable(struct auto_tune *);
+
+
+
 /**
  * register_tunable - Inserts a tunable structure into sysfs
  * @tun:	tunable structure to be registered
@@ -149,17 +154,20 @@ EXPORT_SYMBOL_GPL(unregister_tunable);
 ssize_t show_tuning_mode(struct auto_tune *tun_addr, char *buf)
 {
 	int valid;
+	struct auto_tune *which;
 
 	if (tun_addr == NULL) {
 		printk(KERN_ERR "AKT: tunable address is invalid\n");
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
 
-	valid = is_auto_tune_enabled(tun_addr);
+	spin_lock(&which->tunable_lck);
 
-	spin_unlock(&tun_addr->tunable_lck);
+	valid = is_auto_tune_enabled(which);
+
+	spin_unlock(&which->tunable_lck);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", valid);
 }
@@ -183,6 +191,7 @@ ssize_t store_tuning_mode(struct auto_tu
 			size_t count)
 {
 	int new_value;
+	struct auto_tune *which;
 
 	if (sscanf(buffer, "%d", &new_value) != 1)
 		return -EINVAL;
@@ -195,18 +204,20 @@ ssize_t store_tuning_mode(struct auto_tu
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
+
+	spin_lock(&which->tunable_lck);
 
 	switch (new_value) {
 	case AKT_AUTO:
-		tun_addr->flags |= AUTO_TUNE_ENABLE;
+		which->flags |= AUTO_TUNE_ENABLE;
 		break;
 	case AKT_MANUAL:
-		tun_addr->flags &= ~AUTO_TUNE_ENABLE;
+		which->flags &= ~AUTO_TUNE_ENABLE;
 		break;
 	}
 
-	spin_unlock(&tun_addr->tunable_lck);
+	spin_unlock(&which->tunable_lck);
 
 	return strnlen(buffer, PAGE_SIZE);
 }
@@ -227,17 +238,20 @@ ssize_t store_tuning_mode(struct auto_tu
 ssize_t show_tunable_min(struct auto_tune *tun_addr, char *buf)
 {
 	ssize_t rc;
+	struct auto_tune *which;
 
 	if (tun_addr == NULL) {
 		printk(KERN_ERR "AKT: tunable address is invalid\n");
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
+
+	spin_lock(&which->tunable_lck);
 
-	rc = snprintf(buf, PAGE_SIZE, "%lu\n", tun_addr->min.value);
+	rc = snprintf(buf, PAGE_SIZE, "%lu\n", which->min.value);
 
-	spin_unlock(&tun_addr->tunable_lck);
+	spin_unlock(&which->tunable_lck);
 
 	return rc;
 }
@@ -259,6 +273,7 @@ ssize_t store_tunable_min(struct auto_tu
 			size_t count)
 {
 	ssize_t rc;
+	struct auto_tune *which;
 	ulong new_value;
 
 	if (sscanf(buf, "%lu", &new_value) != 1)
@@ -269,16 +284,18 @@ ssize_t store_tunable_min(struct auto_tu
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
 
-	if (new_value >= tun_addr->min.abs_value &&
-					new_value < tun_addr->max.value) {
-		tun_addr->min.value = new_value;
+	spin_lock(&which->tunable_lck);
+
+	if (new_value >= which->min.abs_value &&
+					new_value < which->max.value) {
+		which->min.value = new_value;
 		rc = strnlen(buf, PAGE_SIZE);
 	} else
 		rc = -EINVAL;
 
-	spin_unlock(&tun_addr->tunable_lck);
+	spin_unlock(&which->tunable_lck);
 
 	return rc;
 }
@@ -299,17 +316,20 @@ ssize_t store_tunable_min(struct auto_tu
 ssize_t show_tunable_max(struct auto_tune *tun_addr, char *buf)
 {
 	ssize_t rc;
+	struct auto_tune *which;
 
 	if (tun_addr == NULL) {
 		printk(KERN_ERR "AKT: tunable address is invalid\n");
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
+
+	spin_lock(&which->tunable_lck);
 
-	rc = snprintf(buf, PAGE_SIZE, "%lu\n", tun_addr->max.value);
+	rc = snprintf(buf, PAGE_SIZE, "%lu\n", which->max.value);
 
-	spin_unlock(&tun_addr->tunable_lck);
+	spin_unlock(&which->tunable_lck);
 
 	return rc;
 }
@@ -331,6 +351,7 @@ ssize_t store_tunable_max(struct auto_tu
 			size_t count)
 {
 	ssize_t rc;
+	struct auto_tune *which;
 	ulong new_value;
 
 	if (sscanf(buf, "%lu", &new_value) != 1)
@@ -341,16 +362,43 @@ ssize_t store_tunable_max(struct auto_tu
 		return -EINVAL;
 	}
 
-	spin_lock(&tun_addr->tunable_lck);
+	which = get_ns_tunable(tun_addr);
+
+	spin_lock(&which->tunable_lck);
 
-	if (new_value <= tun_addr->max.abs_value &&
-					new_value > tun_addr->min.value) {
-		tun_addr->max.value = new_value;
+	if (new_value <= which->max.abs_value &&
+					new_value > which->min.value) {
+		which->max.value = new_value;
 		rc = strnlen(buf, PAGE_SIZE);
 	} else
 		rc = -EINVAL;
 
-	spin_unlock(&tun_addr->tunable_lck);
+	spin_unlock(&which->tunable_lck);
 
 	return rc;
 }
+
+
+/**
+ * get_ns_tunable - Gets the tunable structure for the current namespace
+ * @p:	pointer to the tunable for the init namespace
+ *
+ * This routine gets the actual auto_tune structure for the tunables that are
+ * per namespace (presently only ipc ones).
+ *
+ * Returns:	>0 - pointer to the tunable structure for the current ns
+ */
+static struct auto_tune *get_ns_tunable(struct auto_tune *p)
+{
+	if (p->flags & TUNABLE_IPC_NS) {
+		char *shift = (char *) p;
+		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+
+		shift = (shift - (char *) &init_ipc_ns) + (char *) ns;
+
+		return (struct auto_tune *) shift;
+	}
+
+	return p;
+}
+

--
