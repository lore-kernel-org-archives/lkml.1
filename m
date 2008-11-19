Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKSHrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKSHrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKSHqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:46:54 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:43010 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYKSHqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:46:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tWyrEa8rUjeL2FAisXpMSj4nBfVXy8mBUqYRU8suBcsk8FzXYBcNPtRlf3COH/yjeZ
         6wN/RB0sB8yG+hdAFS38m7uZGwi3heAgK98PyNw9DtYfWGE1nOhWwEcyEf/SVI2AcqIi
         teNLfFwQsA+48yGDAGVSJw2NMvW17RUnSKUfI=
Message-ID: <386072610811182346x33d5926ta4d6d48862ffe6f8@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:46:47 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 4/5] Blackfin arch: SMP supporting patchset: Blackfin kernel and memory management code
Cc: linux-kernel@vger.kernel.org, "Graf Yang" <graf.yang@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Bryan Wu" <cooloney@kernel.org>, linux-arch@vger.kernel.org
In-Reply-To: <1226999108-13839-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-5-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: 9ca08073d2d6b1c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc, linux-arch
-Bryan

On Tue, Nov 18, 2008 at 5:05 PM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Graf Yang <graf.yang@analog.com>
>
> Blackfin dual core BF561 processor can support SMP like features.
> https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>
> In this patch, we provide SMP extend to Blackfin kernel and memory management code
>
> Singed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  arch/blackfin/kernel/asm-offsets.c |   29 +++
>  arch/blackfin/kernel/bfin_ksyms.c  |   34 ++++
>  arch/blackfin/kernel/entry.S       |    1 +
>  arch/blackfin/kernel/irqchip.c     |   24 ++--
>  arch/blackfin/kernel/kgdb.c        |    4 +-
>  arch/blackfin/kernel/module.c      |   13 ++-
>  arch/blackfin/kernel/process.c     |   23 ++-
>  arch/blackfin/kernel/ptrace.c      |    8 +-
>  arch/blackfin/kernel/reboot.c      |   24 ++-
>  arch/blackfin/kernel/setup.c       |  163 ++++++++++++------
>  arch/blackfin/kernel/time.c        |  114 +++++++++----
>  arch/blackfin/kernel/traps.c       |   56 +++----
>  arch/blackfin/mm/init.c            |   60 +++++--
>  arch/blackfin/mm/sram-alloc.c      |  336 +++++++++++++++++++++---------------
>  14 files changed, 580 insertions(+), 309 deletions(-)
>
> diff --git a/arch/blackfin/kernel/asm-offsets.c b/arch/blackfin/kernel/asm-offsets.c
> index 9bb85dd..b5df945 100644
> --- a/arch/blackfin/kernel/asm-offsets.c
> +++ b/arch/blackfin/kernel/asm-offsets.c
> @@ -56,6 +56,9 @@ int main(void)
>        /* offsets into the thread struct */
>        DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
>        DEFINE(THREAD_USP, offsetof(struct thread_struct, usp));
> +       DEFINE(THREAD_SR, offsetof(struct thread_struct, seqstat));
> +       DEFINE(PT_SR, offsetof(struct thread_struct, seqstat));
> +       DEFINE(THREAD_ESP0, offsetof(struct thread_struct, esp0));
>        DEFINE(THREAD_PC, offsetof(struct thread_struct, pc));
>        DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);
>
> @@ -128,5 +131,31 @@ int main(void)
>        DEFINE(SIGSEGV, SIGSEGV);
>        DEFINE(SIGTRAP, SIGTRAP);
>
> +       /* PDA management (in L1 scratchpad) */
> +       DEFINE(PDA_SYSCFG, offsetof(struct blackfin_pda, syscfg));
> +#ifdef CONFIG_SMP
> +       DEFINE(PDA_IRQFLAGS, offsetof(struct blackfin_pda, imask));
> +#endif
> +       DEFINE(PDA_IPDT, offsetof(struct blackfin_pda, ipdt));
> +       DEFINE(PDA_IPDT_SWAPCOUNT, offsetof(struct blackfin_pda, ipdt_swapcount));
> +       DEFINE(PDA_DPDT, offsetof(struct blackfin_pda, dpdt));
> +       DEFINE(PDA_DPDT_SWAPCOUNT, offsetof(struct blackfin_pda, dpdt_swapcount));
> +       DEFINE(PDA_EXIPTR, offsetof(struct blackfin_pda, ex_iptr));
> +       DEFINE(PDA_EXOPTR, offsetof(struct blackfin_pda, ex_optr));
> +       DEFINE(PDA_EXBUF, offsetof(struct blackfin_pda, ex_buf));
> +       DEFINE(PDA_EXIMASK, offsetof(struct blackfin_pda, ex_imask));
> +       DEFINE(PDA_EXSTACK, offsetof(struct blackfin_pda, ex_stack));
> +#ifdef ANOMALY_05000261
> +       DEFINE(PDA_LFRETX, offsetof(struct blackfin_pda, last_cplb_fault_retx));
> +#endif
> +       DEFINE(PDA_DCPLB, offsetof(struct blackfin_pda, dcplb_fault_addr));
> +       DEFINE(PDA_ICPLB, offsetof(struct blackfin_pda, icplb_fault_addr));
> +       DEFINE(PDA_RETX, offsetof(struct blackfin_pda, retx));
> +       DEFINE(PDA_SEQSTAT, offsetof(struct blackfin_pda, seqstat));
> +#ifdef CONFIG_SMP
> +       /* Inter-core lock (in L2 SRAM) */
> +       DEFINE(SIZEOF_CORELOCK, sizeof(struct corelock_slot));
> +#endif
> +
>        return 0;
>  }
> diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
> index b66f1d4..763c315 100644
> --- a/arch/blackfin/kernel/bfin_ksyms.c
> +++ b/arch/blackfin/kernel/bfin_ksyms.c
> @@ -68,3 +68,37 @@ EXPORT_SYMBOL(insw_8);
>  EXPORT_SYMBOL(outsl);
>  EXPORT_SYMBOL(insl);
>  EXPORT_SYMBOL(insl_16);
> +
> +#ifdef CONFIG_SMP
> +EXPORT_SYMBOL(__raw_atomic_update_asm);
> +EXPORT_SYMBOL(__raw_atomic_clear_asm);
> +EXPORT_SYMBOL(__raw_atomic_set_asm);
> +EXPORT_SYMBOL(__raw_atomic_xor_asm);
> +EXPORT_SYMBOL(__raw_atomic_test_asm);
> +EXPORT_SYMBOL(__raw_xchg_1_asm);
> +EXPORT_SYMBOL(__raw_xchg_2_asm);
> +EXPORT_SYMBOL(__raw_xchg_4_asm);
> +EXPORT_SYMBOL(__raw_cmpxchg_1_asm);
> +EXPORT_SYMBOL(__raw_cmpxchg_2_asm);
> +EXPORT_SYMBOL(__raw_cmpxchg_4_asm);
> +EXPORT_SYMBOL(__raw_spin_is_locked_asm);
> +EXPORT_SYMBOL(__raw_spin_lock_asm);
> +EXPORT_SYMBOL(__raw_spin_trylock_asm);
> +EXPORT_SYMBOL(__raw_spin_unlock_asm);
> +EXPORT_SYMBOL(__raw_read_lock_asm);
> +EXPORT_SYMBOL(__raw_read_trylock_asm);
> +EXPORT_SYMBOL(__raw_read_unlock_asm);
> +EXPORT_SYMBOL(__raw_write_lock_asm);
> +EXPORT_SYMBOL(__raw_write_trylock_asm);
> +EXPORT_SYMBOL(__raw_write_unlock_asm);
> +EXPORT_SYMBOL(__raw_bit_set_asm);
> +EXPORT_SYMBOL(__raw_bit_clear_asm);
> +EXPORT_SYMBOL(__raw_bit_toggle_asm);
> +EXPORT_SYMBOL(__raw_bit_test_asm);
> +EXPORT_SYMBOL(__raw_bit_test_set_asm);
> +EXPORT_SYMBOL(__raw_bit_test_clear_asm);
> +EXPORT_SYMBOL(__raw_bit_test_toggle_asm);
> +EXPORT_SYMBOL(__raw_uncached_fetch_asm);
> +EXPORT_SYMBOL(__raw_smp_mark_barrier_asm);
> +EXPORT_SYMBOL(__raw_smp_check_barrier_asm);
> +#endif
> diff --git a/arch/blackfin/kernel/entry.S b/arch/blackfin/kernel/entry.S
> index faea88e..c0c3fe8 100644
> --- a/arch/blackfin/kernel/entry.S
> +++ b/arch/blackfin/kernel/entry.S
> @@ -30,6 +30,7 @@
>  #include <linux/linkage.h>
>  #include <asm/thread_info.h>
>  #include <asm/errno.h>
> +#include <asm/blackfin.h>
>  #include <asm/asm-offsets.h>
>
>  #include <asm/context.S>
> diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
> index 07402f5..9eebb78 100644
> --- a/arch/blackfin/kernel/irqchip.c
> +++ b/arch/blackfin/kernel/irqchip.c
> @@ -36,7 +36,7 @@
>  #include <linux/irq.h>
>  #include <asm/trace.h>
>
> -static unsigned long irq_err_count;
> +static atomic_t irq_err_count;
>  static spinlock_t irq_controller_lock;
>
>  /*
> @@ -48,7 +48,7 @@ void dummy_mask_unmask_irq(unsigned int irq)
>
>  void ack_bad_irq(unsigned int irq)
>  {
> -       irq_err_count += 1;
> +       atomic_inc(&irq_err_count);
>        printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
>  }
>  EXPORT_SYMBOL(ack_bad_irq);
> @@ -72,7 +72,7 @@ static struct irq_desc bad_irq_desc = {
>
>  int show_interrupts(struct seq_file *p, void *v)
>  {
> -       int i = *(loff_t *) v;
> +       int i = *(loff_t *) v, j;
>        struct irqaction *action;
>        unsigned long flags;
>
> @@ -80,19 +80,20 @@ int show_interrupts(struct seq_file *p, void *v)
>                spin_lock_irqsave(&irq_desc[i].lock, flags);
>                action = irq_desc[i].action;
>                if (!action)
> -                       goto unlock;
> -
> -               seq_printf(p, "%3d: %10u ", i, kstat_irqs(i));
> +                       goto skip;
> +               seq_printf(p, "%3d: ", i);
> +               for_each_online_cpu(j)
> +                       seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
> +               seq_printf(p, " %8s", irq_desc[i].chip->name);
>                seq_printf(p, "  %s", action->name);
>                for (action = action->next; action; action = action->next)
> -                       seq_printf(p, ", %s", action->name);
> +                       seq_printf(p, "  %s", action->name);
>
>                seq_putc(p, '\n');
> - unlock:
> + skip:
>                spin_unlock_irqrestore(&irq_desc[i].lock, flags);
> -       } else if (i == NR_IRQS) {
> -               seq_printf(p, "Err: %10lu\n", irq_err_count);
> -       }
> +       } else if (i == NR_IRQS)
> +               seq_printf(p, "Err: %10u\n",  atomic_read(&irq_err_count));
>        return 0;
>  }
>
> @@ -101,7 +102,6 @@ int show_interrupts(struct seq_file *p, void *v)
>  * come via this function.  Instead, they should provide their
>  * own 'handler'
>  */
> -
>  #ifdef CONFIG_DO_IRQ_L1
>  __attribute__((l1_text))
>  #endif
> diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
> index b795a20..ab40221 100644
> --- a/arch/blackfin/kernel/kgdb.c
> +++ b/arch/blackfin/kernel/kgdb.c
> @@ -363,12 +363,12 @@ void kgdb_passive_cpu_callback(void *info)
>
>  void kgdb_roundup_cpus(unsigned long flags)
>  {
> -       smp_call_function(kgdb_passive_cpu_callback, NULL, 0, 0);
> +       smp_call_function(kgdb_passive_cpu_callback, NULL, 0);
>  }
>
>  void kgdb_roundup_cpu(int cpu, unsigned long flags)
>  {
> -       smp_call_function_single(cpu, kgdb_passive_cpu_callback, NULL, 0, 0);
> +       smp_call_function_single(cpu, kgdb_passive_cpu_callback, NULL, 0);
>  }
>  #endif
>
> diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
> index e1bebc8..2e14cad 100644
> --- a/arch/blackfin/kernel/module.c
> +++ b/arch/blackfin/kernel/module.c
> @@ -343,7 +343,13 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
>                pr_debug("location is %x, value is %x type is %d \n",
>                         (unsigned int) location32, value,
>                         ELF32_R_TYPE(rel[i].r_info));
> -
> +#ifdef CONFIG_SMP
> +               if ((unsigned long)location16 >= COREB_L1_DATA_A_START) {
> +                       printk(KERN_ERR "module %s: cannot relocate in L1: %u (SMP kernel)",
> +                                      mod->name, ELF32_R_TYPE(rel[i].r_info));
> +                       return -ENOEXEC;
> +               }
> +#endif
>                switch (ELF32_R_TYPE(rel[i].r_info)) {
>
>                case R_pcrel24:
> @@ -436,6 +442,7 @@ module_finalize(const Elf_Ehdr * hdr,
>  {
>        unsigned int i, strindex = 0, symindex = 0;
>        char *secstrings;
> +       long err = 0;
>
>        secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
>
> @@ -460,8 +467,10 @@ module_finalize(const Elf_Ehdr * hdr,
>                    (strcmp(".rela.l1.text", secstrings + sechdrs[i].sh_name) == 0) ||
>                    ((strcmp(".rela.text", secstrings + sechdrs[i].sh_name) == 0) &&
>                        (hdr->e_flags & (EF_BFIN_CODE_IN_L1|EF_BFIN_CODE_IN_L2))))) {
> -                       apply_relocate_add((Elf_Shdr *) sechdrs, strtab,
> +                       err = apply_relocate_add((Elf_Shdr *) sechdrs, strtab,
>                                           symindex, i, mod);
> +                       if (err < 0)
> +                               return -ENOEXEC;
>                }
>        }
>        return 0;
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 326e301..4359ea2 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -171,6 +171,13 @@ asmlinkage int bfin_clone(struct pt_regs *regs)
>        unsigned long clone_flags;
>        unsigned long newsp;
>
> +#ifdef __ARCH_SYNC_CORE_DCACHE
> +       if (current->rt.nr_cpus_allowed == num_possible_cpus()) {
> +               current->cpus_allowed = cpumask_of_cpu(smp_processor_id());
> +               current->rt.nr_cpus_allowed = 1;
> +       }
> +#endif
> +
>        /* syscall2 puts clone_flags in r0 and usp in r1 */
>        clone_flags = regs->r0;
>        newsp = regs->r1;
> @@ -338,22 +345,22 @@ int _access_ok(unsigned long addr, unsigned long size)
>        if (addr >= (unsigned long)__init_begin &&
>            addr + size <= (unsigned long)__init_end)
>                return 1;
> -       if (addr >= L1_SCRATCH_START
> -           && addr + size <= L1_SCRATCH_START + L1_SCRATCH_LENGTH)
> +       if (addr >= get_l1_scratch_start()
> +           && addr + size <= get_l1_scratch_start() + L1_SCRATCH_LENGTH)
>                return 1;
>  #if L1_CODE_LENGTH != 0
> -       if (addr >= L1_CODE_START + (_etext_l1 - _stext_l1)
> -           && addr + size <= L1_CODE_START + L1_CODE_LENGTH)
> +       if (addr >= get_l1_code_start() + (_etext_l1 - _stext_l1)
> +           && addr + size <= get_l1_code_start() + L1_CODE_LENGTH)
>                return 1;
>  #endif
>  #if L1_DATA_A_LENGTH != 0
> -       if (addr >= L1_DATA_A_START + (_ebss_l1 - _sdata_l1)
> -           && addr + size <= L1_DATA_A_START + L1_DATA_A_LENGTH)
> +       if (addr >= get_l1_data_a_start() + (_ebss_l1 - _sdata_l1)
> +           && addr + size <= get_l1_data_a_start() + L1_DATA_A_LENGTH)
>                return 1;
>  #endif
>  #if L1_DATA_B_LENGTH != 0
> -       if (addr >= L1_DATA_B_START + (_ebss_b_l1 - _sdata_b_l1)
> -           && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
> +       if (addr >= get_l1_data_b_start() + (_ebss_b_l1 - _sdata_b_l1)
> +           && addr + size <= get_l1_data_b_start() + L1_DATA_B_LENGTH)
>                return 1;
>  #endif
>  #if L2_LENGTH != 0
> diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
> index 140bf00..4de44f3 100644
> --- a/arch/blackfin/kernel/ptrace.c
> +++ b/arch/blackfin/kernel/ptrace.c
> @@ -220,8 +220,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>                                break;
>                        pr_debug("ptrace: user address is valid\n");
>
> -                       if (L1_CODE_LENGTH != 0 && addr >= L1_CODE_START
> -                           && addr + sizeof(tmp) <= L1_CODE_START + L1_CODE_LENGTH) {
> +                       if (L1_CODE_LENGTH != 0 && addr >= get_l1_code_start()
> +                           && addr + sizeof(tmp) <= get_l1_code_start() + L1_CODE_LENGTH) {
>                                safe_dma_memcpy (&tmp, (const void *)(addr), sizeof(tmp));
>                                copied = sizeof(tmp);
>
> @@ -300,8 +300,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>                                break;
>                        pr_debug("ptrace: user address is valid\n");
>
> -                       if (L1_CODE_LENGTH != 0 && addr >= L1_CODE_START
> -                           && addr + sizeof(data) <= L1_CODE_START + L1_CODE_LENGTH) {
> +                       if (L1_CODE_LENGTH != 0 && addr >= get_l1_code_start()
> +                           && addr + sizeof(data) <= get_l1_code_start() + L1_CODE_LENGTH) {
>                                safe_dma_memcpy ((void *)(addr), &data, sizeof(data));
>                                copied = sizeof(data);
>
> diff --git a/arch/blackfin/kernel/reboot.c b/arch/blackfin/kernel/reboot.c
> index ae97ca4..eeee8cb 100644
> --- a/arch/blackfin/kernel/reboot.c
> +++ b/arch/blackfin/kernel/reboot.c
> @@ -21,7 +21,7 @@
>  * the core reset.
>  */
>  __attribute__((l1_text))
> -static void bfin_reset(void)
> +static void _bfin_reset(void)
>  {
>        /* Wait for completion of "system" events such as cache line
>         * line fills so that we avoid infinite stalls later on as
> @@ -66,6 +66,18 @@ static void bfin_reset(void)
>        }
>  }
>
> +static void bfin_reset(void)
> +{
> +       if (ANOMALY_05000353 || ANOMALY_05000386)
> +               _bfin_reset();
> +       else
> +               /* the bootrom checks to see how it was reset and will
> +                * automatically perform a software reset for us when
> +                * it starts executing boot
> +                */
> +               asm("raise 1;");
> +}
> +
>  __attribute__((weak))
>  void native_machine_restart(char *cmd)
>  {
> @@ -75,14 +87,10 @@ void machine_restart(char *cmd)
>  {
>        native_machine_restart(cmd);
>        local_irq_disable();
> -       if (ANOMALY_05000353 || ANOMALY_05000386)
> -               bfin_reset();
> +       if (smp_processor_id())
> +               smp_call_function((void *)bfin_reset, 0, 1);
>        else
> -               /* the bootrom checks to see how it was reset and will
> -                * automatically perform a software reset for us when
> -                * it starts executing boot
> -                */
> -               asm("raise 1;");
> +               bfin_reset();
>  }
>
>  __attribute__((weak))
> diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
> index 71a9a8c..c644d23 100644
> --- a/arch/blackfin/kernel/setup.c
> +++ b/arch/blackfin/kernel/setup.c
> @@ -26,11 +26,10 @@
>  #include <asm/blackfin.h>
>  #include <asm/cplbinit.h>
>  #include <asm/div64.h>
> +#include <asm/cpu.h>
>  #include <asm/fixed_code.h>
>  #include <asm/early_printk.h>
>
> -static DEFINE_PER_CPU(struct cpu, cpu_devices);
> -
>  u16 _bfin_swrst;
>  EXPORT_SYMBOL(_bfin_swrst);
>
> @@ -79,29 +78,76 @@ static struct change_member *change_point[2*BFIN_MEMMAP_MAX] __initdata;
>  static struct bfin_memmap_entry *overlap_list[BFIN_MEMMAP_MAX] __initdata;
>  static struct bfin_memmap_entry new_map[BFIN_MEMMAP_MAX] __initdata;
>
> -void __init bfin_cache_init(void)
> -{
> +DEFINE_PER_CPU(struct blackfin_cpudata, cpu_data);
> +
>  #if defined(CONFIG_BFIN_DCACHE) || defined(CONFIG_BFIN_ICACHE)
> -       generate_cplb_tables();
> +void __init generate_cplb_tables(void)
> +{
> +       unsigned int cpu;
> +
> +       /* Generate per-CPU I&D CPLB tables */
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu)
> +               generate_cplb_tables_cpu(cpu);
> +}
>  #endif
>
> +void __cpuinit bfin_setup_caches(unsigned int cpu)
> +{
>  #ifdef CONFIG_BFIN_ICACHE
> -       bfin_icache_init();
> -       printk(KERN_INFO "Instruction Cache Enabled\n");
> +#ifdef CONFIG_MPU
> +       bfin_icache_init(icplb_tbl[cpu]);
> +#else
> +       bfin_icache_init(icplb_tables[cpu]);
> +#endif
>  #endif
>
>  #ifdef CONFIG_BFIN_DCACHE
> -       bfin_dcache_init();
> -       printk(KERN_INFO "Data Cache Enabled"
> +#ifdef CONFIG_MPU
> +       bfin_dcache_init(dcplb_tbl[cpu]);
> +#else
> +       bfin_dcache_init(dcplb_tables[cpu]);
> +#endif
> +#endif
> +
> +       /*
> +        * In cache coherence emulation mode, we need to have the
> +        * D-cache enabled before running any atomic operation which
> +        * might invove cache invalidation (i.e. spinlock, rwlock).
> +        * So printk's are deferred until then.
> +        */
> +#ifdef CONFIG_BFIN_ICACHE
> +       printk(KERN_INFO "Instruction Cache Enabled for CPU%u\n", cpu);
> +#endif
> +#ifdef CONFIG_BFIN_DCACHE
> +       printk(KERN_INFO "Data Cache Enabled for CPU%u"
>  # if defined CONFIG_BFIN_WB
>                " (write-back)"
>  # elif defined CONFIG_BFIN_WT
>                " (write-through)"
>  # endif
> -               "\n");
> +               "\n", cpu);
>  #endif
>  }
>
> +void __cpuinit bfin_setup_cpudata(unsigned int cpu)
> +{
> +       struct blackfin_cpudata *cpudata = &per_cpu(cpu_data, cpu);
> +
> +       cpudata->idle = current;
> +       cpudata->loops_per_jiffy = loops_per_jiffy;
> +       cpudata->cclk = get_cclk();
> +       cpudata->imemctl = bfin_read_IMEM_CONTROL();
> +       cpudata->dmemctl = bfin_read_DMEM_CONTROL();
> +}
> +
> +void __init bfin_cache_init(void)
> +{
> +#if defined(CONFIG_BFIN_DCACHE) || defined(CONFIG_BFIN_ICACHE)
> +       generate_cplb_tables();
> +#endif
> +       bfin_setup_caches(0);
> +}
> +
>  void __init bfin_relocate_l1_mem(void)
>  {
>        unsigned long l1_code_length;
> @@ -230,7 +276,7 @@ static int __init sanitize_memmap(struct bfin_memmap_entry *map, int *pnr_map)
>        /* record all known change-points (starting and ending addresses),
>           omitting those that are for empty memory regions */
>        chgidx = 0;
> -       for (i = 0; i < old_nr; i++)    {
> +       for (i = 0; i < old_nr; i++) {
>                if (map[i].size != 0) {
>                        change_point[chgidx]->addr = map[i].addr;
>                        change_point[chgidx++]->pentry = &map[i];
> @@ -238,13 +284,13 @@ static int __init sanitize_memmap(struct bfin_memmap_entry *map, int *pnr_map)
>                        change_point[chgidx++]->pentry = &map[i];
>                }
>        }
> -       chg_nr = chgidx;        /* true number of change-points */
> +       chg_nr = chgidx;        /* true number of change-points */
>
>        /* sort change-point list by memory addresses (low -> high) */
>        still_changing = 1;
> -       while (still_changing)  {
> +       while (still_changing) {
>                still_changing = 0;
> -               for (i = 1; i < chg_nr; i++)  {
> +               for (i = 1; i < chg_nr; i++) {
>                        /* if <current_addr> > <last_addr>, swap */
>                        /* or, if current=<start_addr> & last=<end_addr>, swap */
>                        if ((change_point[i]->addr < change_point[i-1]->addr) ||
> @@ -261,10 +307,10 @@ static int __init sanitize_memmap(struct bfin_memmap_entry *map, int *pnr_map)
>        }
>
>        /* create a new memmap, removing overlaps */
> -       overlap_entries = 0;     /* number of entries in the overlap table */
> -       new_entry = 0;   /* index for creating new memmap entries */
> -       last_type = 0;           /* start with undefined memory type */
> -       last_addr = 0;           /* start with 0 as last starting address */
> +       overlap_entries = 0;    /* number of entries in the overlap table */
> +       new_entry = 0;          /* index for creating new memmap entries */
> +       last_type = 0;          /* start with undefined memory type */
> +       last_addr = 0;          /* start with 0 as last starting address */
>        /* loop through change-points, determining affect on the new memmap */
>        for (chgidx = 0; chgidx < chg_nr; chgidx++) {
>                /* keep track of all overlapping memmap entries */
> @@ -286,14 +332,14 @@ static int __init sanitize_memmap(struct bfin_memmap_entry *map, int *pnr_map)
>                        if (overlap_list[i]->type > current_type)
>                                current_type = overlap_list[i]->type;
>                /* continue building up new memmap based on this information */
> -               if (current_type != last_type)  {
> +               if (current_type != last_type) {
>                        if (last_type != 0) {
>                                new_map[new_entry].size =
>                                        change_point[chgidx]->addr - last_addr;
>                                /* move forward only if the new size was non-zero */
>                                if (new_map[new_entry].size != 0)
>                                        if (++new_entry >= BFIN_MEMMAP_MAX)
> -                                               break;  /* no more space left for new entries */
> +                                               break;  /* no more space left for new entries */
>                        }
>                        if (current_type != 0) {
>                                new_map[new_entry].addr = change_point[chgidx]->addr;
> @@ -303,9 +349,9 @@ static int __init sanitize_memmap(struct bfin_memmap_entry *map, int *pnr_map)
>                        last_type = current_type;
>                }
>        }
> -       new_nr = new_entry;   /* retain count for new entries */
> +       new_nr = new_entry;     /* retain count for new entries */
>
> -       /* copy new  mapping into original location */
> +       /* copy new mapping into original location */
>        memcpy(map, new_map, new_nr*sizeof(struct bfin_memmap_entry));
>        *pnr_map = new_nr;
>
> @@ -361,7 +407,6 @@ static __init int parse_memmap(char *arg)
>  *  - "memmap=XXX[KkmM][@][$]XXX[KkmM]" defines a memory region
>  *       @ from <start> to <start>+<mem>, type RAM
>  *       $ from <start> to <start>+<mem>, type RESERVED
> - *
>  */
>  static __init void parse_cmdline_early(char *cmdline_p)
>  {
> @@ -383,12 +428,10 @@ static __init void parse_cmdline_early(char *cmdline_p)
>                                        if (*to != ' ') {
>                                                if (*to == '$'
>                                                    || *(to + 1) == '$')
> -                                                       reserved_mem_dcache_on =
> -                                                           1;
> +                                                       reserved_mem_dcache_on = 1;
>                                                if (*to == '#'
>                                                    || *(to + 1) == '#')
> -                                                       reserved_mem_icache_on =
> -                                                           1;
> +                                                       reserved_mem_icache_on = 1;
>                                        }
>                                }
>                        } else if (!memcmp(to, "earlyprintk=", 12)) {
> @@ -417,9 +460,8 @@ static __init void parse_cmdline_early(char *cmdline_p)
>  *     [_ramend - DMA_UNCACHED_REGION,
>  *             _ramend]:                       uncached DMA region
>  *  [_ramend, physical_mem_end]:       memory not managed by kernel
> - *
>  */
> -static __init void  memory_setup(void)
> +static __init void memory_setup(void)
>  {
>  #ifdef CONFIG_MTD_UCLINUX
>        unsigned long mtd_phys = 0;
> @@ -436,7 +478,7 @@ static __init void  memory_setup(void)
>        memory_end = _ramend - DMA_UNCACHED_REGION;
>
>  #ifdef CONFIG_MPU
> -       /* Round up to multiple of 4MB.  */
> +       /* Round up to multiple of 4MB */
>        memory_start = (_ramstart + 0x3fffff) & ~0x3fffff;
>  #else
>        memory_start = PAGE_ALIGN(_ramstart);
> @@ -616,7 +658,7 @@ static __init void setup_bootmem_allocator(void)
>        end_pfn = memory_end >> PAGE_SHIFT;
>
>        /*
> -        * give all the memory to the bootmap allocator,  tell it to put the
> +        * give all the memory to the bootmap allocator, tell it to put the
>         * boot mem_map at the start of memory.
>         */
>        bootmap_size = init_bootmem_node(NODE_DATA(0),
> @@ -791,7 +833,11 @@ void __init setup_arch(char **cmdline_p)
>        bfin_write_SWRST(_bfin_swrst | DOUBLE_FAULT);
>  #endif
>
> +#ifdef CONFIG_SMP
> +       if (_bfin_swrst & SWRST_DBL_FAULT_A) {
> +#else
>        if (_bfin_swrst & RESET_DOUBLE) {
> +#endif
>                printk(KERN_EMERG "Recovering from DOUBLE FAULT event\n");
>  #ifdef CONFIG_DEBUG_DOUBLEFAULT
>                /* We assume the crashing kernel, and the current symbol table match */
> @@ -835,7 +881,7 @@ void __init setup_arch(char **cmdline_p)
>        printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");
>
>        printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu MHz System Clock\n",
> -              cclk / 1000000,  sclk / 1000000);
> +              cclk / 1000000, sclk / 1000000);
>
>        if (ANOMALY_05000273 && (cclk >> 1) <= sclk)
>                printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
> @@ -867,18 +913,21 @@ void __init setup_arch(char **cmdline_p)
>        BUG_ON((char *)&safe_user_instruction - (char *)&fixed_code_start
>                != SAFE_USER_INSTRUCTION - FIXED_CODE_START);
>
> +#ifdef CONFIG_SMP
> +       platform_init_cpus();
> +#endif
>        init_exception_vectors();
> -       bfin_cache_init();
> +       bfin_cache_init();      /* Initialize caches for the boot CPU */
>  }
>
>  static int __init topology_init(void)
>  {
> -       int cpu;
> +       unsigned int cpu;
> +       /* Record CPU-private information for the boot processor. */
> +       bfin_setup_cpudata(0);
>
>        for_each_possible_cpu(cpu) {
> -               struct cpu *c = &per_cpu(cpu_devices, cpu);
> -
> -               register_cpu(c, cpu);
> +               register_cpu(&per_cpu(cpu_data, cpu).cpu, cpu);
>        }
>
>        return 0;
> @@ -983,15 +1032,15 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>        char *cpu, *mmu, *fpu, *vendor, *cache;
>        uint32_t revid;
>
> -       u_long cclk = 0, sclk = 0;
> +       u_long sclk = 0;
>        u_int icache_size = BFIN_ICACHESIZE / 1024, dcache_size = 0, dsup_banks = 0;
> +       struct blackfin_cpudata *cpudata = &per_cpu(cpu_data, *(unsigned int *)v);
>
>        cpu = CPU;
>        mmu = "none";
>        fpu = "none";
>        revid = bfin_revid();
>
> -       cclk = get_cclk();
>        sclk = get_sclk();
>
>        switch (bfin_read_CHIPID() & CHIPID_MANUFACTURE) {
> @@ -1003,10 +1052,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>                break;
>        }
>
> -       seq_printf(m, "processor\t: %d\n"
> -               "vendor_id\t: %s\n",
> -               *(unsigned int *)v,
> -               vendor);
> +       seq_printf(m, "processor\t: %d\n" "vendor_id\t: %s\n",
> +               *(unsigned int *)v, vendor);
>
>        if (CPUID == bfin_cpuid())
>                seq_printf(m, "cpu family\t: 0x%04x\n", CPUID);
> @@ -1016,7 +1063,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>
>        seq_printf(m, "model name\t: ADSP-%s %lu(MHz CCLK) %lu(MHz SCLK) (%s)\n"
>                "stepping\t: %d\n",
> -               cpu, cclk/1000000, sclk/1000000,
> +               cpu, cpudata->cclk/1000000, sclk/1000000,
>  #ifdef CONFIG_MPU
>                "mpu on",
>  #else
> @@ -1025,16 +1072,16 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>                revid);
>
>        seq_printf(m, "cpu MHz\t\t: %lu.%03lu/%lu.%03lu\n",
> -               cclk/1000000, cclk%1000000,
> +               cpudata->cclk/1000000, cpudata->cclk%1000000,
>                sclk/1000000, sclk%1000000);
>        seq_printf(m, "bogomips\t: %lu.%02lu\n"
>                "Calibration\t: %lu loops\n",
> -               (loops_per_jiffy * HZ) / 500000,
> -               ((loops_per_jiffy * HZ) / 5000) % 100,
> -               (loops_per_jiffy * HZ));
> +               (cpudata->loops_per_jiffy * HZ) / 500000,
> +               ((cpudata->loops_per_jiffy * HZ) / 5000) % 100,
> +               (cpudata->loops_per_jiffy * HZ));
>
>        /* Check Cache configutation */
> -       switch (bfin_read_DMEM_CONTROL() & (1 << DMC0_P | 1 << DMC1_P)) {
> +       switch (cpudata->dmemctl & (1 << DMC0_P | 1 << DMC1_P)) {
>        case ACACHE_BSRAM:
>                cache = "dbank-A/B\t: cache/sram";
>                dcache_size = 16;
> @@ -1058,10 +1105,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>        }
>
>        /* Is it turned on? */
> -       if ((bfin_read_DMEM_CONTROL() & (ENDCPLB | DMC_ENABLE)) != (ENDCPLB | DMC_ENABLE))
> +       if ((cpudata->dmemctl & (ENDCPLB | DMC_ENABLE)) != (ENDCPLB | DMC_ENABLE))
>                dcache_size = 0;
>
> -       if ((bfin_read_IMEM_CONTROL() & (IMC | ENICPLB)) != (IMC | ENICPLB))
> +       if ((cpudata->imemctl & (IMC | ENICPLB)) != (IMC | ENICPLB))
>                icache_size = 0;
>
>        seq_printf(m, "cache size\t: %d KB(L1 icache) "
> @@ -1086,8 +1133,13 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>                   "dcache setup\t: %d Super-banks/%d Sub-banks/%d Ways, %d Lines/Way\n",
>                   dsup_banks, BFIN_DSUBBANKS, BFIN_DWAYS,
>                   BFIN_DLINES);
> +#ifdef __ARCH_SYNC_CORE_DCACHE
> +       seq_printf(m,
> +               "SMP Dcache Flushes\t: %lu\n\n",
> +               per_cpu(cpu_data, *(unsigned int *)v).dcache_invld_count);
> +#endif
>  #ifdef CONFIG_BFIN_ICACHE_LOCK
> -       switch ((bfin_read_IMEM_CONTROL() >> 3) & WAYALL_L) {
> +       switch ((cpudata->imemctl >> 3) & WAYALL_L) {
>        case WAY0_L:
>                seq_printf(m, "Way0 Locked-Down\n");
>                break;
> @@ -1137,6 +1189,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>                seq_printf(m, "No Ways are locked\n");
>        }
>  #endif
> +       if (*(unsigned int *)v != NR_CPUS-1)
> +               return 0;
> +
> +#if L2_LENGTH
> +       seq_printf(m, "L2 SRAM\t\t: %dKB\n", L2_LENGTH/0x400);
> +#endif
>        seq_printf(m, "board name\t: %s\n", bfin_board_name);
>        seq_printf(m, "board memory\t: %ld kB (0x%p -> 0x%p)\n",
>                 physical_mem_end >> 10, (void *)0, (void *)physical_mem_end);
> @@ -1144,6 +1202,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>                ((int)memory_end - (int)_stext) >> 10,
>                _stext,
>                (void *)memory_end);
> +       seq_printf(m, "\n");
>
>        return 0;
>  }
> diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
> index eb23523..06de2ce 100644
> --- a/arch/blackfin/kernel/time.c
> +++ b/arch/blackfin/kernel/time.c
> @@ -34,9 +34,11 @@
>  #include <linux/interrupt.h>
>  #include <linux/time.h>
>  #include <linux/irq.h>
> +#include <linux/delay.h>
>
>  #include <asm/blackfin.h>
>  #include <asm/time.h>
> +#include <asm/gptimers.h>
>
>  /* This is an NTP setting */
>  #define        TICK_SIZE (tick_nsec / 1000)
> @@ -46,11 +48,14 @@ static unsigned long gettimeoffset(void);
>
>  static struct irqaction bfin_timer_irq = {
>        .name = "BFIN Timer Tick",
> +#ifdef CONFIG_IRQ_PER_CPU
> +       .flags = IRQF_DISABLED  | IRQF_PERCPU,
> +#else
>        .flags = IRQF_DISABLED
> +#endif
>  };
>
> -static void
> -time_sched_init(irq_handler_t timer_routine)
> +void setup_core_timer(void)
>  {
>        u32 tcount;
>
> @@ -71,12 +76,41 @@ time_sched_init(irq_handler_t timer_routine)
>        CSYNC();
>
>        bfin_write_TCNTL(7);
> +}
> +
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +void setup_system_timer0(void)
> +{
> +       /* Power down the core timer, just to play safe. */
> +       bfin_write_TCNTL(0);
> +
> +       disable_gptimers(TIMER0bit);
> +       set_gptimer_status(0, TIMER_STATUS_TRUN0);
> +       while (get_gptimer_status(0) & TIMER_STATUS_TRUN0)
> +               udelay(10);
> +
> +       set_gptimer_config(0, 0x59); /* IRQ enable, periodic, PWM_OUT, SCLKed, OUT PAD disabled */
> +       set_gptimer_period(TIMER0_id, get_sclk() / HZ);
> +       set_gptimer_pwidth(TIMER0_id, 1);
> +       SSYNC();
> +       enable_gptimers(TIMER0bit);
> +}
> +#endif
>
> +static void
> +time_sched_init(irqreturn_t(*timer_routine) (int, void *))
> +{
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +       setup_system_timer0();
> +#else
> +       setup_core_timer();
> +#endif
>        bfin_timer_irq.handler = (irq_handler_t)timer_routine;
> -       /* call setup_irq instead of request_irq because request_irq calls
> -        * kmalloc which has not been initialized yet
> -        */
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +       setup_irq(IRQ_TIMER0, &bfin_timer_irq);
> +#else
>        setup_irq(IRQ_CORETMR, &bfin_timer_irq);
> +#endif
>  }
>
>  /*
> @@ -87,17 +121,23 @@ static unsigned long gettimeoffset(void)
>        unsigned long offset;
>        unsigned long clocks_per_jiffy;
>
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +       clocks_per_jiffy =  bfin_read_TIMER0_PERIOD();
> +       offset =  bfin_read_TIMER0_COUNTER() / \
> +               (((clocks_per_jiffy + 1) * HZ) / USEC_PER_SEC);
> +
> +       if ((get_gptimer_status(0) & TIMER_STATUS_TIMIL0) && offset < (100000 / HZ / 2))
> +               offset += (USEC_PER_SEC / HZ);
> +#else
>        clocks_per_jiffy = bfin_read_TPERIOD();
> -       offset =
> -           (clocks_per_jiffy -
> -            bfin_read_TCOUNT()) / (((clocks_per_jiffy + 1) * HZ) /
> -                                   USEC_PER_SEC);
> +       offset = (clocks_per_jiffy - bfin_read_TCOUNT()) / \
> +               (((clocks_per_jiffy + 1) * HZ)  / USEC_PER_SEC);
>
>        /* Check if we just wrapped the counters and maybe missed a tick */
>        if ((bfin_read_ILAT() & (1 << IRQ_CORETMR))
> -           && (offset < (100000 / HZ / 2)))
> +               && (offset < (100000 / HZ / 2)))
>                offset += (USEC_PER_SEC / HZ);
> -
> +#endif
>        return offset;
>  }
>
> @@ -120,34 +160,38 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
>        static long last_rtc_update;
>
>        write_seqlock(&xtime_lock);
> -
> -       do_timer(1);
> -
> -       profile_tick(CPU_PROFILING);
> -
> -       /*
> -        * If we have an externally synchronized Linux clock, then update
> -        * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
> -        * called as close as possible to 500 ms before the new second starts.
> -        */
> -
> -       if (ntp_synced() &&
> -           xtime.tv_sec > last_rtc_update + 660 &&
> -           (xtime.tv_nsec / NSEC_PER_USEC) >=
> -           500000 - ((unsigned)TICK_SIZE) / 2
> -           && (xtime.tv_nsec / NSEC_PER_USEC) <=
> -           500000 + ((unsigned)TICK_SIZE) / 2) {
> -               if (set_rtc_mmss(xtime.tv_sec) == 0)
> -                       last_rtc_update = xtime.tv_sec;
> -               else
> -                       /* Do it again in 60s. */
> -                       last_rtc_update = xtime.tv_sec - 600;
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +       if (get_gptimer_status(0) & TIMER_STATUS_TIMIL0) {
> +#endif
> +               do_timer(1);
> +
> +
> +               /*
> +                * If we have an externally synchronized Linux clock, then update
> +                * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
> +                * called as close as possible to 500 ms before the new second starts.
> +                */
> +
> +               if (ntp_synced() &&
> +                   xtime.tv_sec > last_rtc_update + 660 &&
> +                   (xtime.tv_nsec / NSEC_PER_USEC) >=
> +                   500000 - ((unsigned)TICK_SIZE) / 2
> +                   && (xtime.tv_nsec / NSEC_PER_USEC) <=
> +                   500000 + ((unsigned)TICK_SIZE) / 2) {
> +                       if (set_rtc_mmss(xtime.tv_sec) == 0)
> +                               last_rtc_update = xtime.tv_sec;
> +                       else
> +                               /* Do it again in 60s. */
> +                               last_rtc_update = xtime.tv_sec - 600;
> +               }
> +#ifdef CONFIG_TICK_SOURCE_SYSTMR0
> +               set_gptimer_status(0, TIMER_STATUS_TIMIL0);
>        }
> +#endif
>        write_sequnlock(&xtime_lock);
>
> -#ifndef CONFIG_SMP
>        update_process_times(user_mode(get_irq_regs()));
> -#endif
> +       profile_tick(CPU_PROFILING);
>
>        return IRQ_HANDLED;
>  }
> diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
> index bef025b..af7cc43 100644
> --- a/arch/blackfin/kernel/traps.c
> +++ b/arch/blackfin/kernel/traps.c
> @@ -75,16 +75,6 @@ void __init trap_init(void)
>        CSYNC();
>  }
>
> -/*
> - * Used to save the RETX, SEQSTAT, I/D CPLB FAULT ADDR
> - * values across the transition from exception to IRQ5.
> - * We put these in L1, so they are going to be in a valid
> - * location during exception context
> - */
> -__attribute__((l1_data))
> -unsigned long saved_retx, saved_seqstat,
> -       saved_icplb_fault_addr, saved_dcplb_fault_addr;
> -
>  static void decode_address(char *buf, unsigned long address)
>  {
>  #ifdef CONFIG_DEBUG_VERBOSE
> @@ -211,18 +201,18 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
>        printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
>  #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT
>        if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) == VEC_UNCOV) {
> +               unsigned int cpu = smp_processor_id();
>                char buf[150];
> -               decode_address(buf, saved_retx);
> +               decode_address(buf, cpu_pda[cpu].retx);
>                printk(KERN_EMERG "While handling exception (EXCAUSE = 0x%x) at %s:\n",
> -                       (int)saved_seqstat & SEQSTAT_EXCAUSE, buf);
> -               decode_address(buf, saved_dcplb_fault_addr);
> +                       (unsigned int)cpu_pda[cpu].seqstat & SEQSTAT_EXCAUSE, buf);
> +               decode_address(buf, cpu_pda[cpu].dcplb_fault_addr);
>                printk(KERN_NOTICE "   DCPLB_FAULT_ADDR: %s\n", buf);
> -               decode_address(buf, saved_icplb_fault_addr);
> +               decode_address(buf, cpu_pda[cpu].icplb_fault_addr);
>                printk(KERN_NOTICE "   ICPLB_FAULT_ADDR: %s\n", buf);
>
>                decode_address(buf, fp->retx);
> -               printk(KERN_NOTICE "The instruction at %s caused a double exception\n",
> -                       buf);
> +               printk(KERN_NOTICE "The instruction at %s caused a double exception\n", buf);
>        } else
>  #endif
>        {
> @@ -240,6 +230,9 @@ asmlinkage void trap_c(struct pt_regs *fp)
>  #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
>        int j;
>  #endif
> +#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
> +       unsigned int cpu = smp_processor_id();
> +#endif
>        int sig = 0;
>        siginfo_t info;
>        unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
> @@ -417,7 +410,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
>                info.si_code = ILL_CPLB_MULHIT;
>                sig = SIGSEGV;
>  #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
> -               if (saved_dcplb_fault_addr < FIXED_CODE_START)
> +               if (cpu_pda[cpu].dcplb_fault_addr < FIXED_CODE_START)
>                        verbose_printk(KERN_NOTICE "NULL pointer access\n");
>                else
>  #endif
> @@ -471,7 +464,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
>                info.si_code = ILL_CPLB_MULHIT;
>                sig = SIGSEGV;
>  #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
> -               if (saved_icplb_fault_addr < FIXED_CODE_START)
> +               if (cpu_pda[cpu].icplb_fault_addr < FIXED_CODE_START)
>                        verbose_printk(KERN_NOTICE "Jump to NULL address\n");
>                else
>  #endif
> @@ -960,6 +953,7 @@ void dump_bfin_process(struct pt_regs *fp)
>                else
>                        verbose_printk(KERN_NOTICE "COMM= invalid\n");
>
> +               printk(KERN_NOTICE "CPU = %d\n", current_thread_info()->cpu);
>                if (!((unsigned long)current->mm & 0x3) && (unsigned long)current->mm >= FIXED_CODE_START)
>                        verbose_printk(KERN_NOTICE  "TEXT = 0x%p-0x%p        DATA = 0x%p-0x%p\n"
>                                KERN_NOTICE " BSS = 0x%p-0x%p  USER-STACK = 0x%p\n"
> @@ -1053,6 +1047,7 @@ void show_regs(struct pt_regs *fp)
>        struct irqaction *action;
>        unsigned int i;
>        unsigned long flags;
> +       unsigned int cpu = smp_processor_id();
>
>        verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\t\t%s\n", print_tainted());
>        verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
> @@ -1112,9 +1107,9 @@ unlock:
>
>        if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) &&
>            (((long)fp->seqstat & SEQSTAT_EXCAUSE) != VEC_HWERR)) {
> -               decode_address(buf, saved_dcplb_fault_addr);
> +               decode_address(buf, cpu_pda[cpu].dcplb_fault_addr);
>                verbose_printk(KERN_NOTICE "DCPLB_FAULT_ADDR: %s\n", buf);
> -               decode_address(buf, saved_icplb_fault_addr);
> +               decode_address(buf, cpu_pda[cpu].icplb_fault_addr);
>                verbose_printk(KERN_NOTICE "ICPLB_FAULT_ADDR: %s\n", buf);
>        }
>
> @@ -1153,20 +1148,21 @@ unlock:
>  asmlinkage int sys_bfin_spinlock(int *spinlock)__attribute__((l1_text));
>  #endif
>
> -asmlinkage int sys_bfin_spinlock(int *spinlock)
> +static DEFINE_SPINLOCK(bfin_spinlock_lock);
> +
> +asmlinkage int sys_bfin_spinlock(int *p)
>  {
> -       int ret = 0;
> -       int tmp = 0;
> +       int ret, tmp = 0;
>
> -       local_irq_disable();
> -       ret = get_user(tmp, spinlock);
> -       if (ret == 0) {
> -               if (tmp)
> +       spin_lock(&bfin_spinlock_lock); /* This would also hold kernel preemption. */
> +       ret = get_user(tmp, p);
> +       if (likely(ret == 0)) {
> +               if (unlikely(tmp))
>                        ret = 1;
> -               tmp = 1;
> -               put_user(tmp, spinlock);
> +               else
> +                       put_user(1, p);
>        }
> -       local_irq_enable();
> +       spin_unlock(&bfin_spinlock_lock);
>        return ret;
>  }
>
> diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
> index bc240ab..57d306b 100644
> --- a/arch/blackfin/mm/init.c
> +++ b/arch/blackfin/mm/init.c
> @@ -31,7 +31,8 @@
>  #include <linux/bootmem.h>
>  #include <linux/uaccess.h>
>  #include <asm/bfin-global.h>
> -#include <asm/l1layout.h>
> +#include <asm/pda.h>
> +#include <asm/cplbinit.h>
>  #include "blackfin_sram.h"
>
>  /*
> @@ -53,6 +54,11 @@ static unsigned long empty_bad_page;
>
>  unsigned long empty_zero_page;
>
> +extern unsigned long exception_stack[NR_CPUS][1024];
> +
> +struct blackfin_pda cpu_pda[NR_CPUS];
> +EXPORT_SYMBOL(cpu_pda);
> +
>  /*
>  * paging_init() continues the virtual memory environment setup which
>  * was begun by the code in arch/head.S.
> @@ -98,6 +104,42 @@ void __init paging_init(void)
>        }
>  }
>
> +asmlinkage void init_pda(void)
> +{
> +       unsigned int cpu = raw_smp_processor_id();
> +
> +       /* Initialize the PDA fields holding references to other parts
> +          of the memory. The content of such memory is still
> +          undefined at the time of the call, we are only setting up
> +          valid pointers to it. */
> +       memset(&cpu_pda[cpu], 0, sizeof(cpu_pda[cpu]));
> +
> +       cpu_pda[0].next = &cpu_pda[1];
> +       cpu_pda[1].next = &cpu_pda[0];
> +
> +       cpu_pda[cpu].ex_stack = exception_stack[cpu + 1];
> +
> +#ifdef CONFIG_MPU
> +#else
> +       cpu_pda[cpu].ipdt = ipdt_tables[cpu];
> +       cpu_pda[cpu].dpdt = dpdt_tables[cpu];
> +#ifdef CONFIG_CPLB_INFO
> +       cpu_pda[cpu].ipdt_swapcount = ipdt_swapcount_tables[cpu];
> +       cpu_pda[cpu].dpdt_swapcount = dpdt_swapcount_tables[cpu];
> +#endif
> +#endif
> +
> +#ifdef CONFIG_SMP
> +       cpu_pda[cpu].imask = 0x1f;
> +#endif
> +}
> +
> +void __cpuinit reserve_pda(void)
> +{
> +       printk(KERN_INFO "PDA for CPU%u reserved at %p\n", smp_processor_id(),
> +                                       &cpu_pda[smp_processor_id()]);
> +}
> +
>  void __init mem_init(void)
>  {
>        unsigned int codek = 0, datak = 0, initk = 0;
> @@ -141,21 +183,13 @@ void __init mem_init(void)
>
>  static int __init sram_init(void)
>  {
> -       unsigned long tmp;
> -
>        /* Initialize the blackfin L1 Memory. */
>        bfin_sram_init();
>
> -       /* Allocate this once; never free it.  We assume this gives us a
> -          pointer to the start of L1 scratchpad memory; panic if it
> -          doesn't.  */
> -       tmp = (unsigned long)l1sram_alloc(sizeof(struct l1_scratch_task_info));
> -       if (tmp != (unsigned long)L1_SCRATCH_TASK_INFO) {
> -               printk(KERN_EMERG "mem_init(): Did not get the right address from l1sram_alloc: %08lx != %08lx\n",
> -                       tmp, (unsigned long)L1_SCRATCH_TASK_INFO);
> -               panic("No L1, time to give up\n");
> -       }
> -
> +       /* Reserve the PDA space for the boot CPU right after we
> +        * initialized the scratch memory allocator.
> +        */
> +       reserve_pda();
>        return 0;
>  }
>  pure_initcall(sram_init);
> diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
> index cc6f336..8f82b4c 100644
> --- a/arch/blackfin/mm/sram-alloc.c
> +++ b/arch/blackfin/mm/sram-alloc.c
> @@ -41,8 +41,10 @@
>  #include <asm/blackfin.h>
>  #include "blackfin_sram.h"
>
> -static spinlock_t l1sram_lock, l1_data_sram_lock, l1_inst_sram_lock;
> -static spinlock_t l2_sram_lock;
> +static DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
> +static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
> +static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
> +static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
>
>  /* the data structure for L1 scratchpad and DATA SRAM */
>  struct sram_piece {
> @@ -52,18 +54,22 @@ struct sram_piece {
>        struct sram_piece *next;
>  };
>
> -static struct sram_piece free_l1_ssram_head, used_l1_ssram_head;
> +static DEFINE_PER_CPU(struct sram_piece, free_l1_ssram_head);
> +static DEFINE_PER_CPU(struct sram_piece, used_l1_ssram_head);
>
>  #if L1_DATA_A_LENGTH != 0
> -static struct sram_piece free_l1_data_A_sram_head, used_l1_data_A_sram_head;
> +static DEFINE_PER_CPU(struct sram_piece, free_l1_data_A_sram_head);
> +static DEFINE_PER_CPU(struct sram_piece, used_l1_data_A_sram_head);
>  #endif
>
>  #if L1_DATA_B_LENGTH != 0
> -static struct sram_piece free_l1_data_B_sram_head, used_l1_data_B_sram_head;
> +static DEFINE_PER_CPU(struct sram_piece, free_l1_data_B_sram_head);
> +static DEFINE_PER_CPU(struct sram_piece, used_l1_data_B_sram_head);
>  #endif
>
>  #if L1_CODE_LENGTH != 0
> -static struct sram_piece free_l1_inst_sram_head, used_l1_inst_sram_head;
> +static DEFINE_PER_CPU(struct sram_piece, free_l1_inst_sram_head);
> +static DEFINE_PER_CPU(struct sram_piece, used_l1_inst_sram_head);
>  #endif
>
>  #if L2_LENGTH != 0
> @@ -75,102 +81,115 @@ static struct kmem_cache *sram_piece_cache;
>  /* L1 Scratchpad SRAM initialization function */
>  static void __init l1sram_init(void)
>  {
> -       free_l1_ssram_head.next =
> -               kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> -       if (!free_l1_ssram_head.next) {
> -               printk(KERN_INFO "Failed to initialize Scratchpad data SRAM\n");
> -               return;
> +       unsigned int cpu;
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
> +               per_cpu(free_l1_ssram_head, cpu).next =
> +                       kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> +               if (!per_cpu(free_l1_ssram_head, cpu).next) {
> +                       printk(KERN_INFO "Fail to initialize Scratchpad data SRAM.\n");
> +                       return;
> +               }
> +
> +               per_cpu(free_l1_ssram_head, cpu).next->paddr = (void *)get_l1_scratch_start_cpu(cpu);
> +               per_cpu(free_l1_ssram_head, cpu).next->size = L1_SCRATCH_LENGTH;
> +               per_cpu(free_l1_ssram_head, cpu).next->pid = 0;
> +               per_cpu(free_l1_ssram_head, cpu).next->next = NULL;
> +
> +               per_cpu(used_l1_ssram_head, cpu).next = NULL;
> +
> +               /* mutex initialize */
> +               spin_lock_init(&per_cpu(l1sram_lock, cpu));
> +               printk(KERN_INFO "Blackfin Scratchpad data SRAM: %d KB\n",
> +                       L1_SCRATCH_LENGTH >> 10);
>        }
> -
> -       free_l1_ssram_head.next->paddr = (void *)L1_SCRATCH_START;
> -       free_l1_ssram_head.next->size = L1_SCRATCH_LENGTH;
> -       free_l1_ssram_head.next->pid = 0;
> -       free_l1_ssram_head.next->next = NULL;
> -
> -       used_l1_ssram_head.next = NULL;
> -
> -       /* mutex initialize */
> -       spin_lock_init(&l1sram_lock);
> -
> -       printk(KERN_INFO "Blackfin Scratchpad data SRAM: %d KB\n",
> -              L1_SCRATCH_LENGTH >> 10);
>  }
>
>  static void __init l1_data_sram_init(void)
>  {
> +       unsigned int cpu;
>  #if L1_DATA_A_LENGTH != 0
> -       free_l1_data_A_sram_head.next =
> -               kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> -       if (!free_l1_data_A_sram_head.next) {
> -               printk(KERN_INFO "Failed to initialize L1 Data A SRAM\n");
> -               return;
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
> +               per_cpu(free_l1_data_A_sram_head, cpu).next =
> +                       kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> +               if (!per_cpu(free_l1_data_A_sram_head, cpu).next) {
> +                       printk(KERN_INFO "Fail to initialize L1 Data A SRAM.\n");
> +                       return;
> +               }
> +
> +               per_cpu(free_l1_data_A_sram_head, cpu).next->paddr =
> +                       (void *)get_l1_data_a_start_cpu(cpu) + (_ebss_l1 - _sdata_l1);
> +               per_cpu(free_l1_data_A_sram_head, cpu).next->size =
> +                       L1_DATA_A_LENGTH - (_ebss_l1 - _sdata_l1);
> +               per_cpu(free_l1_data_A_sram_head, cpu).next->pid = 0;
> +               per_cpu(free_l1_data_A_sram_head, cpu).next->next = NULL;
> +
> +               per_cpu(used_l1_data_A_sram_head, cpu).next = NULL;
> +
> +               printk(KERN_INFO "Blackfin L1 Data A SRAM: %d KB (%d KB free)\n",
> +                       L1_DATA_A_LENGTH >> 10,
> +                       per_cpu(free_l1_data_A_sram_head, cpu).next->size >> 10);
>        }
> -
> -       free_l1_data_A_sram_head.next->paddr =
> -               (void *)L1_DATA_A_START + (_ebss_l1 - _sdata_l1);
> -       free_l1_data_A_sram_head.next->size =
> -               L1_DATA_A_LENGTH - (_ebss_l1 - _sdata_l1);
> -       free_l1_data_A_sram_head.next->pid = 0;
> -       free_l1_data_A_sram_head.next->next = NULL;
> -
> -       used_l1_data_A_sram_head.next = NULL;
> -
> -       printk(KERN_INFO "Blackfin L1 Data A SRAM: %d KB (%d KB free)\n",
> -               L1_DATA_A_LENGTH >> 10,
> -               free_l1_data_A_sram_head.next->size >> 10);
>  #endif
>  #if L1_DATA_B_LENGTH != 0
> -       free_l1_data_B_sram_head.next =
> -               kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> -       if (!free_l1_data_B_sram_head.next) {
> -               printk(KERN_INFO "Failed to initialize L1 Data B SRAM\n");
> -               return;
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
> +               per_cpu(free_l1_data_B_sram_head, cpu).next =
> +                       kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> +               if (!per_cpu(free_l1_data_B_sram_head, cpu).next) {
> +                       printk(KERN_INFO "Fail to initialize L1 Data B SRAM.\n");
> +                       return;
> +               }
> +
> +               per_cpu(free_l1_data_B_sram_head, cpu).next->paddr =
> +                       (void *)get_l1_data_b_start_cpu(cpu) + (_ebss_b_l1 - _sdata_b_l1);
> +               per_cpu(free_l1_data_B_sram_head, cpu).next->size =
> +                       L1_DATA_B_LENGTH - (_ebss_b_l1 - _sdata_b_l1);
> +               per_cpu(free_l1_data_B_sram_head, cpu).next->pid = 0;
> +               per_cpu(free_l1_data_B_sram_head, cpu).next->next = NULL;
> +
> +               per_cpu(used_l1_data_B_sram_head, cpu).next = NULL;
> +
> +               printk(KERN_INFO "Blackfin L1 Data B SRAM: %d KB (%d KB free)\n",
> +                       L1_DATA_B_LENGTH >> 10,
> +                       per_cpu(free_l1_data_B_sram_head, cpu).next->size >> 10);
> +               /* mutex initialize */
>        }
> -
> -       free_l1_data_B_sram_head.next->paddr =
> -               (void *)L1_DATA_B_START + (_ebss_b_l1 - _sdata_b_l1);
> -       free_l1_data_B_sram_head.next->size =
> -               L1_DATA_B_LENGTH - (_ebss_b_l1 - _sdata_b_l1);
> -       free_l1_data_B_sram_head.next->pid = 0;
> -       free_l1_data_B_sram_head.next->next = NULL;
> -
> -       used_l1_data_B_sram_head.next = NULL;
> -
> -       printk(KERN_INFO "Blackfin L1 Data B SRAM: %d KB (%d KB free)\n",
> -               L1_DATA_B_LENGTH >> 10,
> -               free_l1_data_B_sram_head.next->size >> 10);
>  #endif
>
> -       /* mutex initialize */
> -       spin_lock_init(&l1_data_sram_lock);
> +#if L1_DATA_A_LENGTH != 0 || L1_DATA_B_LENGTH != 0
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu)
> +               spin_lock_init(&per_cpu(l1_data_sram_lock, cpu));
> +#endif
>  }
>
>  static void __init l1_inst_sram_init(void)
>  {
>  #if L1_CODE_LENGTH != 0
> -       free_l1_inst_sram_head.next =
> -               kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> -       if (!free_l1_inst_sram_head.next) {
> -               printk(KERN_INFO "Failed to initialize L1 Instruction SRAM\n");
> -               return;
> +       unsigned int cpu;
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
> +               per_cpu(free_l1_inst_sram_head, cpu).next =
> +                       kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
> +               if (!per_cpu(free_l1_inst_sram_head, cpu).next) {
> +                       printk(KERN_INFO "Failed to initialize L1 Instruction SRAM\n");
> +                       return;
> +               }
> +
> +               per_cpu(free_l1_inst_sram_head, cpu).next->paddr =
> +                       (void *)get_l1_code_start_cpu(cpu) + (_etext_l1 - _stext_l1);
> +               per_cpu(free_l1_inst_sram_head, cpu).next->size =
> +                       L1_CODE_LENGTH - (_etext_l1 - _stext_l1);
> +               per_cpu(free_l1_inst_sram_head, cpu).next->pid = 0;
> +               per_cpu(free_l1_inst_sram_head, cpu).next->next = NULL;
> +
> +               per_cpu(used_l1_inst_sram_head, cpu).next = NULL;
> +
> +               printk(KERN_INFO "Blackfin L1 Instruction SRAM: %d KB (%d KB free)\n",
> +                       L1_CODE_LENGTH >> 10,
> +                       per_cpu(free_l1_inst_sram_head, cpu).next->size >> 10);
> +
> +               /* mutex initialize */
> +               spin_lock_init(&per_cpu(l1_inst_sram_lock, cpu));
>        }
> -
> -       free_l1_inst_sram_head.next->paddr =
> -               (void *)L1_CODE_START + (_etext_l1 - _stext_l1);
> -       free_l1_inst_sram_head.next->size =
> -               L1_CODE_LENGTH - (_etext_l1 - _stext_l1);
> -       free_l1_inst_sram_head.next->pid = 0;
> -       free_l1_inst_sram_head.next->next = NULL;
> -
> -       used_l1_inst_sram_head.next = NULL;
> -
> -       printk(KERN_INFO "Blackfin L1 Instruction SRAM: %d KB (%d KB free)\n",
> -               L1_CODE_LENGTH >> 10,
> -               free_l1_inst_sram_head.next->size >> 10);
>  #endif
> -
> -       /* mutex initialize */
> -       spin_lock_init(&l1_inst_sram_lock);
>  }
>
>  static void __init l2_sram_init(void)
> @@ -179,7 +198,7 @@ static void __init l2_sram_init(void)
>        free_l2_sram_head.next =
>                kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
>        if (!free_l2_sram_head.next) {
> -               printk(KERN_INFO "Failed to initialize L2 SRAM\n");
> +               printk(KERN_INFO "Fail to initialize L2 SRAM.\n");
>                return;
>        }
>
> @@ -200,6 +219,7 @@ static void __init l2_sram_init(void)
>        /* mutex initialize */
>        spin_lock_init(&l2_sram_lock);
>  }
> +
>  void __init bfin_sram_init(void)
>  {
>        sram_piece_cache = kmem_cache_create("sram_piece_cache",
> @@ -353,20 +373,20 @@ int sram_free(const void *addr)
>  {
>
>  #if L1_CODE_LENGTH != 0
> -       if (addr >= (void *)L1_CODE_START
> -                && addr < (void *)(L1_CODE_START + L1_CODE_LENGTH))
> +       if (addr >= (void *)get_l1_code_start()
> +                && addr < (void *)(get_l1_code_start() + L1_CODE_LENGTH))
>                return l1_inst_sram_free(addr);
>        else
>  #endif
>  #if L1_DATA_A_LENGTH != 0
> -       if (addr >= (void *)L1_DATA_A_START
> -                && addr < (void *)(L1_DATA_A_START + L1_DATA_A_LENGTH))
> +       if (addr >= (void *)get_l1_data_a_start()
> +                && addr < (void *)(get_l1_data_a_start() + L1_DATA_A_LENGTH))
>                return l1_data_A_sram_free(addr);
>        else
>  #endif
>  #if L1_DATA_B_LENGTH != 0
> -       if (addr >= (void *)L1_DATA_B_START
> -                && addr < (void *)(L1_DATA_B_START + L1_DATA_B_LENGTH))
> +       if (addr >= (void *)get_l1_data_b_start()
> +                && addr < (void *)(get_l1_data_b_start() + L1_DATA_B_LENGTH))
>                return l1_data_B_sram_free(addr);
>        else
>  #endif
> @@ -384,17 +404,20 @@ void *l1_data_A_sram_alloc(size_t size)
>  {
>        unsigned long flags;
>        void *addr = NULL;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_data_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
>
>  #if L1_DATA_A_LENGTH != 0
> -       addr = _sram_alloc(size, &free_l1_data_A_sram_head,
> -                       &used_l1_data_A_sram_head);
> +       addr = _sram_alloc(size, &per_cpu(free_l1_data_A_sram_head, cpu),
> +                       &per_cpu(used_l1_data_A_sram_head, cpu));
>  #endif
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_data_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
> +       put_cpu();
>
>        pr_debug("Allocated address in l1_data_A_sram_alloc is 0x%lx+0x%lx\n",
>                 (long unsigned int)addr, size);
> @@ -407,19 +430,22 @@ int l1_data_A_sram_free(const void *addr)
>  {
>        unsigned long flags;
>        int ret;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_data_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
>
>  #if L1_DATA_A_LENGTH != 0
> -       ret = _sram_free(addr, &free_l1_data_A_sram_head,
> -                       &used_l1_data_A_sram_head);
> +       ret = _sram_free(addr, &per_cpu(free_l1_data_A_sram_head, cpu),
> +                       &per_cpu(used_l1_data_A_sram_head, cpu));
>  #else
>        ret = -1;
>  #endif
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_data_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
> +       put_cpu();
>
>        return ret;
>  }
> @@ -430,15 +456,18 @@ void *l1_data_B_sram_alloc(size_t size)
>  #if L1_DATA_B_LENGTH != 0
>        unsigned long flags;
>        void *addr;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_data_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
>
> -       addr = _sram_alloc(size, &free_l1_data_B_sram_head,
> -                       &used_l1_data_B_sram_head);
> +       addr = _sram_alloc(size, &per_cpu(free_l1_data_B_sram_head, cpu),
> +                       &per_cpu(used_l1_data_B_sram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_data_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
> +       put_cpu();
>
>        pr_debug("Allocated address in l1_data_B_sram_alloc is 0x%lx+0x%lx\n",
>                 (long unsigned int)addr, size);
> @@ -455,15 +484,18 @@ int l1_data_B_sram_free(const void *addr)
>  #if L1_DATA_B_LENGTH != 0
>        unsigned long flags;
>        int ret;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_data_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_data_sram_lock, cpu), flags);
>
> -       ret = _sram_free(addr, &free_l1_data_B_sram_head,
> -                       &used_l1_data_B_sram_head);
> +       ret = _sram_free(addr, &per_cpu(free_l1_data_B_sram_head, cpu),
> +                       &per_cpu(used_l1_data_B_sram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_data_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_data_sram_lock, cpu), flags);
> +       put_cpu();
>
>        return ret;
>  #else
> @@ -509,15 +541,18 @@ void *l1_inst_sram_alloc(size_t size)
>  #if L1_CODE_LENGTH != 0
>        unsigned long flags;
>        void *addr;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_inst_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_inst_sram_lock, cpu), flags);
>
> -       addr = _sram_alloc(size, &free_l1_inst_sram_head,
> -                       &used_l1_inst_sram_head);
> +       addr = _sram_alloc(size, &per_cpu(free_l1_inst_sram_head, cpu),
> +                       &per_cpu(used_l1_inst_sram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_inst_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_inst_sram_lock, cpu), flags);
> +       put_cpu();
>
>        pr_debug("Allocated address in l1_inst_sram_alloc is 0x%lx+0x%lx\n",
>                 (long unsigned int)addr, size);
> @@ -534,15 +569,18 @@ int l1_inst_sram_free(const void *addr)
>  #if L1_CODE_LENGTH != 0
>        unsigned long flags;
>        int ret;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1_inst_sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1_inst_sram_lock, cpu), flags);
>
> -       ret = _sram_free(addr, &free_l1_inst_sram_head,
> -                       &used_l1_inst_sram_head);
> +       ret = _sram_free(addr, &per_cpu(free_l1_inst_sram_head, cpu),
> +                       &per_cpu(used_l1_inst_sram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1_inst_sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1_inst_sram_lock, cpu), flags);
> +       put_cpu();
>
>        return ret;
>  #else
> @@ -556,15 +594,18 @@ void *l1sram_alloc(size_t size)
>  {
>        unsigned long flags;
>        void *addr;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1sram_lock, cpu), flags);
>
> -       addr = _sram_alloc(size, &free_l1_ssram_head,
> -                       &used_l1_ssram_head);
> +       addr = _sram_alloc(size, &per_cpu(free_l1_ssram_head, cpu),
> +                       &per_cpu(used_l1_ssram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1sram_lock, cpu), flags);
> +       put_cpu();
>
>        return addr;
>  }
> @@ -574,15 +615,18 @@ void *l1sram_alloc_max(size_t *psize)
>  {
>        unsigned long flags;
>        void *addr;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1sram_lock, cpu), flags);
>
> -       addr = _sram_alloc_max(&free_l1_ssram_head,
> -                       &used_l1_ssram_head, psize);
> +       addr = _sram_alloc_max(&per_cpu(free_l1_ssram_head, cpu),
> +                       &per_cpu(used_l1_ssram_head, cpu), psize);
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1sram_lock, cpu), flags);
> +       put_cpu();
>
>        return addr;
>  }
> @@ -592,15 +636,18 @@ int l1sram_free(const void *addr)
>  {
>        unsigned long flags;
>        int ret;
> +       unsigned int cpu;
>
> +       cpu = get_cpu();
>        /* add mutex operation */
> -       spin_lock_irqsave(&l1sram_lock, flags);
> +       spin_lock_irqsave(&per_cpu(l1sram_lock, cpu), flags);
>
> -       ret = _sram_free(addr, &free_l1_ssram_head,
> -                       &used_l1_ssram_head);
> +       ret = _sram_free(addr, &per_cpu(free_l1_ssram_head, cpu),
> +                       &per_cpu(used_l1_ssram_head, cpu));
>
>        /* add mutex operation */
> -       spin_unlock_irqrestore(&l1sram_lock, flags);
> +       spin_unlock_irqrestore(&per_cpu(l1sram_lock, cpu), flags);
> +       put_cpu();
>
>        return ret;
>  }
> @@ -761,33 +808,36 @@ static int sram_proc_read(char *buf, char **start, off_t offset, int count,
>                int *eof, void *data)
>  {
>        int len = 0;
> +       unsigned int cpu;
>
> -       if (_sram_proc_read(buf, &len, count, "Scratchpad",
> -                       &free_l1_ssram_head, &used_l1_ssram_head))
> -               goto not_done;
> +       for (cpu = 0; cpu < num_possible_cpus(); ++cpu) {
> +               if (_sram_proc_read(buf, &len, count, "Scratchpad",
> +                       &per_cpu(free_l1_ssram_head, cpu), &per_cpu(used_l1_ssram_head, cpu)))
> +                       goto not_done;
>  #if L1_DATA_A_LENGTH != 0
> -       if (_sram_proc_read(buf, &len, count, "L1 Data A",
> -                       &free_l1_data_A_sram_head,
> -                       &used_l1_data_A_sram_head))
> -               goto not_done;
> +               if (_sram_proc_read(buf, &len, count, "L1 Data A",
> +                       &per_cpu(free_l1_data_A_sram_head, cpu),
> +                       &per_cpu(used_l1_data_A_sram_head, cpu)))
> +                       goto not_done;
>  #endif
>  #if L1_DATA_B_LENGTH != 0
> -       if (_sram_proc_read(buf, &len, count, "L1 Data B",
> -                       &free_l1_data_B_sram_head,
> -                       &used_l1_data_B_sram_head))
> -               goto not_done;
> +               if (_sram_proc_read(buf, &len, count, "L1 Data B",
> +                       &per_cpu(free_l1_data_B_sram_head, cpu),
> +                       &per_cpu(used_l1_data_B_sram_head, cpu)))
> +                       goto not_done;
>  #endif
>  #if L1_CODE_LENGTH != 0
> -       if (_sram_proc_read(buf, &len, count, "L1 Instruction",
> -                       &free_l1_inst_sram_head, &used_l1_inst_sram_head))
> -               goto not_done;
> +               if (_sram_proc_read(buf, &len, count, "L1 Instruction",
> +                       &per_cpu(free_l1_inst_sram_head, cpu),
> +                       &per_cpu(used_l1_inst_sram_head, cpu)))
> +                       goto not_done;
>  #endif
> +       }
>  #if L2_LENGTH != 0
> -       if (_sram_proc_read(buf, &len, count, "L2",
> -                       &free_l2_sram_head, &used_l2_sram_head))
> +       if (_sram_proc_read(buf, &len, count, "L2", &free_l2_sram_head,
> +               &used_l2_sram_head))
>                goto not_done;
>  #endif
> -
>        *eof = 1;
>  not_done:
>        return len;
> --
> 1.5.6.3
>
