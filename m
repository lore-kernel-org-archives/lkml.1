Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbXBVUil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbXBVUil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXBVUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:38:41 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:37789 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXBVUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:38:40 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 15:38:40 EST
Message-ID: <45DDFD98.4080300@BitWagon.com>
Date: Thu, 22 Feb 2007 12:31:20 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fully honor vdso_enabled [i386, sh; x86_64?]
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures such as i386, sh, x86_64 have a flag /proc/sys/vm/vdso_enabled
to choose whether the kernel should setup a process to use vdso after execve().
Informing the user code via AT_SYSINFO* is controlled by macro ARCH_DLINFO in
fs/binfmt_elf.c and include/asm-$ARCH/elf.h, but the vdso page is established
always via arch_setup_additonal_pages() called from load_elf_binary().
If vdso_enabled is off, then current code wastes kernel time during execve()
and fragments the address space unnecessarily.

This patch changes arch_setup_additonal_pages() to honor vdso_enabled.
For i386 it also allows the option of a fixed addresss to avoid
fragmenting the address space.  Compiles and runs on i386.
x86_64 [IA32 support] and sh maintainers also please comment.

For some related history, including interaction with exec-shield, see:
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229304
and also 207020 and 162797.


Signed-off-by: John Reiser <jreiser@BitWagon.com>

diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
index 13ca54a..f8c4d76 100644
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -22,6 +22,8 @@
 #include <asm/msr.h>
 #include <asm/pgtable.h>
 #include <asm/unistd.h>
+#include <asm/a.out.h>
+#include <asm/mman.h>

 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
+	unsigned long flags;
 	int ret;

+	switch (vdso_enabled) {
+	case 0:  /* none */
+		return 0;
+	default:
+	case 1:  /* vdso in random available page */
+		addr = 0ul;
+		flags = 0ul;
+		break;
+	case 2:  /* out of user's way */
+		addr = STACK_TOP;
+		flags = MAP_FIXED;
+		break;
+	}
+
 	down_write(&mm->mmap_sem);
-	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+	addr = get_unmapped_area(NULL, addr, PAGE_SIZE, 0, flags);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 7b0f66f..2b789fb 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -64,6 +64,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	unsigned long addr;
 	int ret;

+	if (!vdso_enabled)
+		return 0;
+
 	down_write(&mm->mmap_sem);
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
diff --git a/include/asm-i386/a.out.h b/include/asm-i386/a.out.h
index ab17bb8..9894f73 100644
--- a/include/asm-i386/a.out.h
+++ b/include/asm-i386/a.out.h
@@ -19,7 +19,7 @@ struct exec

 #ifdef __KERNEL__

-#define STACK_TOP	TASK_SIZE
+#define STACK_TOP	(TASK_SIZE - PAGE_SIZE)  /* 1 page optional for vdso */

 #endif

-- 

