Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZEaHIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZEaHIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 03:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZEaHIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 03:08:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:39120 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZEaHIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 03:08:05 -0400
Message-ID: <4A22281B.7020908@windriver.com>
Date: Sun, 31 May 2009 14:47:55 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
References: <cover.1243604390.git.wuzj@lemote.com> <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
In-Reply-To: <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2009 07:07:19.0290 (UTC) FILETIME=[6FD2EDA0:01C9E1BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Wu,

I have one question about dynamic ftrace support for modules on mips arch.
I have also ported a dynamic ftrace of mips before, but when I using modules 
with dynamic ftrace enabled in mips, I have following error:

# insmod ./usbcore
module usbcore: relocation overflow
insmod: cannot insert './usbcore.ko': invalid module format
#

I have no time to test your patch, but I think your patch also has this problem.

Below I explain possibility of this problem in details:

We know that on mips, kernel symbol will locate in 0x80000000~0x90000000, and 
modules' symbol will locate in >0xc0000000.

On mips, gcc will insert following assembler code before every functions:

     move    at,ra
     jal     0 <usb_ifnum_to_if>
     10: R_MIPS_26   _mcount


Here "_mcount" is a kernel symbol in 0x80000000~0x90000000, for
example at 0x8027a740.

When loading a module, kernel should relocate "jal 0" instruction to jump to the 
kernel's "_mcount" address, 0x8027a740. But "jal 0" is a 26 bits offset jump
instruction, it only can be relocated to jump to modules' symbol address
space(>0xc0000000) and it can't be relocated to jump to kernel symbol address
space(such as 0x8027a740), because offset is 32 bits(is 0xc0000000 -
0x80000000). We can't modify this instruction to jump to a 32 offset address
except that we modify gcc compiler to insert other assembler codes.

So, when installing modules, the kernel will try to relocate "jal 0" instruction
  to instruction of jumping to >0xc0000000, but it finds that _mcount's address
is 0x8027a740 and then print error indicated that it can't be reloacted.

The following source code is the checking place:


----------arch/mips/kernel/module.c:apply_r_mips_26_rel()-------------------

static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
{
     ...
     if ((v & 0xf0000000) != (((unsigned long)location + 4) & 0xf0000000)) {
                 printk(KERN_ERR
                        "module %s: relocation overflow, v:%x, location:%x\n",
                        me->name, v, (unsigned long)location);
                 return -ENOEXEC;
         }

     *location = (*location & ~0x03ffffff) |
                     ((*location + (v >> 2)) & 0x03ffffff);

}
----------arch/mips/kernel/module.c:apply_r_mips_26_rel()-------------------

v is kernel _mcount's address, location is the address of the instrution that 
should be relocated;

To resolve this problem, we may need to do more work, either on gcc or on the 
kernel. So I want to hear your test result and if you have solution, please let 
me know.

Thanks a lot!

Liming Wang

wuzhangjin@gmail.com wrote:
> From: Wu Zhangjin <wuzj@lemote.com>
> 
> dynamic function tracer need to replace "nop" to "jumps & links" and
> something reversely.
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> ---
>  arch/mips/Kconfig              |    3 +
>  arch/mips/include/asm/ftrace.h |   10 ++
>  arch/mips/kernel/Makefile      |    2 +
>  arch/mips/kernel/ftrace.c      |  207 ++++++++++++++++++++++++++++++++++++++++
>  arch/mips/kernel/mcount.S      |   31 ++++++
>  scripts/recordmcount.pl        |   17 +++-
>  6 files changed, 267 insertions(+), 3 deletions(-)
>  create mode 100644 arch/mips/kernel/ftrace.c
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index d5c01ca..0c00536 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -6,6 +6,9 @@ config MIPS
>  	select HAVE_ARCH_KGDB
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
> +	select HAVE_DYNAMIC_FTRACE
> +	select HAVE_FTRACE_MCOUNT_RECORD
> +	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
>  	# Horrible source of confusion.  Die, die, die ...
>  	select EMBEDDED
>  	select RTC_LIB
> diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
> index 5f8ebcf..b4970c9 100644
> --- a/arch/mips/include/asm/ftrace.h
> +++ b/arch/mips/include/asm/ftrace.h
> @@ -19,6 +19,16 @@
>  extern void _mcount(void);
>  #define mcount _mcount
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +/* reloction of mcount call site is the same as the address */
> +static inline unsigned long ftrace_call_adjust(unsigned long addr)
> +{
> +	return addr;
> +}
> +
> +struct dyn_arch_ftrace {
> +};
> +#endif /*  CONFIG_DYNAMIC_FTRACE */
>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_TRACER */
>  #endif /* _ASM_MIPS_FTRACE_H */
> diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
> index 559a820..8dabcc6 100644
> --- a/arch/mips/kernel/Makefile
> +++ b/arch/mips/kernel/Makefile
> @@ -10,6 +10,7 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not profile debug and lowlevel utilities
> +CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_early_printk.o = -pg
>  endif
>  
> @@ -30,6 +31,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
>  obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
>  
>  obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
> +obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o
>  
>  obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
>  obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
> diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
> new file mode 100644
> index 0000000..ad490cc
> --- /dev/null
> +++ b/arch/mips/kernel/ftrace.c
> @@ -0,0 +1,207 @@
> +/*
> + * Code for replacing ftrace calls with jumps.
> + *
> + * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
> + * Copyright (C) 2009 DSLab, Lanzhou University, China
> + * Author: Wu Zhangjin <wuzj@lemote.com>
> + *
> + * Thanks goes to Steven Rostedt for writing the original x86 version.
> + */
> +
> +#include <linux/spinlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/uaccess.h>
> +#include <linux/percpu.h>
> +#include <linux/sched.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/ftrace.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/ftrace.h>
> +#include <asm/asm.h>
> +#include <asm/unistd.h>
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +
> +#define JAL 0x0c000000	/* jump & link: ip --> ra, jump to target */
> +#define ADDR_MASK 0x03ffffff	/*  op_code|addr : 31...26|25 ....0 */
> +
> +static unsigned int ftrace_nop = 0x00000000;
> +
> +static unsigned char *ftrace_call_replace(unsigned long op_code,
> +					  unsigned long addr)
> +{
> +    static unsigned int op;
> +
> +    op = op_code | ((addr >> 2) & ADDR_MASK);
> +
> +    return (unsigned char *) &op;
> +}
> +
> +static atomic_t nmi_running = ATOMIC_INIT(0);
> +static int mod_code_status;	/* holds return value of text write */
> +static int mod_code_write;	/* set when NMI should do the write */
> +static void *mod_code_ip;	/* holds the IP to write to */
> +static void *mod_code_newcode;	/* holds the text to write to the IP */
> +
> +static unsigned nmi_wait_count;
> +static atomic_t nmi_update_count = ATOMIC_INIT(0);
> +
> +int ftrace_arch_read_dyn_info(char *buf, int size)
> +{
> +    int r;
> +
> +    r = snprintf(buf, size, "%u %u",
> +		 nmi_wait_count, atomic_read(&nmi_update_count));
> +    return r;
> +}
> +
> +static void ftrace_mod_code(void)
> +{
> +    /*
> +     * Yes, more than one CPU process can be writing to mod_code_status.
> +     *    (and the code itself)
> +     * But if one were to fail, then they all should, and if one were
> +     * to succeed, then they all should.
> +     */
> +    mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
> +					 MCOUNT_INSN_SIZE);
> +
> +    /* if we fail, then kill any new writers */
> +    if (mod_code_status)
> +		mod_code_write = 0;
> +}
> +
> +void ftrace_nmi_enter(void)
> +{
> +    atomic_inc(&nmi_running);
> +    /* Must have nmi_running seen before reading write flag */
> +    smp_mb();
> +    if (mod_code_write) {
> +		ftrace_mod_code();
> +		atomic_inc(&nmi_update_count);
> +    }
> +}
> +
> +void ftrace_nmi_exit(void)
> +{
> +    /* Finish all executions before clearing nmi_running */
> +    smp_wmb();
> +    atomic_dec(&nmi_running);
> +}
> +
> +static void wait_for_nmi(void)
> +{
> +    int waited = 0;
> +
> +    while (atomic_read(&nmi_running)) {
> +		waited = 1;
> +		cpu_relax();
> +    }
> +
> +    if (waited)
> +		nmi_wait_count++;
> +}
> +
> +static int do_ftrace_mod_code(unsigned long ip, void *new_code)
> +{
> +    mod_code_ip = (void *) ip;
> +    mod_code_newcode = new_code;
> +
> +    /* The buffers need to be visible before we let NMIs write them */
> +    smp_wmb();
> +
> +    mod_code_write = 1;
> +
> +    /* Make sure write bit is visible before we wait on NMIs */
> +    smp_mb();
> +
> +    wait_for_nmi();
> +
> +    /* Make sure all running NMIs have finished before we write the code */
> +    smp_mb();
> +
> +    ftrace_mod_code();
> +
> +    /* Make sure the write happens before clearing the bit */
> +    smp_wmb();
> +
> +    mod_code_write = 0;
> +
> +    /* make sure NMIs see the cleared bit */
> +    smp_mb();
> +
> +    wait_for_nmi();
> +
> +    return mod_code_status;
> +}
> +
> +static unsigned char *ftrace_nop_replace(void)
> +{
> +    return (unsigned char *) &ftrace_nop;
> +}
> +
> +static int
> +ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> +		   unsigned char *new_code)
> +{
> +    unsigned char replaced[MCOUNT_INSN_SIZE];
> +
> +    /* read the text we want to modify */
> +    if (probe_kernel_read(replaced, (void *) ip, MCOUNT_INSN_SIZE))
> +		return -EFAULT;
> +
> +    /* Make sure it is what we expect it to be */
> +    if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
> +		return -EINVAL;
> +
> +    /* replace the text with the new text */
> +    if (do_ftrace_mod_code(ip, new_code))
> +		return -EPERM;
> +
> +    return 0;
> +}
> +
> +int ftrace_make_nop(struct module *mod,
> +		    struct dyn_ftrace *rec, unsigned long addr)
> +{
> +    unsigned char *new, *old;
> +
> +    old = ftrace_call_replace(JAL, addr);
> +    new = ftrace_nop_replace();
> +
> +    return ftrace_modify_code(rec->ip, old, new);
> +}
> +
> +int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> +{
> +    unsigned char *new, *old;
> +
> +    old = ftrace_nop_replace();
> +    new = ftrace_call_replace(JAL, addr);
> +
> +    return ftrace_modify_code(rec->ip, old, new);
> +}
> +
> +int ftrace_update_ftrace_func(ftrace_func_t func)
> +{
> +    unsigned long ip = (unsigned long) (&ftrace_call);
> +    unsigned char old[MCOUNT_INSN_SIZE], *new;
> +    int ret;
> +
> +    memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
> +    new = ftrace_call_replace(JAL, (unsigned long) func);
> +    ret = ftrace_modify_code(ip, old, new);
> +
> +    return ret;
> +}
> +
> +int __init ftrace_dyn_arch_init(void *data)
> +{
> +    /* The return code is retured via data */
> +    *(unsigned long *) data = 0;
> +
> +    return 0;
> +}
> +#endif				/* CONFIG_DYNAMIC_FTRACE */
> diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> index 268724e..ce8a0ba 100644
> --- a/arch/mips/kernel/mcount.S
> +++ b/arch/mips/kernel/mcount.S
> @@ -67,6 +67,35 @@
>  	move ra, $1
>  	.endm
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +
> +LEAF(_mcount)
> +	RESTORE_SP_FOR_32BIT
> + 	RETURN_BACK
> + 	END(_mcount)
> +
> +NESTED(ftrace_caller, PT_SIZE, ra)
> +	RESTORE_SP_FOR_32BIT
> +	lw	t0, function_trace_stop
> +	bnez	t0, ftrace_stub
> +	nop
> +
> +	MCOUNT_SAVE_REGS
> +
> +	MCOUNT_SET_ARGS
> +	.globl ftrace_call
> +ftrace_call:
> +	jal	ftrace_stub
> +	nop
> +
> +	MCOUNT_RESTORE_REGS
> +	.globl ftrace_stub
> +ftrace_stub:
> +	RETURN_BACK
> +	END(ftrace_caller)
> +
> +#else	/* ! CONFIG_DYNAMIC_FTRACE */
> +
>  NESTED(_mcount, PT_SIZE, ra)
>  	RESTORE_SP_FOR_32BIT
>  	PTR_L	t0, function_trace_stop
> @@ -94,5 +123,7 @@ ftrace_stub:
>  	RETURN_BACK
>  	END(_mcount)
>  
> +#endif	/* ! CONFIG_DYNAMIC_FTRACE */
> +
>  	.set at
>  	.set reorder
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 409596e..a5d2ace 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -213,6 +213,17 @@ if ($arch eq "x86_64") {
>      if ($is_module eq "0") {
>          $cc .= " -mconstant-gp";
>      }
> +
> +} elsif ($arch eq "mips") {
> +	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> +	$ld .= " -melf".$bits."btsmip";
> +
> +	$cc .= " -mno-abicalls -fno-pic ";
> +
> +    if ($bits == 64) {
> +		$type = ".dword";
> +    }
> +
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }
> @@ -441,12 +452,12 @@ if ($#converts >= 0) {
>      #
>      # Step 5: set up each local function as a global
>      #
> -    `$objcopy $globallist $inputfile $globalobj`;
> +    `$objcopy $globallist $inputfile $globalobj 2>&1 >/dev/null`;
>  
>      #
>      # Step 6: Link the global version to our list.
>      #
> -    `$ld -r $globalobj $mcount_o -o $globalmix`;
> +    `$ld -r $globalobj $mcount_o -o $globalmix 2>&1 >/dev/null`;
>  
>      #
>      # Step 7: Convert the local functions back into local symbols
> @@ -454,7 +465,7 @@ if ($#converts >= 0) {
>      `$objcopy $locallist $globalmix $inputfile`;
>  
>      # Remove the temp files
> -    `$rm $globalobj $globalmix`;
> +    `$rm $globalobj $globalmix 2>&1 >/dev/null`;
>  
>  } else {
>  

