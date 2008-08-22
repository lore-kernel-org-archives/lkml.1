Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYHVPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYHVPu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYHVPus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:50:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34401 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYHVPur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:50:47 -0400
Subject: [PATCH] securityfs: do not depend on CONFIG_SECURITY
From: Eric Paris <eparis@redhat.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
       tpm@selhorst.net, tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Fri, 22 Aug 2008 11:35:57 -0400
Message-Id: <1219419357.3613.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new Kconfig option SECURITYFS which will build securityfs support
but does not require CONFIG_SECURITY.  The only current user of
securityfs does not depend on CONFIG_SECURITY and there is no reason the
full LSM needs to be built to build this fs.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

Testing was basically just making sure that my kernel built with TCG_TPM
on but SECURITY off.  I don't actually have a way to test is TCG_TPM
still worked properly....

 drivers/char/tpm/Kconfig    |    1 +
 include/linux/security.h    |   54 +++++++++++++++++++++++-------------------
 security/Kconfig            |    8 ++++++
 security/Makefile           |    3 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 3738cfa..f5fc64f 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -6,6 +6,7 @@ menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
 	depends on EXPERIMENTAL
+	select SECURITYFS
 	---help---
 	  If you have a TPM security chip in your system, which
 	  implements the Trusted Computing Group's specification,
diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
diff --git a/include/linux/security.h b/include/linux/security.h
index 80c4d00..f5c4a51 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1560,11 +1560,6 @@ struct security_operations {
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
 extern int register_security(struct security_operations *ops);
-extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
-					     struct dentry *parent, void *data,
-					     const struct file_operations *fops);
-extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
-extern void securityfs_remove(struct dentry *dentry);
 
 /* Security operations */
 int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
@@ -2424,25 +2419,6 @@ static inline int security_netlink_recv(struct sk_buff *skb, int cap)
 	return cap_netlink_recv(skb, cap);
 }
 
-static inline struct dentry *securityfs_create_dir(const char *name,
-					struct dentry *parent)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline struct dentry *securityfs_create_file(const char *name,
-						mode_t mode,
-						struct dentry *parent,
-						void *data,
-						const struct file_operations *fops)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline void securityfs_remove(struct dentry *dentry)
-{
-}
-
 static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
@@ -2806,5 +2782,35 @@ static inline void security_audit_rule_free(void *lsmrule)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITYFS
+
+extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
+					     struct dentry *parent, void *data,
+					     const struct file_operations *fops);
+extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
+extern void securityfs_remove(struct dentry *dentry);
+
+#else /* CONFIG_SECURITYFS */
+
+static inline struct dentry *securityfs_create_dir(const char *name,
+						   struct dentry *parent)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *securityfs_create_file(const char *name,
+						    mode_t mode,
+						    struct dentry *parent,
+						    void *data,
+						    const struct file_operations *fops)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void securityfs_remove(struct dentry *dentry)
+{}
+
+#endif
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index 5592939..d9f47ce 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -51,6 +51,14 @@ config SECURITY
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITYFS
+	bool "Enable the securityfs filesystem"
+	help
+	  This will build the securityfs filesystem.  It is currently used by
+	  the TPM bios character driver.  It is not used by SELinux or SMACK.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_NETWORK
 	bool "Socket and Networking Security Hooks"
 	depends on SECURITY
diff --git a/security/Makefile b/security/Makefile
index f654260..c05c127 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -10,7 +10,8 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 obj-y		+= commoncap.o
 
 # Object file lists
-obj-$(CONFIG_SECURITY)			+= security.o capability.o inode.o
+obj-$(CONFIG_SECURITY)			+= security.o capability.o
+obj-$(CONFIG_SECURITYFS)		+= inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
diff --git a/security/inode.c b/security/inode.c


