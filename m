Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXCVN14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXCVN14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXCVN14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:27:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:33272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXCVN1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=p6VhXgYI2qJXS4ujYYARmJsL3YfftNzTnlMjNDG74+1vyUsGhQidkPMgXna3PmsQibhZYCzNWOelyIn2iKFad42JdKlNKgYmpJLaRV8/kbt50pyr4sGHgPMOf5Tx70+bfUCFcIxhyzbS+fSv3B0aFVLZ8t3jgExLpt+JVB0eujw=
Message-ID: <4602843D.9000306@googlemail.com>
Date: Thu, 22 Mar 2007 14:27:25 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc4-rt0-kdump (was: Re: [patch] setup_boot_APIC_clock() irq-enable
 fix)
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>	 <20070322093119.GA19394@elte.hu> <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com>
In-Reply-To: <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> On 22/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>
>> > Hi Ingo,
>>
>> > 2.6.21-rc4-rt0
>>
>> > BUG: at kernel/fork.c:1033 copy_process()
>>
>> thanks Michal - this is a real bug that affects upstream too. Find the
>> fix below - i've test-booted it and it fixes the warning.
> 
> Problem is fixed, thanks.

BTW. It seems that nobody uses -rt as a crash dump kernel ;)

BUG: unable to handle kernel paging request at virtual address f7ebf8c4
 printing eip:
c1610192
*pde = 00000000
stopped custom tracer.
Oops: 0000 [#1]
PREEMPT 
Modules linked in:
CPU:    0
EIP:    0060:[<c1610192>]    Not tainted VLI
EFLAGS: 00010206   (2.6.21-rc4-rt0-kdump #3)
EIP is at copy_oldmem_page+0x4a/0xd0
eax: 000008c4   ebx: f7ebf000   ecx: 00000100   edx: 00000246
esi: f7ebf8c4   edi: c4c520fc   ebp: c4d54e30   esp: c4d54e18
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000001
Process swapper (pid: 1, ti=c4d54000 task=c4d52c20 task.ti=c4d54000)
Stack: c17ab7e0 c183f982 c1969658 00000400 00000400 00037ebf c4d54e5c c16af187 
       00037ebf c4c520fc 00000400 000008c4 00000000 00000000 c4c696e0 00000400 
       c4c520fc c4d54f94 c19a9cfd c4c520fc 00000400 c4d54f78 00000000 c1840996 
Call Trace:
 [<c16af187>] read_from_oldmem+0x73/0x98
 [<c19a9cfd>] vmcore_init+0x26c/0xab7
 [<c199979b>] init+0xaa/0x287
 [<c16044eb>] kernel_thread_helper+0x7/0x10
 =======================

l *copy_oldmem_page+0x4a/0xd0
0xc1610148 is in copy_oldmem_page (arch/i386/kernel/crash_dump.c:35).
30       * copying the data to a pre-allocated kernel page and then copying to user
31       * space in non-atomic context.
32       */
33      ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
34                                     size_t csize, unsigned long offset, int userbuf)
35      {
36              void  *vaddr;
37
38              if (!csize)
39                      return 0;


---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c184045a>] .... __spin_lock_irqsave+0x23/0x65
.....[<c1604f8c>] ..   ( <= die+0x44/0x24d)

l *0xc184045a
0xc184045a is in __spin_lock_irqsave (kernel/spinlock.c:122).
117     {
118             unsigned long flags;
119
120             local_irq_save(flags);
121             preempt_disable();
122             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
123             /*
124              * On lockdep we dont want the hand-coded irq-enable of
125              * _raw_spin_lock_flags() code, because lockdep assumes
126              * that interrupts are not re-enabled during lock-acquire:

l *0xc1604f8c
0xc1604f8c is in die (arch/i386/kernel/traps.c:477).
472
473             oops_enter();
474
475             if (die.lock_owner != raw_smp_processor_id()) {
476                     console_verbose();
477                     spin_lock_irqsave(&die.lock, flags);
478                     die.lock_owner = smp_processor_id();
479                     die.lock_owner_depth = 0;
480                     bust_spinlocks(1);
481             }


Code: 10 05 00 c1 e3 05 03 1d 60 8e d6 c1 89 1c 24 e8 fc 33 00 00 89 c3 83 7d 18 00 75 2a 8b 4d 10 c1 e9 02 8b 45 14 8d 34 03 8b 7d 0c <f3> a5 8b 4d 10 83 e1 03 74 02 f3 a4 e8 cb 10 05 00 89 1c 24 e8 
EIP: [<c1610192>] copy_oldmem_page+0x4a/0xd0 SS:ESP 0068:c4d54e18
Kernel panic - not syncing: Attempted to kill init!
 [<c160496d>] dump_trace+0x78/0x21a
 [<c1604b44>] show_trace_log_lvl+0x35/0x54
 [<c16052c4>] show_trace+0x2c/0x2e
 [<c160538b>] dump_stack+0x29/0x2b
 [<c1618b30>] panic+0x68/0x130
 [<c161b67c>] do_exit+0xa1/0x7e3
 [<c160516a>] die+0x222/0x24d
 [<c1612a3f>] do_page_fault+0x4a1/0x586
 [<c1841044>] error_code+0x74/0x7c
 [<c1610192>] copy_oldmem_page+0x4a/0xd0
 [<c16af187>] read_from_oldmem+0x73/0x98
 [<c19a9cfd>] vmcore_init+0x26c/0xab7
 [<c199979b>] init+0xaa/0x287
 [<c16044eb>] kernel_thread_helper+0x7/0x10
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c1618ae6>] .... panic+0x1e/0x130
.....[<c161b67c>] ..   ( <= do_exit+0xa1/0x7e3)

l *0xc1618ae6
0xc1618ae6 is in panic (kernel/panic.c:85).
80               * have preempt disabled. Some functions called from here want
81               * preempt to be disabled. No point enabling it later though...
82               */
83              preempt_disable();
84
85              bust_spinlocks(1);
86              va_start(args, fmt);
87              vsnprintf(buf, sizeof(buf), fmt, args);
88              va_end(args);
89              printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);

l *0xc161b67c
0xc161b67c is in do_exit (include/linux/pid_namespace.h:42).
37              kref_put(&ns->kref, free_pid_ns);
38      }
39
40      static inline struct task_struct *child_reaper(struct task_struct *tsk)
41      {
42              return init_pid_ns.child_reaper;
43      }
44
45      #endif /* _LINUX_PID_NS_H */

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/kdump-console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/kdump-config


NOHZ: local_softirq_pending 02 on CPU#1
NOHZ: local_softirq_pending 02 on CPU#0
NOHZ: local_softirq_pending 08 on CPU#0
NOHZ: local_softirq_pending 02 on CPU#1
NOHZ: local_softirq_pending 10 on CPU#0
NOHZ: local_softirq_pending 02 on CPU#0
NOHZ: local_softirq_pending 02 on CPU#1
NOHZ: local_softirq_pending 08 on CPU#0

           CPU0       CPU1
  0:        304          0   IO-APIC-edge      timer
  1:       2319          0   IO-APIC-edge      i8042
  7:          0          0   IO-APIC-edge      parport0
  8:          1          0   IO-APIC-edge      rtc
  9:          1          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 14:        738          0   IO-APIC-edge      ide0
 15:       3050          0   IO-APIC-edge      ide1
 16:      23802          0   IO-APIC-fasteoi   uhci_hcd:usb2, uhci_hcd:usb5
 17:      33123          0   IO-APIC-fasteoi   eth1
 19:      29280          0   IO-APIC-fasteoi   libata, uhci_hcd:usb4
 20:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 22:      38572          0   IO-APIC-fasteoi   Intel ICH5
NMI:          0          0
LOC:     351305     268386
ERR:          0
MIS:          0

Hibernation is still broken.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/rt-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
