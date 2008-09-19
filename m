Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYISUjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYISUjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYISUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:39:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:52202 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbYISUjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:39:14 -0400
Message-ID: <48D40DE7.8010107@windriver.com>
Date: Fri, 19 Sep 2008 15:39:03 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH] [kgdb]switch master cpu after gdb thread command for
 SMP
References: <1221554235.15380.16.camel@eight.analog.com>
In-Reply-To: <1221554235.15380.16.camel@eight.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 20:39:02.0894 (UTC) FILETIME=[C082A0E0:01C91A97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sonic zhang wrote:
>  In blackfin SMP architecture, different core has its own L1 SRAM and MMR
>  memory, which code running on the other core can't access. In current kgdb
>  impelemntation, cpus are represented by thread with minus prefix.
>
> If user wants gdb to switch to the thread of the other cpu, kgdb should:
> 1. signal current master cpu to enter kgdb_wait
> 2. release the specific waiting passive cpu
> 3. exit kgdb exception loop on current master cpu
> 4. trap the release cpu into kgdb exception loop
>

This definitely seems reasonable for the blackfin architecture, but
will definitely not work correctly for the present set of kgdb
architectures.

Each architecture specific stub can make use of a flags variable IE:

struct kgdb_arch arch_kgdb_ops = {
    /* Breakpoint instruction: */
    .gdb_bpt_instr        = { 0xcc },
    .flags            = KGDB_HW_BREAKPOINT,

Given that other architectures might want to make use of the swapping
functionality can be enabled / disabled by adding another flag to the
bit mask in include/linux/kgdb.h

Right now the only flag is KGDB_HW_BREAKPOINT, but you can add something
like:

#define KGDB_HW_BREAKPOINT 0x1
#define KGDB_THR_PROC_SWAP 0x2


> The kgdb arch implementation with SMP support should include function
> kgdb_roundup_cpu().


Yup I agree.


>
>
> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
> ---
>  kernel/kgdb.c        |   32 ++++++++++++++++++++++++++++++--
>
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -566,6 +566,7 @@ static void kgdb_wait(struct pt_regs *regs)
>  {
>      unsigned long flags;
>      int cpu;
> +    struct task_struct *thread;
> 
>      local_irq_save(flags);
>      cpu = raw_smp_processor_id();
> @@ -585,6 +586,15 @@ static void kgdb_wait(struct pt_regs *regs)
>      kgdb_info[cpu].debuggerinfo = NULL;
>      kgdb_info[cpu].task = NULL;
> 


This would have to be enclosed in:

if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) {
  ...



> +    /* Trap into kgdb as the active CPU if gdb asks to switch. */
> +    thread = getthread(regs, -raw_smp_processor_id() - 2);
> +    if (kgdb_usethread && kgdb_usethread == thread) {
> +        kgdb_breakpoint();
> +        clocksource_touch_watchdog();
> +        local_irq_restore(flags);
> +        return;
> +    }
> +
>      /* fix up hardware debug registers on local cpu */
>      if (arch_kgdb_ops.correct_hw_break)
>          arch_kgdb_ops.correct_hw_break();
> @@ -1072,7 +1082,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
>  }
> 
>  /* Handle the 'H' task query packets */
> -static void gdb_cmd_task(struct kgdb_state *ks)
> +static int gdb_cmd_task(struct kgdb_state *ks)
>  {
>      struct task_struct *thread;
>      char *ptr;
> @@ -1089,6 +1099,13 @@ static void gdb_cmd_task(struct kgdb_state *ks)
>          kgdb_usethread = thread;
>          ks->kgdb_usethreadid = ks->threadid;
>          strcpy(remcom_out_buffer, "OK");

if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) {
  ...


> +#ifdef CONFIG_SMP
> +        if (ks->kgdb_usethreadid < -1 &&
> +            ks->kgdb_usethreadid + 2 != -raw_smp_processor_id()) {
> +            kgdb_roundup_cpu(-ks->kgdb_usethreadid - 2);
> +            return 1;
> +        }
> +#endif
>          break;
>      case 'c':
>          ptr = &remcom_in_buffer[2];
> @@ -1106,6 +1123,8 @@ static void gdb_cmd_task(struct kgdb_state *ks)
>          strcpy(remcom_out_buffer, "OK");
>          break;
>      }
> +
> +    return 0;
>  }
> 
>  /* Handle the 'T' thread query packets */
> @@ -1284,7 +1303,8 @@ static int gdb_serial_stub(struct kgdb_state *ks)
>              gdb_cmd_query(ks);
>              break;
>          case 'H': /* task related */
> -            gdb_cmd_task(ks);
> +            if (gdb_cmd_task(ks))
> +                goto default_handle;
>              break;
>          case 'T': /* Query thread status */
>              gdb_cmd_thread(ks);
> @@ -1509,6 +1529,14 @@ acquirelock:
>      kgdb_info[ks->cpu].task = NULL;
>      atomic_set(&cpu_in_kgdb[ks->cpu], 0);
> 

And you need to stick this logic in here too.

if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) {
  ...


> +#ifdef CONFIG_SMP
> +    i = -(ks->kgdb_usethreadid + 2);
> +    if (ks->kgdb_usethreadid < -1 && i != cpu) {
> +        atomic_set(&passive_cpu_wait[i], 0);
> +        while (atomic_read(&cpu_in_kgdb[i]))
> +            cpu_relax();
> +    } else
> +#endif
>      if (!kgdb_single_step || !kgdb_contthread) {
>          for (i = NR_CPUS-1; i >= 0; i--)
>              atomic_set(&passive_cpu_wait[i], 0);



I am going ask if you tested switching back and forth between threads
several times? 

It was not immediately obvious it would actually work by looking at
the top level kernel/kgdb.c file.  For the non-black blackfin
architectures this would cause nested exceptions with the second kgdb
roundup call as well as exec'ing a breakpoint from the kgdb_wait()
which is already in the exception context on non blackfin archs. For
the blackfin arch you would obviously have to have something that to
recover from the nested exceptions, which is arch specific.

The current incarnation of kgdb just doesn't have support in it to
switch core context and make a different core the "master".  If you
want to consider doing something more generic, it would require a bit
of refactoring such that all the cores get into the same busy loop and
the master core can return to this loop while another is changed to
the master core.  This will allow you to not have to issue a
breakpoint, and you can keep the system stopped, while you switch to a
different core context.


The design would look something like what is shown below, noting that
you will still need to do something special to elect the first
processor and deal with the race of a cpu making it back in before
others are done.

all_cpu_handle_exception() {
   handle_race_of_re_entering_processor_while_others_are_exiting;

   master = ATOMIC_FIRST_CPU_X;
   signal_all_other_cpus_to_stop_if_I_am_the_master();

   while(keep_debugging) {
      if (all_processors_here) {
          if (i_am_master)
              gdb_stub();
      /* A master can elect a new master
           * and return here */
      }
      cpu_relax();
   }

   helper_loop_to_handle_re_entry_race;

   return system_to_good_state;
}

Jason.

