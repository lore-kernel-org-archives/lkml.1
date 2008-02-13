Return-Path: <linux-kernel-owner+w=401wt.eu-S1764184AbYBMPRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764184AbYBMPRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYBMPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:17:46 -0500
Received: from r00tworld.com ([212.85.137.21]:40615 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYBMPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:17:45 -0500
X-Greylist: delayed 2277 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 10:17:44 EST
From: pageexec@freemail.hu
To: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>
Date: Wed, 13 Feb 2008 15:38:45 +0200
MIME-Version: 1.0
Subject: Re: vmsplice exploits, stack protector and Makefiles
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Message-ID: <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
In-reply-to: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 13 Feb 2008 15:37:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Feb 2008 at 9:00, Arjan van de Ven wrote:
> I just read the excellent LWN writeup of the vmsplice security thing, and that got me
> wondering why this attack wasn't stopped by the CONFIG_CC_STACKPROTECTOR option... because
> it plain should have been...

what makes you think it should have been? you probably didn't even look,
there're so many problems with ssp here and in general.

1. despite the nice analysis in LWN, it unfortunately stopped half way where
   Jon declared that:

     And this turns the failure to read-verify the source array into a buffer
     overflow vulnerability within the kernel. Once that is in place, it is a
     relatively straightforward exercise for any suitably 31337 hacker to
     cause the kernel to jump into the code of his or her choice. Game over. 

   fact of the matter is, it's far from game over at this point. and that's
   because despite all appearances, this is far from your run-of-the-mill
   stack buffer overflow. in particular, the overflow does *not* rely on
   overwriting any saved return address on the stack.

   the trickery with the fake compound page set up should have been a sign
   that something else is going on here and the lesson ain't over until you
   understand that part as well.

2. so why isn't this exploit about an overflowed return address? because
   before any potentially overflowed return address would be dereferenced,
   the kernel will attempt to release the page refcounts it acquired in
   get_user_pages (check splice_to_pipe, called from vmsplice_to_pipe
   where the overflowed buffer is). normally that wouldn't be a problem
   since even though the pages[PIPE_BUFFERS] array was overflowed, it was
   overflowed with valid struct page pointers, so releasing them should
   be fine. except there's a trick in the exploit that will cause a userland
   controlled struct page pointer to be released as well at which point
   the exploit takes matters into its own hands:

   previous to calling vmsplice, the exploit has prepared a specially
   constructed struct page array to fake a compound page. the point in
   using a compound page is that such a page has a destructor (read:
   function pointer) which is now under the direct control of the exploit
   and will result in ring-0 code execution of exploit code. *this* is
   the point where it becomes a trivial exercise to escalate privileges.

3. what's ssp got to do with all this? Arjan would have you believe that
   it would have caught this exploit in action, preventing the privilege
   escalation. nothing could be further from the truth though.

   for one if ssp were to kick into action, it could at most be at the
   time vmsplice_to_pipe returns. except it doesn't as explained above.

   but imagine for a second that vmsplice_to_pipe does return. would ssp
   detect anything? at least gentoo's gcc 4.2.2 doesn't at all instrument
   vmsplice_to_pipe with -fstack-protector, so no dice.

   let's go further and imagine we enable CONFIG_CC_STACKPROTECTOR_ALL
   (which in turn makes gcc use -fstack-protector-all). this will now
   properly instrument vmsplice_to_pipe. problem is, such a kernel doesn't
   boot. probably noone has ever tried it (why does it have a config option?).
   the fix isn't trivial and possibly incomplete, see the patches at the end.

   finally just imagine that ssp somehow caught this or another exploit in
   action. what will we learn about it? nothing. that's right, due to bad
   decisions made by certain developers (both gcc and kernel),__stack_chk_fail
   doesn't get passed any extra info (unlike Etoh's original ssp), nor does
   the kernel's version produce any actually useful output that, pray tell,
   could help identify the attacked function. instead it just panic's. a truly
   useful experience.

   it also bears a note here that the way ssp is currently implemented in
   the kernel is quite useless, a per-task static cookie is trivial to learn
   in a kernel info-leak exploit that in turn can be built into the actual
   attack payload to bypass any detection (a case that ssp was designed to
   protect against, this particular bug/exploit doesn't give direct control
   over the overflow content, hence even the current cookie method would have
   been fine, were it not irrelevant for reasons explained above).

[...]
> It would have made this exploit not possible for those kernels that
> enable this feature (and that includes distros like Fedora) 

sadly for all those users living in a false sense of security, this has
never been true. but long live cargo cult security.

---
patches to get CONFIG_CC_STACKPROTECTOR_ALL actually to work (it includes
the Makefile patch proposed in this thread already).

note that the fix to ACPI is an actual stack corruption bug (caught by ssp
thanks to a lucky stack layout), due to the misuse of the pci accessor
functions, probably a whole-tree audit is in order for similar bugs.

note also that the vsyscall functions (more precisely, all the code that
goes into .vsyscall* sections) had better be separated into their own .c
files so that they can be compiled without -mcmodel=kernel and use %fs for
getting the ssp cookie, if ssp is desired at all there).
---
diff -u linux-2.6.24.2-pax/Makefile linux-2.6.24.2-pax/Makefile
--- linux-2.6.24.2-pax/Makefile	2008-02-11 17:24:34.000000000 +0100
+++ linux-2.6.24.2-pax/Makefile	2008-02-12 20:31:56.000000000 +0100
@@ -507,6 +507,9 @@
 KBUILD_CFLAGS	+= -O2
 endif
 
+# Force gcc to behave correct even for buggy distributions
+KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
@@ -520,9 +523,6 @@
 KBUILD_AFLAGS	+= -gdwarf-2
 endif
 
-# Force gcc to behave correct even for buggy distributions
-KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
-
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
diff -u linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S linux-2.6.24.2-
pax/arch/x86/kernel/entry_64.S
--- linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S	2008-01-25 
15:34:25.000000000 +0100
+++ linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S	2008-02-13 
11:12:26.000000000 +0100
@@ -440,6 +440,7 @@
 	CFI_REGISTER rip, r11
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
 	call sys_execve
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
@@ -1004,15 +1005,16 @@
  *	rdi: name, rsi: argv, rdx: envp
  *
  * We want to fallback into:
- *	extern long sys_execve(char *name, char **argv,char **envp, struct 
pt_regs regs)
+ *	extern long sys_execve(char *name, char **argv,char **envp, struct 
pt_regs *regs)
  *
  * do_sys_execve asm fallback arguments:
- *	rdi: name, rsi: argv, rdx: envp, fake frame on the stack
+ *	rdi: name, rsi: argv, rdx: envp, rcx: fake frame on the stack
  */
 ENTRY(kernel_execve)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $0
 	SAVE_ALL	
+	movq %rsp,%rcx
 	call sys_execve
 	movq %rax, RAX(%rsp)	
 	RESTORE_REST
diff -u linux-2.6.24.2-pax/arch/x86/kernel/process_64.c linux-2.6.24.2-
pax/arch/x86/kernel/process_64.c
--- linux-2.6.24.2-pax/arch/x86/kernel/process_64.c	2008-01-25 
15:34:25.000000000 +0100
+++ linux-2.6.24.2-pax/arch/x86/kernel/process_64.c	2008-02-13 
11:13:14.000000000 +0100
@@ -673,7 +673,6 @@
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - 
PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
@@ -702,7 +701,7 @@
  */
 asmlinkage 
 long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs regs)
+		char __user * __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char * filename;
@@ -711,7 +710,7 @@
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename)) 
 		return error;
-	error = do_execve(filename, argv, envp, &regs); 
+	error = do_execve(filename, argv, envp, regs);
 	if (error == 0) {
 		task_lock(current);
 		current->ptrace &= ~PT_DTRACE;
diff -u linux-2.6.24.2-pax/drivers/acpi/osl.c linux-2.6.24.2-
pax/drivers/acpi/osl.c
--- linux-2.6.24.2-pax/drivers/acpi/osl.c	2008-02-08 22:34:51.000000000 
+0100
+++ linux-2.6.24.2-pax/drivers/acpi/osl.c	2008-02-13 03:06:49.000000000 
+0100
@@ -524,7 +524,7 @@
 
 acpi_status
 acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
-			       void *value, u32 width)
+			       u32 *value, u32 width)
 {
 	int result, size;
 
@@ -596,7 +596,7 @@
 	acpi_status status;
 	unsigned long temp;
 	acpi_object_type type;
-	u8 tu8;
+	u32 tu8;
 
 	acpi_get_parent(chandle, &handle);
 	if (handle != rhandle) {
diff -u linux-2.6.24.2-pax/include/asm-x86/system_64.h linux-2.6.24.2-
pax/include/asm-x86/system_64.h
--- linux-2.6.24.2-pax/include/asm-x86/system_64.h	2008-01-25 
15:34:27.000000000 +0100
+++ linux-2.6.24.2-pax/include/asm-x86/system_64.h	2008-02-12 
22:03:42.000000000 +0100
@@ -33,6 +33,8 @@
 		     ".globl thread_return\n"					\
 		     "thread_return:\n\t"					    \
 		     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  
\
+		     "movq %P[task_canary](%%rsi),%%r8\n\t"			  
\
+		     "movq %%r8,%%gs:%P[pda_canary]\n\t"			  \
 		     "movq %P[thread_info](%%rsi),%%r8\n\t"			  
\
 		     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  
\
 		     "movq %%rax,%%rdi\n\t" 					  
\
@@ -44,7 +46,9 @@
 		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
 		       [tif_fork] "i" (TIF_FORK),			  \
 		       [thread_info] "i" (offsetof(struct task_struct, stack)), 
\
-		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   
\
+		       [task_canary] "i" (offsetof(struct task_struct, 
stack_canary)), \
+		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, 
pcurrent)),   \
+		       [pda_canary] "i" (offsetof(struct x8664_pda, 
stack_canary))   \
 		     : "memory", "cc" __EXTRA_CLOBBER)
     
 extern void load_gs_index(unsigned); 
--- linux-2.6.24.2/arch/x86/kernel/Makefile_64	2008-01-24 23:58:37.000000000 
+0100
+++ linux-2.6.24.2-pax/arch/x86/kernel/Makefile_64	2008-02-13 
11:36:14.000000000 +0100
@@ -42,4 +42,6 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 obj-y				+= topology.o
 obj-y				+= pcspeaker.o
 
-CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0
+CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0 -fno-stack-protector
+CFLAGS_hpet.o			:= -fno-stack-protector
+CFLAGS_tsc_64.o			:= -fno-stack-protector
--- linux-2.6.24.2/include/acpi/acpiosxf.h	2008-01-24 23:58:37.000000000 
+0100
+++ linux-2.6.24.2-pax/include/acpi/acpiosxf.h	2008-02-13 03:07:31.000000000 
+0100
@@ -219,7 +219,7 @@ acpi_os_write_memory(acpi_physical_addre
  */
 acpi_status
 acpi_os_read_pci_configuration(struct acpi_pci_id *pci_id,
-			       u32 reg, void *value, u32 width);
+			       u32 reg, u32 *value, u32 width);
 
 acpi_status
 acpi_os_write_pci_configuration(struct acpi_pci_id *pci_id,
only in patch2:
unchanged:
--- linux-2.6.24.2/kernel/panic.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24.2-pax/kernel/panic.c	2008-02-13 11:39:28.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
 #include <linux/random.h>
+#include <linux/kallsyms.h>
 
 int panic_on_oops;
 int tainted;
@@ -299,6 +300,8 @@ void oops_exit(void)
  */
 void __stack_chk_fail(void)
 {
+	print_symbol("stack corrupted in: %s\n", (unsigned 
long)__builtin_return_address(0));
+	dump_stack();
 	panic("stack-protector: Kernel stack is corrupted");
 }
 EXPORT_SYMBOL(__stack_chk_fail);


