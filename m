Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXFUQLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXFUQLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXFUQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:10:22 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:46114 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbXFUQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:10:16 -0400
From: Alexander Wuerstlein <arw@arw.name>
To: linux-kernel@vger.kernel.org
Cc: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: [PATCH] sns: check related executable memory of binaries [3/4]
Date: Thu, 21 Jun 2007 18:02:27 +0200
Message-Id: <11824417551479-git-send-email-arw@arw.name>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: 20070621155516.GA6838@faui01.informatik.uni-erlangen.de
References: 20070621155516.GA6838@faui01.informatik.uni-erlangen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>

Checks on mmap and mprotect (i.e. libraries) wether they are signed and adjusts
the processe's signed flag accordingly.

If a process looses its signed state it gets, in our current design, killed, for
it is no longer trustworthy. A process also looses its signed flag if it mprotects
any memory as executable.

Signed-off-by: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>
---
 include/linux/mm.h  |    3 ++
 include/linux/sns.h |   17 +++++++++++
 kernel/fork.c       |    7 ++++
 mm/mmap.c           |   79 +++++++++++++++++++++++++++++++++++++++++++++++----
 mm/mprotect.c       |   30 +++++++++++++++++++
 security/Kconfig    |   36 +++++++++++++++++++++++
 security/sns.c      |   10 ++++++
 7 files changed, 176 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e4183c6..903bc45 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -112,6 +112,9 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
+#ifdef CONFIG_SNS_SIGNED
+	int sns_valid_sig;
+#endif
 };
 
 extern struct kmem_cache *vm_area_cachep;
diff --git a/include/linux/sns.h b/include/linux/sns.h
index ad15e4b..eefb6e7 100644
--- a/include/linux/sns.h
+++ b/include/linux/sns.h
@@ -1,3 +1,20 @@
 #ifdef CONFIG_SNS_SIGNED
 int sns_signature_valid(struct file *);
+int sns_signature_becomes_invalid(void);
+
+/*
+ * The following is unfortunately necessary, there does not seem to be a
+ * common define to find out wether some ominous DSO which somebody
+ * likes to mmap or mprotect is in fact trustworthy kernel code.
+ */
+#ifdef CONFIG_X86
+#define sns_is_gate_vdso(addr, len) (addr==0xffffe000 && len == PAGE_SIZE)
+#else
+#ifdef CONFIG_IA64
+#define sns_is_gate_vdso(addr, len) (addr==0xffffe000UL && len == PAGE_SIZE)
+#else
+#define sns_is_gate_vdso(addr, len) 0
+#endif
+#endif
+
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index c12cf61..b1afa57 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -260,6 +260,9 @@ static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file->f_path.dentry->d_inode;
+#ifdef CONFIG_SNS_SIGNED
+			tmp->sns_valid_sig = mpnt->sns_valid_sig;
+#endif
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
@@ -271,6 +274,10 @@ static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			vma_prio_tree_add(tmp, mpnt);
 			flush_dcache_mmap_unlock(file->f_mapping);
 			spin_unlock(&file->f_mapping->i_mmap_lock);
+#ifdef CONFIG_SNS_SIGNED
+		} else {
+			tmp->sns_valid_sig = 0;
+#endif
 		}
 
 		/*
diff --git a/mm/mmap.c b/mm/mmap.c
index 68b9ad2..1f4bdf0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -25,6 +25,9 @@
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
+#ifdef CONFIG_SNS_SIGNED
+#include <linux/sns.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1101,10 +1104,33 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
-	} else if (vm_flags & VM_SHARED) {
-		error = shmem_zero_setup(vma);
-		if (error)
-			goto free_vma;
+#ifdef CONFIG_SNS_SIGNED
+		if (current->sns_valid_sig && (vm_flags & VM_EXEC)) {
+			if (vm_flags & VM_WRITE){
+				vma->sns_valid_sig = 0;
+				current->sns_valid_sig = 0;
+				sns_signature_becomes_invalid();
+			} else {
+				vma->sns_valid_sig = sns_signature_valid(file);
+				current->sns_valid_sig = vma->sns_valid_sig;
+				if(!current->sns_valid_sig)
+					sns_signature_becomes_invalid();
+			}
+		}
+#endif
+	} else {
+#ifdef CONFIG_SNS_SIGNED
+		/* JIT could have written some evil code here, which we are unable to verify */
+		if (prot & PROT_EXEC && current->sns_valid_sig) {
+			if ((vma->sns_valid_sig = (current->sns_valid_sig = (sns_is_gate_vdso(addr, len)))))
+				sns_signature_becomes_invalid();
+		}
+#endif
+		if (vm_flags & VM_SHARED) {
+			error = shmem_zero_setup(vma);
+			if (error)
+				goto free_vma;
+		}
 	}
 
 	/* We set VM_ACCOUNT in a shared mapping's vm_flags, to inform
@@ -1946,8 +1972,49 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = pgoff;
 	vma->vm_flags = flags;
-	vma->vm_page_prot = protection_map[flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+
+#ifdef CONFIG_SNS_SIGNED
+	/*
+	 * A signed process could put executable code into an area
+	 * it got from brk(). We can either disable the exec-bit on
+	 * that area, which might break some programs, or we can
+	 * allow the exec bit but remove the signed status, thereby
+	 * unsigning any program that does some malloc()...
+	 *
+	 * Choose your poison.
+	 */
+
+	if (current->sns_valid_sig){
+#ifdef CONFIG_SNS_BRK_ALLOW_EXEC
+		vma->vm_page_prot = protection_map[flags &
+			(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+
+
+#ifdef CONFIG_SNS_BRK_UNSIGN
+		current->sns_valid_sig = 0;
+		sns_signature_becomes_invalid();
+		vma->sns_valid_sig = 0;
+#endif /* CONFIG_SNS_BRK_UNSIGN */
+
+
+
+#else /* not CONFIG_SNS_BRK_ALLOW_EXEC */
+		vma->vm_page_prot = protection_map[flags &
+			(VM_READ|VM_WRITE|VM_SHARED)];
+#endif /* CONFIG_SNS_BRK_ALLOW_EXEC */
+	} else {
+		vma->vm_page_prot = protection_map[flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+	}
+
+
+#else /* not CONFIG_SNS_SIGNED */
+	vma->vm_page_prot = protection_map[flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+
+
+
+
+#endif /* CONFIG_SNS_SIGNED */
+
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 3b8f3c0..db17887 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -26,6 +26,10 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_SNS_SIGNED
+#include <linux/sns.h>
+#endif
+
 static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
@@ -289,6 +293,32 @@ sys_mprotect(unsigned long start, size_t len, unsigned long prot)
 		if (error)
 			goto out;
 
+#ifdef CONFIG_SNS_SIGNED
+		if (! sns_is_gate_vdso(start, len)) {
+			if ((newflags & VM_EXEC) && current->sns_valid_sig){
+				if ((newflags & VM_WRITE) == 0) {
+					if (current->sns_valid_sig && vma->vm_file) {
+						vma->sns_valid_sig = sns_signature_valid(vma->vm_file);
+						current->sns_valid_sig = vma->sns_valid_sig;
+						if (!current->sns_valid_sig)
+							sns_signature_becomes_invalid();
+					} else {
+						vma->sns_valid_sig = 0;
+						current->sns_valid_sig = 0;
+						sns_signature_becomes_invalid();
+					}
+				} else {
+					vma->sns_valid_sig = 0;
+					current->sns_valid_sig = 0;
+					sns_signature_becomes_invalid();
+				}
+			}
+		} else {
+			/* always trust kernelspace */
+			vma->sns_valid_sig = 1;
+		}
+#endif
+
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
diff --git a/security/Kconfig b/security/Kconfig
index bfaace7..9776e29 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -32,6 +32,42 @@ config SNS_SIGNED_SETGID
 
 	  If you don't know exactly what you are doing, answer N.
 
+config SNS_BRK_ALLOW_EXEC
+	bool "Allows the executable bit to be set on brk()-ed memory"
+	depends on SNS_SIGNED
+	help
+	  By default the memory a process gets from brk() is executable.
+	  This is undesirable in our situation because it would allow
+	  an evil binary to load unsigned code.
+
+	  We can either disable the exec-bit on that area (set this option to
+	  off), which might break some programs, or we can allow the exec bit
+	  but remove the signed status (this option on, next option on),
+	  thereby unsigning any program that does some malloc()...
+
+          Choose your poison.
+
+	  On old x86 (without CPU-flag NX to be exact) this option is useless
+	  because every readable page is also executable. This might apply to
+	  some other broken architectures as well. YMMV.
+
+	  The default behaviour everybody expects is probably broken
+	  either way. If you do not want any problems or you are
+	  unsure, enable this option (SNS_BREAK_ALLOW_EXEC) and
+	  disable the next one (SNS_BRK_UNSIGN).
+
+	  I repeat: Always say Y, unless you are very brave...
+
+config SNS_BRK_UNSIGN
+	bool "Unsign process after doing brk()"
+	depends on SNS_BRK_ALLOW_EXEC
+	help
+	  Remove signed bit from any process that does brk().
+
+	  See previous option (SNS_BRK_ALLOW_EXEC) for help.
+
+	  If unsure say N.
+
 config KEYS
 	bool "Enable access key retention support"
 	help
diff --git a/security/sns.c b/security/sns.c
index 4403e5a..3192a90 100644
--- a/security/sns.c
+++ b/security/sns.c
@@ -33,6 +33,16 @@ static int sns_sig_reader(read_descriptor_t *desc, struct page *page, unsigned l
 	return read;
 }
 
+int sns_signature_becomes_invalid(void)
+{
+	current->sns_valid_sig = 0;
+	/*no checking necessary because of SEND_SIG_FORCED*/
+	force_sig_info(SIGKILL, SEND_SIG_FORCED, current);
+	return 0; /*Leave the actual killing to the scheduler*/
+	/*TODO check if the process has any way left to execute any code*/
+}
+
+
 /*
  * check file signature for setuid
  */
-- 
1.5.2.1

