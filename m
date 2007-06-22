Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbXFVSZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbXFVSZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbXFVSZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:25:32 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61077 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759148AbXFVSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:25:30 -0400
From: Alexander Wuerstlein <arw@arw.name>
To: linux-kernel@vger.kernel.org
Cc: Alexander Wuerstlein <arw@arw.name>,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Date: Fri, 22 Jun 2007 20:25:27 +0200
Message-Id: <1182536729847-git-send-email-arw@arw.name>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modified task_struct to hold a 'signed flag' which is set on exec(), inherited
on fork() and checked during exec before giving the new process suid/sgid
privileges.

sns.c contains our helper functions to verify the signatures.
sns_secret_key.dat contains the 'secret key' which is used for HMAC.

Signed-off-by: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>
---
 fs/exec.c                   |   19 +++++++-
 include/linux/Kbuild        |    2 +
 include/linux/sched.h       |    3 +
 include/linux/sns.h         |    3 +
 kernel/fork.c               |    6 +++
 security/Kconfig            |   28 ++++++++++++
 security/Makefile           |    1 +
 security/sns.c              |  104 +++++++++++++++++++++++++++++++++++++++++++
 security/sns_secret_key.dat |    5 ++
 9 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/sns.h
 create mode 100644 security/sns.c
 create mode 100644 security/sns_secret_key.dat

diff --git a/fs/exec.c b/fs/exec.c
index f20561f..5dfa406 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,9 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/signalfd.h>
+#ifdef CONFIG_SNS_SIGNED
+#include <linux/sns.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -928,13 +931,21 @@ int prepare_binprm(struct linux_binprm *bprm)
 	mode = inode->i_mode;
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
+#ifdef CONFIG_SNS_SIGNED
+	if (mode & S_ISUID)
+		current->sns_valid_sig = sns_signature_valid(bprm->file);
+#endif
 
 	bprm->e_uid = current->euid;
 	bprm->e_gid = current->egid;
 
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
-		if (mode & S_ISUID) {
+#ifdef CONFIG_SNS_SIGNED_SETUID
+               if (mode & S_ISUID && current->sns_valid_sig) {
+#else
+               if (mode & S_ISUID) {
+#endif /*SNS_SIGNED_SETUID*/
 			current->personality &= ~PER_CLEAR_ON_SETID;
 			bprm->e_uid = inode->i_uid;
 		}
@@ -945,7 +956,11 @@ int prepare_binprm(struct linux_binprm *bprm)
 		 * is a candidate for mandatory locking, not a setgid
 		 * executable.
 		 */
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+#ifdef CONFIG_SNS_SIGNED_SETGID
+               if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) && current->sns_valid_sig) {
+#else
+               if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+#endif /*SNS_SIGNED_SETGID*/
 			current->personality &= ~PER_CLEAR_ON_SETID;
 			bprm->e_gid = inode->i_gid;
 		}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f317c27..16df5f0 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -159,6 +159,7 @@ header-y += videotext.h
 header-y += vt.h
 header-y += wireless.h
 header-y += x25.h
+header-y += sns.h
 
 unifdef-y += acct.h
 unifdef-y += adb.h
@@ -347,5 +348,6 @@ unifdef-y += watchdog.h
 unifdef-y += wireless.h
 unifdef-y += xattr.h
 unifdef-y += xfrm.h
+unifdef-y += sns.h
 
 objhdr-y += version.h
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 693f0e6..36c58d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1076,6 +1076,9 @@ struct task_struct {
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+#ifdef CONFIG_SNS_SIGNED
+	int sns_valid_sig;
+#endif
 };
 
 static inline pid_t process_group(struct task_struct *tsk)
diff --git a/include/linux/sns.h b/include/linux/sns.h
new file mode 100644
index 0000000..ad15e4b
--- /dev/null
+++ b/include/linux/sns.h
@@ -0,0 +1,3 @@
+#ifdef CONFIG_SNS_SIGNED
+int sns_signature_valid(struct file *);
+#endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 73ad5cd..c12cf61 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -156,6 +156,9 @@ void __init fork_init(unsigned long mempages)
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_max = max_threads/2;
 	init_task.signal->rlim[RLIMIT_SIGPENDING] =
 		init_task.signal->rlim[RLIMIT_NPROC];
+#ifdef CONFIG_SNS_SIGNED
+	init_task.sns_valid_sig = 0;
+#endif
 }
 
 static struct task_struct *dup_task_struct(struct task_struct *orig)
@@ -182,6 +185,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
 #endif
+#ifdef CONFIG_SNS_SIGNED
+	tsk->sns_valid_sig = orig->sns_valid_sig;
+#endif
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */
 	atomic_set(&tsk->usage,2);
diff --git a/security/Kconfig b/security/Kconfig
index 460e5c9..bfaace7 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -4,6 +4,34 @@
 
 menu "Security options"
 
+config SNS_SIGNED
+	bool "Enable sns-signed binaries (EXPERIMENTAL)"
+	depends on (EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4DEV_FS_XATTR || REISERFS_FS_XATTR || JFFS2_FS_XATTR || CIFS_XATTR) && (CRYPTO_SHA1 || CRYPTO_HMAC || CRYPTO_MD5) && MMU && EXPERIMENTAL
+	help
+	  This option turns on sns-signatures of binaries. Requires extended
+	  attributes and cryptographic hashes/HMAC support. HMAC is preferred.
+
+	  This will leave your system unusable without proper preparation of
+	  your sbit-files.
+
+	  If you don't know exactly what you are doing, answer N.
+
+config SNS_SIGNED_SETUID
+	bool "Enables sns-signed binaries mandatory for suid-bits"
+	depends on SNS_SIGNED
+	help
+	  Mandates signed binaries for suidbits.
+
+	  If you don't know exactly what you are doing, answer N.
+
+config SNS_SIGNED_SETGID
+	bool "Enables sns-signed binaries mandatory for sgid-bits"
+	depends on SNS_SIGNED
+	help
+	  Mandates signed binaries for sgidbits.
+
+	  If you don't know exactly what you are doing, answer N.
+
 config KEYS
 	bool "Enable access key retention support"
 	help
diff --git a/security/Makefile b/security/Makefile
index ef87df2..677b978 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SNS_SIGNED)		+= sns.o
diff --git a/security/sns.c b/security/sns.c
new file mode 100644
index 0000000..4403e5a
--- /dev/null
+++ b/security/sns.c
@@ -0,0 +1,104 @@
+#include <linux/crypto.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+#include <linux/xattr.h>
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/sns.h>
+
+#include "sns_secret_key.dat"
+
+#define SNS_MAX_DIGEST_SIZE	64
+
+struct sns_attr {
+	char algname[CRYPTO_MAX_ALG_NAME+1];
+	char hash_value[SNS_MAX_DIGEST_SIZE];
+};
+
+
+static int sns_sig_reader(read_descriptor_t *desc, struct page *page, unsigned long offset, unsigned long nr)
+{
+	struct scatterlist s;
+	struct hash_desc *hash_desc = (struct hash_desc *) desc->arg.data;
+	unsigned int read;
+
+	s.page = page;
+	s.offset = offset;
+	s.length = nr;
+	read = nr - offset;
+	crypto_hash_update(hash_desc, &s, read);
+	desc->written += read;
+	desc->count -= read;
+	return read;
+}
+
+/*
+ * check file signature for setuid
+ */
+
+int sns_signature_valid(struct file *file)
+{
+	unsigned long i;
+	struct inode *inode = file->f_mapping->host;
+	struct crypto_hash *tfm;
+	struct hash_desc hash_desc;
+	struct sns_attr attrdata;
+	char hash_result[SNS_MAX_DIGEST_SIZE];
+	struct xattr_handler *handler;
+	const char *namespaces[2] = { "trusted.", NULL };
+	int ret = 0;
+	loff_t pos = 0;
+	read_descriptor_t read_desc;
+
+	handler = xattr_resolve_name_sns(inode->i_sb->s_xattr, namespaces);
+	if (unlikely(!handler)) {
+		printk(KERN_DEBUG "sns_signature_valid: xattr_resolve_name failed\n");
+		return 0;
+	}
+	memset(&attrdata, 0, sizeof(struct sns_attr));
+	i = handler->get(inode, "sns", &attrdata, sizeof(struct sns_attr));
+	if (i != sizeof(struct sns_attr)) {
+		printk(KERN_DEBUG "sns_signature_valid: invalid xattr found\n");
+		return 0;
+	}
+	attrdata.algname[CRYPTO_MAX_ALG_NAME] = '\0';
+	read_desc.count = i_size_read(inode);
+	if (unlikely(!read_desc.count)) {
+		printk(KERN_DEBUG "sns_signature_valid: inode of file has invalid size\n");
+		return 0;
+	}
+	tfm = crypto_alloc_hash(attrdata.algname, 0, CRYPTO_ALG_ASYNC);
+	if (unlikely(IS_ERR(tfm))) {
+		printk("sns_signature_valid: %s unavailable\n", attrdata.algname);
+		return 0;
+		/*FIXME: failure mode should be defined at build-time */
+	}
+	memset(hash_result, 0, SNS_MAX_DIGEST_SIZE); /*Needed?*/
+	hash_desc.tfm = tfm;
+	hash_desc.flags = 0;
+	read_desc.arg.data = &hash_desc;
+	read_desc.written = 0;
+	if (crypto_hash_setkey(tfm, sns_secret_key, SNS_SECRET_KEY_SIZE)) {
+		printk("sns_signature_valid: hash function did not accept setkey\n");
+		return 0;
+	}
+	crypto_hash_init(&hash_desc);
+	do_generic_file_read(file, &pos, &read_desc, sns_sig_reader);
+	crypto_hash_final(&hash_desc, hash_result);
+	BUG_ON(read_desc.written != i_size_read(inode));
+#ifdef SNS_SIGNED_DEBUG
+	printk("sns_signature_valid: attrdata.algname = %s\n", attrdata.algname);
+	printk("sns_signature_valid: attrib: ");
+	for (i = 0; i < SNS_MAX_DIGEST_SIZE; i++)
+		printk("%02x ", (unsigned char) attrdata.hash_value[i]);
+	printk("\n");
+	printk("sns_signature_valid: result: ");
+	for (i = 0; i < SNS_MAX_DIGEST_SIZE; i++)
+		printk("%02x ", (unsigned char) hash_result[i]);
+	printk("\n");
+#endif
+	ret = !memcmp(attrdata.hash_value, hash_result, SNS_MAX_DIGEST_SIZE);
+	crypto_free_hash(tfm);
+	return ret;
+}
diff --git a/security/sns_secret_key.dat b/security/sns_secret_key.dat
new file mode 100644
index 0000000..aec09da
--- /dev/null
+++ b/security/sns_secret_key.dat
@@ -0,0 +1,5 @@
+#define SNS_SECRET_KEY_SIZE 8
+static char sns_secret_key[SNS_SECRET_KEY_SIZE] =
+	{
+		'd', 'e', 'a', 'd', 'b', 'e', 'e', 'f'
+	};
-- 
1.5.2.1

