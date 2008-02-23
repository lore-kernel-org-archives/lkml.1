Return-Path: <linux-kernel-owner+w=401wt.eu-S936152AbYBWIdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152AbYBWIdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762502AbYBWIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:40 -0500
Received: from po-out-1718.google.com ([72.14.252.159]:36241 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022AbYBWIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PCD1cs0CMdqt/gpL58/k/CaekjjUEwY2Bta31WXJAZeeX/dh4fYPKGCrJicYJBU/mDg/YBTE09PlUpQ0tWSa+lDZm2CiPYDMXtpIDhE+BfIkkx2zAw5zS/Wh2TvSEM3GXa6fUblfF3ZhpG8jHWSs8uCODmD1iqe4GxPj+ad1IkY=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 08/16] x86: use get_personality()
Date: Sat, 23 Feb 2008 16:14:11 +0800
Message-Id: <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for x86 code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc:  Ingo Molnar <mingo@redhat.com>

---
 arch/x86/ia32/sys_ia32.c     |    6 +++---
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 arch/x86/kernel/sys_x86_64.c |    2 +-
 arch/x86/mm/mmap.c           |    2 +-
 include/asm-x86/page.h       |    2 +-
 include/asm-x86/processor.h  |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index abf71d2..80e7431 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -666,7 +666,7 @@ asmlinkage long sys32_personality(unsigned long personality)
 {
 	int ret;
 
-	if (personality(current->personality) == PER_LINUX32 &&
+	if (personality(get_personality()) == PER_LINUX32 &&
 		personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
@@ -744,7 +744,7 @@ asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
 			      __OLD_UTS_LEN);
 	err |= __put_user(0, name->version+__OLD_UTS_LEN);
 
-	if (personality(current->personality) == PER_LINUX32)
+	if (personality(get_personality()) == PER_LINUX32)
 		arch = "i686";
 
 	err |= __copy_to_user(&name->machine, arch, strlen(arch) + 1);
@@ -765,7 +765,7 @@ long sys32_uname(struct old_utsname __user *name)
 	down_read(&uts_sem);
 	err = copy_to_user(name, utsname(), sizeof(*name));
 	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32)
+	if (personality(get_personality()) == PER_LINUX32)
 		err |= copy_to_user(&name->machine, "i686", 5);
 
 	return err ? -EFAULT : 0;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a7d50a5..c4992fc 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -837,7 +837,7 @@ unsigned long get_wchan(struct task_struct *p)
 
 unsigned long arch_align_stack(unsigned long sp)
 {
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	if (!(get_personality() & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b0cc8f0..8223f3f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -915,7 +915,7 @@ long sys_arch_prctl(int code, unsigned long addr)
 
 unsigned long arch_align_stack(unsigned long sp)
 {
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	if (!(get_personality() & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index bd802a5..0b7548b 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -247,7 +247,7 @@ asmlinkage long sys_uname(struct new_utsname __user * name)
 	down_read(&uts_sem);
 	err = copy_to_user(name, utsname(), sizeof (*name));
 	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32) 
+	if (personality(get_personality()) == PER_LINUX32) 
 		err |= copy_to_user(&name->machine, "i686", 5); 		
 	return err ? -EFAULT : 0;
 }
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 56fe712..f299d64 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -55,7 +55,7 @@ static int mmap_is_ia32(void)
 
 static int mmap_is_legacy(void)
 {
-	if (current->personality & ADDR_COMPAT_LAYOUT)
+	if (get_personality() & ADDR_COMPAT_LAYOUT)
 		return 1;
 
 	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 1cb7c51..fd90c7a 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -42,7 +42,7 @@
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 
 #define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	(((get_personality() & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 45a2f0a..c426dc1 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -791,7 +791,7 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
-#define IA32_PAGE_OFFSET ((current->personality & ADDR_LIMIT_3GB) ? \
+#define IA32_PAGE_OFFSET ((get_personality() & ADDR_LIMIT_3GB) ? \
 			   0xc0000000 : 0xFFFFe000)
 
 #define TASK_SIZE 		(test_thread_flag(TIF_IA32) ? \
-- 
1.5.3.8

