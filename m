Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbXLWR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbXLWR0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 12:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXLWR0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 12:26:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbXLWR0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 12:26:31 -0500
Message-ID: <476E9A30.6070602@redhat.com>
Date: Sun, 23 Dec 2007 11:26:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, mike@halcrow.us,
       Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] (UPDATED2) ecryptfs: check for existing key_tfm at mount
 time
References: <476B4CB9.9070700@redhat.com>	<20071221205618.d04bea09.akpm@linux-foundation.org>	<476D4C8D.9080602@redhat.com> <20071222162516.df6fe557.akpm@linux-foundation.org>
In-Reply-To: <20071222162516.df6fe557.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer pointed out that a mount; umount loop of ecryptfs,
with the same cipher & other mount options, created a new 
ecryptfs_key_tfm_cache item each time, and the cache could
grow quite large this way.

Looking at this with mhalcrow, we saw that ecryptfs_parse_options()
unconditionally called ecryptfs_add_new_key_tfm(), which is what
was adding these items.

Refactor ecryptfs_get_tfm_and_mutex_for_cipher_name() to create a 
new helper function, ecryptfs_tfm_exists(), which checks for the 
cipher on the cached key_tfm_list, and sets a pointer
to it if it exists.  This can then be called from 
ecryptfs_parse_options(), and new key_tfm's can be added only when
a cached one is not found.

With list locking changes suggested by akpm.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24-rc3/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.24-rc3/fs/ecryptfs/crypto.c
@@ -1778,7 +1778,7 @@ out:
 
 struct kmem_cache *ecryptfs_key_tfm_cache;
 static struct list_head key_tfm_list;
-static struct mutex key_tfm_list_mutex;
+struct mutex key_tfm_list_mutex;
 
 int ecryptfs_init_crypto(void)
 {
@@ -1787,6 +1787,11 @@ int ecryptfs_init_crypto(void)
 	return 0;
 }
 
+/**
+ * ecryptfs_destroy_crypto - free all cached key_tfms on key_tfm_list
+ *
+ * Called only at module unload time
+ */
 int ecryptfs_destroy_crypto(void)
 {
 	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
@@ -1810,6 +1815,8 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 	struct ecryptfs_key_tfm *tmp_tfm;
 	int rc = 0;
 
+	BUG_ON(!mutex_is_locked(&key_tfm_list_mutex));
+
 	tmp_tfm = kmem_cache_alloc(ecryptfs_key_tfm_cache, GFP_KERNEL);
 	if (key_tfm != NULL)
 		(*key_tfm) = tmp_tfm;
@@ -1835,13 +1842,51 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 			(*key_tfm) = NULL;
 		goto out;
 	}
-	mutex_lock(&key_tfm_list_mutex);
 	list_add(&tmp_tfm->key_tfm_list, &key_tfm_list);
-	mutex_unlock(&key_tfm_list_mutex);
 out:
 	return rc;
 }
 
+/**
+ * ecryptfs_tfm_exists - Search for existing tfm for cipher_name.
+ * @cipher_name: the name of the cipher to search for
+ * @key_tfm: set to corresponding tfm if found
+ *
+ * Searches for cached key_tfm matching @cipher_name
+ * Must be called with &key_tfm_list_mutex held
+ * Returns 1 if found, with @key_tfm set
+ * Returns 0 if not found, with @key_tfm set to NULL
+ */
+int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm)
+{
+	struct ecryptfs_key_tfm *tmp_key_tfm;
+
+	BUG_ON(!mutex_is_locked(&key_tfm_list_mutex));
+
+	list_for_each_entry(tmp_key_tfm, &key_tfm_list, key_tfm_list) {
+		if (strcmp(tmp_key_tfm->cipher_name, cipher_name) == 0) {
+			mutex_unlock(&key_tfm_list_mutex);
+			if (key_tfm)
+				(*key_tfm) = tmp_key_tfm;
+			return 1;
+		}
+	}
+	if (key_tfm)
+		(*key_tfm) = NULL;
+	return 0;
+}
+
+/**
+ * ecryptfs_get_tfm_and_mutex_for_cipher_name
+ *
+ * @tfm: set to cached tfm found, or new tfm created
+ * @tfm_mutex: set to mutex for cached tfm found, or new tfm created
+ * @cipher_name: the name of the cipher to search for and/or add
+ *
+ * Sets pointers to @tfm & @tfm_mutex matching @cipher_name.
+ * Searches for cached item first, and creates new if not found.
+ * Returns 0 on success, non-zero if adding new cipher failed
+ */
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name)
@@ -1851,22 +1896,17 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 
 	(*tfm) = NULL;
 	(*tfm_mutex) = NULL;
+
 	mutex_lock(&key_tfm_list_mutex);
-	list_for_each_entry(key_tfm, &key_tfm_list, key_tfm_list) {
-		if (strcmp(key_tfm->cipher_name, cipher_name) == 0) {
-			(*tfm) = key_tfm->key_tfm;
-			(*tfm_mutex) = &key_tfm->key_tfm_mutex;
-			mutex_unlock(&key_tfm_list_mutex);
+	if (!ecryptfs_tfm_exists(cipher_name, &key_tfm)) {
+		rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
+		if (rc) {
+			printk(KERN_ERR "Error adding new key_tfm to list; "
+					"rc = [%d]\n", rc);
 			goto out;
 		}
 	}
 	mutex_unlock(&key_tfm_list_mutex);
-	rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
-	if (rc) {
-		printk(KERN_ERR "Error adding new key_tfm to list; rc = [%d]\n",
-		       rc);
-		goto out;
-	}
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
Index: linux-2.6.24-rc3/fs/ecryptfs/ecryptfs_kernel.h
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/ecryptfs_kernel.h
+++ linux-2.6.24-rc3/fs/ecryptfs/ecryptfs_kernel.h
@@ -323,6 +323,8 @@ struct ecryptfs_key_tfm {
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
+extern struct mutex key_tfm_list_mutex;
+
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -617,6 +619,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 			 size_t key_size);
 int ecryptfs_init_crypto(void);
 int ecryptfs_destroy_crypto(void);
+int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm);
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name);
Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
+++ linux-2.6.24-rc3/fs/ecryptfs/main.c
@@ -420,9 +420,13 @@ static int ecryptfs_parse_options(struct
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
 	}
-	rc = ecryptfs_add_new_key_tfm(
-		NULL, mount_crypt_stat->global_default_cipher_name,
-		mount_crypt_stat->global_default_cipher_key_size);
+	mutex_lock(&key_tfm_list_mutex);
+	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
+				 NULL))
+		rc = ecryptfs_add_new_key_tfm(
+			NULL, mount_crypt_stat->global_default_cipher_name,
+			mount_crypt_stat->global_default_cipher_key_size);
+	mutex_unlock(&key_tfm_list_mutex);
 	if (rc) {
 		printk(KERN_ERR "Error attempting to initialize cipher with "
 		       "name = [%s] and key size = [%td]; rc = [%d]\n",

