Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZJBBcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZJBBcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZJBBcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:43 -0400
Received: from kroah.org ([198.145.64.141]:32948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbZJBBcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:09 2009
Message-Id: <20091002012408.943522261@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Serge Hallyn <serue@us.ibm.com>, ecryptfs-devel@lists.launchpad.net,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [021/136] eCryptfs: Filename encryption only supports password auth tokens
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-filename-encryption-only-supports-password-auth-tokens.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit df6ad33ba1b9846bd5f0e2b9016c30c20bc2d948 upstream.

Returns -ENOTSUPP when attempting to use filename encryption with
something other than a password authentication token, such as a private
token from openssl.  Using filename encryption with a userspace eCryptfs
key module is a future goal.  Until then, this patch handles the
situation a little better than simply using a BUG_ON().

Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c   |    4 ++--
 fs/ecryptfs/keystore.c |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1703,7 +1703,7 @@ ecryptfs_encrypt_filename(struct ecryptf
 	} else {
 		printk(KERN_ERR "%s: No support for requested filename "
 		       "encryption method in this release\n", __func__);
-		rc = -ENOTSUPP;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 out:
@@ -2167,7 +2167,7 @@ int ecryptfs_encrypt_and_encode_filename
 			(*encoded_name)[(*encoded_name_size)] = '\0';
 			(*encoded_name_size)++;
 		} else {
-			rc = -ENOTSUPP;
+			rc = -EOPNOTSUPP;
 		}
 		if (rc) {
 			printk(KERN_ERR "%s: Error attempting to encode "
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -612,7 +612,12 @@ ecryptfs_write_tag_70_packet(char *dest,
 	}
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
-	BUG_ON(s->auth_tok->token_type != ECRYPTFS_PASSWORD);
+	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
+		rc = -EOPNOTSUPP;
+		printk(KERN_INFO "%s: Filename encryption only supports "
+		       "password tokens\n", __func__);
+		goto out_free_unlock;
+	}
 	sg_init_one(
 		&s->hash_sg,
 		(u8 *)s->auth_tok->token.password.session_key_encryption_key,
@@ -910,7 +915,12 @@ ecryptfs_parse_tag_70_packet(char **file
 	}
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
-	BUG_ON(s->auth_tok->token_type != ECRYPTFS_PASSWORD);
+	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
+		rc = -EOPNOTSUPP;
+		printk(KERN_INFO "%s: Filename encryption only supports "
+		       "password tokens\n", __func__);
+		goto out_free_unlock;
+	}
 	rc = crypto_blkcipher_setkey(
 		s->desc.tfm,
 		s->auth_tok->token.password.session_key_encryption_key,


