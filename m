Return-Path: <linux-kernel-owner+w=401wt.eu-S1765634AbYBZXNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765634AbYBZXNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763483AbYBZXMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:12:54 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:59015 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbYBZXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:12:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMsrxEdMQWRV/2dsb2JhbACBVqxO
Date: Tue, 26 Feb 2008 18:12:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080226231248.GA32455@Krystal>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080226225242.GA15926@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:00:35 up 15 days, 19:01,  4 users,  load average: 0.41, 1.12,
	0.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Sat, Feb 02, 2008 at 04:08:29PM -0500, Mathieu Desnoyers wrote:
> > Changelog:
> > 
> > - section __imv is already SHF_ALLOC
> > - Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
> >   the if (immediateindex) is unnecessary here.
> > - Remove module_mutex usage: depend on functions implemented in module.c for
> >   that.
> 
> hi,
> 
> In testing this patch, i've run across a deadlock...apply_imv_update() can get
> called again before, ipi_busy_loop() has had a chance to finsh, and set 
> wait_sync back to its initial value. This causes ipi_busy_loop() to get stuck
> indefinitely and the subsequent apply_imv_update() hangs. I've shown this 
> deadlock below using nmi_watchdog=1 in item 1). 
> 

Hrm, yes, Jan pointed out the exact same problem in my ltt-test-tsc TSC
test module in LTTng a few days ago. His fix implied to add another
barrier upon which the smp_call_function() caller must wait for the ipis
to finish. Since this immediate value code does the same I did in my
ltt-test-tsc code, the same fix will likely apply.

I'll cook something.

Hrm, does your stop machine implementation disable interrupts while the
CPUs busy loop ?

> After hitting this deadlock i modified apply_imv_update() to wait for 
> ipi_busy_loop(), to finish, however this resulted in a 3 way deadlock. Process
> A held a read lock on tasklist_lock, then process B called apply_imv_update().
> Process A received the IPI and begins executing ipi_busy_loop(). Then process
> C takes a write lock irq on the task list lock, before receiving the IPI. Thus,
> process A holds up process C, and C can't get an IPI b/c interrupts are
> disabled. i believe this is an inherent problem in using smp_call_function, in
> that one can't synchronize the processes on each other...you can reproduce
> these issues using the test module below item 2)
> 
> In order to address these issues, i've modified stop_machine_run() to take an
> new third parameter, RUN_ALL, to allow stop_machine_run() to run a function
> on all cpus, item 3). I then modified kernel/immediate.c to use this new 
> infrastructure item 4). the code in immediate.c simplifies quite a bit. This
> new code has been robust through all testing thus far.
> 
> thanks,
> 
> -Jason
> 
> 1)
> 
>  NMI Watchdog detected LOCKUP on CPU 3
> CPU 3
> Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 0, comm: swapper Not tainted 2.6.24-git12markers #1
> RIP: 0010:[<ffffffff8106e7cc>]  [<ffffffff8106e7cc>] ipi_busy_loop+0x19/0x41
> RSP: 0018:ffff81007fbdff70  EFLAGS: 00000002
> RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffff81007fbd2930
> RDX: ffffffff81491b80 RSI: 0000000000000046 RDI: 0000000000000000
> RBP: ffff81007fbdff78 R08: ffff81007fbdff78 R09: ffff81007dd91e80
> R10: ffff810001030b80 R11: 0000000000000246 R12: ffffffff8106e7b3
> R13: 0000000000000000 R14: ffffffff81491a80 R15: ffff810001030a80
> FS:  0000000000000000(0000) GS:ffff81007f801c80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000025e8d68 CR3: 000000007549c000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff81007fbd6000, task ffff81007fbd2930)
> Stack:  0000000000000000 ffff81007fbdffa8 ffffffff8101ca4e ffff81007fbdffa8
>  ffffffff8100b0e2 0000000000000003 0000000000000040 ffff81007fbd7e60
>  ffffffff8100cac6 ffff81007fbd7e60 <EOI>  ffff81007fbd7ee8 0000000000000246
> Call Trace:
>  <IRQ>  [<ffffffff8101ca4e>] smp_call_function_interrupt+0x48/0x71
>  [<ffffffff8100b0e2>] ? mwait_idle+0x0/0x4a
>  [<ffffffff8100cac6>] call_function_interrupt+0x66/0x70
>  <EOI>  [<ffffffff8100b127>] ? mwait_idle+0x45/0x4a
>  [<ffffffff8100a723>] ? enter_idle+0x22/0x24
>  [<ffffffff8100b06f>] ? cpu_idle+0x97/0xc1
>  [<ffffffff81270a35>] ? start_secondary+0x3ba/0x3c6
> 
> 
> ---[ end trace 738433437d960ebc ]---
> NMI Watchdog detected LOCKUP on CPU 2
> CPU 2
> Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 9704, comm: toggle-writer Not tainted 2.6.24-git12markers #1
> RIP: 0010:[<ffffffff8101c717>]  [<ffffffff8101c717>] __smp_call_function_mask+0x9f/0xc1
> RSP: 0018:ffff81003ac35da8  EFLAGS: 00000297
> RAX: 00000000000008fc RBX: 000000000000000b RCX: 00000000000008fc
> RDX: 00000000000008fc RSI: 00000000000000fc RDI: 000000000000000b
> RBP: ffff81003ac35e08 R08: ffffffff8840504f R09: 00007f01f07696f0
> R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff8106e7b3
> FS:  00007f01f07696f0(0000) GS:ffff81007f801980(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f01f0796000 CR3: 000000006bcdf000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process toggle-writer (pid: 9704, threadinfo ffff81003ac34000, task ffff81003ad14930)
> Stack:  ffffffff8106e7b3 0000000000000000 0000000000000002 00003fff00000000
>  000000000000000b ffffffff81075c03 00000010001280d2 0000000000000000
>  0000000000000000 ffffffff8106e7b3 000000000000000f 0000000000000005
> Call Trace:
>  [<ffffffff8106e7b3>] ? ipi_busy_loop+0x0/0x41
>  [<ffffffff81075c03>] ? __alloc_pages+0x8e/0x337
>  [<ffffffff8106e7b3>] ? ipi_busy_loop+0x0/0x41
>  [<ffffffff8101c783>] smp_call_function_mask+0x4a/0x59
>  [<ffffffff8101c7ab>] smp_call_function+0x19/0x1b
>  [<ffffffff8106e703>] imv_update_range+0xd7/0x16e
>  [<ffffffff8105494e>] _module_imv_update+0x35/0x54
>  [<ffffffff81054982>] module_imv_update+0x15/0x23
>  [<ffffffff884050c4>] :toggle_tester:proc_toggle_write+0x4c/0x64
>  [<ffffffff810d64a4>] proc_reg_write+0x7b/0x96
>  [<ffffffff81099f72>] vfs_write+0xae/0x157
>  [<ffffffff8109a53f>] sys_write+0x47/0x70
>  [<ffffffff8100c0e9>] tracesys+0xdc/0xe1
> 
> Code: f8 48 3b 5d c0 48 8b 05 28 1a 41 00 75 0a bf fc 00 00 00 ff 50 38 eb 0f be fc 00 00 00 48
> ---[ end trace 738433437d960ebc ]---
> NMI Watchdog detected LOCKUP on CPU 1
> CPU 1
> Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 0, comm: swapper Not tainted 2.6.24-git12markers #1
> RIP: 0010:[<ffffffff8106e7cc>]  [<ffffffff8106e7cc>] ipi_busy_loop+0x19/0x41
> RSP: 0018:ffff81007fb6ff70  EFLAGS: 00000002
> RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffff81007fb5f260
> RDX: ffffffff81491b80 RSI: 0000000000000046 RDI: 0000000000000000
> RBP: ffff81007fb6ff78 R08: ffff81007fb6ff78 R09: ffff810001016700
> R10: ffff810001018b80 R11: 0000000000000001 R12: ffffffff8106e7b3
> R13: 0000000000000000 R14: ffffffff81491a80 R15: ffff810001018a80
> FS:  0000000000000000(0000) GS:ffff81007f801680(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000031fac9ac20 CR3: 00000000778e6000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff81007fb6a000, task ffff81007fb5f260)
> Stack:  0000000000000000 ffff81007fb6ffa8 ffffffff8101ca4e ffff81007fb6ffa8
>  ffffffff8100b0e2 0000000000000001 0000000000000040 ffff81007fb6be60
>  ffffffff8100cac6 ffff81007fb6be60 <EOI>  ffff81007fb6bee8 0000000000000001
> Call Trace:
>  <IRQ>  [<ffffffff8101ca4e>] smp_call_function_interrupt+0x48/0x71
>  [<ffffffff8100b0e2>] ? mwait_idle+0x0/0x4a
>  [<ffffffff8100cac6>] call_function_interrupt+0x66/0x70
>  <EOI>  [<ffffffff8100b127>] ? mwait_idle+0x45/0x4a
>  [<ffffffff8100a723>] ? enter_idle+0x22/0x24
>  [<ffffffff8100b06f>] ? cpu_idle+0x97/0xc1
>  [<ffffffff81270a35>] ? start_secondary+0x3ba/0x3c6
> 
> Code: 81 48 c7 c7 02 fd 36 81 48 89 e5 e8 7b fe ff ff c9 c3 55 48 89 e5 53 9c 5e fa f0 ff 0d 82
> ---[ end trace 738433437d960ebc ]---
> NMI Watchdog detected LOCKUP on CPU 0
> Kernel panic - not syncing: Aiee, killing interrupt handler!
> CPU 0
> Modules linked in: toggle_tester ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf]Pid: 0, comm: swapper Not tainted 2.6.24-git12markers #1
> RIP: 0010:[<ffffffff8106e7e6>]  [<ffffffff8106e7e6>] ipi_busy_loop+0x33/0x41
> RSP: 0018:ffffffff81498f70  EFLAGS: 00000006
> RAX: 0000000000000004 RBX: 0000000000000000 RCX: ffffffff81394620
> RDX: ffffffff81491b80 RSI: 0000000000000046 RDI: 0000000000000000
> RBP: ffffffff81498f78 R08: ffffffff81498f78 R09: ffff810062cc1e98
> R10: ffff81000100cb80 R11: ffff810062cc1d58 R12: ffffffff8106e7b3
> R13: 0000000000000000 R14: ffffffff81466640 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff813d2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000031fac6f060 CR3: 0000000000201000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff81434000, task ffffffff81394620)
> Stack:  0000000000000000 ffffffff81498fa8 ffffffff8101ca4e ffffffff8100b0e2
>  ffffffff8100b0e2 0000000000000000 ffffffffffffffff ffffffff81435ec0
>  ffffffff8100cac6 ffffffff81435ec0 <EOI>  ffffffff81435f48 ffff810062cc1d58
> Call Trace:
>  <IRQ>  [<ffffffff8101ca4e>] smp_call_function_interrupt+0x48/0x71
>  [<ffffffff8100b0e2>] ? mwait_idle+0x0/0x4a
>  [<ffffffff8100b0e2>] ? mwait_idle+0x0/0x4a
>  [<ffffffff8100cac6>] call_function_interrupt+0x66/0x70
>  <EOI>  [<ffffffff8100b127>] ? mwait_idle+0x45/0x4a
>  [<ffffffff8100a723>] ? enter_idle+0x22/0x24
>  [<ffffffff8100b06f>] ? cpu_idle+0x97/0xc1
>  [<ffffffff81266ee6>] ? rest_init+0x5a/0x5c
> 
> Code: f0 ff 0d 82 6b 49 00 0f ae f0 48 63 05 78 6b 49 00 48 3b 05 5d 6b 49 00 7f ed f0 ff 0d 68
> ---[ end trace 738433437d960ebc ]---
> 
> 
> 2)
> 
> 
> --- /dev/null
> +++ b/samples/markers/toggle-tester.c
> @@ -0,0 +1,90 @@
> +/* probe-example.c
> + *
> + * toggle module to test immedidate infrastructure.
> + *
> + * (C) Copyright 2007 Jason Baron <jbaron@redhat.com>
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/marker.h>
> +#include <asm/atomic.h>
> +#include <linux/seq_file.h>
> +#include <linux/fs.h>
> +#include <linux/proc_fs.h>
> +
> +static DECLARE_MUTEX(toggle_mutex);
> +DEFINE_IMV(char, toggle_value) = 0;
> +
> +static ssize_t proc_toggle_write(struct file *file, const char __user *buf,
> +                                size_t length, loff_t *ppos)
> +{
> +	int i;
> +
> +	down(&toggle_mutex);
> +	i = imv_read(toggle_value);
> +	imv_set(toggle_value, !i);
> +	up(&toggle_mutex);
> +
> +	return 0;
> +}
> +
> +static int proc_toggle_show(struct seq_file *s, void *p)
> +{
> +	int i;
> +
> +	down(&toggle_mutex);        
> +        i = imv_read(toggle_value);
> +	up(&toggle_mutex);
> +
> +	seq_printf(s, "%u\n", i);
> +
> +        return 0;
> +}
> +
> +
> +static int proc_toggle_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, proc_toggle_show, NULL);
> +}
> +
> +
> +static const struct file_operations toggle_operations = {
> +	.open           = proc_toggle_open,
> +	.read           = seq_read,
> +	.write          = proc_toggle_write,
> +	.llseek         = seq_lseek,
> +	.release        = single_release,
> +};
> +	
> +
> +struct proc_dir_entry *pde;
> +
> +static int __init toggle_init(void)
> +{
> +	
> +	pde = create_proc_entry("toggle", 0, NULL);
> +	if (!pde)
> +		return -ENOMEM;
> +	pde->proc_fops = &toggle_operations;
> +
> +
> +	return 0;
> +}
> +
> +static void __exit toggle_fini(void)
> +{
> +	remove_proc_entry("toggle", &proc_root);
> +	
> +}
> +
> +module_init(toggle_init);
> +module_exit(toggle_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jason Baron");
> +MODULE_DESCRIPTION("testing immediate implementation");
> 
> 
> 3)
> 
> 
> diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> index 5bfc553..1ab1c5b 100644
> --- a/include/linux/stop_machine.h
> +++ b/include/linux/stop_machine.h
> @@ -8,6 +8,9 @@
>  #include <asm/system.h>
>  
>  #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
> +
> +#define RUN_ALL ~0U
> +
>  /**
>   * stop_machine_run: freeze the machine on all CPUs and run this function
>   * @fn: the function to run
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 51b5ee5..e6ee46f 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -23,9 +23,17 @@ enum stopmachine_state {
>  	STOPMACHINE_WAIT,
>  	STOPMACHINE_PREPARE,
>  	STOPMACHINE_DISABLE_IRQ,
> +	STOPMACHINE_RUN,
>  	STOPMACHINE_EXIT,
>  };
>  
> +struct stop_machine_data {
> +	int (*fn)(void *);
> +	void *data;
> +	struct completion done;
> +	int run_all;
> +} smdata;
> +
>  static enum stopmachine_state stopmachine_state;
>  static unsigned int stopmachine_num_threads;
>  static atomic_t stopmachine_thread_ack;
> @@ -35,6 +43,7 @@ static int stopmachine(void *cpu)
>  {
>  	int irqs_disabled = 0;
>  	int prepared = 0;
> +	int ran = 0;
>  
>  	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
>  
> @@ -59,6 +68,11 @@ static int stopmachine(void *cpu)
>  			prepared = 1;
>  			smp_mb(); /* Must read state first. */
>  			atomic_inc(&stopmachine_thread_ack);
> +		} else if (stopmachine_state == STOPMACHINE_RUN && !ran) {
> +			smdata.fn(smdata.data);
> +			ran = 1;
> +			smp_mb(); /* Must read state first. */
> +			atomic_inc(&stopmachine_thread_ack);
>  		}
>  		/* Yield in first stage: migration threads need to
>  		 * help our sisters onto their CPUs. */
> @@ -136,12 +150,10 @@ static void restart_machine(void)
>  	preempt_enable_no_resched();
>  }
>  
> -struct stop_machine_data
> +static void run_other_cpus(void)
>  {
> -	int (*fn)(void *);
> -	void *data;
> -	struct completion done;
> -};
> +	stopmachine_set_state(STOPMACHINE_RUN);
> +}
>  
>  static int do_stop(void *_smdata)
>  {
> @@ -151,6 +163,8 @@ static int do_stop(void *_smdata)
>  	ret = stop_machine();
>  	if (ret == 0) {
>  		ret = smdata->fn(smdata->data);
> +		if (smdata->run_all)
> +			run_other_cpus();
>  		restart_machine();
>  	}
>  
> @@ -170,17 +184,16 @@ static int do_stop(void *_smdata)
>  struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
>  				       unsigned int cpu)
>  {
> -	struct stop_machine_data smdata;
>  	struct task_struct *p;
>  
> +	down(&stopmachine_mutex);
>  	smdata.fn = fn;
>  	smdata.data = data;
> +	smdata.run_all = (cpu == RUN_ALL) ? 1 : 0;
>  	init_completion(&smdata.done);
> -
> -	down(&stopmachine_mutex);
> -
> +	smp_wmb();
>  	/* If they don't care which CPU fn runs on, bind to any online one. */
> -	if (cpu == NR_CPUS)
> +	if (cpu == NR_CPUS || cpu == RUN_ALL)
>  		cpu = raw_smp_processor_id();
>  
>  	p = kthread_create(do_stop, &smdata, "kstopmachine");
> 
> 
> 4)
> 
> 
> diff --git a/kernel/immediate.c b/kernel/immediate.c
> index 4c36a89..39ec13e 100644
> --- a/kernel/immediate.c
> +++ b/kernel/immediate.c
> @@ -20,6 +20,7 @@
>  #include <linux/immediate.h>
>  #include <linux/memory.h>
>  #include <linux/cpu.h>
> +#include <linux/stop_machine.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -30,6 +31,23 @@ static int imv_early_boot_complete;
>  
>  extern const struct __imv __start___imv[];
>  extern const struct __imv __stop___imv[];
> +int started;
> +
> +int stop_machine_imv_update(void *imv_ptr)
> +{
> +	struct __imv *imv = imv_ptr;
> +
> +	if (!started) {
> +		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
> +		started = 1;
> +		smp_wmb();
> +	} else
> +		sync_core();
> +
> +	flush_icache_range(imv->imv, imv->imv + imv->size);
> +
> +	return 0;
> +}
>  
>  /*
>   * imv_mutex nests inside module_mutex. imv_mutex protects builtin
> @@ -37,38 +55,6 @@ extern const struct __imv __stop___imv[];
>   */
>  static DEFINE_MUTEX(imv_mutex);
>  
> -static atomic_t wait_sync;
> -
> -struct ipi_loop_data {
> -	long value;
> -	const struct __imv *imv;
> -} loop_data;
> -
> -static void ipi_busy_loop(void *arg)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	atomic_dec(&wait_sync);
> -	do {
> -		/* Make sure the wait_sync gets re-read */
> -		smp_mb();
> -	} while (atomic_read(&wait_sync) > loop_data.value);
> -	atomic_dec(&wait_sync);
> -	do {
> -		/* Make sure the wait_sync gets re-read */
> -		smp_mb();
> -	} while (atomic_read(&wait_sync) > 0);
> -	/*
> -	 * Issuing a synchronizing instruction must be done on each CPU before
> -	 * reenabling interrupts after modifying an instruction. Required by
> -	 * Intel's errata.
> -	 */
> -	sync_core();
> -	flush_icache_range(loop_data.imv->imv,
> -		loop_data.imv->imv + loop_data.imv->size);
> -	local_irq_restore(flags);
> -}
>  
>  /**
>   * apply_imv_update - update one immediate value
> @@ -82,9 +68,6 @@ static void ipi_busy_loop(void *arg)
>   */
>  static int apply_imv_update(const struct __imv *imv)
>  {
> -	unsigned long flags;
> -	long online_cpus;
> -
>  	/*
>  	 * If the variable and the instruction have the same value, there is
>  	 * nothing to do.
> @@ -111,30 +94,8 @@ static int apply_imv_update(const struct __imv *imv)
>  
>  	if (imv_early_boot_complete) {
>  		kernel_text_lock();
> -		get_online_cpus();
> -		online_cpus = num_online_cpus();
> -		atomic_set(&wait_sync, 2 * online_cpus);
> -		loop_data.value = online_cpus;
> -		loop_data.imv = imv;
> -		smp_call_function(ipi_busy_loop, NULL, 1, 0);
> -		local_irq_save(flags);
> -		atomic_dec(&wait_sync);
> -		do {
> -			/* Make sure the wait_sync gets re-read */
> -			smp_mb();
> -		} while (atomic_read(&wait_sync) > online_cpus);
> -		text_poke((void *)imv->imv, (void *)imv->var,
> -				imv->size);
> -		/*
> -		 * Make sure the modified instruction is seen by all CPUs before
> -		 * we continue (visible to other CPUs and local interrupts).
> -		 */
> -		wmb();
> -		atomic_dec(&wait_sync);
> -		flush_icache_range(imv->imv,
> -				imv->imv + imv->size);
> -		local_irq_restore(flags);
> -		put_online_cpus();
> +		started = 0;
> +		stop_machine_run(stop_machine_imv_update, (void *)imv, RUN_ALL);
>  		kernel_text_unlock();
>  	} else
>  		text_poke_early((void *)imv->imv, (void *)imv->var,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
