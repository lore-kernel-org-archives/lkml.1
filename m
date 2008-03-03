Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYCCV2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYCCV2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYCCV1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:27:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:61311 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYCCV1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Z+r2HqSkMplhaVniilCXaGP1M+Db8P1cFW8VvHn0Uk6hUaNw36T4EoStmIOgb/XhjaKCqEh1gTORHu66pFeM12jgq5ag3Gns/7KHJxWxOFew7BkyUREJMwFeeB1ZPxTu9WdF2KvYeKdECk1OpXm4yvhxlUBKJ+HngNviy9O+AQk=
Date: Mon, 3 Mar 2008 23:24:33 +0200
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
       Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v4 -mm] LSM: Add security= boot parameter
Message-ID: <20080303212433.GA12998@ubuntu>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi> <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu> <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu> <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu> <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

On Mon, Mar 03, 2008 at 10:54:02AM -0500, Stephen Smalley wrote:
> 
> On Mon, 2008-03-03 at 17:35 +0200, Ahmed S. Darwish wrote:
> > Hi James,
> > 
....
> > 
> > SElinux (As you already know ;)) does the security setup of the initial 
> > task before calling register_security. Would it be safe to do this
> > setup after registeration ?
> 
> I wouldn't recommend it - the hook functions presume that the initial
> task security blob has been set up already, and that other dependencies
> like the inode security cache and access vector cache have been created
> and can be used.  We have to assume that the security hooks can start
> being invoked as soon as we call register_security(), even if in
> practice it won't happen until after the init function completes.
>

OK, the patch will stick with the two-stage registration model to give
a safe initialization time for LSMs.

james: Could you please make it OK to use the atomic counter instead of
       the spinlock ? It'll just add unneeded complexity. We only set
       `chosen_lsm' once at the parameters parsing time. 

Changes (per James suggestions):
- Added a BUG_ON(!ops->name).
- Removed a redundant setting of last string character to NULL.

Sample Output:
[    0.065487] SELinux:  Initializing.
[    0.067115] SELinux:  Starting in permissive mode
[    0.067186] Smack:  Another security module was chosen.
[    0.067345] Smack:  Use security=smack to force loading Smack on boot.

-->

Add the security= boot parameter. This is done to avoid LSM 
registration clashes in case of more than one bult-in module.

User can choose a security module to enable at boot. If no 
security= boot parameter is specified, only the first LSM 
asking for registration will be loaded. An invalid security 
module name will be treated as if no module has been chosen.

LSM modules must check now if they are allowed to register
by calling security_module_enable(ops) first. Modify SELinux 
and SMACK to do so.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 Documentation/kernel-parameters.txt |    6 ++++
 include/linux/security.h            |   12 +++++++++
 security/dummy.c                    |    2 -+
 security/security.c                 |   45 ++++++++++++++++++++++++++++++++++--
 security/selinux/hooks.c            |   10 ++++++++
 security/smack/smack_lsm.c          |    9 +++++++

 6 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c64dfd7..85044e8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -374,6 +374,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
+	security=	[SECURITY] Choose a security module to enable at boot. 
+			If this boot parameter is not specified, only the first 
+			security module asking for security registration will be
+			loaded. An invalid security module name will be treated
+			as if no module has been chosen.
+
 	capability.disable=
 			[SECURITY] Disable capabilities.  This would normally
 			be used only if an alternative security model is to be
diff --git a/include/linux/security.h b/include/linux/security.h
index eb663e5..3db2819 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -42,6 +42,9 @@
 
 extern unsigned securebits;
 
+/* Maximum number of letters for an LSM name string */
+#define SECURITY_NAME_MAX	10
+
 struct ctl_table;
 struct audit_krule;
 
@@ -118,6 +121,12 @@ struct request_sock;
 /**
  * struct security_operations - main security structure
  *
+ * Security module identifier.
+ *
+ * @name:
+ *	A string that acts as a unique identifeir for the LSM with max number
+ *	of characters = SECURITY_NAME_MAX.
+ *
  * Security hooks for program execution operations.
  *
  * @bprm_alloc_security:
@@ -1262,6 +1271,8 @@ struct request_sock;
  * This is the main security structure.
  */
 struct security_operations {
+	char name[SECURITY_NAME_MAX + 1];
+
 	int (*ptrace) (struct task_struct * parent, struct task_struct * child);
 	int (*capget) (struct task_struct * target,
 		       kernel_cap_t * effective,
@@ -1530,6 +1541,7 @@ struct security_operations {
 
 /* prototypes */
 extern int security_init	(void);
+extern int security_module_enable(struct security_operations *ops);
 extern int register_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
diff --git a/security/dummy.c b/security/dummy.c
index 241ab20..d081699 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -1022,7 +1022,7 @@ static inline void dummy_audit_rule_free(void *lsmrule)
 
 #endif /* CONFIG_AUDIT */
 
-struct security_operations dummy_security_ops;
+struct security_operations dummy_security_ops = { "dummy" };
 
 #define set_to_dummy_if_null(ops, function)				\
 	do {								\
diff --git a/security/security.c b/security/security.c
index 1bf2ee4..5419fec 100644
--- a/security/security.c
+++ b/security/security.c
@@ -17,6 +17,9 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 
+/* Boot-time LSM user choice */
+static char chosen_lsm[SECURITY_NAME_MAX + 1];
+static atomic_t security_ops_enabled = ATOMIC_INIT(-1);
 
 /* things that live in dummy.c */
 extern struct security_operations dummy_security_ops;
@@ -30,7 +33,7 @@ unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;
 static inline int verify(struct security_operations *ops)
 {
 	/* verify the security_operations structure exists */
-	if (!ops)
+	if (!ops || !ops->name)
 		return -EINVAL;
 	security_fixup_ops(ops);
 	return 0;
@@ -67,13 +70,51 @@ int __init security_init(void)
 	return 0;
 }
 
+/* Save user chosen LSM */
+static int __init choose_lsm(char *str)
+{
+	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
+	return 1;
+}
+__setup("security=", choose_lsm);
+
+/**
+ * security_module_enable - Load given security module on boot ?
+ * @ops: a pointer to the struct security_operations that is to be checked.
+ *
+ * Each LSM must pass this method before registering its own operations
+ * to avoid security registration races.
+ *
+ * Return true if:
+ *	-The passed LSM is the one chosen by user at boot time,
+ *	-or user didsn't specify a specific LSM and we're the first to ask
+ *	 for registeration permissoin.
+ * Otherwise, return false.
+ */
+int security_module_enable(struct security_operations *ops)
+{
+	if (!ops || !ops->name) {
+		BUG();
+		return 0;
+	}
+
+	if (!*chosen_lsm && atomic_inc_and_test(&security_ops_enabled))
+		return 1;
+
+	if (!strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
+		return 1;
+
+	return 0;
+}
+
 /**
  * register_security - registers a security framework with the kernel
  * @ops: a pointer to the struct security_options that is to be registered
  *
  * This function is to allow a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function.
+ * value passed to this function. You'll need to check first if your LSM
+ * is allowed to register its @ops by calling security_module_enable(@ops).
  *
  * If there is already a security module registered with the kernel,
  * an error will be returned.  Otherwise 0 is returned on success.
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bef1834..c3a52a8 100644
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
@@ -5448,6 +5450,14 @@ static __init int selinux_init(void)
 		return 0;
 	}
 
+	if (!security_module_enable(&selinux_ops)) {
+		selinux_enabled = 0;
+		printk(KERN_INFO "SELinux:  Another security module was chosen.\n");
+		printk(KERN_INFO "SELinux:  Use security=%s to force loading "
+		       "SELinux on boot.\n", selinux_ops.name);
+		return 0;
+	}
+
 	printk(KERN_INFO "SELinux:  Initializing.\n");
 
 	/* Set the security state for the initial task. */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2b5d6f7..ad31819 100644
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
@@ -2485,6 +2487,13 @@ static struct security_operations smack_ops = {
  */
 static __init int smack_init(void)
 {
+	if (!security_module_enable(&smack_ops)) {
+		printk(KERN_INFO "Smack:  Another security module was chosen.\n");
+		printk(KERN_INFO "Smack:  Use security=%s to force loading "
+		       "Smack on boot.\n", smack_ops.name);
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

