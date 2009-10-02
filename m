Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZJBCAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZJBCAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZJBB75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:59:57 -0400
Received: from kroah.org ([198.145.64.141]:32937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZJBBcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:08 2009
Message-Id: <20091002012408.644856870@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>, ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [019/136] eCryptfs: Handle unrecognized tag 3 cipher codes
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-handle-unrecognized-tag-3-cipher-codes.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit b0105eaefa7cce8f4a941d0fc6354b250d30e745 upstream.

Returns an error when an unrecognized cipher code is present in a tag 3
packet or an ecryptfs_crypt_stat cannot be initialized.  Also sets an
crypt_stat->tfm error pointer to NULL to ensure that it will not be
incorrectly freed in ecryptfs_destroy_crypt_stat().

Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c   |    1 +
 fs/ecryptfs/keystore.c |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -797,6 +797,7 @@ int ecryptfs_init_crypt_ctx(struct ecryp
 	kfree(full_alg_name);
 	if (IS_ERR(crypt_stat->tfm)) {
 		rc = PTR_ERR(crypt_stat->tfm);
+		crypt_stat->tfm = NULL;
 		ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
 				"Error initializing cipher [%s]\n",
 				crypt_stat->cipher);
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1316,8 +1316,10 @@ parse_tag_3_packet(struct ecryptfs_crypt
 		rc = -EINVAL;
 		goto out_free;
 	}
-	ecryptfs_cipher_code_to_string(crypt_stat->cipher,
-				       (u16)data[(*packet_size)]);
+	rc = ecryptfs_cipher_code_to_string(crypt_stat->cipher,
+					    (u16)data[(*packet_size)]);
+	if (rc)
+		goto out_free;
 	/* A little extra work to differentiate among the AES key
 	 * sizes; see RFC2440 */
 	switch(data[(*packet_size)++]) {
@@ -1328,7 +1330,9 @@ parse_tag_3_packet(struct ecryptfs_crypt
 		crypt_stat->key_size =
 			(*new_auth_tok)->session_key.encrypted_key_size;
 	}
-	ecryptfs_init_crypt_ctx(crypt_stat);
+	rc = ecryptfs_init_crypt_ctx(crypt_stat);
+	if (rc)
+		goto out_free;
 	if (unlikely(data[(*packet_size)++] != 0x03)) {
 		printk(KERN_WARNING "Only S2K ID 3 is currently supported\n");
 		rc = -ENOSYS;


