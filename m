Return-Path: <linux-kernel-owner+w=401wt.eu-S934434AbXHNVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbXHNVqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbXHNV0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:26:32 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45855 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757939AbXHNV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:26:28 -0400
Date: Tue, 14 Aug 2007 23:26:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] security/ cleanups
Message-ID: <20070814212618.GZ18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups that are now possible:
- remove the unused security_operations->inode_xattr_getsuffix
- remove the no longer used security_operations->unregister_security
- remove some no longer required exit code
- remove a bunch of no longer used exports

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: James Morris <jmorris@namei.org>

---

 drivers/usb/core/usb.c   |    2 -
 fs/exec.c                |    2 -
 include/linux/security.h |   15 ----------
 kernel/capability.c      |    4 --
 mm/mmap.c                |    2 -
 mm/nommu.c               |    1 
 security/commoncap.c     |   21 --------------
 security/dummy.c         |   12 --------
 security/inode.c         |    8 -----
 security/security.c      |   58 ---------------------------------------
 security/selinux/hooks.c |   20 -------------
 11 files changed, 1 insertion(+), 144 deletions(-)

--- linux-2.6.23-rc1-mm1/include/linux/security.h.old	2007-07-26 03:03:21.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/linux/security.h	2007-07-26 03:08:11.000000000 +0200
@@ -1136,10 +1136,6 @@ struct request_sock;
  * 	allow module stacking.
  * 	@name contains the name of the security module being stacked.
  * 	@ops contains a pointer to the struct security_operations of the module to stack.
- * @unregister_security:
- *	remove a stacked module.
- *	@name contains the name of the security module being unstacked.
- *	@ops contains a pointer to the struct security_operations of the module to unstack.
  * 
  * @secid_to_secctx:
  *	Convert secid to security context.
@@ -1235,1 +1231,0 @@ struct security_operations {
-	const char *(*inode_xattr_getsuffix) (void);
@@ -1325,8 +1320,6 @@ struct security_operations {
 	/* allow module stacking */
 	int (*register_security) (const char *name,
 	                          struct security_operations *ops);
-	int (*unregister_security) (const char *name,
-	                            struct security_operations *ops);
 
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
@@ -1407,9 +1400,7 @@ struct security_operations {
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
-extern int unregister_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
-extern int mod_unreg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
 					     struct dentry *parent, void *data,
 					     const struct file_operations *fops);
@@ -1490,1 +1481,0 @@ void security_inode_post_setxattr(struct
-const char *security_inode_xattr_getsuffix(void);
@@ -1879,9 +1869,4 @@ static inline int security_inode_removex
 }
 
-static inline const char *security_inode_xattr_getsuffix (void)
-{
-	return NULL ;
-}
-
 static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
--- linux-2.6.23-rc1-mm1/security/security.c.old	2007-07-26 03:03:33.000000000 +0200
+++ linux-2.6.23-rc1-mm1/security/security.c	2007-07-27 22:24:41.000000000 +0200
@@ -71,6 +71,5 @@ int __init security_init(void)
  * This function is to allow a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function.  A call to unregister_security() should be
- * done to remove this security_options structure from the kernel.
+ * value passed to this function.
  *
  * If there is already a security module registered with the kernel,
@@ -94,31 +93,6 @@ int register_security(struct security_op
 }
 
 /**
- * unregister_security - unregisters a security framework with the kernel
- * @ops: a pointer to the struct security_options that is to be registered
- *
- * This function removes a struct security_operations variable that had
- * previously been registered with a successful call to register_security().
- *
- * If @ops does not match the valued previously passed to register_security()
- * an error is returned.  Otherwise the default security options is set to the
- * the dummy_security_ops structure, and 0 is returned.
- */
-int unregister_security(struct security_operations *ops)
-{
-	if (ops != security_ops) {
-		printk(KERN_INFO "%s: trying to unregister "
-		       "a security_opts structure that is not "
-		       "registered, failing.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	security_ops = &dummy_security_ops;
-
-	return 0;
-}
-
-/**
  * mod_reg_security - allows security modules to be "stacked"
  * @name: a pointer to a string with the name of the security_options to be registered
  * @ops: a pointer to the struct security_options that is to be registered
@@ -147,30 +121,6 @@ int mod_reg_security(const char *name, s
 	return security_ops->register_security(name, ops);
 }
 
-/**
- * mod_unreg_security - allows a security module registered with mod_reg_security() to be unloaded
- * @name: a pointer to a string with the name of the security_options to be removed
- * @ops: a pointer to the struct security_options that is to be removed
- *
- * This function allows security modules that have been successfully registered
- * with a call to mod_reg_security() to be unloaded from the system.
- * This calls the currently loaded security module's unregister_security() call
- * with the @name and @ops variables.
- *
- * The return value depends on the currently loaded security module, with 0 as
- * success.
- */
-int mod_unreg_security(const char *name, struct security_operations *ops)
-{
-	if (ops == security_ops) {
-		printk(KERN_INFO "%s invalid attempt to unregister "
-		       " primary security ops.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	return security_ops->unregister_security(name, ops);
-}
-
 /* Security operations */
 
 int security_ptrace(struct task_struct *parent, struct task_struct *child)
@@ -515,9 +465,4 @@ int security_inode_removexattr(struct de
 }
 
-const char *security_inode_xattr_getsuffix(void)
-{
-	return security_ops->inode_xattr_getsuffix();
-}
-
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
@@ -841,7 +786,6 @@ int security_netlink_send(struct sock *s
 {
 	return security_ops->netlink_send(sk, skb);
 }
-EXPORT_SYMBOL(security_netlink_send);
 
 int security_netlink_recv(struct sk_buff *skb, int cap)
 {
--- linux-2.6.23-rc1-mm1/security/selinux/hooks.c.old	2007-07-26 03:05:47.000000000 +0200
+++ linux-2.6.23-rc1-mm1/security/selinux/hooks.c	2007-07-26 04:31:00.000000000 +0200
@@ -2402,11 +2402,6 @@ static int selinux_inode_removexattr (st
 	return -EACCES;
 }
 
-static const char *selinux_inode_xattr_getsuffix(void)
-{
-      return XATTR_SELINUX_SUFFIX;
-}
-
 /*
  * Copy the in-core inode security context value to the user.  If the
  * getxattr() prior to this succeeded, check to see if we need to
@@ -4486,19 +4481,6 @@ static int selinux_register_security (co
 	return 0;
 }
 
-static int selinux_unregister_security (const char *name, struct security_operations *ops)
-{
-	if (ops != secondary_ops) {
-		printk(KERN_ERR "%s:  trying to unregister a security module "
-		        "that is not registered.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	secondary_ops = original_ops;
-
-	return 0;
-}
-
 static void selinux_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	if (inode)
@@ -4777,7 +4759,6 @@ static struct security_operations selinu
 	.inode_getxattr =		selinux_inode_getxattr,
 	.inode_listxattr =		selinux_inode_listxattr,
 	.inode_removexattr =		selinux_inode_removexattr,
-	.inode_xattr_getsuffix =        selinux_inode_xattr_getsuffix,
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
@@ -4843,7 +4824,6 @@ static struct security_operations selinu
 	.sem_semop =			selinux_sem_semop,
 
 	.register_security =		selinux_register_security,
-	.unregister_security =		selinux_unregister_security,
 
 	.d_instantiate =                selinux_d_instantiate,
 
--- linux-2.6.23-rc1-mm1/security/dummy.c.old	2007-07-26 03:07:10.000000000 +0200
+++ linux-2.6.23-rc1-mm1/security/dummy.c	2007-07-26 03:08:21.000000000 +0200
@@ -391,11 +391,6 @@ static int dummy_inode_listsecurity(stru
 	return 0;
 }
 
-static const char *dummy_inode_xattr_getsuffix(void)
-{
-	return NULL;
-}
-
 static int dummy_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -900,11 +895,6 @@ static int dummy_register_security (cons
 	return -EINVAL;
 }
 
-static int dummy_unregister_security (const char *name, struct security_operations *ops)
-{
-	return -EINVAL;
-}
-
 static void dummy_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	return;
@@ -1017,1 +1007,0 @@ void security_fixup_ops (struct security
-	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
@@ -1077,7 +1066,6 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, netlink_send);
 	set_to_dummy_if_null(ops, netlink_recv);
 	set_to_dummy_if_null(ops, register_security);
-	set_to_dummy_if_null(ops, unregister_security);
 	set_to_dummy_if_null(ops, d_instantiate);
  	set_to_dummy_if_null(ops, getprocattr);
  	set_to_dummy_if_null(ops, setprocattr);
--- linux-2.6.23-rc1-mm1/security/inode.c.old	2007-07-26 03:12:26.000000000 +0200
+++ linux-2.6.23-rc1-mm1/security/inode.c	2007-07-26 03:14:11.000000000 +0200
@@ -332,14 +332,6 @@ static int __init securityfs_init(void)
 	return retval;
 }
 
-static void __exit securityfs_exit(void)
-{
-	simple_release_fs(&mount, &mount_count);
-	unregister_filesystem(&fs_type);
-	subsystem_unregister(&security_subsys);
-}
-
 core_initcall(securityfs_init);
-module_exit(securityfs_exit);
 MODULE_LICENSE("GPL");
 
--- linux-2.6.23-rc1-mm1/mm/mmap.c.old	2007-07-26 03:30:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1/mm/mmap.c	2007-07-26 03:30:51.000000000 +0200
@@ -180,8 +180,6 @@ error:
 	return -ENOMEM;
 }
 
-EXPORT_SYMBOL(__vm_enough_memory);
-
 /*
  * Requires inode->i_mapping->i_mmap_lock
  */
--- linux-2.6.23-rc1-mm1/mm/nommu.c.old	2007-07-26 03:31:02.000000000 +0200
+++ linux-2.6.23-rc1-mm1/mm/nommu.c	2007-07-26 03:31:05.000000000 +0200
@@ -44,7 +44,6 @@ int sysctl_max_map_count = DEFAULT_MAX_M
 int heap_stack_gap = 0;
 
 EXPORT_SYMBOL(mem_map);
-EXPORT_SYMBOL(__vm_enough_memory);
 EXPORT_SYMBOL(num_physpages);
 
 /* list of shareable VMAs */
--- linux-2.6.23-rc1-mm1/kernel/capability.c.old	2007-07-26 03:32:34.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/capability.c	2007-07-26 03:34:42.000000000 +0200
@@ -18,9 +18,6 @@
 unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
 kernel_cap_t cap_bset = CAP_INIT_EFF_SET;
 
-EXPORT_SYMBOL(securebits);
-EXPORT_SYMBOL(cap_bset);
-
 /*
  * This lock protects task->cap_* for all tasks including current.
  * Locking rule: acquire this prior to tasklist_lock.
@@ -245,7 +242,6 @@ int __capable(struct task_struct *t, int
 	}
 	return 0;
 }
-EXPORT_SYMBOL(__capable);
 
 int capable(int cap)
 {
--- linux-2.6.23-rc1-mm1/fs/exec.c.old	2007-07-26 03:33:12.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/exec.c	2007-07-26 03:33:52.000000000 +0200
@@ -64,7 +64,6 @@ int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
 
-EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
 static LIST_HEAD(formats);
@@ -1682,7 +1681,6 @@ void set_dumpable(struct mm_struct *mm, 
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(set_dumpable);
 
 int get_dumpable(struct mm_struct *mm)
 {
--- linux-2.6.23-rc1-mm1/security/commoncap.c.old	2007-07-26 03:44:04.000000000 +0200
+++ linux-2.6.23-rc1-mm1/security/commoncap.c	2007-07-26 04:24:01.000000000 +0200
@@ -31,8 +31,6 @@ int cap_netlink_send(struct sock *sk, st
 	return 0;
 }
 
-EXPORT_SYMBOL(cap_netlink_send);
-
 int cap_netlink_recv(struct sk_buff *skb, int cap)
 {
 	if (!cap_raised(NETLINK_CB(skb).eff_cap, cap))
@@ -498,22 +496,3 @@ int cap_vm_enough_memory(long pages)
 	return __vm_enough_memory(pages, cap_sys_admin);
 }
 
-EXPORT_SYMBOL(cap_capable);
-EXPORT_SYMBOL(cap_settime);
-EXPORT_SYMBOL(cap_ptrace);
-EXPORT_SYMBOL(cap_capget);
-EXPORT_SYMBOL(cap_capset_check);
-EXPORT_SYMBOL(cap_capset_set);
-EXPORT_SYMBOL(cap_bprm_set_security);
-EXPORT_SYMBOL(cap_bprm_apply_creds);
-EXPORT_SYMBOL(cap_bprm_secureexec);
-EXPORT_SYMBOL(cap_inode_setxattr);
-EXPORT_SYMBOL(cap_inode_removexattr);
-EXPORT_SYMBOL(cap_task_post_setuid);
-EXPORT_SYMBOL(cap_task_kill);
-EXPORT_SYMBOL(cap_task_setscheduler);
-EXPORT_SYMBOL(cap_task_setioprio);
-EXPORT_SYMBOL(cap_task_setnice);
-EXPORT_SYMBOL(cap_task_reparent_to_init);
-EXPORT_SYMBOL(cap_syslog);
-EXPORT_SYMBOL(cap_vm_enough_memory);
--- linux-2.6.23-rc1-mm1/drivers/usb/core/usb.c.old	2007-07-26 03:50:10.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/usb/core/usb.c	2007-07-26 03:50:19.000000000 +0200
@@ -981,7 +981,6 @@ EXPORT_SYMBOL(usb_altnum_to_altsetting);
 
 EXPORT_SYMBOL(__usb_get_extra_descriptor);
 
-EXPORT_SYMBOL(usb_find_device);
 EXPORT_SYMBOL(usb_get_current_frame_number);
 
 EXPORT_SYMBOL(usb_buffer_alloc);

