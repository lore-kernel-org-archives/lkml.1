Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbYBSSvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbYBSSvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYBSSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:51:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbYBSSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:51:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o2wIqdPzuhj6rSehjjYg22ZyVJFqIA1dndqs5wgH3QKXP3lT+gkWy8CqHhDq4KuRh
	Fk7W4go2MjPMu/+xM5laA==
Message-ID: <3f1a065b0802191051k2c89ecdek769c83d628fac4b4@mail.gmail.com>
Date: Tue, 19 Feb 2008 10:51:35 -0800
From: "Russell Leidich" <rml@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc2-mm1: build failure (x86)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pavel Machek" <pavel@suse.cz>, "Len Brown" <lenb@kernel.org>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>
In-Reply-To: <20080217095641.GB6054@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <20080216030949.5b11ba4c.akpm@linux-foundation.org>
	 <20080216113722.GA9041@joi> <200802170237.10816.rjw@sisk.pl>
	 <20080217095641.GB6054@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 1:56 AM, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> On Sun, Feb 17, 2008 at 02:37:09AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, 16 of February 2008, Marcin Slusarz wrote:
> > > On Sat, Feb 16, 2008 at 03:09:49AM -0800, Andrew Morton wrote:
> > > > On Sat, 16 Feb 2008 11:59:07 +0100 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > >
> > > > > arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> > > > > (.text+0xe03b): undefined reference to `mce_log_therm_throt_event'
> > > > > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > > > > (.text+0x12239): undefined reference to `setup_trampoline'
> > > > >
> > > > > #
> > > > > # Automatically generated make config: don't edit
> > > > > # Linux kernel version: 2.6.25-rc2-mm1
> > > > > # Sat Feb 16 11:32:49 2008
> > > >
> > > > ho hum, thanks.  I think I'll drop x86-amd-thermal-interrupt-support.patch.
> > > >  I don't think it's the final version anwyay.
> > > >
> > > Ok, I had to revert x86-remove-pt_regs-arg-from-smp_thermal_interrupt before x86-amd-thermal-interrupt-support.
> > >
> > > Second error vanished when I reverted "suspend: wakeup code in C".
> >
> > The appended patch should fix the second error.

Thanks for fixing this, Rafael.

I must admit that I'm puzzled as to why this should fail, since my
Kconfig change forces K8_NB=y when X86_MCE_AMD=y -- unless this is a
discussion of my earlier patch, which did not include this change.

Anyhow, I'm pleased that you've created a fix which seems to solve the problem.

> Yes, it did.
>
>
> > Thanks,
> > Rafael
> >
> > ---
> > On x86-64 the CPU trampoline code is now used while waking up from ACPI
> > suspend to RAM.  For this reason, make it depend on
> > (64BIT && ACPI_SLEEP) as well as on SMP, move the relevant declarations
> > to a separate header and move the definition of setup_trampoline() from
> > smpboot_64.c .
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/Kconfig             |    2 +-
> >  arch/x86/kernel/acpi/sleep.c |    1 -
> >  arch/x86/kernel/acpi/sleep.h |    3 ++-
> >  arch/x86/kernel/e820_64.c    |    5 +++--
> >  arch/x86/kernel/setup_64.c   |   16 ++++++++++++++++
> >  arch/x86/kernel/smpboot_64.c |   23 ++---------------------
> >  include/asm-x86/smp_64.h     |    2 --
> >  include/asm-x86/trampoline.h |   18 ++++++++++++++++++
> >  8 files changed, 42 insertions(+), 28 deletions(-)
> >
> > Index: linux-2.6.25-rc2-mm1/arch/x86/Kconfig
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/Kconfig
> > +++ linux-2.6.25-rc2-mm1/arch/x86/Kconfig
> > @@ -180,7 +180,7 @@ config X86_BIOS_REBOOT
> >
> >  config X86_TRAMPOLINE
> >       bool
> > -     depends on X86_SMP || (X86_VOYAGER && SMP)
> > +     depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
> >       default y
> >
> >  config KTIME_SCALAR
> > Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/e820_64.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/e820_64.c
> > +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/e820_64.c
> > @@ -27,6 +27,7 @@
> >  #include <asm/setup.h>
> >  #include <asm/sections.h>
> >  #include <asm/kdebug.h>
> > +#include <asm/trampoline.h>
> >
> >  struct e820map e820;
> >
> > @@ -58,8 +59,8 @@ struct early_res {
> >  };
> >  static struct early_res early_res[MAX_EARLY_RES] __initdata = {
> >       { 0, PAGE_SIZE, "BIOS data page" },                     /* BIOS data page */
> > -#ifdef CONFIG_SMP
> > -     { SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE, "SMP_TRAMPOLINE" },
> > +#ifdef CONFIG_X86_TRAMPOLINE
> > +     { TRAMPOLINE_BASE, TRAMPOLINE_BASE + 2 * PAGE_SIZE, "TRAMPOLINE" },
> >  #endif
> >       {}
> >  };
> > Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/smpboot_64.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/smpboot_64.c
> > +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/smpboot_64.c
> > @@ -59,6 +59,7 @@
> >  #include <asm/irq.h>
> >  #include <asm/hw_irq.h>
> >  #include <asm/numa.h>
> > +#include <asm/trampoline.h>
> >
> >  /* Number of siblings per CPU package */
> >  int smp_num_siblings = 1;
> > @@ -96,13 +97,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
> >  DEFINE_PER_CPU(cpumask_t, cpu_core_map);
> >  EXPORT_PER_CPU_SYMBOL(cpu_core_map);
> >
> > -/*
> > - * Trampoline 80x86 program as an array.
> > - */
> > -
> > -extern const unsigned char trampoline_data[];
> > -extern const unsigned char trampoline_end[];
> > -
> >  /* State of each CPU */
> >  DEFINE_PER_CPU(int, cpu_state) = { 0 };
> >
> > @@ -127,19 +121,6 @@ struct task_struct *idle_thread_array[NR
> >
> >
> >  /*
> > - * Currently trivial. Write the real->protected mode
> > - * bootstrap into the page concerned. The caller
> > - * has made sure it's suitably aligned.
> > - */
> > -
> > -unsigned long __cpuinit setup_trampoline(void)
> > -{
> > -     void *tramp = __va(SMP_TRAMPOLINE_BASE);
> > -     memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
> > -     return virt_to_phys(tramp);
> > -}
> > -
> > -/*
> >   * The bootstrap kernel entry code has set these up. Save them for
> >   * a given CPU
> >   */
> > @@ -690,7 +671,7 @@ do_rest:
> >                       Dprintk("CPU has booted.\n");
> >               } else {
> >                       boot_error = 1;
> > -                     if (*((volatile unsigned char *)phys_to_virt(SMP_TRAMPOLINE_BASE))
> > +                     if (*((unsigned char *)phys_to_virt(TRAMPOLINE_BASE))
> >                                       == 0xA5)
> >                               /* trampoline started but...? */
> >                               printk("Stuck ??\n");
> > Index: linux-2.6.25-rc2-mm1/include/asm-x86/smp_64.h
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/include/asm-x86/smp_64.h
> > +++ linux-2.6.25-rc2-mm1/include/asm-x86/smp_64.h
> > @@ -47,8 +47,6 @@ static inline int cpu_present_to_apicid(
> >
> >  #ifdef CONFIG_SMP
> >
> > -#define SMP_TRAMPOLINE_BASE 0x6000
> > -
> >  extern int __cpu_disable(void);
> >  extern void __cpu_die(unsigned int cpu);
> >  extern void prefill_possible_map(void);
> > Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/sleep.h
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/acpi/sleep.h
> > +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/sleep.h
> > @@ -2,6 +2,8 @@
> >   *   Variables and functions used by the code in sleep.c
> >   */
> >
> > +#include <asm/trampoline.h>
> > +
> >  extern char wakeup_code_start, wakeup_code_end;
> >
> >  extern unsigned long saved_video_mode;
> > @@ -13,5 +15,4 @@ extern int wakeup_pmode_return;
> >  extern char swsusp_pg_dir[PAGE_SIZE];
> >
> >  extern unsigned long acpi_copy_wakeup_routine(unsigned long);
> > -extern unsigned long setup_trampoline(void);
> >  extern void wakeup_long64(void);
> > Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/setup_64.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/setup_64.c
> > +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/setup_64.c
> > @@ -66,6 +66,7 @@
> >  #include <asm/mce.h>
> >  #include <asm/ds.h>
> >  #include <asm/topology.h>
> > +#include <asm/trampoline.h>
> >
> >  #ifdef CONFIG_PARAVIRT
> >  #include <asm/paravirt.h>
> > @@ -1184,3 +1185,18 @@ const struct seq_operations cpuinfo_op =
> >       .stop = c_stop,
> >       .show = show_cpuinfo,
> >  };
> > +
> > +#ifdef CONFIG_X86_TRAMPOLINE
> > +/*
> > + * Currently trivial. Write the real->protected mode
> > + * bootstrap into the page concerned. The caller
> > + * has made sure it's suitably aligned.
> > + */
> > +
> > +unsigned long setup_trampoline(void)
> > +{
> > +     void *tramp = __va(TRAMPOLINE_BASE);
> > +     memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
> > +     return virt_to_phys(tramp);
> > +}
> > +#endif /* CONFIG_X86_TRAMPOLINE */
> > Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/sleep.c
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/acpi/sleep.c
> > +++ linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/sleep.c
> > @@ -10,7 +10,6 @@
> >  #include <linux/dmi.h>
> >  #include <linux/cpumask.h>
> >
> > -#include <asm/smp.h>
> >  #include "realmode/wakeup.h"
> >  #include "sleep.h"
> >
> > Index: linux-2.6.25-rc2-mm1/include/asm-x86/trampoline.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.25-rc2-mm1/include/asm-x86/trampoline.h
> > @@ -0,0 +1,18 @@
> > +#ifndef __TRAMPOLINE_HEADER
> > +#define __TRAMPOLINE_HEADER
> > +
> > +#ifndef __ASSEMBLY__
> > +
> > +#define TRAMPOLINE_BASE 0x6000
> > +
> > +/*
> > + * Trampoline 80x86 program as an array.
> > + */
> > +extern const unsigned char trampoline_data[];
> > +extern const unsigned char trampoline_end[];
> > +
> > +extern unsigned long setup_trampoline(void);
> > +
> > +#endif /* __ASSEMBLY__ */
> > +
> > +#endif /* __TRAMPOLINE_HEADER */
>



-- 
Russell Leidich
