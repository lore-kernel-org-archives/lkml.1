Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYCATKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYCATKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbYCATK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:10:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:52524 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYCATK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=dKS7ku+yveB6GtljsL6DPDI6NkQHKpZdck4+hJwCN+YsYDH0In8ZjrXzgtmLfjajjrWNgGJo4thCzMK/wHIVabcMpTskzeR1bVpT1Yvar+jlYY2oyT/AzE79dXX6/wuz9CWMShzPxkn9pEkBcbm10JPG1hA9XT5otBAVWXgGXDg=
Date: Sat, 1 Mar 2008 21:07:18 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Alexey Dobriyan <adobriyan@sw.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [RFC PATCH -mm] LSM: Add lsm= boot parameter
Message-ID: <20080301190718.GA16307@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

This is a first try of adding lsm= boot parameter. 

Current situation is:
1- Ignore wrong input, with a small warning to users.
2- If user didn't specify a specific module, none will be loaded

Basically, the patch adds a @name attribute to each LSM. It
also adds a security_module_chosen(op) method where each
LSM _must_ pass before calling register_security().

Thanks,

 Documentation/kernel-parameters.txt |    4 ++++
 include/linux/security.h            |   10 ++++++++++
 security/dummy.c                    |    3 ++-
 security/security.c                 |   35 +++++++++++++++++++++++++++++++++++
 security/selinux/hooks.c            |    5 ++++-
 security/smack/smack_lsm.c          |    7 +++++++
 6 files changed, 62 insertions(+), 2 deletions(-)

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c64dfd7..dde04c8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -374,6 +374,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
+	lsm=		[SECURITY] Choose an LSM to enable at boot. If this boot
+			parameter is not specified, no security module will be 
+			loaded.
+
 	capability.disable=
 			[SECURITY] Disable capabilities.  This would normally
 			be used only if an alternative security model is to be
diff --git a/include/linux/security.h b/include/linux/security.h
index eb663e5..4f695c0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -42,6 +42,9 @@
 
 extern unsigned securebits;
 
+/* Maximum number of letters for an LSM name string */
+#define SECURITY_NAME_MAX	10
+
 struct ctl_table;
 struct audit_krule;
 
@@ -118,6 +121,10 @@ struct request_sock;
 /**
  * struct security_operations - main security structure
  *
+ * Security module identifier.
+ *
+ * @name: LSM name
+ *
  * Security hooks for program execution operations.
  *
  * @bprm_alloc_security:
@@ -1262,6 +1269,8 @@ struct request_sock;
  * This is the main security structure.
  */
 struct security_operations {
+	char name[SECURITY_NAME_MAX + 1];
+
 	int (*ptrace) (struct task_struct * parent, struct task_struct * child);
 	int (*capget) (struct task_struct * target,
 		       kernel_cap_t * effective,
@@ -1530,6 +1539,7 @@ struct security_operations {
 
 /* prototypes */
 extern int security_init	(void);
+extern int security_module_chosen(struct security_operations *ops);
 extern int register_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
diff --git a/security/dummy.c b/security/dummy.c
index 241ab20..ed11f97 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -1022,7 +1022,7 @@ static inline void dummy_audit_rule_free(void *lsmrule)
 
 #endif /* CONFIG_AUDIT */
 
-struct security_operations dummy_security_ops;
+struct security_operations dummy_security_ops = { "dummy" };
 
 #define set_to_dummy_if_null(ops, function)				\
 	do {								\
@@ -1035,6 +1035,7 @@ struct security_operations dummy_security_ops;
 
 void security_fixup_ops (struct security_operations *ops)
 {
+	BUG_ON(!ops->name);
 	set_to_dummy_if_null(ops, ptrace);
 	set_to_dummy_if_null(ops, capget);
 	set_to_dummy_if_null(ops, capset_check);
diff --git a/security/security.c b/security/security.c
index 1bf2ee4..7a84b4e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 
+/* Boot time LSM user choice */
+char chosen_lsm[SECURITY_NAME_MAX + 1];
 
 /* things that live in dummy.c */
 extern struct security_operations dummy_security_ops;
@@ -67,6 +69,39 @@ int __init security_init(void)
 	return 0;
 }
 
+/* Save user chosen LSM */
+static int __init choose_lsm(char *str)
+{
+	if (strlen(str) > SECURITY_NAME_MAX) {
+		printk(KERN_INFO "Security: LSM name length extends possible "
+		       "limit.\n");
+		printk(KERN_INFO "Security: Ignoring passed lsm= parameter.\n");
+		return 0;
+	}
+
+	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
+	return 1;
+}
+__setup("lsm=", choose_lsm);
+
+/**
+ * security_module_chosen - Load given security module on boot ?
+ * @ops: a pointer to the struct security_operations that is to be checked.
+ *
+ * Return true if the passed LSM is the one chosen by user at
+ * boot time, otherwise return false.
+ */
+int security_module_chosen(struct security_operations *ops)
+{
+	if (!ops || !ops->name)
+		return 0;
+
+	if (strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
+		return 0;
+	
+	return 1;
+}
+
 /**
  * register_security - registers a security framework with the kernel
  * @ops: a pointer to the struct security_options that is to be registered
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bef1834..d4926b0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5247,6 +5247,8 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 #endif
 
 static struct security_operations selinux_ops = {
+	.name =				"selinux",
+
 	.ptrace =			selinux_ptrace,
 	.capget =			selinux_capget,
 	.capset_check =			selinux_capset_check,
@@ -5443,7 +5445,8 @@ static __init int selinux_init(void)
 {
 	struct task_security_struct *tsec;
 
-	if (!selinux_enabled) {
+	if (!selinux_enabled || !security_module_chosen(&selinux_ops)) {
+		selinux_enabled = 0;
 		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
 		return 0;
 	}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2b5d6f7..4348257 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2358,6 +2358,8 @@ static void smack_release_secctx(char *secdata, u32 seclen)
 }
 
 static struct security_operations smack_ops = {
+	.name =				"smack",
+
 	.ptrace = 			smack_ptrace,
 	.capget = 			cap_capget,
 	.capset_check = 		cap_capset_check,
@@ -2485,6 +2487,11 @@ static struct security_operations smack_ops = {
  */
 static __init int smack_init(void)
 {
+	if (!security_module_chosen(&smack_ops)) {
+		printk(KERN_INFO "Smack: Disabled at boot.\n");
+		return 0;
+	}
+
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
 	/*

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

