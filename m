Return-Path: <linux-kernel-owner+w=401wt.eu-S1030879AbXAZQ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030879AbXAZQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030916AbXAZQ46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:56:58 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:31208 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030893AbXAZQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:56:37 -0500
Date: Fri, 26 Jan 2007 17:56:33 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] Convert memory detection into C code.
Message-ID: <20070126165633.GC11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Convert memory detection into C code.

Hopefully this will make it more maintainable and less error prone.
Code makes use of search_exception_tables(). Since it calls this
function before the kernel exeception table is sorted, there is an
early call to sort_main_extable().

This way it's easy to use the already present infrastructure of fixup
sections. Also this would allows to easily convert the rest of
head[31|64].S into C code.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/defconfig            |    1 
 arch/s390/kernel/Makefile      |    2 
 arch/s390/kernel/base.S        |  150 ++++++++++++++++++++
 arch/s390/kernel/early.c       |  307 +++++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/head31.S      |  164 ---------------------
 arch/s390/kernel/head64.S      |  175 -----------------------
 arch/s390/kernel/ipl.c         |   15 --
 arch/s390/kernel/reset.S       |   90 ------------
 arch/s390/kernel/setup.c       |  134 -----------------
 drivers/s390/Kconfig           |    8 -
 drivers/s390/char/Makefile     |    4 
 drivers/s390/char/sclp.c       |   12 -
 drivers/s390/char/sclp.h       |   18 --
 drivers/s390/char/sclp_cpi.c   |    2 
 drivers/s390/char/sclp_info.c  |   57 +++++++
 drivers/s390/char/sclp_rw.c    |    2 
 drivers/s390/char/sclp_vt220.c |    2 
 drivers/s390/cio/cio.c         |   10 -
 include/asm-s390/processor.h   |   12 +
 include/asm-s390/reset.h       |    3 
 include/asm-s390/sclp.h        |   39 +++++
 21 files changed, 598 insertions(+), 609 deletions(-)

diff -urpN linux-2.6/arch/s390/defconfig linux-2.6-patched/arch/s390/defconfig
--- linux-2.6/arch/s390/defconfig	2007-01-26 17:29:33.000000000 +0100
+++ linux-2.6-patched/arch/s390/defconfig	2007-01-26 17:29:38.000000000 +0100
@@ -433,7 +433,6 @@ CONFIG_TN3270_CONSOLE=y
 CONFIG_TN3215=y
 CONFIG_TN3215_CONSOLE=y
 CONFIG_CCW_CONSOLE=y
-CONFIG_SCLP=y
 CONFIG_SCLP_TTY=y
 CONFIG_SCLP_CONSOLE=y
 CONFIG_SCLP_VT220_TTY=y
diff -urpN linux-2.6/arch/s390/kernel/base.S linux-2.6-patched/arch/s390/kernel/base.S
--- linux-2.6/arch/s390/kernel/base.S	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/base.S	2007-01-26 17:29:38.000000000 +0100
@@ -0,0 +1,150 @@
+/*
+ *  arch/s390/kernel/base.S
+ *
+ *    Copyright IBM Corp. 2006,2007
+ *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
+ *		 Michael Holzheu <holzheu@de.ibm.com>
+ */
+
+#include <asm/ptrace.h>
+#include <asm/lowcore.h>
+
+#ifdef CONFIG_64BIT
+
+	.globl	s390_base_mcck_handler
+s390_base_mcck_handler:
+	basr	%r13,0
+0:	lg	%r15,__LC_PANIC_STACK	# load panic stack
+	aghi	%r15,-STACK_FRAME_OVERHEAD
+	larl	%r1,s390_base_mcck_handler_fn
+	lg	%r1,0(%r1)
+	ltgr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+1:	la	%r1,4095
+	lmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-4095(%r1)
+	lpswe	__LC_MCK_OLD_PSW
+
+	.section .bss
+	.globl	s390_base_mcck_handler_fn
+s390_base_mcck_handler_fn:
+	.quad	0
+	.previous
+
+	.globl	s390_base_ext_handler
+s390_base_ext_handler:
+	stmg	%r0,%r15,__LC_SAVE_AREA
+	basr	%r13,0
+0:	aghi	%r15,-STACK_FRAME_OVERHEAD
+	larl	%r1,s390_base_ext_handler_fn
+	lg	%r1,0(%r1)
+	ltgr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+1:	lmg	%r0,%r15,__LC_SAVE_AREA
+	ni	__LC_EXT_OLD_PSW+1,0xfd	# clear wait state bit
+	lpswe	__LC_EXT_OLD_PSW
+
+	.section .bss
+	.globl s390_base_ext_handler_fn
+s390_base_ext_handler_fn:
+	.quad	0
+	.previous
+
+	.globl	s390_base_pgm_handler
+s390_base_pgm_handler:
+	stmg	%r0,%r15,__LC_SAVE_AREA
+	basr	%r13,0
+0:	aghi	%r15,-STACK_FRAME_OVERHEAD
+	larl	%r1,s390_base_pgm_handler_fn
+	lg	%r1,0(%r1)
+	ltgr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+	lmg	%r0,%r15,__LC_SAVE_AREA
+	lpswe	__LC_PGM_OLD_PSW
+1:	lpswe	disabled_wait_psw-0b(%r13)
+
+	.align	8
+disabled_wait_psw:
+	.quad	0x0002000180000000,0x0000000000000000 + s390_base_pgm_handler
+
+	.section .bss
+	.globl s390_base_pgm_handler_fn
+s390_base_pgm_handler_fn:
+	.quad	0
+	.previous
+
+#else /* CONFIG_64BIT */
+
+	.globl	s390_base_mcck_handler
+s390_base_mcck_handler:
+	basr	%r13,0
+0:	l	%r15,__LC_PANIC_STACK	# load panic stack
+	ahi	%r15,-STACK_FRAME_OVERHEAD
+	l	%r1,2f-0b(%r13)
+	l	%r1,0(%r1)
+	ltr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+1:	lm	%r0,%r15,__LC_GPREGS_SAVE_AREA
+	lpsw	__LC_MCK_OLD_PSW
+
+2:	.long	s390_base_mcck_handler_fn
+
+	.section .bss
+	.globl	s390_base_mcck_handler_fn
+s390_base_mcck_handler_fn:
+	.long	0
+	.previous
+
+	.globl	s390_base_ext_handler
+s390_base_ext_handler:
+	stm	%r0,%r15,__LC_SAVE_AREA
+	basr	%r13,0
+0:	ahi	%r15,-STACK_FRAME_OVERHEAD
+	l	%r1,2f-0b(%r13)
+	l	%r1,0(%r1)
+	ltr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+1:	lm	%r0,%r15,__LC_SAVE_AREA
+	ni	__LC_EXT_OLD_PSW+1,0xfd	# clear wait state bit
+	lpsw	__LC_EXT_OLD_PSW
+
+2:	.long	s390_base_ext_handler_fn
+
+	.section .bss
+	.globl	s390_base_ext_handler_fn
+s390_base_ext_handler_fn:
+	.long	0
+	.previous
+
+	.globl	s390_base_pgm_handler
+s390_base_pgm_handler:
+	stm	%r0,%r15,__LC_SAVE_AREA
+	basr	%r13,0
+0:	ahi	%r15,-STACK_FRAME_OVERHEAD
+	l	%r1,2f-0b(%r13)
+	l	%r1,0(%r1)
+	ltr	%r1,%r1
+	jz	1f
+	basr	%r14,%r1
+	lm	%r0,%r15,__LC_SAVE_AREA
+	lpsw	__LC_PGM_OLD_PSW
+
+1:	lpsw	disabled_wait_psw-0b(%r13)
+
+2:	.long	s390_base_pgm_handler_fn
+
+disabled_wait_psw:
+	.align	8
+	.long	0x000a0000,0x00000000 + s390_base_pgm_handler
+
+	.section .bss
+	.globl	s390_base_pgm_handler_fn
+s390_base_pgm_handler_fn:
+	.long	0
+	.previous
+
+#endif /* CONFIG_64BIT */
diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-01-26 17:29:38.000000000 +0100
@@ -0,0 +1,307 @@
+/*
+ *  arch/s390/kernel/early.c
+ *
+ *    Copyright IBM Corp. 2007
+ *    Author(s): Hongjie Yang <hongjie@us.ibm.com>,
+ *		 Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/pfn.h>
+#include <linux/uaccess.h>
+#include <asm/lowcore.h>
+#include <asm/processor.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/cpcmd.h>
+#include <asm/sclp.h>
+
+/*
+ * Create a Kernel NSS if the SAVESYS= parameter is defined
+ */
+#define DEFSYS_CMD_SIZE		96
+#define SAVESYS_CMD_SIZE	32
+
+extern int _eshared;
+char kernel_nss_name[NSS_NAME_SIZE + 1];
+
+#ifdef CONFIG_SHARED_KERNEL
+static noinline __init void create_kernel_nss(void)
+{
+	unsigned int i, stext_pfn, eshared_pfn, end_pfn, min_size;
+#ifdef CONFIG_BLK_DEV_INITRD
+	unsigned int sinitrd_pfn, einitrd_pfn;
+#endif
+	int response;
+	char *savesys_ptr;
+	char upper_command_line[COMMAND_LINE_SIZE];
+	char defsys_cmd[DEFSYS_CMD_SIZE];
+	char savesys_cmd[SAVESYS_CMD_SIZE];
+
+	/* Do nothing if we are not running under VM */
+	if (!MACHINE_IS_VM)
+		return;
+
+	/* Convert COMMAND_LINE to upper case */
+	for (i = 0; i < strlen(COMMAND_LINE); i++)
+		upper_command_line[i] = toupper(COMMAND_LINE[i]);
+
+	savesys_ptr = strstr(upper_command_line, "SAVESYS=");
+
+	if (!savesys_ptr)
+		return;
+
+	savesys_ptr += 8;    /* Point to the beginning of the NSS name */
+	for (i = 0; i < NSS_NAME_SIZE; i++) {
+		if (savesys_ptr[i] == ' ' || savesys_ptr[i] == '\0')
+			break;
+		kernel_nss_name[i] = savesys_ptr[i];
+	}
+
+	stext_pfn = PFN_DOWN(__pa(&_stext));
+	eshared_pfn = PFN_DOWN(__pa(&_eshared));
+	end_pfn = PFN_UP(__pa(&_end));
+	min_size = end_pfn << 2;
+
+	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
+		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
+		eshared_pfn, end_pfn);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (INITRD_START && INITRD_SIZE) {
+		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
+		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
+		min_size = einitrd_pfn << 2;
+		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
+		sinitrd_pfn, einitrd_pfn);
+	}
+#endif
+
+	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK", defsys_cmd, min_size);
+	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
+		kernel_nss_name, kernel_nss_name);
+
+	__cpcmd(defsys_cmd, NULL, 0, &response);
+
+	if (response != 0)
+		return;
+
+	__cpcmd(savesys_cmd, NULL, 0, &response);
+
+	if (response != strlen(savesys_cmd))
+		return;
+
+	ipl_flags = IPL_NSS_VALID;
+}
+
+#else /* CONFIG_SHARED_KERNEL */
+
+static inline void create_kernel_nss(void) { }
+
+#endif /* CONFIG_SHARED_KERNEL */
+
+/*
+ * Clear bss memory
+ */
+static noinline __init void clear_bss_section(void)
+{
+	memset(__bss_start, 0, _end - __bss_start);
+}
+
+/*
+ * Initialize storage key for kernel pages
+ */
+static noinline __init void init_kernel_storage_key(void)
+{
+	unsigned long end_pfn, init_pfn;
+
+	end_pfn = PFN_UP(__pa(&_end));
+
+	for (init_pfn = 0 ; init_pfn < end_pfn; init_pfn++)
+		page_set_storage_key(init_pfn << PAGE_SHIFT, PAGE_DEFAULT_KEY);
+}
+
+static noinline __init void detect_machine_type(void)
+{
+	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
+
+	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
+
+	/* Running under z/VM ? */
+	if (cpuinfo->cpu_id.version == 0xff)
+		machine_flags |= 1;
+
+	/* Running on a P/390 ? */
+	if (cpuinfo->cpu_id.machine == 0x7490)
+		machine_flags |= 4;
+}
+
+static noinline __init int memory_fast_detect(void)
+{
+
+	unsigned long val0 = 0;
+	unsigned long val1 = 0xc;
+	int ret = -ENOSYS;
+
+	if (ipl_flags & IPL_NSS_VALID)
+		return -ENOSYS;
+
+	asm volatile(
+		"	diag	%1,%2,0x260\n"
+		"0:	lhi	%0,0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (ret), "+d" (val0), "+d" (val1) : : "cc");
+
+	if (ret || val0 != val1)
+		return -ENOSYS;
+
+	memory_chunk[0].size = val0;
+	return 0;
+}
+
+#define ADDR2G	(1UL << 31)
+
+static noinline __init unsigned long sclp_memory_detect(void)
+{
+	struct sclp_readinfo_sccb *sccb;
+	unsigned long long memsize;
+
+	sccb = &s390_readinfo_sccb;
+
+	if (sccb->header.response_code != 0x10)
+		return 0;
+
+	if (sccb->rnsize)
+		memsize = sccb->rnsize << 20;
+	else
+		memsize = sccb->rnsize2 << 20;
+	if (sccb->rnmax)
+		memsize *= sccb->rnmax;
+	else
+		memsize *= sccb->rnmax2;
+#ifndef CONFIG_64BIT
+	/*
+	 * Can't deal with more than 2G in 31 bit addressing mode, so
+	 * limit the value in order to avoid strange side effects.
+	 */
+	if (memsize > ADDR2G)
+		memsize = ADDR2G;
+#endif
+	return (unsigned long) memsize;
+}
+
+static inline __init unsigned long __tprot(unsigned long addr)
+{
+	int cc = -1;
+
+	asm volatile(
+		"	tprot	0(%1),0\n"
+		"0:	ipm	%0\n"
+		"	srl	%0,28\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (cc) : "a" (addr) : "cc");
+	return (unsigned long)cc;
+}
+
+/* Checking memory in 128KB increments. */
+#define CHUNK_INCR	(1UL << 17)
+
+static noinline __init void find_memory_chunks(unsigned long memsize)
+{
+	unsigned long addr = 0, old_addr = 0;
+	unsigned long old_cc = CHUNK_READ_WRITE;
+	unsigned long cc;
+	int chunk = 0;
+
+	while (chunk < MEMORY_CHUNKS) {
+		cc = __tprot(addr);
+		while (cc == old_cc) {
+			addr += CHUNK_INCR;
+			cc = __tprot(addr);
+#ifndef CONFIG_64BIT
+			if (addr == ADDR2G)
+				break;
+#endif
+		}
+
+		if (old_addr != addr &&
+		    (old_cc == CHUNK_READ_WRITE || old_cc == CHUNK_READ_ONLY)) {
+			memory_chunk[chunk].addr = old_addr;
+			memory_chunk[chunk].size = addr - old_addr;
+			memory_chunk[chunk].type = old_cc;
+			chunk++;
+		}
+
+		old_addr = addr;
+		old_cc = cc;
+
+#ifndef CONFIG_64BIT
+		if (addr == ADDR2G)
+			break;
+#endif
+		/*
+		 * Finish memory detection at the first hole, unless
+		 * - we reached the hsa -> skip it.
+		 * - we know there must be more.
+		 */
+		if (cc == -1UL && !memsize && old_addr != ADDR2G)
+			break;
+		if (memsize && addr >= memsize)
+			break;
+	}
+}
+
+static __init void early_pgm_check_handler(void)
+{
+	unsigned long addr;
+	const struct exception_table_entry *fixup;
+
+	addr = S390_lowcore.program_old_psw.addr;
+	fixup = search_exception_tables(addr & PSW_ADDR_INSN);
+	if (!fixup)
+		disabled_wait(0);
+	S390_lowcore.program_old_psw.addr = fixup->fixup | PSW_ADDR_AMODE;
+}
+
+static noinline __init void setup_lowcore_early(void)
+{
+	psw_t psw;
+
+	psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	psw.addr = PSW_ADDR_AMODE | (unsigned long) s390_base_ext_handler;
+	S390_lowcore.external_new_psw = psw;
+	psw.addr = PSW_ADDR_AMODE | (unsigned long) s390_base_pgm_handler;
+	S390_lowcore.program_new_psw = psw;
+	s390_base_pgm_handler_fn = early_pgm_check_handler;
+}
+
+/*
+ * Save ipl parameters, clear bss memory, initialize storage keys
+ * and create a kernel NSS at startup if the SAVESYS= parm is defined
+ */
+void __init startup_init(void)
+{
+	unsigned long memsize;
+
+	ipl_save_parameters();
+	clear_bss_section();
+	init_kernel_storage_key();
+	lockdep_init();
+	lockdep_off();
+	detect_machine_type();
+	create_kernel_nss();
+	sort_main_extable();
+	setup_lowcore_early();
+	sclp_readinfo_early();
+	memsize = sclp_memory_detect();
+	if (memory_fast_detect() < 0)
+		find_memory_chunks(memsize);
+	lockdep_on();
+}
diff -urpN linux-2.6/arch/s390/kernel/head31.S linux-2.6-patched/arch/s390/kernel/head31.S
--- linux-2.6/arch/s390/kernel/head31.S	2007-01-26 17:29:34.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head31.S	2007-01-26 17:29:38.000000000 +0100
@@ -58,145 +58,6 @@ startup_continue:
 	l	%r14,.Lstartup_init-.LPG1(%r13)
 	basr	%r14,%r14
 
-	l	%r2,.Lrcp-.LPG1(%r13)	# Read SCP forced command word
-.Lservicecall:
-	stosm	.Lpmask-.LPG1(%r13),0x01	# authorize ext interrupts
-
-	stctl	%r0, %r0,.Lcr-.LPG1(%r13)	# get cr0
-	la	%r1,0x200		# set bit 22
-	o	%r1,.Lcr-.LPG1(%r13)	# or old cr0 with r1
-	st	%r1,.Lcr-.LPG1(%r13)
-	lctl	%r0, %r0,.Lcr-.LPG1(%r13)	# load modified cr0
-
-	mvc	__LC_EXT_NEW_PSW(8),.Lpcext-.LPG1(%r13) # set postcall psw
-	la	%r1, .Lsclph-.LPG1(%r13)
-	a	%r1,__LC_EXT_NEW_PSW+4	# set handler
-	st	%r1,__LC_EXT_NEW_PSW+4
-
-	l	%r4,.Lsccbaddr-.LPG1(%r13) # %r4 is our index for sccb stuff
-	lr	%r1,%r4			# our sccb
-	.insn	rre,0xb2200000,%r2,%r1	# service call
-	ipm	%r1
-	srl	%r1,28			# get cc code
-	xr	%r3, %r3
-	chi	%r1,3
-	be	.Lfchunk-.LPG1(%r13)	# leave
-	chi	%r1,2
-	be	.Lservicecall-.LPG1(%r13)
-	lpsw	.Lwaitsclp-.LPG1(%r13)
-.Lsclph:
-	lh	%r1,.Lsccbr-.Lsccb(%r4)
-	chi	%r1,0x10		# 0x0010 is the sucess code
-	je	.Lprocsccb		# let's process the sccb
-	chi	%r1,0x1f0
-	bne	.Lfchunk-.LPG1(%r13)	# unhandled error code
-	c	%r2, .Lrcp-.LPG1(%r13)	# Did we try Read SCP forced
-	bne	.Lfchunk-.LPG1(%r13)	# if no, give up
-	l	%r2, .Lrcp2-.LPG1(%r13)	# try with Read SCP
-	b	.Lservicecall-.LPG1(%r13)
-.Lprocsccb:
-	lhi	%r1,0
-	icm	%r1,3,.Lscpincr1-.Lsccb(%r4) # use this one if != 0
-	jnz	.Lscnd
-	lhi	%r1,0x800		# otherwise report 2GB
-.Lscnd:
-	lhi	%r3,0x800		# limit reported memory size to 2GB
-	cr	%r1,%r3
-	jl	.Lno2gb
-	lr	%r1,%r3
-.Lno2gb:
-	xr	%r3,%r3			# same logic
-	ic	%r3,.Lscpa1-.Lsccb(%r4)
-	chi	%r3,0x00
-	jne	.Lcompmem
-	l	%r3,.Lscpa2-.Lsccb(%r4)
-.Lcompmem:
-	mr	%r2,%r1			# mem in MB on 128-bit
-	l	%r1,.Lonemb-.LPG1(%r13)
-	mr	%r2,%r1			# mem size in bytes in %r3
-	b	.Lfchunk-.LPG1(%r13)
-
-	.align 4
-.Linittu:
-	.long	init_thread_union
-.Lstartup_init:
-	.long	startup_init
-.Lpmask:
-	.byte	0
-	.align	8
-.Lpcext:.long	0x00080000,0x80000000
-.Lcr:
-	.long	0x00			# place holder for cr0
-	.align	8
-.Lwaitsclp:
-	.long 0x010a0000,0x80000000 + .Lsclph
-.Lrcp:
-	.int	0x00120001		# Read SCP forced code
-.Lrcp2:
-	.int	0x00020001		# Read SCP code
-.Lonemb:
-	.int	0x100000
-.Lfchunk:
-
-#
-# find memory chunks.
-#
-	lr	%r9,%r3			# end of mem
-	mvc	__LC_PGM_NEW_PSW(8),.Lpcmem-.LPG1(%r13)
-	la	%r1,1			# test in increments of 128KB
-	sll	%r1,17
-	l	%r3,.Lmchunk-.LPG1(%r13) # get pointer to memory_chunk array
-	slr	%r4,%r4			# set start of chunk to zero
-	slr	%r5,%r5			# set end of chunk to zero
-	slr	%r6,%r6			# set access code to zero
-	la	%r10,MEMORY_CHUNKS	# number of chunks
-.Lloop:
-	tprot	0(%r5),0		# test protection of first byte
-	ipm	%r7
-	srl	%r7,28
-	clr	%r6,%r7			# compare cc with last access code
-	be	.Lsame-.LPG1(%r13)
-	lhi	%r8,0			# no program checks
-	b	.Lsavchk-.LPG1(%r13)
-.Lsame:
-	ar	%r5,%r1			# add 128KB to end of chunk
-	bno	.Lloop-.LPG1(%r13)	# r1 < 0x80000000 -> loop
-.Lchkmem:				# > 2GB or tprot got a program check
-	lhi	%r8,1			# set program check flag
-.Lsavchk:
-	clr	%r4,%r5			# chunk size > 0?
-	be	.Lchkloop-.LPG1(%r13)
-	st	%r4,0(%r3)		# store start address of chunk
-	lr	%r0,%r5
-	slr	%r0,%r4
-	st	%r0,4(%r3)		# store size of chunk
-	st	%r6,8(%r3)		# store type of chunk
-	la	%r3,12(%r3)
-	ahi	%r10,-1			# update chunk number
-.Lchkloop:
-	lr	%r6,%r7			# set access code to last cc
-	# we got an exception or we're starting a new
-	# chunk , we must check if we should
-	# still try to find valid memory (if we detected
-	# the amount of available storage), and if we
-	# have chunks left
-	xr	%r0,%r0
-	clr	%r0,%r9			# did we detect memory?
-	je	.Ldonemem		# if not, leave
-	chi	%r10,0			# do we have chunks left?
-	je	.Ldonemem
-	chi	%r8,1			# program check ?
-	je	.Lpgmchk
-	lr	%r4,%r5			# potential new chunk
-	alr	%r5,%r1			# add 128KB to end of chunk
-	j	.Llpcnt
-.Lpgmchk:
-	alr	%r5,%r1			# add 128KB to end of chunk
-	lr	%r4,%r5			# potential new chunk
-.Llpcnt:
-	clr	%r5,%r9			# should we go on?
-	jl	.Lloop
-.Ldonemem:
 	l	%r12,.Lmflags-.LPG1(%r13) # get address of machine_flags
 #
 # find out if we have an IEEE fpu
@@ -273,7 +134,6 @@ startup_continue:
 	.long	0			# cr15: linkage stack operations
 .Lduct:	.long	0,0,0,0,0,0,0,0
 	.long	0,0,0,0,0,0,0,0
-.Lpcmem:.long	0x00080000,0x80000000 + .Lchkmem
 .Lpcfpu:.long	0x00080000,0x80000000 + .Lchkfpu
 .Lpccsp:.long	0x00080000,0x80000000 + .Lchkcsp
 .Lpcmvpg:.long	0x00080000,0x80000000 + .Lchkmvpg
@@ -284,7 +144,9 @@ startup_continue:
 .Lbss_bgn:  .long __bss_start
 .Lbss_end:  .long _end
 .Lparmaddr: .long PARMAREA
-.Lsccbaddr: .long .Lsccb
+.Linittu:   .long init_thread_union
+.Lstartup_init:
+	    .long startup_init
 
 	.globl ipl_schib
 ipl_schib:
@@ -300,26 +162,6 @@ ipl_devno:
 	.word 0
 
 	.org	0x12000
-.globl s390_readinfo_sccb
-s390_readinfo_sccb:
-.Lsccb:
-	.hword	0x1000			# length, one page
-	.byte	0x00,0x00,0x00
-	.byte	0x80			# variable response bit set
-.Lsccbr:
-	.hword	0x00			# response code
-.Lscpincr1:
-	.hword	0x00
-.Lscpa1:
-	.byte	0x00
-	.fill	89,1,0
-.Lscpa2:
-	.int	0x00
-.Lscpincr2:
-	.quad	0x00
-	.fill	3984,1,0
-	.org	0x13000
-
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
 #endif
diff -urpN linux-2.6/arch/s390/kernel/head64.S linux-2.6-patched/arch/s390/kernel/head64.S
--- linux-2.6/arch/s390/kernel/head64.S	2007-01-26 17:29:34.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head64.S	2007-01-26 17:29:38.000000000 +0100
@@ -65,162 +65,6 @@ startup_continue:
 	brasl	%r14,startup_init
 					# set program check new psw mask
 	mvc	__LC_PGM_NEW_PSW(8),.Lpcmsk-.LPG1(%r13)
-	larl	%r1,.Lslowmemdetect	# set program check address
-	stg	%r1,__LC_PGM_NEW_PSW+8
-	lghi	%r1,0xc
-	diag	%r0,%r1,0x260		# get memory size of virtual machine
-	cgr	%r0,%r1			# different? -> old detection routine
-	jne	.Lslowmemdetect
-	larl	%r3,ipl_flags
-	llgt	%r3,0(%r3)
-	chi	%r3,4			# ipled from an kernel NSS
-	je	.Lslowmemdetect
-	aghi	%r1,1			# size is one more than end
-	larl	%r2,memory_chunk
-	stg	%r1,8(%r2)		# store size of chunk
-
-.Lslowmemdetect:
-	l	%r2,.Lrcp-.LPG1(%r13)	# Read SCP forced command word
-.Lservicecall:
-	stosm	.Lpmask-.LPG1(%r13),0x01	# authorize ext interrupts
-
-	stctg	%r0,%r0,.Lcr-.LPG1(%r13)	# get cr0
-	la	%r1,0x200		# set bit 22
-	og	%r1,.Lcr-.LPG1(%r13)	# or old cr0 with r1
-	stg	%r1,.Lcr-.LPG1(%r13)
-	lctlg	%r0,%r0,.Lcr-.LPG1(%r13)	# load modified cr0
-
-	mvc	__LC_EXT_NEW_PSW(8),.Lpcmsk-.LPG1(%r13) # set postcall psw
-	larl	%r1,.Lsclph
-	stg	%r1,__LC_EXT_NEW_PSW+8	# set handler
-
-	larl	%r4,.Lsccb		# %r4 is our index for sccb stuff
-	lgr	%r1,%r4			# our sccb
-	.insn	rre,0xb2200000,%r2,%r1	# service call
-	ipm	%r1
-	srl	%r1,28			# get cc code
-	xr	%r3,%r3
-	chi	%r1,3
-	be	.Lfchunk-.LPG1(%r13)	# leave
-	chi	%r1,2
-	be	.Lservicecall-.LPG1(%r13)
-	lpswe	.Lwaitsclp-.LPG1(%r13)
-.Lsclph:
-	lh	%r1,.Lsccbr-.Lsccb(%r4)
-	chi	%r1,0x10		# 0x0010 is the sucess code
-	je	.Lprocsccb		# let's process the sccb
-	chi	%r1,0x1f0
-	bne	.Lfchunk-.LPG1(%r13)	# unhandled error code
-	c	%r2,.Lrcp-.LPG1(%r13)	# Did we try Read SCP forced
-	bne	.Lfchunk-.LPG1(%r13)	# if no, give up
-	l	%r2,.Lrcp2-.LPG1(%r13)	# try with Read SCP
-	b	.Lservicecall-.LPG1(%r13)
-.Lprocsccb:
-	lghi	%r1,0
-	icm	%r1,3,.Lscpincr1-.Lsccb(%r4)	# use this one if != 0
-	jnz	.Lscnd
-	lg	%r1,.Lscpincr2-.Lsccb(%r4)	# otherwise use this one
-.Lscnd:
-	xr	%r3,%r3			# same logic
-	ic	%r3,.Lscpa1-.Lsccb(%r4)
-	chi	%r3,0x00
-	jne	.Lcompmem
-	l	%r3,.Lscpa2-.Lsccb(%r4)
-.Lcompmem:
-	mlgr	%r2,%r1			# mem in MB on 128-bit
-	l	%r1,.Lonemb-.LPG1(%r13)
-	mlgr	%r2,%r1			# mem size in bytes in %r3
-	b	.Lfchunk-.LPG1(%r13)
-
-	.align	4
-.Lpmask:
-	.byte	0
-	.align	8
-.Lcr:
-	.quad	0x00  # place holder for cr0
-.Lwaitsclp:
-	.quad	0x0102000180000000,.Lsclph
-.Lrcp:
-	.int	0x00120001 # Read SCP forced code
-.Lrcp2:
-	.int	0x00020001 # Read SCP code
-.Lonemb:
-	.int	0x100000
-
-.Lfchunk:
-
-#
-# find memory chunks.
-#
-	larl	%r9,memory_chunk	# skip tprot loop if diag260
-	lg	%r9,8(%r9)		# memory detection was successful
-	ltgr	%r9,%r9
-	jne	.Ldonemem
-
-	lgr	%r9,%r3			# end of mem
-	larl	%r1,.Lchkmem		# set program check address
-	stg	%r1,__LC_PGM_NEW_PSW+8
-	la	%r1,1			# test in increments of 128KB
-	sllg	%r1,%r1,17
-	larl	%r3,memory_chunk
-	slgr	%r4,%r4 		# set start of chunk to zero
-	slgr	%r5,%r5 		# set end of chunk to zero
-	slr	%r6,%r6			# set access code to zero
-	la	%r10,MEMORY_CHUNKS	# number of chunks
-.Lloop:
-	tprot	0(%r5),0		# test protection of first byte
-	ipm	%r7
-	srl	%r7,28
-	clr	%r6,%r7			# compare cc with last access code
-	je	.Lsame
-	lghi	%r8,0			# no program checks
-	j	.Lsavchk
-.Lsame:
-	algr	%r5,%r1			# add 128KB to end of chunk
-					# no need to check here,
-	brc	12,.Lloop		# this is the same chunk
-.Lchkmem:				# > 16EB or tprot got a program check
-	lghi	%r8,1			# set program check flag
-.Lsavchk:
-	clgr	%r4,%r5			# chunk size > 0?
-	je	.Lchkloop
-	stg	%r4,0(%r3)		# store start address of chunk
-	lgr	%r0,%r5
-	slgr	%r0,%r4
-	stg	%r0,8(%r3)		# store size of chunk
-	st	%r6,20(%r3)		# store type of chunk
-	la	%r3,24(%r3)
-	ahi	%r10,-1			# update chunk number
-.Lchkloop:
-	lr	%r6,%r7			# set access code to last cc
-	# we got an exception or we're starting a new
-	# chunk , we must check if we should
-	# still try to find valid memory (if we detected
-	# the amount of available storage), and if we
-	# have chunks left
-	lghi	%r4,1
-	sllg	%r4,%r4,31
-	clgr	%r5,%r4
-	je	.Lhsaskip
-	xr	%r0, %r0
-	clgr	%r0, %r9		# did we detect memory?
-	je	.Ldonemem		# if not, leave
-	chi	%r10, 0			# do we have chunks left?
-	je	.Ldonemem
-.Lhsaskip:
-	chi	%r8,1			# program check ?
-	je	.Lpgmchk
-	lgr	%r4,%r5			# potential new chunk
-	algr	%r5,%r1			# add 128KB to end of chunk
-	j	.Llpcnt
-.Lpgmchk:
-	algr	%r5,%r1			# add 128KB to end of chunk
-	lgr	%r4,%r5			# potential new chunk
-.Llpcnt:
-	clgr	%r5,%r9			# should we go on?
-	jl	.Lloop
-.Ldonemem:
-
 	larl	%r12,machine_flags
 #
 # find out if we have the MVPG instruction
@@ -324,25 +168,6 @@ ipl_devno:
 	.word 0
 
 	.org	0x12000
-.globl s390_readinfo_sccb
-s390_readinfo_sccb:
-.Lsccb:
-	.hword	0x1000			# length, one page
-	.byte	0x00,0x00,0x00
-	.byte	0x80			# variable response bit set
-.Lsccbr:
-	.hword	0x00			# response code
-.Lscpincr1:
-	.hword	0x00
-.Lscpa1:
-	.byte	0x00
-	.fill	89,1,0
-.Lscpa2:
-	.int	0x00
-.Lscpincr2:
-	.quad	0x00
-	.fill	3984,1,0
-	.org	0x13000
 
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-01-26 17:29:34.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-01-26 17:29:38.000000000 +0100
@@ -20,14 +20,13 @@
 #include <asm/cio.h>
 #include <asm/ebcdic.h>
 #include <asm/reset.h>
+#include <asm/sclp.h>
 
 #define IPL_PARM_BLOCK_VERSION 0
-#define LOADPARM_LEN 8
 
-extern char s390_readinfo_sccb[];
-#define SCCB_VALID (*((__u16*)&s390_readinfo_sccb[6]) == 0x0010)
-#define SCCB_LOADPARM (&s390_readinfo_sccb[24])
-#define SCCB_FLAG (s390_readinfo_sccb[91])
+#define SCCB_VALID (s390_readinfo_sccb.header.response_code == 0x10)
+#define SCCB_LOADPARM (&s390_readinfo_sccb.loadparm)
+#define SCCB_FLAG (s390_readinfo_sccb.flags)
 
 enum ipl_type {
 	IPL_TYPE_NONE	 = 1,
@@ -1080,8 +1079,6 @@ static void do_reset_calls(void)
 		reset->fn();
 }
 
-extern void reset_mcck_handler(void);
-extern void reset_pgm_handler(void);
 extern __u32 dump_prefix_page;
 
 void s390_reset_system(void)
@@ -1105,12 +1102,12 @@ void s390_reset_system(void)
 	/* Set new machine check handler */
 	S390_lowcore.mcck_new_psw.mask = psw_kernel_bits & ~PSW_MASK_MCHECK;
 	S390_lowcore.mcck_new_psw.addr =
-		PSW_ADDR_AMODE | (unsigned long) &reset_mcck_handler;
+		PSW_ADDR_AMODE | (unsigned long) s390_base_mcck_handler;
 
 	/* Set new program check handler */
 	S390_lowcore.program_new_psw.mask = psw_kernel_bits & ~PSW_MASK_MCHECK;
 	S390_lowcore.program_new_psw.addr =
-		PSW_ADDR_AMODE | (unsigned long) &reset_pgm_handler;
+		PSW_ADDR_AMODE | (unsigned long) s390_base_pgm_handler;
 
 	do_reset_calls();
 }
diff -urpN linux-2.6/arch/s390/kernel/Makefile linux-2.6-patched/arch/s390/kernel/Makefile
--- linux-2.6/arch/s390/kernel/Makefile	2007-01-26 17:27:46.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/Makefile	2007-01-26 17:29:38.000000000 +0100
@@ -4,7 +4,7 @@
 
 EXTRA_AFLAGS	:= -traditional
 
-obj-y	:=  bitmap.o traps.o time.o process.o reset.o \
+obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o \
             setup.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    semaphore.o s390_ext.o debug.o irq.o ipl.o
 
diff -urpN linux-2.6/arch/s390/kernel/reset.S linux-2.6-patched/arch/s390/kernel/reset.S
--- linux-2.6/arch/s390/kernel/reset.S	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/reset.S	1970-01-01 01:00:00.000000000 +0100
@@ -1,90 +0,0 @@
-/*
- *  arch/s390/kernel/reset.S
- *
- *    Copyright (C) IBM Corp. 2006
- *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
- *		 Michael Holzheu <holzheu@de.ibm.com>
- */
-
-#include <asm/ptrace.h>
-#include <asm/lowcore.h>
-
-#ifdef CONFIG_64BIT
-
-	.globl	reset_mcck_handler
-reset_mcck_handler:
-	basr	%r13,0
-0:	lg	%r15,__LC_PANIC_STACK	# load panic stack
-	aghi	%r15,-STACK_FRAME_OVERHEAD
-	lg	%r1,s390_reset_mcck_handler-0b(%r13)
-	ltgr	%r1,%r1
-	jz	1f
-	basr	%r14,%r1
-1:	la	%r1,4095
-	lmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-4095(%r1)
-	lpswe	__LC_MCK_OLD_PSW
-
-	.globl	s390_reset_mcck_handler
-s390_reset_mcck_handler:
-	.quad	0
-
-	.globl	reset_pgm_handler
-reset_pgm_handler:
-	stmg	%r0,%r15,__LC_SAVE_AREA
-	basr	%r13,0
-0:	lg	%r15,__LC_PANIC_STACK	# load panic stack
-	aghi	%r15,-STACK_FRAME_OVERHEAD
-	lg	%r1,s390_reset_pgm_handler-0b(%r13)
-	ltgr	%r1,%r1
-	jz	1f
-	basr	%r14,%r1
-	lmg	%r0,%r15,__LC_SAVE_AREA
-	lpswe	__LC_PGM_OLD_PSW
-1:	lpswe	disabled_wait_psw-0b(%r13)
-	.globl s390_reset_pgm_handler
-s390_reset_pgm_handler:
-	.quad	0
-	.align	8
-disabled_wait_psw:
-	.quad	0x0002000180000000,0x0000000000000000 + reset_pgm_handler
-
-#else /* CONFIG_64BIT */
-
-	.globl	reset_mcck_handler
-reset_mcck_handler:
-	basr	%r13,0
-0:	l	%r15,__LC_PANIC_STACK	# load panic stack
-	ahi	%r15,-STACK_FRAME_OVERHEAD
-	l	%r1,s390_reset_mcck_handler-0b(%r13)
-	ltr	%r1,%r1
-	jz	1f
-	basr	%r14,%r1
-1:	lm	%r0,%r15,__LC_GPREGS_SAVE_AREA
-	lpsw	__LC_MCK_OLD_PSW
-
-	.globl	s390_reset_mcck_handler
-s390_reset_mcck_handler:
-	.long	0
-
-	.globl	reset_pgm_handler
-reset_pgm_handler:
-	stm	%r0,%r15,__LC_SAVE_AREA
-	basr	%r13,0
-0:	l	%r15,__LC_PANIC_STACK	# load panic stack
-	ahi	%r15,-STACK_FRAME_OVERHEAD
-	l	%r1,s390_reset_pgm_handler-0b(%r13)
-	ltr	%r1,%r1
-	jz	1f
-	basr	%r14,%r1
-	lm	%r0,%r15,__LC_SAVE_AREA
-	lpsw	__LC_PGM_OLD_PSW
-
-1:	lpsw	disabled_wait_psw-0b(%r13)
-	.globl	s390_reset_pgm_handler
-s390_reset_pgm_handler:
-	.long	0
-disabled_wait_psw:
-	.align 8
-	.long	0x000a0000,0x00000000 + reset_pgm_handler
-
-#endif /* CONFIG_64BIT */
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-01-26 17:29:34.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-01-26 17:29:38.000000000 +0100
@@ -284,140 +284,6 @@ static void __init conmode_default(void)
 	}
 }
 
-/*
- * Create a Kernel NSS if the SAVESYS= parameter is defined
-*/
-#define DEFSYS_CMD_SIZE	96
-#define SAVESYS_CMD_SIZE	32
-
-extern int _eshared;
-char kernel_nss_name[NSS_NAME_SIZE + 1];
-
-#ifdef CONFIG_SHARED_KERNEL
-static __init void create_kernel_nss(void)
-{
-	unsigned int i, stext_pfn, eshared_pfn, end_pfn, min_size;
-#ifdef CONFIG_BLK_DEV_INITRD
-	unsigned int sinitrd_pfn, einitrd_pfn;
-#endif
-	int response;
-	char *savesys_ptr;
-	char upper_command_line[COMMAND_LINE_SIZE];
-	char defsys_cmd[DEFSYS_CMD_SIZE];
-	char savesys_cmd[SAVESYS_CMD_SIZE];
-
-	/* Do nothing if we are not running under VM */
-	if (!MACHINE_IS_VM)
-		return;
-
-	/* Convert COMMAND_LINE to upper case */
-	for (i = 0; i < strlen(COMMAND_LINE); i++)
-		upper_command_line[i] = toupper(COMMAND_LINE[i]);
-
-	savesys_ptr = strstr(upper_command_line, "SAVESYS=");
-
-	if (!savesys_ptr)
-		return;
-
-	savesys_ptr += 8;    /* Point to the beginning of the NSS name */
-	for (i = 0; i < NSS_NAME_SIZE; i++) {
-		if (savesys_ptr[i] == ' ' || savesys_ptr[i] == '\0')
-			break;
-		kernel_nss_name[i] = savesys_ptr[i];
-	}
-
-	stext_pfn = PFN_DOWN(__pa(&_stext));
-	eshared_pfn = PFN_DOWN(__pa(&_eshared));
-	end_pfn = PFN_UP(__pa(&_end));
-	min_size = end_pfn << 2;
-
-	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
-		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
-		eshared_pfn, end_pfn);
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (INITRD_START && INITRD_SIZE) {
-		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
-		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
-		min_size = einitrd_pfn << 2;
-		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
-		sinitrd_pfn, einitrd_pfn);
-	}
-#endif
-
-	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK", defsys_cmd, min_size);
-	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
-		kernel_nss_name, kernel_nss_name);
-
-	__cpcmd(defsys_cmd, NULL, 0, &response);
-
-	if (response != 0)
-		return;
-
-	__cpcmd(savesys_cmd, NULL, 0, &response);
-
-	if (response != strlen(savesys_cmd))
-		return;
-
-	ipl_flags = IPL_NSS_VALID;
-}
-
-#else /* CONFIG_SHARED_KERNEL */
-
-static inline void create_kernel_nss(void) { }
-
-#endif /* CONFIG_SHARED_KERNEL */
-
-/*
- * Clear bss memory
- */
-static __init void clear_bss_section(void)
-{
-	memset(__bss_start, 0, _end - __bss_start);
-}
-
-/*
- * Initialize storage key for kernel pages
- */
-static __init void init_kernel_storage_key(void)
-{
-	unsigned long end_pfn, init_pfn;
-
-	end_pfn = PFN_UP(__pa(&_end));
-
-	for (init_pfn = 0 ; init_pfn < end_pfn; init_pfn++)
-		page_set_storage_key(init_pfn << PAGE_SHIFT, PAGE_DEFAULT_KEY);
-}
-
-static __init void detect_machine_type(void)
-{
-	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
-
-	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
-
-	/* Running under z/VM ? */
-	if (cpuinfo->cpu_id.version == 0xff)
-		machine_flags |= 1;
-
-	/* Running on a P/390 ? */
-	if (cpuinfo->cpu_id.machine == 0x7490)
-		machine_flags |= 4;
-}
-
-/*
- * Save ipl parameters, clear bss memory, initialize storage keys
- * and create a kernel NSS at startup if the SAVESYS= parm is defined
- */
-void __init startup_init(void)
-{
-	ipl_save_parameters();
-	clear_bss_section();
-	init_kernel_storage_key();
-	lockdep_init();
-	detect_machine_type();
-	create_kernel_nss();
-}
-
 #ifdef CONFIG_SMP
 void (*_machine_restart)(char *command) = machine_restart_smp;
 void (*_machine_halt)(void) = machine_halt_smp;
diff -urpN linux-2.6/drivers/s390/char/Makefile linux-2.6-patched/drivers/s390/char/Makefile
--- linux-2.6/drivers/s390/char/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/Makefile	2007-01-26 17:29:38.000000000 +0100
@@ -2,7 +2,8 @@
 # S/390 character devices
 #
 
-obj-y += ctrlchar.o keyboard.o defkeymap.o
+obj-y += ctrlchar.o keyboard.o defkeymap.o sclp.o sclp_rw.o sclp_quiesce.o \
+	 sclp_info.o
 
 obj-$(CONFIG_TN3270) += raw3270.o
 obj-$(CONFIG_TN3270_CONSOLE) += con3270.o
@@ -11,7 +12,6 @@ obj-$(CONFIG_TN3270_FS) += fs3270.o
 
 obj-$(CONFIG_TN3215) += con3215.o
 
-obj-$(CONFIG_SCLP) += sclp.o sclp_rw.o sclp_quiesce.o
 obj-$(CONFIG_SCLP_TTY) += sclp_tty.o
 obj-$(CONFIG_SCLP_CONSOLE) += sclp_con.o
 obj-$(CONFIG_SCLP_VT220_TTY) += sclp_vt220.o
diff -urpN linux-2.6/drivers/s390/char/sclp.c linux-2.6-patched/drivers/s390/char/sclp.c
--- linux-2.6/drivers/s390/char/sclp.c	2007-01-26 17:28:02.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp.c	2007-01-26 17:29:38.000000000 +0100
@@ -96,8 +96,8 @@ static int sclp_init_mask(int calculate)
 static int sclp_init(void);
 
 /* Perform service call. Return 0 on success, non-zero otherwise. */
-static int
-service_call(sclp_cmdw_t command, void *sccb)
+int
+sclp_service_call(sclp_cmdw_t command, void *sccb)
 {
 	int cc;
 
@@ -173,7 +173,7 @@ __sclp_start_request(struct sclp_req *re
 	if (sclp_running_state != sclp_running_state_idle)
 		return 0;
 	del_timer(&sclp_request_timer);
-	rc = service_call(req->command, req->sccb);
+	rc = sclp_service_call(req->command, req->sccb);
 	req->start_count++;
 
 	if (rc == 0) {
@@ -325,7 +325,7 @@ __sclp_make_read_req(void)
 	sccb = (struct sccb_header *) sclp_read_sccb;
 	clear_page(sccb);
 	memset(&sclp_read_req, 0, sizeof(struct sclp_req));
-	sclp_read_req.command = SCLP_CMDW_READDATA;
+	sclp_read_req.command = SCLP_CMDW_READ_EVENT_DATA;
 	sclp_read_req.status = SCLP_REQ_QUEUED;
 	sclp_read_req.start_count = 0;
 	sclp_read_req.callback = sclp_read_cb;
@@ -628,7 +628,7 @@ __sclp_make_init_req(u32 receive_mask, u
 	sccb = (struct init_sccb *) sclp_init_sccb;
 	clear_page(sccb);
 	memset(&sclp_init_req, 0, sizeof(struct sclp_req));
-	sclp_init_req.command = SCLP_CMDW_WRITEMASK;
+	sclp_init_req.command = SCLP_CMDW_WRITE_EVENT_MASK;
 	sclp_init_req.status = SCLP_REQ_FILLED;
 	sclp_init_req.start_count = 0;
 	sclp_init_req.callback = NULL;
@@ -831,7 +831,7 @@ sclp_check_interface(void)
 	for (retry = 0; retry <= SCLP_INIT_RETRY; retry++) {
 		__sclp_make_init_req(0, 0);
 		sccb = (struct init_sccb *) sclp_init_req.sccb;
-		rc = service_call(sclp_init_req.command, sccb);
+		rc = sclp_service_call(sclp_init_req.command, sccb);
 		if (rc == -EIO)
 			break;
 		sclp_init_req.status = SCLP_REQ_RUNNING;
diff -urpN linux-2.6/drivers/s390/char/sclp_cpi.c linux-2.6-patched/drivers/s390/char/sclp_cpi.c
--- linux-2.6/drivers/s390/char/sclp_cpi.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_cpi.c	2007-01-26 17:29:38.000000000 +0100
@@ -169,7 +169,7 @@ cpi_prepare_req(void)
 	}
 
 	/* prepare request data structure presented to SCLP driver */
-	req->command = SCLP_CMDW_WRITEDATA;
+	req->command = SCLP_CMDW_WRITE_EVENT_DATA;
 	req->sccb = sccb;
 	req->status = SCLP_REQ_FILLED;
 	req->callback = cpi_callback;
diff -urpN linux-2.6/drivers/s390/char/sclp.h linux-2.6-patched/drivers/s390/char/sclp.h
--- linux-2.6/drivers/s390/char/sclp.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp.h	2007-01-26 17:29:38.000000000 +0100
@@ -12,7 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
-
+#include <asm/sclp.h>
 #include <asm/ebcdic.h>
 
 /* maximum number of pages concerning our own memory management */
@@ -49,9 +49,11 @@
 
 typedef unsigned int sclp_cmdw_t;
 
-#define SCLP_CMDW_READDATA	0x00770005
-#define SCLP_CMDW_WRITEDATA	0x00760005
-#define SCLP_CMDW_WRITEMASK	0x00780005
+#define SCLP_CMDW_READ_EVENT_DATA	0x00770005
+#define SCLP_CMDW_WRITE_EVENT_DATA	0x00760005
+#define SCLP_CMDW_WRITE_EVENT_MASK	0x00780005
+#define SCLP_CMDW_READ_SCP_INFO		0x00020001
+#define SCLP_CMDW_READ_SCP_INFO_FORCED	0x00120001
 
 #define GDS_ID_MDSMU		0x1310
 #define GDS_ID_MDSRouteInfo	0x1311
@@ -66,13 +68,6 @@ typedef unsigned int sclp_cmdw_t;
 
 typedef u32 sccb_mask_t;	/* ATTENTION: assumes 32bit mask !!! */
 
-struct sccb_header {
-	u16	length;
-	u8	function_code;
-	u8	control_mask[3];
-	u16	response_code;
-} __attribute__((packed));
-
 struct gds_subvector {
 	u8	length;
 	u8	key;
@@ -131,6 +126,7 @@ void sclp_unregister(struct sclp_registe
 int sclp_remove_processed(struct sccb_header *sccb);
 int sclp_deactivate(void);
 int sclp_reactivate(void);
+int sclp_service_call(sclp_cmdw_t command, void *sccb);
 
 /* useful inlines */
 
diff -urpN linux-2.6/drivers/s390/char/sclp_info.c linux-2.6-patched/drivers/s390/char/sclp_info.c
--- linux-2.6/drivers/s390/char/sclp_info.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_info.c	2007-01-26 17:29:38.000000000 +0100
@@ -0,0 +1,57 @@
+/*
+ *  drivers/s390/char/sclp_info.c
+ *
+ *    Copyright IBM Corp. 2007
+ *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <asm/sclp.h>
+#include "sclp.h"
+
+struct sclp_readinfo_sccb s390_readinfo_sccb;
+
+void __init sclp_readinfo_early(void)
+{
+	sclp_cmdw_t command;
+	struct sccb_header *sccb;
+	int ret;
+
+	__ctl_set_bit(0, 9); /* enable service signal subclass mask */
+
+	sccb = &s390_readinfo_sccb.header;
+	command = SCLP_CMDW_READ_SCP_INFO_FORCED;
+	while (1) {
+		u16 response;
+
+		memset(&s390_readinfo_sccb, 0, sizeof(s390_readinfo_sccb));
+		sccb->length = sizeof(s390_readinfo_sccb);
+		sccb->control_mask[2] = 0x80;
+
+		ret = sclp_service_call(command, &s390_readinfo_sccb);
+
+		if (ret == -EIO)
+			goto out;
+		if (ret == -EBUSY)
+			continue;
+
+		__load_psw_mask(PSW_BASE_BITS | PSW_MASK_EXT |
+				PSW_MASK_WAIT | PSW_DEFAULT_KEY);
+		local_irq_disable();
+		barrier();
+
+		response = sccb->response_code;
+
+		if (response == 0x10)
+			break;
+
+		if (response != 0x1f0 || command == SCLP_CMDW_READ_SCP_INFO)
+			break;
+
+		command = SCLP_CMDW_READ_SCP_INFO;
+	}
+out:
+	__ctl_clear_bit(0, 9); /* disable service signal subclass mask */
+}
diff -urpN linux-2.6/drivers/s390/char/sclp_rw.c linux-2.6-patched/drivers/s390/char/sclp_rw.c
--- linux-2.6/drivers/s390/char/sclp_rw.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_rw.c	2007-01-26 17:29:38.000000000 +0100
@@ -460,7 +460,7 @@ sclp_emit_buffer(struct sclp_buffer *buf
 		sccb->msg_buf.header.type = EvTyp_PMsgCmd;
 	else
 		return -ENOSYS;
-	buffer->request.command = SCLP_CMDW_WRITEDATA;
+	buffer->request.command = SCLP_CMDW_WRITE_EVENT_DATA;
 	buffer->request.status = SCLP_REQ_FILLED;
 	buffer->request.callback = sclp_writedata_callback;
 	buffer->request.callback_data = buffer;
diff -urpN linux-2.6/drivers/s390/char/sclp_vt220.c linux-2.6-patched/drivers/s390/char/sclp_vt220.c
--- linux-2.6/drivers/s390/char/sclp_vt220.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_vt220.c	2007-01-26 17:29:38.000000000 +0100
@@ -207,7 +207,7 @@ __sclp_vt220_emit(struct sclp_vt220_requ
 		request->sclp_req.status = SCLP_REQ_FAILED;
 		return -EIO;
 	}
-	request->sclp_req.command = SCLP_CMDW_WRITEDATA;
+	request->sclp_req.command = SCLP_CMDW_WRITE_EVENT_DATA;
 	request->sclp_req.status = SCLP_REQ_FILLED;
 	request->sclp_req.callback = sclp_vt220_callback;
 	request->sclp_req.callback_data = (void *) request;
diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-01-26 17:29:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-01-26 17:29:38.000000000 +0100
@@ -895,11 +895,11 @@ static int stsch_reset(struct subchannel
 	int rc;
 
 	pgm_check_occured = 0;
-	s390_reset_pgm_handler = cio_reset_pgm_check_handler;
+	s390_base_pgm_handler_fn = cio_reset_pgm_check_handler;
 	rc = stsch(schid, addr);
-	s390_reset_pgm_handler = NULL;
+	s390_base_pgm_handler_fn = NULL;
 
-	/* The program check handler could have changed pgm_check_occured */
+	/* The program check handler could have changed pgm_check_occured. */
 	barrier();
 
 	if (pgm_check_occured)
@@ -957,7 +957,7 @@ static void css_reset(void)
 	/* Reset subchannels. */
 	for_each_subchannel(__shutdown_subchannel_easy,  NULL);
 	/* Reset channel paths. */
-	s390_reset_mcck_handler = s390_reset_chpids_mcck_handler;
+	s390_base_mcck_handler_fn = s390_reset_chpids_mcck_handler;
 	/* Enable channel report machine checks. */
 	__ctl_set_bit(14, 28);
 	/* Temporarily reenable machine checks. */
@@ -982,7 +982,7 @@ static void css_reset(void)
 	local_mcck_disable();
 	/* Disable channel report machine checks. */
 	__ctl_clear_bit(14, 28);
-	s390_reset_mcck_handler = NULL;
+	s390_base_mcck_handler_fn = NULL;
 }
 
 static struct reset_call css_reset_call = {
diff -urpN linux-2.6/drivers/s390/Kconfig linux-2.6-patched/drivers/s390/Kconfig
--- linux-2.6/drivers/s390/Kconfig	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/Kconfig	2007-01-26 17:29:38.000000000 +0100
@@ -103,14 +103,8 @@ config CCW_CONSOLE
  	depends on TN3215_CONSOLE || TN3270_CONSOLE
  	default y
  
-config SCLP
-	bool "Support for SCLP"
-	help
-	  Include support for the SCLP interface to the service element.
-
 config SCLP_TTY
 	bool "Support for SCLP line mode terminal"
-	depends on SCLP
 	help
 	  Include support for IBM SCLP line-mode terminals.
 
@@ -123,7 +117,6 @@ config SCLP_CONSOLE
 
 config SCLP_VT220_TTY
 	bool "Support for SCLP VT220-compatible terminal"
-	depends on SCLP
 	help
 	  Include support for an IBM SCLP VT220-compatible terminal.
 
@@ -136,7 +129,6 @@ config SCLP_VT220_CONSOLE
 
 config SCLP_CPI
 	tristate "Control-Program Identification"
-	depends on SCLP
 	help
 	  This option enables the hardware console interface for system
 	  identification. This is commonly used for workload management and
diff -urpN linux-2.6/include/asm-s390/processor.h linux-2.6-patched/include/asm-s390/processor.h
--- linux-2.6/include/asm-s390/processor.h	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/processor.h	2007-01-26 17:29:38.000000000 +0100
@@ -327,6 +327,18 @@ static inline void disabled_wait(unsigne
 }
 
 /*
+ * Basic Machine Check/Program Check Handler.
+ */
+
+extern void s390_base_mcck_handler(void);
+extern void s390_base_pgm_handler(void);
+extern void s390_base_ext_handler(void);
+
+extern void (*s390_base_mcck_handler_fn)(void);
+extern void (*s390_base_pgm_handler_fn)(void);
+extern void (*s390_base_ext_handler_fn)(void);
+
+/*
  * CPU idle notifier chain.
  */
 #define CPU_IDLE	0
diff -urpN linux-2.6/include/asm-s390/reset.h linux-2.6-patched/include/asm-s390/reset.h
--- linux-2.6/include/asm-s390/reset.h	2007-01-26 17:27:36.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/reset.h	2007-01-26 17:29:38.000000000 +0100
@@ -18,7 +18,4 @@ struct reset_call {
 extern void register_reset_call(struct reset_call *reset);
 extern void unregister_reset_call(struct reset_call *reset);
 extern void s390_reset_system(void);
-extern void (*s390_reset_mcck_handler)(void);
-extern void (*s390_reset_pgm_handler)(void);
-
 #endif /* _ASM_S390_RESET_H */
diff -urpN linux-2.6/include/asm-s390/sclp.h linux-2.6-patched/include/asm-s390/sclp.h
--- linux-2.6/include/asm-s390/sclp.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/sclp.h	2007-01-26 17:29:38.000000000 +0100
@@ -0,0 +1,39 @@
+/*
+ *  include/asm-s390/sclp.h
+ *
+ *    Copyright IBM Corp. 2007
+ *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#ifndef _ASM_S390_SCLP_H
+#define _ASM_S390_SCLP_H
+
+#include <linux/types.h>
+
+struct sccb_header {
+	u16	length;
+	u8	function_code;
+	u8	control_mask[3];
+	u16	response_code;
+} __attribute__((packed));
+
+#define LOADPARM_LEN 8
+
+struct sclp_readinfo_sccb {
+	struct	sccb_header header;	/* 0-7 */
+	u16	rnmax;			/* 8-9 */
+	u8	rnsize;			/* 10 */
+	u8	_reserved0[24 - 11];	/* 11-23 */
+	u8	loadparm[LOADPARM_LEN];	/* 24-31 */
+	u8	_reserved1[91 - 32];	/* 32-90 */
+	u8	flags;			/* 91 */
+	u8	_reserved2[100 - 92];	/* 92-99 */
+	u32	rnsize2;		/* 100-103 */
+	u64	rnmax2;			/* 104-111 */
+	u8	_reserved3[4096 - 112];	/* 112-4095 */
+} __attribute__((packed, aligned(4096)));
+
+extern struct sclp_readinfo_sccb s390_readinfo_sccb;
+extern void sclp_readinfo_early(void);
+
+#endif /* _ASM_S390_SCLP_H */
