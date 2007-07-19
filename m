Return-Path: <linux-kernel-owner+w=401wt.eu-S1764823AbXGSV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764823AbXGSV3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXGSV3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:29:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50899 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXGSV3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:29:39 -0400
Date: Thu, 19 Jul 2007 16:27:21 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 3/8] eCryptfs: kmem_cache objects for multiple keys; init/exit functions
Message-ID: <20070719212721.GD13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kmem_cache objects for handling multiple keys per inode. Add
calls in the module init and exit code to call the key list
initialization/destruction functions.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/main.c |   39 +++++++++++++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 5da6180..dd9d7b5 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -240,14 +240,11 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 	int cipher_name_set = 0;
 	int cipher_key_bytes;
 	int cipher_key_bytes_set = 0;
-	struct key *auth_tok_key = NULL;
-	struct ecryptfs_auth_tok *auth_tok = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
 	char *sig_src;
-	char *sig_dst;
 	char *debug_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
@@ -258,6 +255,7 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 		rc = -EINVAL;
 		goto out;
 	}
+	ecryptfs_init_mount_crypt_stat(mount_crypt_stat);
 	while ((p = strsep(&options, ",")) != NULL) {
 		if (!*p)
 			continue;
@@ -334,12 +332,10 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 					p);
 		}
 	}
-	/* Do not support lack of mount-wide signature in 0.1
-	 * release */
 	if (!sig_set) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "You must supply a valid "
-				"passphrase auth tok signature as a mount "
+		ecryptfs_printk(KERN_ERR, "You must supply at least one valid "
+				"auth tok signature as a mount "
 				"parameter; see the eCryptfs README\n");
 		goto out;
 	}
@@ -615,6 +611,21 @@ static struct ecryptfs_cache_info {
 		.name = "ecryptfs_key_record_cache",
 		.size = sizeof(struct ecryptfs_key_record),
 	},
+	{
+		.cache = &ecryptfs_key_sig_cache,
+		.name = "ecryptfs_key_sig_cache",
+		.size = sizeof(struct ecryptfs_key_sig),
+	},
+	{
+		.cache = &ecryptfs_global_auth_tok_cache,
+		.name = "ecryptfs_global_auth_tok_cache",
+		.size = sizeof(struct ecryptfs_global_auth_tok),
+	},
+	{
+		.cache = &ecryptfs_key_tfm_cache,
+		.name = "ecryptfs_key_tfm_cache",
+		.size = sizeof(struct ecryptfs_key_tfm),
+	},
 };
 
 static void ecryptfs_free_kmem_caches(void)
@@ -717,7 +728,8 @@ static struct ecryptfs_version_str_map_elem {
 	{ECRYPTFS_VERSIONING_PUBKEY, "pubkey"},
 	{ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH, "plaintext passthrough"},
 	{ECRYPTFS_VERSIONING_POLICY, "policy"},
-	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"}
+	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"},
+	{ECRYPTFS_VERSIONING_MULTKEY, "multiple keys per file"}
 };
 
 static ssize_t version_str_show(struct ecryptfs_obj *obj, char *buff)
@@ -820,6 +832,11 @@ static int __init ecryptfs_init(void)
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
 				"initialize the eCryptfs netlink socket\n");
+		goto out;
+	}
+	if ((rc = ecryptfs_init_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to init crypto; "
+		       "rc = [%d]\n", rc);
 	}
 out:
 	return rc;
@@ -827,6 +844,12 @@ out:
 
 static void __exit ecryptfs_exit(void)
 {
+	int rc;
+
+	if ((rc = ecryptfs_destruct_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to destruct crypto; "
+		       "rc = [%d]\n", rc);
+	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
 			  &sysfs_attr_version.attr);
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
-- 
1.4.4.4

