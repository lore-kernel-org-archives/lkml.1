Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0BVQMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:12:41 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55647 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0BVQMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IuxQKWZV1aAta1PifNP4LP57pDj1F3/rBDEvpFFwJqeOdO17hb1WR3gTc+ZTs5P64c
         /GkhGUq08JrmwDeYtFhHz5RvMqYEGZ9930ZYHkUvHFNrzaaMlpr3Fqd3o0+hEU8Oqv5X
         tUvlkiF0jjjfRiuSlLu/x+syLK9M8AL2OSW9I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002221652190.3770@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
	 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
	 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
	 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
	 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
	 <alpine.LFD.2.00.1002221228130.2811@localhost.localdomain>
	 <520f0cf11002220423u64daf89dxa6a4249522adabee@mail.gmail.com>
	 <alpine.LFD.2.00.1002221614480.4136@localhost.localdomain>
	 <alpine.LFD.2.00.1002221652190.3770@localhost.localdomain>
Date: Mon, 22 Feb 2010 17:12:36 +0100
X-Google-Sender-Auth: f568d40090c18108
Message-ID: <520f0cf11002220812w108a8143rdbeea663a8c702f5@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 4:53 PM, John Kacur <jkacur@redhat.com> wrote:
>
>
> On Mon, 22 Feb 2010, Thomas Gleixner wrote:
>
>> On Mon, 22 Feb 2010, John Kacur wrote:
>> > That patch fixes the symptom I reported, but unfortunately, I still
>> > can't log-in to my laptop without the machine freezing.
>> > Not sure why, investigating.
>>
>> Found it, at least it make my mouse/keyboard work again and fixes the
>> weird double character problem on VT login.
>>
>> Thanks,
>>
>>       tglx
>> ----
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 25642d1..1efad98 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -563,15 +563,20 @@ irq_wait_for_interrupt(struct irq_desc *desc, struct irqaction *action)
>>   * handler finished. unmask if the interrupt has not been disabled and
>>   * is marked MASKED.
>>   */
>> -static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
>> +static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc,
>> +                              struct irqaction *action)
>>  {
>>       chip_bus_lock(irq, desc);
>> +#ifndef CONFIG_PREEMPT_RT
>>       raw_spin_lock_irq(&desc->lock);
>>       if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
>>               desc->status &= ~IRQ_MASKED;
>>               desc->chip->unmask(irq);
>>       }
>>       raw_spin_unlock_irq(&desc->lock);
>> +#else
>> +     preempt_hardirq_thread_done(desc, action);
>> +#endif
>>       chip_bus_sync_unlock(irq, desc);
>>  }
>>
>> @@ -645,7 +650,7 @@ static int irq_thread(void *data)
>>                       action->thread_fn(action->irq, action->dev_id);
>>
>>                       if (oneshot)
>> -                             irq_finalize_oneshot(action->irq, desc);
>> +                             irq_finalize_oneshot(action->irq, desc, action);
>>               }
>>
>>               wake = atomic_dec_and_test(&desc->threads_active);
>>
>
>
> Thanks Thomas
>
> The fix seems to work for me.
> I've got some other issues, but for now I'm going to assume they are the
> same acpi problems I have reported to lkml for the "vanilla" -rc8
>

Sorry, spoke to soon, graphical login still freezing.
I did nohz=off and nmi_watchdog=2 as you told me in the irc session,
and got a nice oops, here it is.

------------[ cut here ]------------
Kernel BUG at ffffffff81045d73 [verbose debug info unavailable]
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/class/power_supply/BAT0/energy_full
CPU 0
Pid: 3467, comm: firefox-bin Tainted: G      D    2.6.33-rc8-rt1-debug #2 2241B4
8/2241B48
RIP: 0010:[<ffffffff81045d73>]  [<ffffffff81045d73>] do_exit+0x776/0x784
RSP: 0018:ffff88002be06e28  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: 0000000000000003 RDI: ffff880115638000
RBP: ffff88002be06e98 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000046 R12: ffff88002be06e48
R13: ffff8801157fd200 R14: ffff88011546d080 R15: ffff8801157fd4c0
FS:  0000000000000000(0000) GS:ffff88002be00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000034e64a7ce0 CR3: 0000000139bd3000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process firefox-bin (pid: 3467, threadinfo ffff880115638000, task ffff8801157fd2
00)
Stack:
 0000000081602f00 ffffffff8135cf95 ffff8801157fd4c0 ffff8801157fd1f0
<0> ffff88002be06e48 ffff88002be06e48 ffff88002bfcbb20 0000000000000001
<0> 0000000000000007 ffffffff811aca40 0000000000000046 ffff88002be06f58
Call Trace:
 <NMI>
 [<ffffffff8135cf95>] ? _raw_spin_unlock_irqrestore+0x63/0x68
 [<ffffffff811aca40>] ? delay_tsc+0x6/0xc6
 [<ffffffff8135e31f>] die_nmi+0xef/0xf8
 [<ffffffff8135e971>] nmi_watchdog_tick+0x159/0x1d6
 [<ffffffff8135de29>] do_nmi+0xc2/0x28a
 [<ffffffff8135d86a>] nmi+0x1a/0x2c
 [<ffffffff811aca40>] ? delay_tsc+0x6/0xc6
 <<EOE>>
 [<ffffffff811ac9d5>] __delay+0xa/0xc
 [<ffffffff811b0d50>] do_raw_spin_lock+0xde/0x146
 [<ffffffff8135ce39>] _raw_spin_lock_irqsave+0x67/0x7f
 [<ffffffff8109e8c0>] ? rcu_sched_qs+0x70/0x16c
 [<ffffffff8109e8c0>] rcu_sched_qs+0x70/0x16c
 [<ffffffff8135a3f7>] __schedule+0x32/0x923
 [<ffffffff8135d340>] ? restore_args+0x0/0x30
 [<ffffffff8135ada8>] preempt_schedule+0x55/0x78
 [<ffffffff8135cf95>] _raw_spin_unlock_irqrestore+0x63/0x68
 [<ffffffff8135bce5>] rt_spin_lock_slowlock+0x2ad/0x2e0
 [<ffffffff8135ba38>] ? rt_spin_lock_slowlock+0x0/0x2e0
 [<ffffffff81076dde>] rt_spin_lock_fastlock+0x56/0x5b
 [<ffffffff8135c625>] rt_spin_lock+0x1f/0x42
 [<ffffffff8110616c>] __d_lookup+0xc5/0x189
 [<ffffffff811060a7>] ? __d_lookup+0x0/0x189
 [<ffffffff810fca20>] do_lookup+0x53/0x187
 [<ffffffff810fd27d>] link_path_walk+0x2ca/0x699
 [<ffffffff810fd802>] path_walk+0x6d/0xeb
 [<ffffffff810fdc29>] do_path_lookup+0x2a/0x8a
 [<ffffffff811004b7>] user_path_at+0x52/0x8c
 [<ffffffff8106ee74>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8135ba0d>] ? rt_spin_lock_slowunlock+0x4e/0x79
 [<ffffffff8110b145>] ? mntput_no_expire+0x24/0xf8
 [<ffffffff810f7d6b>] vfs_fstatat+0x35/0x62
 [<ffffffff810f7dec>] vfs_lstat+0x19/0x1b
 [<ffffffff8102bdbb>] sys32_lstat64+0x1a/0x34
 [<ffffffff810fc85a>] ? path_put+0x1d/0x22
 [<ffffffff81097c8c>] ? audit_syscall_entry+0x114/0x140
 [<ffffffff8102aad8>] sysenter_dispatch+0x7/0x2c
 [<ffffffff8135c1f7>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Code: bd 98 15 00 00 48 85 ff 74 05 e8 03 54 0b 00 bf 01 00 00 00 e8 b4 a2 31 00
 e8 d2 85 05 00 49 c7 45 00 80 00 00 00 e8 58 50 31 00 <0f> 0b eb fe bb fe ff ff
 ff e9 1d ff ff ff 55 48 89 e5 41 56 41
RIP  [<ffffffff81045d73>] do_exit+0x776/0x784
 RSP <ffff88002be06e28>
---[ end trace 6f724503db632ce1 ]---
Fixing recursive fault but reboot is needed!
BUG: NMI Watchdog detected LOCKUP on CPU1, ip ffffffff811aca7e, registers:
CPU 1
Pid: 0, comm: swapper Tainted: G      D    2.6.33-rc8-rt1-debug #2 2241B48/2241B
48
RIP: 0010:[<ffffffff811aca7e>]  [<ffffffff811aca7e>] delay_tsc+0x44/0xc6
RSP: 0018:ffff88002c003d28  EFLAGS: 00000002
RAX: 00000000e46481d9 RBX: 00000000e4648146 RCX: 000000000000ab00
RDX: 00000000000000c5 RSI: ffffffff815527c6 RDI: 0000000000000001
RBP: ffff88002c003d58 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff8175bc00 R11: 0000000000000046 R12: 0000000000000001
R13: 00000000e46481d9 R14: 0000000000000001 R15: ffff88013bbcffd8
FS:  0000000000000000(0000) GS:ffff88002c000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000f05fb0 CR3: 000000012c4c8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88013bbce000, task ffff88013bbd07c0)
Stack:
 ffff88013bbd07c0 000000000d0fcb31 ffffffff8175c080 0000000000000001
<0> ffff88013bbd07c0 ffff88013bbd0ce8 ffff88002c003d68 ffffffff811ac9d5
<0> ffff88002c003da8 ffffffff811b0d50 00000000a6773048 ffffffff8175c098
Call Trace:
 <IRQ>
 [<ffffffff811ac9d5>] __delay+0xa/0xc
 [<ffffffff811b0d50>] do_raw_spin_lock+0xde/0x146
 [<ffffffff8106aa26>] ? tick_sched_timer+0x0/0x9d
 [<ffffffff8135ce39>] _raw_spin_lock_irqsave+0x67/0x7f
 [<ffffffff8109ea01>] ? rcu_print_task_stall+0x45/0xb4
 [<ffffffff8109ea01>] rcu_print_task_stall+0x45/0xb4
 [<ffffffff8106aa26>] ? tick_sched_timer+0x0/0x9d
 [<ffffffff8109ef6a>] __rcu_pending+0x15b/0x2d3
 [<ffffffff8106aa26>] ? tick_sched_timer+0x0/0x9d
 [<ffffffff8109f151>] rcu_check_callbacks+0x6f/0x17a
 [<ffffffff8106aa26>] ? tick_sched_timer+0x0/0x9d
 [<ffffffff81050a69>] update_process_times+0x3e/0x54
 [<ffffffff8106aa99>] tick_sched_timer+0x73/0x9d
 [<ffffffff81060cfb>] __run_hrtimer+0xc9/0x13a
 [<ffffffff81061256>] hrtimer_interrupt+0xe0/0x1de
 [<ffffffff81019a3e>] smp_apic_timer_interrupt+0x81/0x94
 [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
 <EOI>
 [<ffffffff813600ee>] ? __atomic_notifier_call_chain+0x0/0x94
 [<ffffffff812967fb>] ? poll_idle+0x16/0x5f
 [<ffffffff81296809>] ? poll_idle+0x24/0x5f
 [<ffffffff812967fb>] ? poll_idle+0x16/0x5f
 [<ffffffff813600ee>] ? __atomic_notifier_call_chain+0x0/0x94
 [<ffffffff81296d13>] cpuidle_idle_call+0xa0/0x111
 [<ffffffff81001f2a>] cpu_idle+0xa4/0x107
 [<ffffffff81355fc9>] start_secondary+0x18f/0x194
Code: e8 bd 35 1b 00 e8 87 54 00 00 41 89 c6 66 66 90 0f ae e8 0f 31 89 c3 65 4c
 8b 3c 25 48 95 00 00 66 66 90 0f ae e8 0f 31 41 89 c5 <4c> 89 e8 48 29 d8 4c 39
 e0 73 49 bf 01 00 00 00 e8 04 35 1b 00
---[ end trace 6f724503db632ce2 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
