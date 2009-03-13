Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZCMGYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZCMGYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 02:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZCMGYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 02:24:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54389 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZCMGYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 02:24:16 -0400
Date: Fri, 13 Mar 2009 01:24:14 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>
Subject: [PATCH] eCryptfs: Don't encrypt file key with filename key
Message-ID: <20090313062410.GA32384@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs has file encryption keys (FEK), file encryption key encryption
keys (FEKEK), and filename encryption keys (FNEK).  The per-file FEK is
encrypted with one or more FEKEKs and stored in the header of the
encrypted file.  I noticed that the FEK is also being encrypted by the
FNEK.  This is a problem if a user wants to use a different FNEK than
their FEKEK, as their file contents will still be accessible with the
FNEK.

This is a minimalistic patch which prevents the FNEKs signatures from
being copied to the inode signatures list.  Ultimately, it keeps the FEK
from being encrypted with a FNEK.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/crypto.c          |    2 ++
 fs/ecryptfs/ecryptfs_kernel.h |    3 ++-
 fs/ecryptfs/keystore.c        |    3 ++-
 fs/ecryptfs/main.c            |    5 +++--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f6caeb1..bdca1f4 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -946,6 +946,8 @@ static int ecryptfs_copy_mount_wide_sigs_to_inode_sigs(
 	list_for_each_entry(global_auth_tok,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
+		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_FNEK)
+			continue;
 		rc = ecryptfs_add_keysig(crypt_stat, global_auth_tok->sig);
 		if (rc) {
 			printk(KERN_ERR "Error adding keysig; rc = [%d]\n", rc);
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index c11fc95..eb2267e 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -328,6 +328,7 @@ struct ecryptfs_dentry_info {
  */
 struct ecryptfs_global_auth_tok {
 #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
+#define ECRYPTFS_AUTH_TOK_FNEK    0x00000002
 	u32 flags;
 	struct list_head mount_crypt_stat_list;
 	struct key *global_auth_tok_key;
@@ -696,7 +697,7 @@ ecryptfs_write_header_metadata(char *virt,
 int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig);
 int
 ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
-			   char *sig);
+			   char *sig, u32 global_auth_tok_flags);
 int ecryptfs_get_global_auth_tok_for_sig(
 	struct ecryptfs_global_auth_tok **global_auth_tok,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig);
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index ff53942..e4a6223 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -2375,7 +2375,7 @@ struct kmem_cache *ecryptfs_global_auth_tok_cache;
 
 int
 ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
-			     char *sig)
+			     char *sig, u32 global_auth_tok_flags)
 {
 	struct ecryptfs_global_auth_tok *new_auth_tok;
 	int rc = 0;
@@ -2389,6 +2389,7 @@ ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 		goto out;
 	}
 	memcpy(new_auth_tok->sig, sig, ECRYPTFS_SIG_SIZE_HEX);
+	new_auth_tok->flags = global_auth_tok_flags;
 	new_auth_tok->sig[ECRYPTFS_SIG_SIZE_HEX] = '\0';
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	list_add(&new_auth_tok->mount_crypt_stat_list,
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 789cf2e..aed56c2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -319,7 +319,7 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 		case ecryptfs_opt_ecryptfs_sig:
 			sig_src = args[0].from;
 			rc = ecryptfs_add_global_auth_tok(mount_crypt_stat,
-							  sig_src);
+							  sig_src, 0);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to register "
 				       "global sig; rc = [%d]\n", rc);
@@ -370,7 +370,8 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 				ECRYPTFS_SIG_SIZE_HEX] = '\0';
 			rc = ecryptfs_add_global_auth_tok(
 				mount_crypt_stat,
-				mount_crypt_stat->global_default_fnek_sig);
+				mount_crypt_stat->global_default_fnek_sig,
+				ECRYPTFS_AUTH_TOK_FNEK);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to register "
 				       "global fnek sig [%s]; rc = [%d]\n",
-- 
1.5.3.7

