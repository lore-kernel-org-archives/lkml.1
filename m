Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXIOMut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXIOMut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXIOMul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:50:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38750 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXIOMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:50:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Sep 2007 14:50:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: csr1212: proper refcounting
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.2c50dd7344d115e3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Accesses to struct csr1212_keyval's reference counter have to be atomic
and require proper barriers.  Also, calls to csr1212_keep_keyval(kv)
have to occur before kv is getting used.

(We probably should convert refcnt to struct kref, but how to keep
csr1212_destroy_keyval's implementation non-recursively then?)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/csr1212.c |   57 +++++++++++++++++++------------------
 drivers/ieee1394/csr1212.h |    6 ++-
 drivers/ieee1394/nodemgr.c |    4 +-
 3 files changed, 36 insertions(+), 31 deletions(-)

Index: linux/drivers/ieee1394/csr1212.c
===================================================================
--- linux.orig/drivers/ieee1394/csr1212.c
+++ linux/drivers/ieee1394/csr1212.c
@@ -218,12 +218,10 @@ static struct csr1212_keyval *csr1212_ne
 	if (!kv)
 		return NULL;
 
+	atomic_set(&kv->refcnt, 1);
 	kv->key.type = type;
 	kv->key.id = key;
-
 	kv->associate = NULL;
-	kv->refcnt = 1;
-
 	kv->next = NULL;
 	kv->prev = NULL;
 	kv->offset = 0;
@@ -326,12 +324,13 @@ void csr1212_associate_keyval(struct csr
 	if (kv->associate)
 		csr1212_release_keyval(kv->associate);
 
-	associate->refcnt++;
+	csr1212_keep_keyval(associate);
 	kv->associate = associate;
 }
 
-int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
-				       struct csr1212_keyval *kv)
+static int __csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
+						struct csr1212_keyval *kv,
+						bool keep_keyval)
 {
 	struct csr1212_dentry *dentry;
 
@@ -341,10 +340,10 @@ int csr1212_attach_keyval_to_directory(s
 	if (!dentry)
 		return -ENOMEM;
 
+	if (keep_keyval)
+		csr1212_keep_keyval(kv);
 	dentry->kv = kv;
 
-	kv->refcnt++;
-
 	dentry->next = NULL;
 	dentry->prev = dir->value.directory.dentries_tail;
 
@@ -358,6 +357,12 @@ int csr1212_attach_keyval_to_directory(s
 	return CSR1212_SUCCESS;
 }
 
+int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
+				       struct csr1212_keyval *kv)
+{
+	return __csr1212_attach_keyval_to_directory(dir, kv, true);
+}
+
 #define CSR1212_DESCRIPTOR_LEAF_DATA(kv) \
 	(&((kv)->value.leaf.data[1]))
 
@@ -483,15 +488,18 @@ void csr1212_detach_keyval_from_director
 
 /* This function is used to free the memory taken by a keyval.  If the given
  * keyval is a directory type, then any keyvals contained in that directory
- * will be destroyed as well if their respective refcnts are 0.  By means of
+ * will be destroyed as well if noone holds a reference on them.  By means of
  * list manipulation, this routine will descend a directory structure in a
  * non-recursive manner. */
-static void csr1212_destroy_keyval(struct csr1212_keyval *kv)
+void csr1212_release_keyval(struct csr1212_keyval *kv)
 {
 	struct csr1212_keyval *k, *a;
 	struct csr1212_dentry dentry;
 	struct csr1212_dentry *head, *tail;
 
+	if (!atomic_dec_and_test(&kv->refcnt))
+		return;
+
 	dentry.kv = kv;
 	dentry.next = NULL;
 	dentry.prev = NULL;
@@ -503,9 +511,8 @@ static void csr1212_destroy_keyval(struc
 		k = head->kv;
 
 		while (k) {
-			k->refcnt--;
-
-			if (k->refcnt > 0)
+			/* must not dec_and_test kv->refcnt again */
+			if (k != kv && !atomic_dec_and_test(&k->refcnt))
 				break;
 
 			a = k->associate;
@@ -536,14 +543,6 @@ static void csr1212_destroy_keyval(struc
 	}
 }
 
-void csr1212_release_keyval(struct csr1212_keyval *kv)
-{
-	if (kv->refcnt > 1)
-		kv->refcnt--;
-	else
-		csr1212_destroy_keyval(kv);
-}
-
 void csr1212_destroy_csr(struct csr1212_csr *csr)
 {
 	struct csr1212_csr_rom_cache *c, *oc;
@@ -1126,6 +1125,7 @@ csr1212_parse_dir_entry(struct csr1212_k
 	int ret = CSR1212_SUCCESS;
 	struct csr1212_keyval *k = NULL;
 	u32 offset;
+	bool keep_keyval = true;
 
 	switch (CSR1212_KV_KEY_TYPE(ki)) {
 	case CSR1212_KV_TYPE_IMMEDIATE:
@@ -1135,8 +1135,8 @@ csr1212_parse_dir_entry(struct csr1212_k
 			ret = -ENOMEM;
 			goto out;
 		}
-
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
 		break;
 
 	case CSR1212_KV_TYPE_CSR_OFFSET:
@@ -1146,7 +1146,8 @@ csr1212_parse_dir_entry(struct csr1212_k
 			ret = -ENOMEM;
 			goto out;
 		}
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
 		break;
 
 	default:
@@ -1174,8 +1175,10 @@ csr1212_parse_dir_entry(struct csr1212_k
 			ret = -ENOMEM;
 			goto out;
 		}
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
-		k->valid = 0;	/* Contents not read yet so it's not valid. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
+		/* Contents not read yet so it's not valid. */
+		k->valid = 0;
 		k->offset = offset;
 
 		k->prev = dir;
@@ -1183,7 +1186,7 @@ csr1212_parse_dir_entry(struct csr1212_k
 		dir->next->prev = k;
 		dir->next = k;
 	}
-	ret = csr1212_attach_keyval_to_directory(dir, k);
+	ret = __csr1212_attach_keyval_to_directory(dir, k, keep_keyval);
 out:
 	if (ret != CSR1212_SUCCESS && k != NULL)
 		free_keyval(k);
Index: linux/drivers/ieee1394/csr1212.h
===================================================================
--- linux.orig/drivers/ieee1394/csr1212.h
+++ linux/drivers/ieee1394/csr1212.h
@@ -32,6 +32,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <asm/atomic.h>
 
 #define CSR1212_MALLOC(size)	kmalloc((size), GFP_KERNEL)
 #define CSR1212_FREE(ptr)	kfree(ptr)
@@ -149,7 +150,7 @@ struct csr1212_keyval {
 		struct csr1212_directory directory;
 	} value;
 	struct csr1212_keyval *associate;
-	int refcnt;
+	atomic_t refcnt;
 
 	/* used in generating and/or parsing CSR image */
 	struct csr1212_keyval *next, *prev;	/* flat list of CSR elements */
@@ -350,7 +351,8 @@ csr1212_get_keyval(struct csr1212_csr *c
  * need for code to retain a keyval that has been parsed. */
 static inline void csr1212_keep_keyval(struct csr1212_keyval *kv)
 {
-	kv->refcnt++;
+	atomic_inc(&kv->refcnt);
+	smp_mb__after_atomic_inc();
 }
 
 
Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -1015,13 +1015,13 @@ static struct unit_directory *nodemgr_pr
 			    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_LANGUAGE(kv) == 0) {
 				switch (last_key_id) {
 				case CSR1212_KV_ID_VENDOR:
-					ud->vendor_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					ud->vendor_name_kv = kv;
 					break;
 
 				case CSR1212_KV_ID_MODEL:
-					ud->model_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					ud->model_name_kv = kv;
 					break;
 
 				}

-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/

