Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZH0QrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZH0QrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZH0QrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:47:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46317 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZH0QrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:47:21 -0400
Subject: [PATCH] ecryptfs: improved dependency checking and reporting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net,
       Dustin Kirkland <kirkland@canonical.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 09:47:07 -0700
Message-Id: <1251391627.9753.3771.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I compiled a 2.6.31-rc5 kernel with ecryptfs and loaded its module.
When it came time to mount my filesystem, I got this in dmesg, and it
refused to mount:

[93577.776637] Unable to allocate crypto cipher with name [aes]; rc = [-2]
[93577.783280] Error attempting to initialize key TFM cipher with name = [aes]; rc = [-2]
[93577.791183] Error attempting to initialize cipher with name = [aes] and key size = [32]; rc = [-2]
[93577.800113] Error parsing options; rc = [-22]

I figured from the error message that I'd either forgotten to load "aes"
or that my key size was bogus.  Neither one of those was the case.  In
fact, I was missing the CRYPTO_ECB config option and the 'ecb' module.
Unfortunately, there's no trace of 'ecb' in that error message.

I've done two things to fix this.  First, I've modified ecryptfs's
Kconfig entry to select CRYPTO_ECB and CRYPTO_CBC.  I also took CRYPTO
out of the dependencies since the 'select' will take care of it for us.

I've also modified the error messages to print a string that should
contain both 'ecb' and 'aes' in my error case.  That will give any
future users a chance of finding the right modules and Kconfig options.

I also wonder if we should:

	select CRYPTO_AES if !EMBEDDED

since I think most ecryptfs users are using AES like me.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index 0c754e6..29c7f97 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,8 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
+	depends on EXPERIMENTAL && KEYS && NET
+	select CRYPTO_ECB
+	select CRYPTO_CBC
 	help
 	  Encrypted filesystem that operates on the VFS layer.  See
 	  <file:Documentation/filesystems/ecryptfs.txt> to learn more about
@@ -9,3 +11,4 @@ config ECRYPT_FS
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ecryptfs.
+
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index b91851f..5cda73d 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1763,7 +1763,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	if (IS_ERR(*key_tfm)) {
 		rc = PTR_ERR(*key_tfm);
 		printk(KERN_ERR "Unable to allocate crypto cipher with name "
-		       "[%s]; rc = [%d]\n", cipher_name, rc);
+		       "[%s]; rc = [%d]\n", full_alg_name, rc);
 		goto out;
 	}
 	crypto_blkcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_WEAK_KEY);
@@ -1776,7 +1776,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 	rc = crypto_blkcipher_setkey(*key_tfm, dummy_key, *key_size);
 	if (rc) {
 		printk(KERN_ERR "Error attempting to set key of size [%zd] for "
-		       "cipher [%s]; rc = [%d]\n", *key_size, cipher_name, rc);
+		       "cipher [%s]; rc = [%d]\n", *key_size, full_alg_name, rc);
 		rc = -EINVAL;
 		goto out;
 	}


-- 


-- Dave

