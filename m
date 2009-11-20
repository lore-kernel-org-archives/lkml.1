Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZKTTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZKTTw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZKTTw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:52:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbZKTTw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:52:26 -0500
Date: Fri, 20 Nov 2009 11:50:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: David Howells <dhowells@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org, john.johansen@canonical.com
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Message-Id: <20091120115016.82d01eaa.akpm@linux-foundation.org>
In-Reply-To: <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>
References: <20091120094217.b94d99bb.akpm@linux-foundation.org>
	<20091117141314.0238a49b.akpm@linux-foundation.org>
	<1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	<7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	<1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	<18475.1255529305@redhat.com>
	<6207.1255706090@redhat.com>
	<23382.1255707790@redhat.com>
	<1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
	<16299.1258729209@redhat.com>
	<18122.1258739664@redhat.com>
	<1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 14:32:02 -0500
Eric Paris <eparis@redhat.com> wrote:

> On Fri, 2009-11-20 at 17:54 +0000, David Howells wrote:
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > I'll hold off, as Eric is preparing an alternative for "the end of this
> > > week".  If that doesn't work out, we can add
> > > nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
> > > to 2.6.32.1, OK?
> > 
> > I'll be on holiday next week.
> 
> Can we give this a whirl?  I can't even seem to make a config not select
> MMU, so it isn't even compile tested in that case.  If it is good, I'll
> send as a clean message for James Morris to take through the security
> tree....
> 

You'll need a cross-compiler.

> commit 58c728c7f9c2c8e2c62f7dfda3e10f77524c4379
> Author: Eric Paris <eparis@redhat.com>
> Date:   Fri Nov 20 14:23:57 2009 -0500
> 
>     security: do not check mmap_min_addr on nommu systems
>     
>     nommu systems can do anything with memory they please and so they already
>     win.  mmap_min_addr is the least of their worries.  Currently the
>     mmap_min_addr implementation is problamatic on such systems.  This patch
>     changes the addr_only argument to be a flags which can take the arguments
>     for addr_only or not_addr.  LSMs then need to properly implement these two
>     flags.
>     
>     Signed-off-by: Eric Paris <eparis@redhat.com>

Patch doesn't apply to current mainline for some reason.  I fixed that
up and checked that the affected files compile OK on superh.

The patch adds trailing whitespace.  If only we had a tool for that ;)

diff -puN include/linux/security.h~mm-nommuc-fix-improperly-call-of-security-api-in-mmap include/linux/security.h
--- a/include/linux/security.h~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/include/linux/security.h
@@ -43,6 +43,10 @@
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
 
+/* sec_flags for security_file_mmap */
+#define SECURITY_MMAP_ADDR_ONLY	0x01
+#define SECURITY_MMAP_NOT_ADDR	0x02
+
 struct ctl_table;
 struct audit_krule;
 
@@ -69,7 +73,7 @@ extern int cap_inode_need_killpriv(struc
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
-			 unsigned long addr, unsigned long addr_only);
+			 unsigned long addr, unsigned long sec_flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -593,6 +597,8 @@ static inline void security_free_mnt_opt
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr address vm will map to
+ *	@sec_flags what security checks should be done
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
@@ -1535,7 +1541,7 @@ struct security_operations {
 	int (*file_mmap) (struct file *file,
 			  unsigned long reqprot, unsigned long prot,
 			  unsigned long flags, unsigned long addr,
-			  unsigned long addr_only);
+			  unsigned long sec_flags);
 	int (*file_mprotect) (struct vm_area_struct *vma,
 			      unsigned long reqprot,
 			      unsigned long prot);
@@ -1804,7 +1810,7 @@ void security_file_free(struct file *fil
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only);
+			unsigned long addr, unsigned long sec_flags);
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			   unsigned long prot);
 int security_file_lock(struct file *file, unsigned int cmd);
@@ -2300,9 +2306,9 @@ static inline int security_file_mmap(str
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
diff -puN mm/mmap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap mm/mmap.c
--- a/mm/mmap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/mm/mmap.c
@@ -1668,7 +1668,8 @@ static int expand_downwards(struct vm_ar
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
-	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, address,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
@@ -2009,7 +2010,8 @@ unsigned long do_brk(unsigned long addr,
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, addr,
+				   SECURITY_MMAP_ADDR_ONLY);
 	if (error)
 		return error;
 
diff -puN mm/mremap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap mm/mremap.c
--- a/mm/mremap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/mm/mremap.c
@@ -313,7 +313,8 @@ unsigned long do_mremap(unsigned long ad
 		if ((addr <= new_addr) && (addr+old_len) > new_addr)
 			goto out;
 
-		ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+		ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+					 SECURITY_MMAP_ADDR_ONLY);
 		if (ret)
 			goto out;
 
@@ -421,7 +422,8 @@ unsigned long do_mremap(unsigned long ad
 				goto out;
 			}
 
-			ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
+			ret = security_file_mmap(NULL, 0, 0, 0, new_addr,
+						 SECURITY_MMAP_ADDR_ONLY);
 			if (ret)
 				goto out;
 		}
diff -puN mm/nommu.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/mm/nommu.c
@@ -974,7 +974,8 @@ static int validate_mmap_request(struct 
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0, 
+				 SECURITY_MMAP_NOT_ADDR);
 	if (ret < 0)
 		return ret;
 
diff -puN security/commoncap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap security/commoncap.c
--- a/security/commoncap.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/security/commoncap.c
@@ -992,7 +992,7 @@ int cap_vm_enough_memory(struct mm_struc
  * @prot: unused
  * @flags: unused
  * @addr: address attempting to be mapped
- * @addr_only: unused
+ * @sec_flags: should the addr be checked?
  *
  * If the process is attempting to map memory below mmap_min_addr they need
  * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
@@ -1001,11 +1001,12 @@ int cap_vm_enough_memory(struct mm_struc
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
diff -puN security/security.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap security/security.c
--- a/security/security.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/security/security.c
@@ -637,9 +637,9 @@ int security_file_ioctl(struct file *fil
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-			unsigned long addr, unsigned long addr_only)
+			unsigned long addr, unsigned long sec_flags)
 {
-	return security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	return security_ops->file_mmap(file, reqprot, prot, flags, addr, sec_flags);
 }
 
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
diff -puN security/selinux/hooks.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap security/selinux/hooks.c
--- a/security/selinux/hooks.c~mm-nommuc-fix-improperly-call-of-security-api-in-mmap
+++ a/security/selinux/hooks.c
@@ -3043,7 +3043,7 @@ error:
 
 static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long prot, unsigned long flags,
-			     unsigned long addr, unsigned long addr_only)
+			     unsigned long addr, unsigned long sec_flags)
 {
 	int rc = 0;
 	u32 sid = current_sid();
@@ -3054,7 +3054,8 @@ static int selinux_file_mmap(struct file
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
+	if (!(sec_flags & SECURITY_MMAP_NOT_ADDR) &&
+	    (addr < CONFIG_LSM_MMAP_MIN_ADDR)) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 		if (rc)
@@ -3062,8 +3063,8 @@ static int selinux_file_mmap(struct file
 	}
 
 	/* do DAC check on address space usage */
-	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
-	if (rc || addr_only)
+	rc = cap_file_mmap(file, reqprot, prot, flags, addr, sec_flags);
+	if (rc || (sec_flags & SECURITY_MMAP_ADDR_ONLY))
 		return rc;
 
 	if (selinux_checkreqprot)
_

