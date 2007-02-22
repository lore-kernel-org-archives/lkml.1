Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXBVKuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXBVKuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXBVKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:50:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:10472 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXBVKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=GQ4Y1yz0hGO6qudhLv5J1SvSx+0WoWlw88INR9MGpBYgxzuERXFporkIgdxI+BmiBF4kHCAL85MokRc62Z/g7xH18QJsLlAaf0CMXvWVGMHW+nJo+NXFnOuOfNCGy3Qc4cUb3uzi2mXbPRzADFAgUDxaPReSqXmUqc94rwO5Rtk=
Message-ID: <45DD756D.3040006@googlemail.com>
Date: Thu, 22 Feb 2007 11:50:21 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: tglx@linutronix.de, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>	 <1172008584.25076.0.camel@localhost.localdomain>	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>	 <1172072023.25076.64.camel@localhost.localdomain>	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com> <1172088044.25076.125.camel@localhost.localdomain> <45DCF644.9040009@googlemail.com>
In-Reply-To: <45DCF644.9040009@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisa³(a):
> Thomas Gleixner napisa³(a):
>> Michal,
>>
>> On Wed, 2007-02-21 at 16:38 +0100, Michal Piotrowski wrote:
>>>> But you still have those softirq pending messages, right ?
>>> Yes
>>>
>>> (+ new NOHZ: local_softirq_pending 02)
>> Yike, that's the timer softirq.
>>
>> Can you add the patch below, maybe it gives us some useful info. Please
>> enable lockdep (your last config had it already)
>>
> 
> I hope this helps.
> 
> irq event stamp: 103630856
> hardirqs last  enabled at (103630855): [<c031356a>] _spin_unlock_irq+0x22/0x43
> hardirqs last disabled at (103630856): [<c013a00e>] tick_nohz_stop_sched_tick+0x13/0x1fd
> softirqs last  enabled at (103630824): [<c01265df>] __do_softirq+0xe4/0xea
> softirqs last disabled at (103630819): [<c0106a75>] do_softirq+0x64/0xd1
> NOHZ: local_softirq_pending 20, 00000001
> 
> (gdb) l *0xc031356a
> 0xc031356a is in _spin_unlock_irq (include2/asm/irqflags.h:48).
> 43              __asm__ __volatile__("cli" : : : "memory");
> 44      }
> 45
> 46      static inline void raw_local_irq_enable(void)
> 47      {
> 48              __asm__ __volatile__("sti" : : : "memory");
> 49      }
> 50
> 51      /*
> 52       * Used in the idle loop; sti takes one instruction cycle
> (gdb) l *0xc013a00e
> 0xc013a00e is in tick_nohz_stop_sched_tick (/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:158).
> 153             ktime_t last_update, expires, now, delta;
> 154             int cpu;
> 155
> 156             local_irq_save(flags);
> 157
> 158             cpu = smp_processor_id();
> 159             ts = &per_cpu(tick_cpu_sched, cpu);
> 160
> 161             if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
> 162                     goto end;
> (gdb) l *0xc01265df
> 0xc01265df is in __do_softirq (/mnt/md0/devel/linux-git/kernel/softirq.c:251).
> 246
> 247             trace_softirq_exit();
> 248
> 249             account_system_vtime(current);
> 250             _local_bh_enable();
> 251     }
> 252
> 253     #ifndef __ARCH_HAS_DO_SOFTIRQ
> 254
> 255     asmlinkage void do_softirq(void)
> (gdb) l *0xc0106a75
> 0xc0106a75 is in do_softirq (/mnt/md0/devel/linux-git/arch/i386/kernel/irq.c:222).
> 217                     irqctx->tinfo.previous_esp = current_stack_pointer;
> 218
> 219                     /* build the stack frame on the softirq stack */
> 220                     isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
> 221
> 222                     asm volatile(
> 223                             "       xchgl   %%ebx,%%esp     \n"
> 224                             "       call    __do_softirq    \n"
> 225                             "       movl    %%ebx,%%esp     \n"
> 226                             : "=b"(isp)
> 

Here is more

BUG: at /mnt/md0/devel/linux-git/kernel/lockdep.c:2427 check_flags()
 [<c01050f9>] show_trace_log_lvl+0x1a/0x2f
 [<c01057e0>] show_trace+0x12/0x14
 [<c0105892>] dump_stack+0x16/0x18
 [<c013abf7>] check_flags+0x95/0x143
 [<c013d978>] lock_acquire+0x29/0x82
 [<c0136974>] down_write+0x3a/0x54
 [<c01630f8>] sys_munmap+0x23/0x3f
 [<c0104120>] syscall_call+0x7/0xb
 =======================
irq event stamp: 30788
hardirqs last  enabled at (30787): [<c0104249>] syscall_exit_work+0x11/0x26
hardirqs last disabled at (30788): [<c0103fc9>] ret_from_exception+0x9/0xc
softirqs last  enabled at (30202): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (30193): [<c0106a75>] do_softirq+0x64/0xd1
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 02, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 02, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 02, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 137191105
hardirqs last  enabled at (137191105): [<c0102b80>] default_idle+0x3e/0x59
hardirqs last disabled at (137191104): [<c0102451>] cpu_idle+0xba/0xfb
softirqs last  enabled at (137190592): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (137190587): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 20, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 24, 00000001
irq event stamp: 214661966
hardirqs last  enabled at (214661965): [<c0104168>] restore_nocheck+0x12/0x15
hardirqs last disabled at (214661966): [<c0313174>] _spin_lock_irq+0xf/0x48
softirqs last  enabled at (214661782): [<c01265df>] __do_softirq+0xe4/0xea
softirqs last disabled at (214661755): [<c0106a75>] do_softirq+0x64/0xd1
NOHZ: local_softirq_pending 06, 00000001


http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc1/git-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc1/git-dmesg2

[<c01265df>] __do_softirq+0xe4/0xea
[<c0106a75>] do_softirq+0x64/0xd1

this repeats every time

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
