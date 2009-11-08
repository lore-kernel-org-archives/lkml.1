Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZKHOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZKHOi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZKHOi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:38:56 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:49225 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZKHOiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:38:55 -0500
Message-ID: <4AF6D7F8.3070004@free.fr>
Date: Sun, 08 Nov 2009 15:38:48 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.22) Gecko/20090605 Iceape/1.1.17 (Debian-1.1.17-2)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jkosina@suse.cz, hpa@zytor.com
Subject: Re: Using x86 segments against NULL pointer deference exploit
References: <1257512389.4af41dc504e1b@imp.free.fr> <87eiob76fh.fsf@basil.nowhere.org>
In-Reply-To: <87eiob76fh.fsf@basil.nowhere.org>
Content-Type: multipart/mixed;
 boundary="------------070304010909050208030904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070304010909050208030904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Andi Kleen wrote:
> castet.matthieu@free.fr writes:
> 
>> Hi,
>>
>> I am wondering why we can't set the KERNEL_DS data segment to not contain the
>> first page, ie changing it from R/W flat model to R/W expand down from
>> 0xffffffff to 4096.
> 
> As Alan pointed out setting segment limits/bases has large penalties.
> 
> This has been already addressed by the mmap limit defaults 
> on the VM level by disallowing to place something on the zero page.
> 
> In fact a lot of systems should already run with that default.
Yes, but lot's of system run with access to zero page enabled.
Mmap limit was added near 2 years ago. But this summer lot's of machines were
still vulnerable to 'NULL deference exploits'.
Why ?

May be because the kernel still allow it (mmap_min_addr is 0 by default). Openbsd enforce it.
There are lots of way to bypass it (root, RAW_IO cap, personality, ...).
Also some distro doesn't enable it because it break some applications. For example vm86 can't
be used by dosemu, wine.

I attach a basic (, slow and probably buggy) protection with segments. It works for wine and dosemu, and catch kernel access to page0.

I believe a better solution should be to implement a new vm86 syscall. This syscall will allow to run code in
virtual 8086 mode that doesn't need to be in low pages.
For that an extra argument pointing to the code region could be added.
The kernel in the syscall entry will :
- duplicate the memory mapping of the calling thread.
- map at low pages (zero page and more) the code to run
- switch to this mapping
- enter in vm86 mode
...
- exit vm86 mode
- switch back to original mapping (without page0).
- return to user

With that new syscall, there should less programs that need page0 mapping.


Matthieu


> 
>> PS : why x86_64 segment got access bit set and x86_32 doesn't ?
> 
> It's a extremly minor optimization, but the CPU sets it on the first
> access anyways.
Setting it for x86_32 will allow to merge them out the ifdef. Not that it is important...

--------------070304010909050208030904
Content-Type: text/x-diff;
 name="kernel_page0_prot.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_page0_prot.diff"

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..898a569 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -101,7 +101,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xa0fb, 0, 0xfffff),
 #else
 	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
-	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc096, 0, 0x00001),
 	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
 	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
 	/*
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..2221c68 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -224,7 +224,7 @@
 	pushl %ebx
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ebx, 0
-	movl $(__USER_DS), %edx
+	movl $(__KERNEL_DS), %edx
 	movl %edx, %ds
 	movl %edx, %es
 	movl $(__KERNEL_PERCPU), %edx
@@ -1255,7 +1255,7 @@ error_code:
 	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
 	REG_TO_PTGS %ecx
 	SET_KERNEL_GS %ecx
-	movl $(__USER_DS), %ecx
+	movl $(__KERNEL_DS), %ecx
 	movl %ecx, %ds
 	movl %ecx, %es
 	TRACE_IRQS_OFF
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 050c278..3c74fae 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -424,7 +424,7 @@ is386:	movl $2,%ecx		# set MP
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
 	movl %eax,%ss			# after changing gdt.
 
-	movl $(__USER_DS),%eax		# DS/ES contains default USER segment
+	movl $(__KERNEL_DS),%eax	# DS/ES contains default KERNEL segment
 	movl %eax,%ds
 	movl %eax,%es
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..8ede717 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -210,8 +210,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.bx = (unsigned long) fn;
 	regs.dx = (unsigned long) arg;
 
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
+	regs.ds = __KERNEL_DS;
+	regs.es = __KERNEL_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
 	regs.orig_ax = -1;
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 9c4e625..584a80e 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -48,6 +48,20 @@
 #include <asm/irq.h>
 #include <asm/syscalls.h>
 
+static inline void set_data_segment(int seg, int line)
+{
+	static int print;
+	int old_seg;
+	savesegment(ds, old_seg);
+	if (print++ < 100)
+		printk("oldseg %x->%x (%d)\n", old_seg,seg, line);
+	if (old_seg == seg)
+		return;
+	loadsegment(ds, seg);
+	loadsegment(es, seg);
+}
+
+
 /*
  * Known problems:
  *
@@ -129,6 +143,7 @@ struct pt_regs *save_v86_state(struct kernel_vm86_regs *regs)
 	struct pt_regs *ret;
 	unsigned long tmp;
 
+	set_data_segment(__USER_DS, __LINE__);
 	/*
 	 * This gets called from entry.S with interrupts disabled, but
 	 * from process context. Enable interrupts here, before trying
@@ -160,6 +175,7 @@ struct pt_regs *save_v86_state(struct kernel_vm86_regs *regs)
 	ret->fs = current->thread.saved_fs;
 	set_user_gs(ret, current->thread.saved_gs);
 
+	set_data_segment(__KERNEL_DS, __LINE__);
 	return ret;
 }
 
@@ -208,6 +224,7 @@ int sys_vm86old(struct pt_regs *regs)
 	struct task_struct *tsk;
 	int tmp, ret = -EPERM;
 
+	set_data_segment(__USER_DS, __LINE__);
 	tsk = current;
 	if (tsk->thread.saved_sp0)
 		goto out;
@@ -223,6 +240,7 @@ int sys_vm86old(struct pt_regs *regs)
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
 out:
+	set_data_segment(__KERNEL_DS, __LINE__);
 	return ret;
 }
 
@@ -237,6 +255,7 @@ int sys_vm86(struct pt_regs *regs)
 	struct task_struct *tsk;
 	int tmp, ret;
 	struct vm86plus_struct __user *v86;
+	set_data_segment(__USER_DS, __LINE__);
 
 	tsk = current;
 	switch (regs->bx) {
@@ -274,6 +293,7 @@ int sys_vm86(struct pt_regs *regs)
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
 out:
+	set_data_segment(__KERNEL_DS, __LINE__);
 	return ret;
 }
 
@@ -339,6 +359,7 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(0), 0);
 
+	set_data_segment(__KERNEL_DS, __LINE__);
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
@@ -551,6 +572,7 @@ cannot_handle:
 
 int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
 {
+	set_data_segment(__USER_DS, __LINE__);
 	if (VMPI.is_vm86pus) {
 		if ((trapno == 3) || (trapno == 1))
 			return_to_32bit(regs, VM86_TRAP + (trapno << 8));
@@ -573,6 +595,7 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
 	unsigned short ip, sp, orig_flags;
 	int data32, pref_done;
 
+	set_data_segment(__USER_DS, __LINE__);
 #define CHECK_IF_IN_TRAP \
 	if (VMPI.vm86dbg_active && VMPI.vm86dbg_TFpendig) \
 		newflags |= X86_EFLAGS_TF

--------------070304010909050208030904--
