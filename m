Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXCTHzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXCTHzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXCTHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:55:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:37551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbXCTHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=JdhAlROev8dydTNwuQ14NO/HswTjo5xcJnEIvLtccRq4KKH54SXxp9iw24E9uKmoLGpwHEQAsZvOAtUTdV1WmXiFOr7vemTkSx3NA7g/WSE54GSwgxc5QNVbQcRn5SJH+L4lArHkZPAKYSUkKRyJ4iXlFuhHijJBhg0WbEe8gAw=
Message-ID: <45FF9319.6070604@googlemail.com>
Date: Tue, 20 Mar 2007 08:54:01 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 

Some new details about
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/1367.html

I can reproduce it by running this on AutoTest

for profiler in ('oprofile', ):
	try:
		print "Testing profiler %s ..." % profiler
		job.profilers.add(profiler)
		job.run_test('aiostress',)
		job.profilers.delete(profiler)
	except:
		print "Test of profiler %s failed" % profiler
		raise

I guess that oprofile triggers it.

BUG: using smp_processor_id() in preemptible [00000001] code: mount/4934
caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0212f43>] debug_smp_processor_id+0xb3/0xc8
 [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<fdc829b9>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdc81f52>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdc82157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c018296e>] get_sb_single+0x59/0x9f
 [<fdc8208f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c01823d2>] vfs_kern_mount+0x81/0xf1
 [<c0182492>] do_kern_mount+0x38/0xde
 [<c01962b1>] do_mount+0x605/0x693
 [<c01963bf>] sys_mount+0x80/0xb5
 [<c0104270>] syscall_call+0x7/0xb
 =======================

l *avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
0xc01169fb is in avail_to_resrv_perfctr_nmi_bit (/mnt/md0/devel/linux-mm/arch/i386/kernel/nmi.c:124).
119             return 0;
120     }
121
122     /* checks for a bit availability (hack for oprofile) */
123     int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
124     {
125             BUG_ON(counter > NMI_MAX_COUNTER_BITS);
126
127             return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
128     }


BUG: using smp_processor_id() in preemptible [00000001] code: mount/4934
caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0212f43>] debug_smp_processor_id+0xb3/0xc8
 [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<fdc829b9>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdc81f52>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdc82157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c018296e>] get_sb_single+0x59/0x9f
 [<fdc8208f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c01823d2>] vfs_kern_mount+0x81/0xf1
 [<c0182492>] do_kern_mount+0x38/0xde
 [<c01962b1>] do_mount+0x605/0x693
 [<c01963bf>] sys_mount+0x80/0xb5
 [<c0104270>] syscall_call+0x7/0xb
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: mount/4934
caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0212f43>] debug_smp_processor_id+0xb3/0xc8
 [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<fdc829b9>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdc81f52>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdc82157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c018296e>] get_sb_single+0x59/0x9f
 [<fdc8208f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c01823d2>] vfs_kern_mount+0x81/0xf1
 [<c0182492>] do_kern_mount+0x38/0xde
 [<c01962b1>] do_mount+0x605/0x693
 [<c01963bf>] sys_mount+0x80/0xb5
 [<c0104270>] syscall_call+0x7/0xb
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: mount/4934
caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0212f43>] debug_smp_processor_id+0xb3/0xc8
 [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
 [<fdc829b9>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdc81f52>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdc82157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c018296e>] get_sb_single+0x59/0x9f
 [<fdc8208f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c01823d2>] vfs_kern_mount+0x81/0xf1
 [<c0182492>] do_kern_mount+0x38/0xde
 [<c01962b1>] do_mount+0x605/0x693
 [<c01963bf>] sys_mount+0x80/0xb5
 [<c0104270>] syscall_call+0x7/0xb
 =======================
SELinux: initialized (dev oprofilefs, type oprofilefs), uses genfs_contexts

=================================
[ INFO: inconsistent lock state ]
2.6.21-rc4-mm1 #5
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
init/1 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (oprofilefs_lock){+-..}, at: [<fdc82b6e>] nmi_cpu_setup+0x15/0x4f [oprofile]
{hardirq-on-W} state was registered at:
  [<c0140c15>] __lock_acquire+0x4e8/0xceb
  [<c0141491>] lock_acquire+0x79/0x93
  [<c033eb3f>] _spin_lock+0x35/0x42
  [<fdc82347>] oprofilefs_ulong_from_user+0x4e/0x74 [oprofile]
  [<fdc81fc7>] depth_write+0x27/0x43 [oprofile]
  [<c0180afa>] vfs_write+0xd1/0x15a
  [<c018112a>] sys_write+0x3d/0x72
  [<c0104270>] syscall_call+0x7/0xb
  [<ffffffff>] 0xffffffff
irq event stamp: 1022800
hardirqs last  enabled at (1022799): [<c01042b8>] restore_nocheck+0x12/0x15
hardirqs last disabled at (1022800): [<c0104cf1>] call_function_interrupt+0x29/0x38
softirqs last  enabled at (1022784): [<c0128eb4>] __do_softirq+0xe4/0xea
softirqs last disabled at (1022779): [<c0128ef3>] do_softirq+0x39/0x55

l *0xc01042b8
0xc01042b8 is at include2/asm/bitops.h:246.
241     static int test_bit(int nr, const volatile void * addr);
242     #endif
243
244     static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
245     {
246             return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
247     }
248
249     static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
250     {

l *0xc0104cf1
0xc0104cf1 is at include2/asm/bitops.h:246.
241     static int test_bit(int nr, const volatile void * addr);
242     #endif
243
244     static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
245     {
246             return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
247     }
248
249     static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
250     {

l *0xc0128eb4
0xc0128eb4 is in __do_softirq (/mnt/md0/devel/linux-mm/kernel/softirq.c:252).
247
248             trace_softirq_exit();
249
250             account_system_vtime(current);
251             _local_bh_enable();
252     }
253
254     #ifndef __ARCH_HAS_DO_SOFTIRQ
255
256     asmlinkage void do_softirq(void)

l *0xc0128ef3
0xc0128ef3 is in do_softirq (/mnt/md0/devel/linux-mm/kernel/softirq.c:271).
266             pending = local_softirq_pending();
267
268             if (pending)
269                     __do_softirq();
270
271             local_irq_restore(flags);
272     }
273
274     EXPORT_SYMBOL(do_softirq);
275


other info that might help us debug this:
2 locks held by init/1:
 #0:  (tasklist_lock){..??}, at: [<c01261b6>] do_wait+0x54/0xba4
 #1:  (policy_rwlock){..??}, at: [<c01ef326>] security_compute_av+0x4f/0xbf

l *0xc01261b6
0xc01261b6 is in do_wait (include2/asm/current.h:11).
6
7       struct task_struct;
8
9       static __always_inline struct task_struct *get_current(void)
10      {
11              return read_pda(pcurrent);
12      }
13
14      #define current get_current()
15

l *0xc01ef326
0xc01ef326 is in security_compute_av (/mnt/md0/devel/linux-mm/security/selinux/ss/services.c:527).
522                     return 0;
523             }
524
525             POLICY_RDLOCK;
526
527             scontext = sidtab_search(&sidtab, ssid);
528             if (!scontext) {
529                     printk(KERN_ERR "security_compute_av:  unrecognized SID %d\n",
530                            ssid);
531                     rc = -EINVAL;


stack backtrace:
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c013f327>] print_usage_bug+0x140/0x14a
 [<c013fbbf>] mark_lock+0xc9/0x510
 [<c0140b86>] __lock_acquire+0x459/0xceb
 [<c0141491>] lock_acquire+0x79/0x93
 [<c033eb3f>] _spin_lock+0x35/0x42
 [<fdc82b6e>] nmi_cpu_setup+0x15/0x4f [oprofile]
 [<c0113b63>] smp_call_function_interrupt+0x3a/0x56
 [<c0104cfb>] call_function_interrupt+0x33/0x38
 [<c01ef380>] security_compute_av+0xa9/0xbf
 [<c01e2649>] avc_has_perm_noaudit+0x1cf/0x490
 [<c01e34da>] avc_has_perm+0x28/0x58
 [<c01e3cd7>] task_has_perm+0x2d/0x2f
 [<c01e6e74>] selinux_task_wait+0x2f/0x31
 [<c0126295>] do_wait+0x133/0xba4
 [<c0126d36>] sys_wait4+0x30/0x32
 [<c0126d5f>] sys_waitpid+0x27/0x29
 [<c01041e6>] sysenter_past_esp+0x5f/0x99
 =======================

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-mm1/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
