Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXLRU7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXLRU7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXLRU6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:58:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXLRU6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:58:54 -0500
Message-ID: <47683470.1050904@redhat.com>
Date: Tue, 18 Dec 2007 14:58:24 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
CC: Michael Halcrow <mhalcrow@us.ibm.com>, mike@halcrow.us,
       Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] ecryptfs: fix unlocking in error paths
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Josef Bacik for finding these.

A couple of ecryptfs error paths don't properly unlock things they locked.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
---

Index: linux-2.6.24-rc3/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.24-rc3/fs/ecryptfs/crypto.c
@@ -799,7 +799,7 @@ int ecryptfs_init_crypt_ctx(struct ecryp
 	rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
 						    crypt_stat->cipher, "cbc");
 	if (rc)
-		goto out;
+		goto out_unlock;
 	crypt_stat->tfm = crypto_alloc_blkcipher(full_alg_name, 0,
 						 CRYPTO_ALG_ASYNC);
 	kfree(full_alg_name);
@@ -808,12 +808,12 @@ int ecryptfs_init_crypt_ctx(struct ecryp
 		ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
 				"Error initializing cipher [%s]\n",
 				crypt_stat->cipher);
-		mutex_unlock(&crypt_stat->cs_tfm_mutex);
-		goto out;
+		goto out_unlock;
 	}
 	crypto_blkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 	rc = 0;
+out_unlock:
+	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 out:
 	return rc;
 }
Index: linux-2.6.24-rc3/fs/ecryptfs/messaging.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/messaging.c
+++ linux-2.6.24-rc3/fs/ecryptfs/messaging.c
@@ -427,6 +427,7 @@ int ecryptfs_init_messaging(unsigned int
 	if (!ecryptfs_daemon_id_hash) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
 		goto out;
 	}
 	for (i = 0; i < ecryptfs_hash_buckets; i++)

