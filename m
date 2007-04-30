Return-Path: <linux-kernel-owner+w=401wt.eu-S1946413AbXD3QgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946413AbXD3QgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946368AbXD3QgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:36:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60736 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945907AbXD3Qfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:35:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/12] i386: remove cpuid checking in head.S
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
	<m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1647d4ybr.fsf_-_@ebiederm.dsl.xmission.com>
	<m11wi14ya7.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 10:35:05 -0600
In-Reply-To: <m11wi14ya7.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 10:33:52 -0600")
Message-ID: <m1wszt3jnq.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch augments the existing cpu initialization code in C
with the the few missing pieces that were performed in assembly.
Allowing us to remove cpu initialization from head.S completely.

This should also allow remove the need to call cpu_detect in
the paravirt initialization code paths.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/cpu/common.c |   55 +++++++++++++++++++----
 arch/i386/kernel/head.S       |   96 +----------------------------------------
 arch/i386/kernel/setup.c      |    3 -
 3 files changed, 47 insertions(+), 107 deletions(-)

diff --git a/arch/i386/kernel/cpu/common.c b/arch/i386/kernel/cpu/common.c
index 794d593..1a7b48a 100644
--- a/arch/i386/kernel/cpu/common.c
+++ b/arch/i386/kernel/cpu/common.c
@@ -251,6 +251,16 @@ static inline int flag_is_changeable_p(u32 flag)
 	return ((f1^f2) & flag) != 0;
 }
 
+static inline int has_x87(void)
+{
+	unsigned result;
+	asm("clts\n\t"
+	    "fninit\n\t"
+	    "fstsw %%ax\n\t"
+	    : "=a"(result));
+	return (result & 0xf) == 0;
+}
+
 
 /* Probe for the CPUID instruction */
 static int __cpuinit have_cpuid_p(void)
@@ -258,6 +268,23 @@ static int __cpuinit have_cpuid_p(void)
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
 
+static int __cpuinit init_cr0(void)
+{
+	unsigned long cr0;
+	int hard_math;
+	cr0 = read_cr0();
+	cr0 &= X86_CR0_PG | X86_CR0_ET | X86_CR0_PE;
+	cr0 |= X86_CR0_MP;
+	if (flag_is_changeable_p(X86_EFLAGS_AC))
+		cr0 |= X86_CR0_AM | X86_CR0_WP | X86_CR0_NE;
+	write_cr0(cr0);
+	hard_math = has_x87();
+	if (!hard_math)
+		/* No coprocessor: Enable emulation */
+		write_cr0(cr0 | X86_CR0_EM);
+	return hard_math;
+}
+
 void __init cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
@@ -268,8 +295,10 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 
 	c->x86 = 4;
 	if (c->cpuid_level >= 0x00000001) {
-		u32 junk, tfms, cap0, misc;
-		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
+		u32 tfms, misc, excap, capability;
+		cpuid(0x00000001, &tfms, &misc, &excap, &capability);
+		c->x86_capability[0] = capability;
+		c->x86_capability[4] = excap;
 		c->x86 = (tfms >> 8) & 15;
 		c->x86_model = (tfms >> 4) & 15;
 		if (c->x86 == 0xf)
@@ -277,7 +306,7 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 		if (c->x86 >= 0x6)
 			c->x86_model += ((tfms >> 16) & 0xF) << 4;
 		c->x86_mask = tfms & 15;
-		if (cap0 & (1<<19))
+		if (capability & (1<<19))
 			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 	}
 }
@@ -292,14 +321,21 @@ static void __init early_cpu_detect(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
+	c->cpuid_level = -1;
 	c->x86_cache_alignment = 32;
 
-	if (!have_cpuid_p())
-		return;
-
-	cpu_detect(c);
-
-	get_cpu_vendor(c, 1);
+	if (!have_cpuid_p()) {
+		/* First of all, decide if this is a 486 or higher */
+		/* It's a 486 if we can modify the AC flag */
+		if ( flag_is_changeable_p(X86_EFLAGS_AC) )
+			c->x86 = 4;
+		else
+			c->x86 = 3;
+	} else {
+		cpu_detect(c);
+		get_cpu_vendor(c, 1);
+	}
+	c->hard_math = init_cr0();
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
@@ -670,6 +706,7 @@ void __cpuinit cpu_init(void)
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
+	init_cr0();
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 	if (tsc_disable && cpu_has_tsc) {
diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 0ee615b..5e3478b 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -20,19 +20,6 @@
 #include <asm/setup.h>
 
 /*
- * References to members of the new_cpu_data structure.
- */
-
-#define X86		new_cpu_data+CPUINFO_x86
-#define X86_VENDOR	new_cpu_data+CPUINFO_x86_vendor
-#define X86_MODEL	new_cpu_data+CPUINFO_x86_model
-#define X86_MASK	new_cpu_data+CPUINFO_x86_mask
-#define X86_HARD_MATH	new_cpu_data+CPUINFO_hard_math
-#define X86_CPUID	new_cpu_data+CPUINFO_cpuid_level
-#define X86_CAPABILITY	new_cpu_data+CPUINFO_x86_capability
-#define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
-
-/*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
  * CS and DS must be 4 GB flat segments, but we don't depend on
@@ -182,6 +169,7 @@ ENTRY(startup_32_smp)
 	movl $swapper_pg_dir-__PAGE_OFFSET,%eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
+	andl $0x0000011,%eax	/* Save PE,ET */
 	orl $0x80000000,%eax
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
@@ -197,69 +185,6 @@ ENTRY(startup_32_smp)
 	pushl $0
 	popfl
 
-checkCPUtype:
-
-	movl $-1,X86_CPUID		#  -1 for no CPUID initially
-
-/* check if it is 486 or 386. */
-/*
- * XXX - this does a lot of unnecessary setup.  Alignment checks don't
- * apply at our cpl of 0 and the stack ought to be aligned already, and
- * we don't need to preserve eflags.
- */
-
-	movb $3,X86		# at least 386
-	pushfl			# push EFLAGS
-	popl %eax		# get EFLAGS
-	movl %eax,%ecx		# save original EFLAGS
-	xorl $0x240000,%eax	# flip AC and ID bits in EFLAGS
-	pushl %eax		# copy to EFLAGS
-	popfl			# set EFLAGS
-	pushfl			# get new EFLAGS
-	popl %eax		# put it in eax
-	xorl %ecx,%eax		# change in flags
-	pushl %ecx		# restore original EFLAGS
-	popfl
-	testl $0x40000,%eax	# check if AC bit changed
-	je is386
-
-	movb $4,X86		# at least 486
-	testl $0x200000,%eax	# check if ID bit changed
-	je is486
-
-	/* get vendor info */
-	xorl %eax,%eax			# call CPUID with 0 -> return vendor ID
-	cpuid
-	movl %eax,X86_CPUID		# save CPUID level
-	movl %ebx,X86_VENDOR_ID		# lo 4 chars
-	movl %edx,X86_VENDOR_ID+4	# next 4 chars
-	movl %ecx,X86_VENDOR_ID+8	# last 4 chars
-
-	orl %eax,%eax			# do we have processor info as well?
-	je is486
-
-	movl $1,%eax		# Use the CPUID instruction to get CPU type
-	cpuid
-	movb %al,%cl		# save reg for future use
-	andb $0x0f,%ah		# mask processor family
-	movb %ah,X86
-	andb $0xf0,%al		# mask model
-	shrb $4,%al
-	movb %al,X86_MODEL
-	andb $0x0f,%cl		# mask mask revision
-	movb %cl,X86_MASK
-	movl %edx,X86_CAPABILITY
-
-is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
-	jmp 2f
-
-is386:	movl $2,%ecx		# set MP
-2:	movl %cr0,%eax
-	andl $0x80000011,%eax	# Save PG,PE,ET
-	orl %ecx,%eax
-	movl %eax,%cr0
-
-	call check_x87
 	lgdt early_gdt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
@@ -288,25 +213,6 @@ is386:	movl $2,%ecx		# set MP
 #endif /* CONFIG_SMP */
 	jmp i386_start_kernel
 
-/*
- * We depend on ET to be correct. This checks for 287/387.
- */
-check_x87:
-	movb $0,X86_HARD_MATH
-	clts
-	fninit
-	fstsw %ax
-	cmpb $0,%al
-	je 1f
-	movl %cr0,%eax		/* no coprocessor: have to set bits */
-	xorl $4,%eax		/* set EM */
-	movl %eax,%cr0
-	ret
-	ALIGN
-1:	movb $1,X86_HARD_MATH
-	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
-	ret
-
 ENTRY(early_divide_err)
 	xor %edx,%edx
 	pushl $0	/* fake errcode */
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 3e31591..401e48a 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -76,8 +76,6 @@ int disable_pse __devinitdata = 0;
 extern struct resource code_resource;
 extern struct resource data_resource;
 
-/* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 EXPORT_SYMBOL(boot_cpu_data);
@@ -515,7 +513,6 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned long max_low_pfn;
 
-	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
 
-- 
1.5.1.1.181.g2de0

