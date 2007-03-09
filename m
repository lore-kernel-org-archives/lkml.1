Return-Path: <linux-kernel-owner+w=401wt.eu-S1767456AbXCIS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767456AbXCIS2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767457AbXCIS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:28:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:36909 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767456AbXCIS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:28:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=OnfEN7hTmxieH+dFQcl4TB4BLojftlaj+VLK2R0VDmxN3TS6XU20WIwUyLUseSKwy1jQXFOXNQLNgwWfk3nnEChqYa++EZxTErabSuGEYgbaGd4tHaEa14Au8zcY6lovlmsSgQ78TCo9UVUPzrXjRJzS83eunETyVGQhhYr6MDg=
Message-ID: <45F1A744.2060607@googlemail.com>
Date: Fri, 09 Mar 2007 19:28:20 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc3-rt0
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get a lot of
"NOHZ: local_softirq_pending 02"

and I have noticed some swsuspend problems.

Disabling non-boot CPUs ...
CPU1 playing dead
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c010213a>] cpu_idle+0x91/0x126
 [<c01156ec>] start_secondary+0x30d/0x315
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c01021c4>] .... cpu_idle+0x11b/0x126
.....[<c01156ec>] ..   ( <= start_secondary+0x30d/0x315)

l *0xc01021c4
0xc01021c4 is in cpu_idle (arch/i386/kernel/process.c:204).
199                     tick_nohz_restart_sched_tick();
200                     local_irq_disable();
201                     __preempt_enable_no_resched();
202                     __schedule();
203                     preempt_disable();
204                     local_irq_enable();
205             }
206     }
207
208     void cpu_idle_wait(void)

 l *0xc01156ec
0xc01156ec is in start_secondary (arch/i386/kernel/smpboot.c:432).
427             /* We can take interrupts now: we're officially "up". */
428             local_irq_enable();
429
430             wmb();
431             cpu_idle();
432     }
433
434     /*
435      * Everything has been set up for the secondary
436      * CPUs - they just need to reload everything


CPU 1 is now offline
lockdep: not fixing up alternatives.
stopped custom tracer.

=============================================
[ INFO: possible recursive locking detected ]
[ 2.6.21-rc3-rt0 #1
---------------------------------------------
swsusp_shutdown/3406 is trying to acquire lock:
 ((raw_spinlock_t *)(&lock->wait_lock)){--..}, at: [<c01329cd>] migrate_timers+0x8b/0x16e

but task is already holding lock:
 ((raw_spinlock_t *)(&lock->wait_lock)){--..}, at: [<c01329b9>] migrate_timers+0x77/0x16e

l *0xc01329cd
0xc01329cd is in migrate_timers (kernel/timer.c:1854).
1849
1850            local_irq_disable_nort();
1851            double_spin_lock(&new_base->lock, &old_base->lock,
1852                             smp_processor_id() < cpu);
1853
1854            BUG_ON(old_base->running_timer);
1855
1856            for (i = 0; i < TVR_SIZE; i++)
1857                    migrate_timer_list(new_base, old_base->tv1.vec + i);
1858            for (i = 0; i < TVN_SIZE; i++) {

l *0xc01329b9
0xc01329b9 is in migrate_timers (include/linux/spinlock.h:711).
706             __acquires(l1)
707             __acquires(l2)
708     {
709             if (l1_first) {
710                     spin_lock(l1);
711                     spin_lock(l2);
712             } else {
713                     spin_lock(l2);
714                     spin_lock(l1);
715             }

other info that might help us debug this:
5 locks held by swsusp_shutdown/3406:
 #0:  (pm_mutex){--..}, at: [<c0155c98>] enter_state+0x40/0xbf
 #1:  (cpu_add_remove_lock){--..}, at: [<c014f781>] disable_nonboot_cpus+0x1a/0x11c
 #2:  (cache_chain_mutex){--..}, at: [<c01872b7>] cpuup_callback+0x214/0x3c1
 #3:  (workqueue_mutex){--..}, at: [<c0139fb0>] workqueue_cpu_callback+0x11f/0x1a6
 #4:  ((raw_spinlock_t *)(&lock->wait_lock)){--..}, at: [<c01329b9>] migrate_timers+0x77/0x16e

l *0xc0155c98
0xc0155c98 is in enter_state (kernel/power/main.c:197).
192             int error;
193
194             if (!valid_state(state))
195                     return -ENODEV;
196             if (!mutex_trylock(&pm_mutex))
197                     return -EBUSY;
198
199             if (state == PM_SUSPEND_DISK) {
200                     error = pm_suspend_disk();
201                     goto Unlock;

l *0xc014f781
0xc014f781 is in disable_nonboot_cpus (kernel/cpu.c:264).
259     int disable_nonboot_cpus(void)
260     {
261             int cpu, first_cpu, error = 0;
262
263             mutex_lock(&cpu_add_remove_lock);
264             first_cpu = first_cpu(cpu_present_map);
265             if (!cpu_online(first_cpu)) {
266                     error = _cpu_up(first_cpu);
267                     if (error) {
268                             printk(KERN_ERR "Could not bring CPU%d up.\n",

l *0xc01872b7
0xc01872b7 is in cpuup_callback (mm/slab.c:1342).
1337                    start_cpu_timer(cpu);
1338                    break;
1339    #ifdef CONFIG_HOTPLUG_CPU
1340            case CPU_DOWN_PREPARE:
1341                    mutex_lock(&cache_chain_mutex);
1342                    break;
1343            case CPU_DOWN_FAILED:
1344                    mutex_unlock(&cache_chain_mutex);
1345                    break;
1346            case CPU_DEAD:

l *0xc0139fb0
0xc0139fb0 is in workqueue_cpu_callback (kernel/workqueue.c:883).
878                     mutex_unlock(&workqueue_mutex);
879                     break;
880
881             case CPU_DOWN_PREPARE:
882                     mutex_lock(&workqueue_mutex);
883                     break;
884
885             case CPU_DOWN_FAILED:
886                     mutex_unlock(&workqueue_mutex);
887                     break;


stack backtrace:
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c0145df8>] print_deadlock_bug+0xc0/0xc8
 [<c0145e4f>] check_deadlock+0x4f/0x66
 [<c014819f>] __lock_acquire+0xa31/0xb48
 [<c0148d4b>] lock_acquire+0x6e/0x86
 [<c0370565>] __spin_lock+0x4c/0x59
 [<c01329cd>] migrate_timers+0x8b/0x16e
 [<c0132ae6>] timer_cpu_notify+0x36/0x3f
 [<c013604f>] notifier_call_chain+0x2a/0x3f
 [<c0136265>] raw_notifier_call_chain+0x24/0x26
 [<c014f55d>] _cpu_down+0x18f/0x247
 [<c014f7f4>] disable_nonboot_cpus+0x8d/0x11c
 [<c0156aa5>] pm_suspend_disk+0xb6/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000003 ]
| 3-level deep critical section nesting:
----------------------------------------
.. [<c0132986>] .... migrate_timers+0x44/0x16e
.....[<c0132ae6>] ..   ( <= timer_cpu_notify+0x36/0x3f)
.. [<c0370533>] .... __spin_lock+0x1a/0x59
.....[<c01329b9>] ..   ( <= migrate_timers+0x77/0x16e)
.. [<c0370533>] .... __spin_lock+0x1a/0x59
.....[<c01329cd>] ..   ( <= migrate_timers+0x8b/0x16e)

l *0xc0132986
0xc0132986 is in migrate_timers (kernel/timer.c:1848).
1843            tvec_base_t *new_base;
1844            int i;
1845
1846            BUG_ON(cpu_online(cpu));
1847            old_base = per_cpu(tvec_bases, cpu);
1848            new_base = get_cpu_var(tvec_bases);
1849
1850            local_irq_disable_nort();
1851            double_spin_lock(&new_base->lock, &old_base->lock,
1852                             smp_processor_id() < cpu);

l *0xc0132ae6
0xc0132ae6 is in timer_cpu_notify (kernel/timer.c:1889).
1884                    break;
1885    #endif
1886            default:
1887                    break;
1888            }
1889            return NOTIFY_OK;
1890    }
1891
1892    static struct notifier_block __cpuinitdata timers_nb = {
1893            .notifier_call  = timer_cpu_notify,

l *0xc0370533
0xc0370533 is in __spin_lock (kernel/spinlock.c:218).
213     EXPORT_SYMBOL(__write_lock_bh);
214
215     void __lockfunc __spin_lock(raw_spinlock_t *lock)
216     {
217             preempt_disable();
218             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
219             _raw_spin_lock(lock);
220     }
221
222     EXPORT_SYMBOL(__spin_lock);


CPU1 is down
PM: snapshotting memory.
rtc-test rtc-test.1: LATE freeze
rtc-test rtc-test.0: LATE freeze
serial8250 serial8250: LATE freeze
platform pcspkr: LATE freeze
8139too 0000:02:0d.0: LATE freeze
skge 0000:02:05.0: LATE freeze
Intel ICH 0000:00:1f.5: LATE freeze
i801_smbus 0000:00:1f.3: LATE freeze
PIIX_IDE 0000:00:1f.1: LATE freeze
pci 0000:00:1f.0: LATE freeze
pci 0000:00:1e.0: LATE freeze
pci 0000:00:01.0: LATE freeze
agpgart-intel 0000:00:00.0: LATE freeze
lapic suspend on CPU#0
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c01170f4>] lapic_suspend+0xd9/0x102
 [<c028ffd2>] sysdev_suspend+0xc3/0x219
 [<c0295d42>] device_power_down+0x5f/0x8c
 [<c0156880>] swsusp_suspend+0x1d/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

swsusp: critical section: 
swsusp: Need to copy 123028 pages
swsusp: Normal pages needed: 44905 + 1024 + 40, available pages: 184464
BUG: sleeping function called from invalid context swsusp_shutdown(3406) at arch/i386/mm/highmem.c:8
in_atomic():1 [00000001], irqs_disabled():1
5 locks held by swsusp_shutdown/3406:
 #0:  (pm_mutex){--..}, at: [<c0155c98>] enter_state+0x40/0xbf
 #1:  (cpu_add_remove_lock){--..}, at: [<c014f781>] disable_nonboot_cpus+0x1a/0x11c
 #2:  (cache_chain_mutex){--..}, at: [<c01872b7>] cpuup_callback+0x214/0x3c1
 #3:  (workqueue_mutex){--..}, at: [<c0139fb0>] workqueue_cpu_callback+0x11f/0x1a6
 #4:  ((raw_spinlock_t *)(&lock->wait_lock)){--..}, at: [<c01329b9>] migrate_timers+0x77/0x16e

l *0xc0155c98
0xc0155c98 is in enter_state (kernel/power/main.c:197).
192             int error;
193
194             if (!valid_state(state))
195                     return -ENODEV;
196             if (!mutex_trylock(&pm_mutex))
197                     return -EBUSY;
198
199             if (state == PM_SUSPEND_DISK) {
200                     error = pm_suspend_disk();
201                     goto Unlock;

l *0xc014f781
0xc014f781 is in disable_nonboot_cpus (kernel/cpu.c:264).
259     int disable_nonboot_cpus(void)
260     {
261             int cpu, first_cpu, error = 0;
262
263             mutex_lock(&cpu_add_remove_lock);
264             first_cpu = first_cpu(cpu_present_map);
265             if (!cpu_online(first_cpu)) {
266                     error = _cpu_up(first_cpu);
267                     if (error) {
268                             printk(KERN_ERR "Could not bring CPU%d up.\n",

l *0xc01872b7
0xc01872b7 is in cpuup_callback (mm/slab.c:1342).
1337                    start_cpu_timer(cpu);
1338                    break;
1339    #ifdef CONFIG_HOTPLUG_CPU
1340            case CPU_DOWN_PREPARE:
1341                    mutex_lock(&cache_chain_mutex);
1342                    break;
1343            case CPU_DOWN_FAILED:
1344                    mutex_unlock(&cache_chain_mutex);
1345                    break;
1346            case CPU_DEAD:

l *0xc0139fb0
0xc0139fb0 is in workqueue_cpu_callback (kernel/workqueue.c:883).
878                     mutex_unlock(&workqueue_mutex);
879                     break;
880
881             case CPU_DOWN_PREPARE:
882                     mutex_lock(&workqueue_mutex);
883                     break;
884
885             case CPU_DOWN_FAILED:
886                     mutex_unlock(&workqueue_mutex);
887                     break;

irq event stamp: 76355
hardirqs last  enabled at (76355): [<c037082b>] __spin_unlock_irqrestore+0x54/0x70
hardirqs last disabled at (76354): [<c03701d9>] __spin_lock_irqsave+0x17/0x65
softirqs last  enabled at (0): [<c0126092>] copy_process+0x330/0x1037
softirqs last disabled at (0): [<00000000>] 0x0

l *0xc037082b
0xc037082b is in __spin_unlock_irqrestore (include/asm/irqflags.h:33).
28              return flags;
29      }
30
31      static inline void raw_local_irq_restore(unsigned long flags)
32      {
33              __asm__ __volatile__(
34                      "pushl %0 ; popfl"
35                      : /* no output */
36                      :"g" (flags)
37                      :"memory", "cc"

l *0xc03701d9
0xc03701d9 is in __spin_lock_irqsave (kernel/spinlock.c:121).
116     unsigned long __lockfunc __spin_lock_irqsave(raw_spinlock_t *lock)
117     {
118             unsigned long flags;
119
120             local_irq_save(flags);
121             preempt_disable();
122             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
123             /*
124              * On lockdep we dont want the hand-coded irq-enable of
125              * _raw_spin_lock_flags() code, because lockdep assumes

l *0xc0126092
0xc0126092 is in copy_process (include/linux/list.h:31).
26
27      #define LIST_HEAD(name) \
28              struct list_head name = LIST_HEAD_INIT(name)
29
30      static inline void INIT_LIST_HEAD(struct list_head *list)
31      {
32              list->next = list;
33              list->prev = list;
34      }

l *0xc0126092
0xc0126092 is in copy_process (include/linux/list.h:31).
26
27      #define LIST_HEAD(name) \
28              struct list_head name = LIST_HEAD_INIT(name)
29
30      static inline void INIT_LIST_HEAD(struct list_head *list)
31      {
32              list->next = list;
33              list->prev = list;
34      }
35

 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c0124e38>] __might_sleep+0x11f/0x121
 [<c011e469>] kmap+0x49/0x55
 [<c01578bb>] copy_data_pages+0x105/0x1e6
 [<c0157cb5>] swsusp_save+0xa5/0xd4
 [<c0311fba>] swsusp_arch_suspend+0x2a/0x2c
DWARF2 unwinder stuck at swsusp_arch_suspend+0x2a/0x2c
Leftover inexact backtrace:
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 =======================

l *swsusp_arch_suspend+0x2a/0x2c
0xc0311f90 is at include/asm/string.h:103.
98      return dest;
99      }
100
101     #define __HAVE_ARCH_STRCMP
102     static inline int strcmp(const char * cs,const char * ct)
103     {
104     int d0, d1;
105     register int __res;
106     __asm__ __volatile__(
107             "1:\tlodsb\n\t"


---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0109c90>] .... kernel_fpu_begin+0x18/0x52
.....[<c0311d51>] ..   ( <= __save_processor_state+0x11/0x43)

l *0xc0109c90
0xc0109c90 is in kernel_fpu_begin (include/asm/thread_info.h:93).
88      register unsigned long current_stack_pointer asm("esp") __attribute_used__;
89
90      /* how to get the thread information struct from C */
91      static inline struct thread_info *current_thread_info(void)
92      {
93              return (struct thread_info *)(current_stack_pointer & ~(THREAD_SIZE - 1));
94      }
95
96      /* thread information allocation */
97      #ifdef CONFIG_DEBUG_STACK_USAGE

l *0xc0311d51
0xc0311d51 is in __save_processor_state (arch/i386/power/cpu.c:29).
24              kernel_fpu_begin();
25
26              /*
27               * descriptor tables
28               */
29              store_gdt(&ctxt->gdt);
30              store_idt(&ctxt->idt);
31              store_tr(ctxt->tr);
32
33              /*


swsusp: critical section/: done (123028 pages copied)
Intel machine check architecture supported.
BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3406
caller is intel_p4_mcheck_init+0x82/0xe0
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c022278e>] debug_smp_processor_id+0xae/0xbc
 [<c010ef46>] intel_p4_mcheck_init+0x82/0xe0
 [<c010e88b>] mcheck_init+0x72/0x87
 [<c0311f75>] __restore_processor_state+0x61/0x63
 [<c0311f8c>] restore_processor_state+0x15/0x19
 [<c01568b9>] swsusp_suspend+0x56/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0222737>] .... debug_smp_processor_id+0x57/0xbc
.....[<c010ef46>] ..   ( <= intel_p4_mcheck_init+0x82/0xe0)

l *0xc0222737
0xc0222737 is in debug_smp_processor_id (lib/smp_processor_id.c:42).
37              /*
38               * Avoid recursion:
39               */
40              preempt_disable();
41
42              if (!printk_ratelimit())
43                      goto out_enable;
44
45              printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] code: %s/%d\n", preempt_count()-1, current->comm, current->pid);
46              print_symbol("caller is %s\n", (long)__builtin_return_address(0));

l *0xc010ef46
0xc010ef46 is in intel_p4_mcheck_init (arch/i386/kernel/cpu/mcheck/p4.c:245).
240                     wrmsr (MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
241                     wrmsr (MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
242             }
243
244             set_in_cr4 (X86_CR4_MCE);
245             printk (KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
246                     smp_processor_id());
247
248             /* Check for P4/Xeon extended MCE MSRs */
249             rdmsr (MSR_IA32_MCG_CAP, l, h);

BUG: swsusp_shutdown:3406 task might have lost a preemption check!
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c0124fa8>] preempt_enable_no_resched+0x5d/0x61
 [<c0222793>] debug_smp_processor_id+0xb3/0xbc
 [<c010ef46>] intel_p4_mcheck_init+0x82/0xe0
 [<c010e88b>] mcheck_init+0x72/0x87
 [<c0311f75>] __restore_processor_state+0x61/0x63
 [<c0311f8c>] restore_processor_state+0x15/0x19
 [<c01568b9>] swsusp_suspend+0x56/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

Intel machine check reporting enabled on CPU#0.
BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3406
caller is intel_p4_mcheck_init+0xb0/0xe0
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c022278e>] debug_smp_processor_id+0xae/0xbc
 [<c010ef74>] intel_p4_mcheck_init+0xb0/0xe0
 [<c010e88b>] mcheck_init+0x72/0x87
 [<c0311f75>] __restore_processor_state+0x61/0x63
 [<c0311f8c>] restore_processor_state+0x15/0x19
 [<c01568b9>] swsusp_suspend+0x56/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0222737>] .... debug_smp_processor_id+0x57/0xbc
.....[<c010ef74>] ..   ( <= intel_p4_mcheck_init+0xb0/0xe0)

CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3406
caller is intel_init_thermal+0x16/0xf8
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c022278e>] debug_smp_processor_id+0xae/0xbc
 [<c010eb75>] intel_init_thermal+0x16/0xf8
 [<c010ef99>] intel_p4_mcheck_init+0xd5/0xe0
 [<c010e88b>] mcheck_init+0x72/0x87
 [<c0311f75>] __restore_processor_state+0x61/0x63
 [<c0311f8c>] restore_processor_state+0x15/0x19
 [<c01568b9>] swsusp_suspend+0x56/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0222737>] .... debug_smp_processor_id+0x57/0xbc
.....[<c010eb75>] ..   ( <= intel_init_thermal+0x16/0xf8)

CPU0: Thermal monitoring enabled
lapic resume on CPU#0
 [<c0105114>] dump_trace+0x7f/0x229
 [<c0105397>] show_trace_log_lvl+0x35/0x54
 [<c01053e2>] show_trace+0x2c/0x2e
 [<c0105515>] dump_stack+0x29/0x2b
 [<c0117151>] lapic_resume+0x34/0x19c
 [<c028fec9>] __sysdev_resume+0x1e/0x64
 [<c029016d>] sysdev_resume+0x45/0x74
 [<c02960e2>] device_power_up+0xd/0x17
 [<c01568c3>] swsusp_suspend+0x60/0x6d
 [<c0156afb>] pm_suspend_disk+0x10c/0x1c7
 [<c0155cab>] enter_state+0x53/0xbf
 [<c0155e62>] state_store+0x91/0xa7
 [<c01c9e41>] subsys_attr_store+0x34/0x3e
 [<c01ca0b7>] flush_write_buffer+0x43/0x4a
 [<c01ca117>] sysfs_write_file+0x59/0x7a
 [<c018d66d>] vfs_write+0xc9/0x16d
 [<c018d7d6>] sys_write+0x4f/0x76
 [<c010429d>] syscall_call+0x7/0xb
 [<b7fbd410>] 0xb7fbd410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-rt0/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-rt0/rt-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
