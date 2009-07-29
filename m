Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZG2S5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZG2S5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZG2S47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:56:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbZG2S46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:56:58 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 1/3] Capabilities: move cap_file_mmap to commoncap.c
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Cc: jwcart2@tycho.nsa.gov, eparis@redhat.com, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp
Date: Wed, 29 Jul 2009 14:56:20 -0400
Message-ID: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
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
---

 include/linux/security.h |    7 ++++---
 security/capability.c    |    9 ---------
 security/commoncap.c     |   24 ++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 12 deletions(-)

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
index aa97704..9a731d7 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -984,3 +984,27 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
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
+	if (addr < mmap_min_addr)
+		return cap_capable(current, current_cred(), CAP_SYS_RAWIO,
+				   SECURITY_CAP_AUDIT);
+	return 0;
+}

