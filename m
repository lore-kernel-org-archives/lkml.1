Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYKDVn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYKDVn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYKDVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:43:17 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40506 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbYKDVnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:43:16 -0500
Date: Tue, 4 Nov 2008 15:43:13 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: [PATCH 5/5] eCryptfs: Filename Encryption: mount option
Message-ID: <20081104214313.GE6677@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable mount-wide filename encryption by providing the Filename
Encryption Key (FNEK) signature as a mount option. Note that the
ecryptfs-utils userspace package versions 61 or later support
this option.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/main.c |  126 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 99 insertions(+), 27 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index fd63071..789cf2e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -206,7 +206,9 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_cipher, ecryptfs_opt_ecryptfs_cipher,
        ecryptfs_opt_ecryptfs_key_bytes,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
-       ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
+       ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
+       ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
+       ecryptfs_opt_err };
 
 static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -217,6 +219,9 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_passthrough, "ecryptfs_passthrough"},
 	{ecryptfs_opt_xattr_metadata, "ecryptfs_xattr_metadata"},
 	{ecryptfs_opt_encrypted_view, "ecryptfs_encrypted_view"},
+	{ecryptfs_opt_fnek_sig, "ecryptfs_fnek_sig=%s"},
+	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=%s"},
+	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -281,8 +286,11 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 	int rc = 0;
 	int sig_set = 0;
 	int cipher_name_set = 0;
+	int fn_cipher_name_set = 0;
 	int cipher_key_bytes;
 	int cipher_key_bytes_set = 0;
+	int fn_cipher_key_bytes;
+	int fn_cipher_key_bytes_set = 0;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
 	substring_t args[MAX_OPT_ARGS];
@@ -290,7 +298,12 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 	char *sig_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
+	char *fn_cipher_name_dst;
+	char *fn_cipher_name_src;
+	char *fnek_dst;
+	char *fnek_src;
 	char *cipher_key_bytes_src;
+	char *fn_cipher_key_bytes_src;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -322,10 +335,7 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 				global_default_cipher_name;
 			strncpy(cipher_name_dst, cipher_name_src,
 				ECRYPTFS_MAX_CIPHER_NAME_SIZE);
-			ecryptfs_printk(KERN_DEBUG,
-					"The mount_crypt_stat "
-					"global_default_cipher_name set to: "
-					"[%s]\n", cipher_name_dst);
+			cipher_name_dst[ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
 			cipher_name_set = 1;
 			break;
 		case ecryptfs_opt_ecryptfs_key_bytes:
@@ -335,11 +345,6 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 						   &cipher_key_bytes_src, 0);
 			mount_crypt_stat->global_default_cipher_key_size =
 				cipher_key_bytes;
-			ecryptfs_printk(KERN_DEBUG,
-					"The mount_crypt_stat "
-					"global_default_cipher_key_size "
-					"set to: [%d]\n", mount_crypt_stat->
-					global_default_cipher_key_size);
 			cipher_key_bytes_set = 1;
 			break;
 		case ecryptfs_opt_passthrough:
@@ -356,11 +361,51 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 			mount_crypt_stat->flags |=
 				ECRYPTFS_ENCRYPTED_VIEW_ENABLED;
 			break;
+		case ecryptfs_opt_fnek_sig:
+			fnek_src = args[0].from;
+			fnek_dst =
+				mount_crypt_stat->global_default_fnek_sig;
+			strncpy(fnek_dst, fnek_src, ECRYPTFS_SIG_SIZE_HEX);
+			mount_crypt_stat->global_default_fnek_sig[
+				ECRYPTFS_SIG_SIZE_HEX] = '\0';
+			rc = ecryptfs_add_global_auth_tok(
+				mount_crypt_stat,
+				mount_crypt_stat->global_default_fnek_sig);
+			if (rc) {
+				printk(KERN_ERR "Error attempting to register "
+				       "global fnek sig [%s]; rc = [%d]\n",
+				       mount_crypt_stat->global_default_fnek_sig,
+				       rc);
+				goto out;
+			}
+			mount_crypt_stat->flags |=
+				(ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES
+				 | ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK);
+			break;
+		case ecryptfs_opt_fn_cipher:
+			fn_cipher_name_src = args[0].from;
+			fn_cipher_name_dst =
+				mount_crypt_stat->global_default_fn_cipher_name;
+			strncpy(fn_cipher_name_dst, fn_cipher_name_src,
+				ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+			mount_crypt_stat->global_default_fn_cipher_name[
+				ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
+			fn_cipher_name_set = 1;
+			break;
+		case ecryptfs_opt_fn_cipher_key_bytes:
+			fn_cipher_key_bytes_src = args[0].from;
+			fn_cipher_key_bytes =
+				(int)simple_strtol(fn_cipher_key_bytes_src,
+						   &fn_cipher_key_bytes_src, 0);
+			mount_crypt_stat->global_default_fn_cipher_key_bytes =
+				fn_cipher_key_bytes;
+			fn_cipher_key_bytes_set = 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
-			ecryptfs_printk(KERN_WARNING,
-					"eCryptfs: unrecognized option '%s'\n",
-					p);
+			printk(KERN_WARNING
+			       "%s: eCryptfs: unrecognized option [%s]\n",
+			       __func__, p);
 		}
 	}
 	if (!sig_set) {
@@ -374,33 +419,60 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 		int cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
 
 		BUG_ON(cipher_name_len >= ECRYPTFS_MAX_CIPHER_NAME_SIZE);
-
 		strcpy(mount_crypt_stat->global_default_cipher_name,
 		       ECRYPTFS_DEFAULT_CIPHER);
 	}
-	if (!cipher_key_bytes_set) {
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !fn_cipher_name_set)
+		strcpy(mount_crypt_stat->global_default_fn_cipher_name,
+		       mount_crypt_stat->global_default_cipher_name);
+	if (!cipher_key_bytes_set)
 		mount_crypt_stat->global_default_cipher_key_size = 0;
-	}
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !fn_cipher_key_bytes_set)
+		mount_crypt_stat->global_default_fn_cipher_key_bytes =
+			mount_crypt_stat->global_default_cipher_key_size;
 	mutex_lock(&key_tfm_list_mutex);
 	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
-				 NULL))
+				 NULL)) {
 		rc = ecryptfs_add_new_key_tfm(
 			NULL, mount_crypt_stat->global_default_cipher_name,
 			mount_crypt_stat->global_default_cipher_key_size);
-	mutex_unlock(&key_tfm_list_mutex);
-	if (rc) {
-		printk(KERN_ERR "Error attempting to initialize cipher with "
-		       "name = [%s] and key size = [%td]; rc = [%d]\n",
-		       mount_crypt_stat->global_default_cipher_name,
-		       mount_crypt_stat->global_default_cipher_key_size, rc);
-		rc = -EINVAL;
-		goto out;
+		if (rc) {
+			printk(KERN_ERR "Error attempting to initialize "
+			       "cipher with name = [%s] and key size = [%td]; "
+			       "rc = [%d]\n",
+			       mount_crypt_stat->global_default_cipher_name,
+			       mount_crypt_stat->global_default_cipher_key_size,
+			       rc);
+			rc = -EINVAL;
+			mutex_unlock(&key_tfm_list_mutex);
+			goto out;
+		}
 	}
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !ecryptfs_tfm_exists(
+		    mount_crypt_stat->global_default_fn_cipher_name, NULL)) {
+		rc = ecryptfs_add_new_key_tfm(
+			NULL, mount_crypt_stat->global_default_fn_cipher_name,
+			mount_crypt_stat->global_default_fn_cipher_key_bytes);
+		if (rc) {
+			printk(KERN_ERR "Error attempting to initialize "
+			       "cipher with name = [%s] and key size = [%td]; "
+			       "rc = [%d]\n",
+			       mount_crypt_stat->global_default_fn_cipher_name,
+			       mount_crypt_stat->global_default_fn_cipher_key_bytes,
+			       rc);
+			rc = -EINVAL;
+			mutex_unlock(&key_tfm_list_mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&key_tfm_list_mutex);
 	rc = ecryptfs_init_global_auth_toks(mount_crypt_stat);
-	if (rc) {
+	if (rc)
 		printk(KERN_WARNING "One or more global auth toks could not "
 		       "properly register; rc = [%d]\n", rc);
-	}
 out:
 	return rc;
 }
-- 
1.5.3.6

