Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXJWENH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXJWENH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXJWEMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:12:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXJWEMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:12:54 -0400
Date: Mon, 22 Oct 2007 21:09:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
Message-ID: <20071022210956.31f7bbcf@laptopd505.fenrus.org>
In-Reply-To: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
	<alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
	<200710192226.53233.agruen@suse.de>
	<alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
	<Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
	<Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 08:57:06 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> On Sat, 20 Oct 2007, Jan Engelhardt wrote:
> 
> > >I'd like to note that I asked people who were actually affected,
> > >and had examples of their real-world use to step forward and
> > >explain their use, and that I explicitly mentioned that this is
> > >something we can easily re-visit.
> > >
> > 
> > I do have a pseudo LSM called "multiadm" at 
> > http://freshmeat.net/p/multiadm/ , quoting:
> > 
> 
> Based on Linus' criteria, this appears to be a case for reverting the 
> static LSM patch.

I don't want to argue for or against the actual revert; however if Linus/James/Chris
decide to do a revert, I've made a patch to do that below

(doing a full git revert is tricky since it gets mixed up with various other cleanup 
patches; even inside the original patch. I've done the relevant pieces by hand via a 
selective patch -R and compile-tested it). In addition I've made the modularity a 
Kconfig option, since it's clearly something that is contested and thus is justified 
as a user compile time choice; people who don't want this (out of paranoia or otherwise)
can now decide to disable, while others who want to experiment or use out of tree 
LSM modules, can select the KConfig option.

If it turns out that the above module becomes unmaintained and no longer usable, and no
other useful cases show up, we can always garbage collect this code in the future; it's 
now low-overhead anyway for those who care, due to the KConfig option.

---

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: revert the modular LSM patch

Since there is a real out of tree, non-racey modular LSM module,
add back the capability to have modular LSM modules as a config option.

(note that this patch fails checkpatch.pl in a few places, however
since this is just a reverse-patch of the original code, I don't
want to fix this in order to keep exact revert behavior)


Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff -purN linux-2.6.23-git17/include/linux.org/security.h linux-2.6.23-git17/include/linux/security.h
--- linux-2.6.23-git17/include/linux.org/security.h	2007-10-21 10:35:49.000000000 +0200
+++ linux-2.6.23-git17/include/linux/security.h	2007-10-21 10:36:00.000000000 +0200
@@ -1178,6 +1178,10 @@ struct request_sock;
  * 	allow module stacking.
  * 	@name contains the name of the security module being stacked.
  * 	@ops contains a pointer to the struct security_operations of the module to stack.
+ * @unregister_security:
+ *	remove a stacked module.
+ *	@name contains the name of the security module being unstacked.
+ *	@ops contains a pointer to the struct security_operations of the module to unstack.
  * 
  * @secid_to_secctx:
  *	Convert secid to security context.
@@ -1365,6 +1369,8 @@ struct security_operations {
 	/* allow module stacking */
 	int (*register_security) (const char *name,
 	                          struct security_operations *ops);
+	int (*unregister_security) (const char *name,
+	                            struct security_operations *ops);
 
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
@@ -1445,7 +1451,9 @@ struct security_operations {
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
+extern int unregister_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
+extern int mod_unreg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
 					     struct dentry *parent, void *data,
 					     const struct file_operations *fops);
diff -purN linux-2.6.23-git17/security.org/dummy.c linux-2.6.23-git17/security/dummy.c
--- linux-2.6.23-git17/security.org/dummy.c	2007-10-21 02:04:21.000000000 +0200
+++ linux-2.6.23-git17/security/dummy.c	2007-10-21 10:36:00.000000000 +0200
@@ -908,6 +908,11 @@ static int dummy_register_security (cons
 	return -EINVAL;
 }
 
+static int dummy_unregister_security (const char *name, struct security_operations *ops)
+{
+	return -EINVAL;
+}
+
 static void dummy_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	return;
@@ -1082,6 +1087,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, netlink_send);
 	set_to_dummy_if_null(ops, netlink_recv);
 	set_to_dummy_if_null(ops, register_security);
+	set_to_dummy_if_null(ops, unregister_security);
 	set_to_dummy_if_null(ops, d_instantiate);
  	set_to_dummy_if_null(ops, getprocattr);
  	set_to_dummy_if_null(ops, setprocattr);
diff -purN linux-2.6.23-git17/security.org/Kconfig linux-2.6.23-git17/security/Kconfig
--- linux-2.6.23-git17/security.org/Kconfig	2007-10-21 02:04:21.000000000 +0200
+++ linux-2.6.23-git17/security/Kconfig	2007-10-21 10:36:14.000000000 +0200
@@ -51,6 +51,20 @@ config SECURITY
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_MODULAR
+	bool "Allow loadable security models"
+	depends on SECURITY
+	help
+	  This allows you to load and unload security modules at
+	  runtime.
+
+	  This option is useful for developers of security modules
+	  or for experimenting with security modules that are not in
+	  your kernel (yet). Note that (un)loading security modules
+	  can be a dangerous situation so use with care.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_NETWORK
 	bool "Socket and Networking Security Hooks"
 	depends on SECURITY
diff -purN linux-2.6.23-git17/security.org/security.c linux-2.6.23-git17/security/security.c
--- linux-2.6.23-git17/security.org/security.c	2007-10-21 02:04:21.000000000 +0200
+++ linux-2.6.23-git17/security/security.c	2007-10-21 10:37:41.000000000 +0200
@@ -71,7 +71,8 @@ int __init security_init(void)
  *
  * This function is to allow a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function.
+ * value passed to this function.  A call to unregister_security() should be
+ * done to remove this security_options structure from the kernel.
  *
  * If there is already a security module registered with the kernel,
  * an error will be returned.  Otherwise 0 is returned on success.
@@ -121,6 +122,62 @@ int mod_reg_security(const char *name, s
 	return security_ops->register_security(name, ops);
 }
 
+#ifdef CONFIG_SECURITY_MODULAR
+/**
+ * unregister_security - unregisters a security framework with the kernel
+ * @ops: a pointer to the struct security_options that is to be registered
+ *
+ * This function removes a struct security_operations variable that had
+ * previously been registered with a successful call to register_security().
+ *
+ * If @ops does not match the valued previously passed to register_security()
+ * an error is returned.  Otherwise the default security options is set to the
+ * the dummy_security_ops structure, and 0 is returned.
+ */
+int unregister_security(struct security_operations *ops)
+{
+	if (ops != security_ops) {
+		printk(KERN_INFO "%s: trying to unregister "
+		       "a security_opts structure that is not "
+		       "registered, failing.\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	security_ops = &dummy_security_ops;
+
+	return 0;
+}
+
+/**
+ * mod_unreg_security - allows a security module registered with mod_reg_security() to be unloaded
+ * @name: a pointer to a string with the name of the security_options to be removed
+ * @ops: a pointer to the struct security_options that is to be removed
+ *
+ * This function allows security modules that have been successfully registered
+ * with a call to mod_reg_security() to be unloaded from the system.
+ * This calls the currently loaded security module's unregister_security() call
+ * with the @name and @ops variables.
+ *
+ * The return value depends on the currently loaded security module, with 0 as
+ * success.
+ */
+int mod_unreg_security(const char *name, struct security_operations *ops)
+{
+	if (ops == security_ops) {
+		printk(KERN_INFO "%s invalid attempt to unregister "
+		       " primary security ops.\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	return security_ops->unregister_security(name, ops);
+}
+
+EXPORT_SYMBOL_GPL(register_security);
+EXPORT_SYMBOL_GPL(unregister_security);
+EXPORT_SYMBOL_GPL(mod_reg_security);
+EXPORT_SYMBOL_GPL(mod_unreg_security);
+#endif
+
 /* Security operations */
 
 int security_ptrace(struct task_struct *parent, struct task_struct *child)
diff -purN linux-2.6.23-git17/security.org/selinux/hooks.c linux-2.6.23-git17/security/selinux/hooks.c
--- linux-2.6.23-git17/security.org/selinux/hooks.c	2007-10-21 02:04:21.000000000 +0200
+++ linux-2.6.23-git17/security/selinux/hooks.c	2007-10-21 10:38:27.000000000 +0200
@@ -4549,6 +4549,19 @@ static int selinux_register_security (co
 	return 0;
 }
 
+static int selinux_unregister_security (const char *name, struct security_operations *ops)
+{
+	if (ops != secondary_ops) {
+		printk(KERN_ERR "%s:  trying to unregister a security module "
+		        "that is not registered.\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	secondary_ops = original_ops;
+
+	return 0;
+}
+
 static void selinux_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	if (inode)
@@ -4895,6 +4908,7 @@ static struct security_operations selinu
 	.sem_semop =			selinux_sem_semop,
 
 	.register_security =		selinux_register_security,
+	.unregister_security =		selinux_unregister_security,
 
 	.d_instantiate =                selinux_d_instantiate,
 
