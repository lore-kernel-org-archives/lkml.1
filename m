Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZGaQ7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZGaQ7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZGaQ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:59:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZGaQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:59:07 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v4 1/3] Capabilities: move cap_file_mmap to commoncap.c
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Cc: jwcart2@tycho.nsa.gov, eparis@redhat.com, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp,
       serue@us.ibm.com
Date: Fri, 31 Jul 2009 12:53:58 -0400
Message-ID: <20090731165358.20992.14757.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we duplicate the mmap_min_addr test in cap_file_mmap and in
security_file_mmap if !CONFIG_SECURITY.  This patch moves cap_file_mmap
into commoncap.c and then calls that function directly from
security_file_mmap ifndef CONFIG_SECURITY like all of the other capability
checks are done.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 include/linux/security.h |    7 ++++---
 security/capability.c    |    9 ---------
 security/commoncap.c     |   30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 1459091..963a48f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -66,6 +66,9 @@ extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
 extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
+extern int cap_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags,
+			 unsigned long addr, unsigned long addr_only);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -2197,9 +2200,7 @@ static inline int security_file_mmap(struct file *file, unsigned long reqprot,
 				     unsigned long addr,
 				     unsigned long addr_only)
 {
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-	return 0;
+	return cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
 }
 
 static inline int security_file_mprotect(struct vm_area_struct *vma,
diff --git a/security/capability.c b/security/capability.c
index f218dd3..ec05730 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -330,15 +330,6 @@ static int cap_file_ioctl(struct file *file, unsigned int command,
 	return 0;
 }
 
-static int cap_file_mmap(struct file *file, unsigned long reqprot,
-			 unsigned long prot, unsigned long flags,
-			 unsigned long addr, unsigned long addr_only)
-{
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-	return 0;
-}
-
 static int cap_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			     unsigned long prot)
 {
diff --git a/security/commoncap.c b/security/commoncap.c
index aa97704..3852e94 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -984,3 +984,33 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 		cap_sys_admin = 1;
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
+
+/*
+ * cap_file_mmap - check if able to map given addr
+ * @file: unused
+ * @reqprot: unused
+ * @prot: unused
+ * @flags: unused
+ * @addr: address attempting to be mapped
+ * @addr_only: unused
+ *
+ * If the process is attempting to map memory below mmap_min_addr they need
+ * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
+ * capability security module.  Returns 0 if this mapping should be allowed
+ * -EPERM if not.
+ */
+int cap_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags,
+		  unsigned long addr, unsigned long addr_only)
+{
+	int ret = 0;
+
+	if (addr < mmap_min_addr) {
+		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
+				  SECURITY_CAP_AUDIT);
+		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
+		if (ret == 0)
+			current->flags |= PF_SUPERPRIV;
+	}
+	return ret;
+}

