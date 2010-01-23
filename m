Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529Ab0AWA32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0AWA32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519Ab0AWA3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:29:24 -0500
Received: from kroah.org ([198.145.64.141]:35028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0AWASo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.003565766@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [06/29] ecryptfs: use after free
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit ece550f51ba175c14ec3ec047815927d7386ea1f upstream.

The "full_alg_name" variable is used on a couple error paths, so we
shouldn't free it until the end.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1748,7 +1748,7 @@ ecryptfs_process_key_cipher(struct crypt
 			    char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
-	char *full_alg_name;
+	char *full_alg_name = NULL;
 	int rc;
 
 	*key_tfm = NULL;
@@ -1763,7 +1763,6 @@ ecryptfs_process_key_cipher(struct crypt
 	if (rc)
 		goto out;
 	*key_tfm = crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
-	kfree(full_alg_name);
 	if (IS_ERR(*key_tfm)) {
 		rc = PTR_ERR(*key_tfm);
 		printk(KERN_ERR "Unable to allocate crypto cipher with name "
@@ -1786,6 +1785,7 @@ ecryptfs_process_key_cipher(struct crypt
 		goto out;
 	}
 out:
+	kfree(full_alg_name);
 	return rc;
 }
 


