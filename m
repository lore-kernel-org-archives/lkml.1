Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZLCTpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZLCTpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZLCTpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:45:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbZLCTpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:45:01 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] security: do not check mmap_min_addr on nommu systems
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Cc: eparis@redhat.com, dhowells@redhat.com, akpm@linux-foundation.org,
       gyang@blackfin.uclinux.org, john.johansen@canonical.com
Date: Thu, 03 Dec 2009 14:43:01 -0500
Message-ID: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nommu systems can do anything with memory they please and so they already
win.  mmap_min_addr is the least of their worries.  Currently the
mmap_min_addr implementation is problamatic on such systems.  This patch
changes the addr_only argument to be a flags which can take the arguments
for addr_only or not_addr.  LSMs then need to properly implement these two
flags.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/security.h |   18 +++++++++++++-----
 mm/mmap.c                |    6 ++++--
 mm/mremap.c              |    6 ++++--
 mm/nommu.c               |    3 ++-
 security/commoncap.c     |    7 ++++---
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    9 +++++----
 7 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 9c3a43b..e3875ff 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -43,6 +43,12 @@
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
 
+/* sec_flags for security_file_mmap */
+/* Only check the address portion */
+#define SECURITY_MMAP_ADDR_ONLY	0x01
+/* Do not do the address checks */
+#define SECURITY_MMAP_NOT_ADDR	0x02
+
 struct ctl_table;
 struct audit_krule;
 
@@ -69,7 +75,7 @@ extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
-			 unsigned long addr, unsigned long addr_only);
+			 unsigned long addr, unsigned long sec_flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -609,6 +615,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr address vm will map to
+ *	@sec_flags what security checks should be done
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
@@ -1556,7 +1564,7 @@ struct security_operations {
 	int (*file_mmap) (struct file *file,
 			  unsigned long reqprot, unsigned long prot,
 			  unsigned long flags, unsigned long addr,
-			  unsigned long addr_only);
+			  unsigned long sec_flags);
 	int (*file_mprotect) (struct vm_area_struct *vma,
 			      unsigned long reqprot,
 			      unsigned long prot);
@@ -1826,7 +1834,7 @@ void security_file_free(struct file *file);
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only);
+			unsigned long addr, unsigned long sec_flags);
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			   unsigned long prot);
 int security_file_lock(struct file *file, unsigned int cmd);
@@ -2323,9 +2331,9 @@ static inline int security_file_mmap(struct file *file, unsigned long reqprot,
 				     unsigned long prot,
 				     unsigned long flags,
 				     unsigned long addr,
-				     unsigned long addr_only)
+				     unsigned long sec_flags)
 {
-	return cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	return cap_file_mmap(file, reqprot, prot, flags, addr, sec_flags);
 }
 
 static inline int security_file_mprotect(struct vm_area_struct *vma,
diff --git a/mm/mmap.c b/mm/mmap.c
index 828ecbf..fb7eb10 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1664,7 +1664,8 @@ static int expand_downwards(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
-	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, address,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
@@ -2005,7 +2006,8 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, addr,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 97bff25..d308319 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -313,7 +313,8 @@ unsigned long do_mremap(unsigned long addr,
 		if ((addr <= new_addr) && (addr+old_len) > new_addr)
 			goto out;
 
-		ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+		ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+					 SECURITY_MMAP_ADDR_ONLY);
 		if (ret)
 			goto out;
 
@@ -421,7 +422,8 @@ unsigned long do_mremap(unsigned long addr,
 				goto out;
 			}
 
-			ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+			ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+						 SECURITY_MMAP_ADDR_ONLY);
 			if (ret)
 				goto out;
 		}
diff --git a/mm/nommu.c b/mm/nommu.c
index 9876fa0..f87c1f9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -974,7 +974,8 @@ static int validate_mmap_request(struct file *file,
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0,
+				 SECURITY_MMAP_NOT_ADDR);
 	if (ret < 0)
 		return ret;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index f800fdb..fc9a92b 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -924,7 +924,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
  * @prot: unused
  * @flags: unused
  * @addr: address attempting to be mapped
- * @addr_only: unused
+ * @sec_flags: should the addr be checked?
  *
  * If the process is attempting to map memory below mmap_min_addr they need
  * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
@@ -933,11 +933,12 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
  */
 int cap_file_mmap(struct file *file, unsigned long reqprot,
 		  unsigned long prot, unsigned long flags,
-		  unsigned long addr, unsigned long addr_only)
+		  unsigned long addr, unsigned long sec_flags)
 {
 	int ret = 0;
 
-	if (addr < dac_mmap_min_addr) {
+	if (!(sec_flags & SECURITY_MMAP_NOT_ADDR) &&
+	    (addr < dac_mmap_min_addr)) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
 		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
diff --git a/security/security.c b/security/security.c
index b6e43a1..fd2d450 100644
--- a/security/security.c
+++ b/security/security.c
@@ -677,11 +677,12 @@ int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only)
+			unsigned long addr, unsigned long sec_flags)
 {
 	int ret;
 
-	ret = security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	ret = security_ops->file_mmap(file, reqprot, prot, flags, addr,
+				      sec_flags);
 	if (ret)
 		return ret;
 	return ima_file_mmap(file, prot);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9688ccc..0c415d1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3043,7 +3043,7 @@ error:
 
 static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long prot, unsigned long flags,
-			     unsigned long addr, unsigned long addr_only)
+			     unsigned long addr, unsigned long sec_flags)
 {
 	int rc = 0;
 	u32 sid = current_sid();
@@ -3054,7 +3054,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
+	if (!(sec_flags & SECURITY_MMAP_NOT_ADDR) &&
+	    (addr < CONFIG_LSM_MMAP_MIN_ADDR)) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 		if (rc)
@@ -3062,8 +3063,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	}
 
 	/* do DAC check on address space usage */
-	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
-	if (rc || addr_only)
+	rc = cap_file_mmap(file, reqprot, prot, flags, addr, sec_flags);
+	if (rc || (sec_flags & SECURITY_MMAP_ADDR_ONLY))
 		return rc;
 
 	if (selinux_checkreqprot)

