Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZA3PJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZA3PJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZA3PJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:09:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZA3PJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:09:17 -0500
Date: Fri, 30 Jan 2009 16:08:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
	00000100, exited with 00010100?" in tip.git
Message-ID: <20090130150859.GB27549@elte.hu>
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com> <49825B8B.2000202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49825B8B.2000202@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Paul E. McKenney wrote:
>> On Thu, Jan 29, 2009 at 02:12:31PM -0800, Jeremy Fitzhardinge wrote:
>>   
>>> When I boot my x86-64 tip.git kernel under Xen, I'm seeing:
>>>
>>> pnp: PnP ACPI: disabled
>>> NET: Registered protocol family 2
>>> huh, entered softirq 8 ffffffff802682aa preempt_count 00000100, 
>>> exited with 00010100?
>>> IP route cache hash table entries: 512 (order: 0, 4096 bytes)
>>> TCP established hash table entries: 1024 (order: 2, 16384 bytes)
>>> [...]
>>> XENBUS: Device with no driver: device/console/0
>>> Freeing unused kernel memory: 372k freed
>>> Red Hat nash version 6.0.19 starting
>>> Mounting proc filesystem
>>> Mounting sysfs filesystem
>>> Creating /dev
>>> BUG: scheduling while atomic: swapper/0/0x00010000
>>> Modules linked in:
>>> Pid: 0, comm: swapper Not tainted 2.6.29-rc3-tip #481
>>> Call Trace:
>>> [<ffffffff80238c1f>] __schedule_bug+0x62/0x66
>>> [<ffffffff80211d2d>] ? retint_restore_args+0x5/0x20
>>> [<ffffffff80503921>] __schedule+0x95/0x792
>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>> [<ffffffff805040c2>] schedule+0xe/0x22
>>> [<ffffffff8020ff04>] cpu_idle+0x70/0x72
>>> [<ffffffff804fc3a0>] cpu_bringup_and_idle+0x13/0x15
>>> Creating initial device nodes
>>> Setting up hotplug.
>>>
>>>
>>> From what I can see, softirq 8 is the RCU softirq.  I don't know if 
>>> the "scheduling while atomic" is related or not, but its two new 
>>> schedulerish symptoms appearing at once, so I think its likely 
>>> they're related.
>>>     
>>
>> Hmmm...  Mysterious, as you seem to be using classic RCU, which hasn't
>> changed in awhile.  Which branch of the tip tree are you using?
>>   
>
> tip/master.  It looks like this appeared since -rc1.  Mu current  
> suspicion is the percpu changes, since I'm seeing some other strange  
> symptoms.

Cc:-ed more folks - it's either the percpu changes or the APIC changes 
(both occured at about the same time). Or maybe something from upstream.

Find below another crash the -tip testing has been triggering. I suspect 
the percpu changes.

it's this assert in SLUB that triggers:

  void kfree(const void *x)
  {
        struct page *page;
        void *object = (void *)x;

        if (unlikely(ZERO_OR_NULL_PTR(x)))
                return;

        page = virt_to_head_page(x);
        if (unlikely(!PageSlab(page))) {
                BUG_ON(!PageCompound(page)); <---------------- [bug]

that page frame got corrupted perhaps.

	Ingo

-------------------------->
Fedora release 9 (Sulphur)
Kernel 2.6.29-rc3-tip-01340-gb55ddcbf-dirty on an x86_64 (/dev/ttyS0)

centauri login: [   24.526227] skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   24.528235] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   35.296005] eth0: no IPv6 routers present
[   68.844034] ------------[ cut here ]------------
[   68.848000] kernel BUG at mm/slub.c:2815!
[   68.848000] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[   68.848000] last sysfs file: /sys/class/net/eth0/broadcast
[   68.848000] CPU 0 
[   68.848000] Modules linked in:
[   68.848000] Pid: 321, comm: rcu_torture_rea Tainted: G        W  2.6.29-rc3-tip-01340-gb55ddcbf-dirty #518
[   68.848000] RIP: 0010:[<ffffffff803100fa>]  [<ffffffff803100fa>] kfree+0x17a/0x180
[   68.848000] RSP: 0018:ffff880008e66e18  EFLAGS: 00010246
[   68.848000] RAX: 0000000000000400 RBX: ffffffff80d2c100 RCX: 0000000000000d2c
[   68.848000] RDX: ffff880007463000 RSI: 0000000000000000 RDI: ffffffff80d2c100
[   68.848000] RBP: ffff880008e66e48 R08: 0000000000000002 R09: 0000000000000001
[   68.848000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800074b89e0
[   68.848000] R13: ffff8800090313e0 R14: ffffffff80d2c100 R15: 00000000001ce460
[   68.848000] FS:  00007fabf62056f0(0000) GS:ffff880008e63000(0000) knlGS:0000000000000000
[   68.848000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   68.848000] CR2: 00000000006c3444 CR3: 000000003cd27000 CR4: 00000000000006e0
[   68.848000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.848000] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   68.848000] Process rcu_torture_rea (pid: 321, threadinfo ffff88003f042000, task ffff88003f03c000)
[   68.848000] Stack:
[   68.848000]  ffff880008e66e28 ffffffff80d2c100 ffffffff802b7bd0 ffff8800090313e0
[   68.848000]  0000000000000001 00000000001ce460 ffff880008e66e68 ffffffff802b7bf5
[   68.848000]  ffff880008e66e68 ffffffff80d2c100 ffff880008e66e88 ffffffff8049e6e7
[   68.848000] Call Trace:
[   68.848000]  <IRQ> <0> [<ffffffff802b7bd0>] ? free_user_ns+0x0/0x30
[   68.848000]  [<ffffffff802b7bf5>] free_user_ns+0x25/0x30
[   68.848000]  [<ffffffff8049e6e7>] kref_put+0x37/0x80
[   68.848000]  [<ffffffff8027f187>] free_uid+0xb7/0x110
[   68.848000]  [<ffffffff80292152>] put_cred_rcu+0x62/0xb0
[   68.848000]  [<ffffffff802c6e18>] __rcu_process_callbacks+0x158/0x2e0
[   68.848000]  [<ffffffff802c6fcb>] rcu_process_callbacks+0x2b/0x50
[   68.848000]  [<ffffffff80278bc4>] __do_softirq+0xa4/0x190
[   68.848000]  [<ffffffff8022f56c>] call_softirq+0x1c/0x30
[   68.848000]  [<ffffffff80230e55>] do_softirq+0x95/0xe0
[   68.848000]  [<ffffffff802786ad>] irq_exit+0x5d/0x70
[   68.848000]  [<ffffffff80245cbf>] smp_apic_timer_interrupt+0x6f/0xa0
[   68.848000]  [<ffffffff8022ef43>] apic_timer_interrupt+0x13/0x20
[   68.848000]  <EOI> <0>Code: 08 75 8e 8b 43 10 85 c0 78 87 8b 53 14 48 8b 03 49 89 04 d6 4c 89 33 eb 8e f6 c4 60 74 0d 4c 89 e7 e8 7b 4c fd ff 0f 1f 00 eb 95 <0f> 0b eb fe 66 90 55 48 89 e5 e8 37 dd f1 ff 48 81 ef e0 00 00 
[   68.848000] RIP  [<ffffffff803100fa>] kfree+0x17a/0x180
[   68.848000]  RSP <ffff880008e66e18>
[   68.848002] ---[ end trace 93d72a36b9146f24 ]---
[   68.852002] Kernel panic - not syncing: Fatal exception in interrupt
[   68.856002] Pid: 321, comm: rcu_torture_rea Tainted: G      D W  2.6.29-rc3-tip-01340-gb55ddcbf-dirty #518
[   68.860001] Call Trace:
[   68.862509]  <IRQ>  [<ffffffff809710af>] panic+0x7a/0x14b
[   68.868004]  [<ffffffff809746f0>] ? _spin_unlock_irqrestore+0x70/0x80
[   68.872003]  [<ffffffff8097605a>] oops_end+0xba/0xd0
[   68.876002]  [<ffffffff802324fb>] die+0x5b/0x90
[   68.880002]  [<ffffffff80975816>] do_trap+0x146/0x170
[   68.884003]  [<ffffffff8022f995>] do_invalid_op+0x95/0xb0
[   68.888003]  [<ffffffff803100fa>] ? kfree+0x17a/0x180
[   68.892004]  [<ffffffff8029b719>] ? trace_hardirqs_off_caller+0x29/0xe0
[   68.896003]  [<ffffffff809741be>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   68.900003]  [<ffffffff8022f1ab>] invalid_op+0x1b/0x20
[   68.904003]  [<ffffffff803100fa>] ? kfree+0x17a/0x180
[   68.908003]  [<ffffffff8030ffb3>] ? kfree+0x33/0x180
[   68.912003]  [<ffffffff802b7bd0>] ? free_user_ns+0x0/0x30
[   68.916003]  [<ffffffff802b7bf5>] free_user_ns+0x25/0x30
[   68.920003]  [<ffffffff8049e6e7>] kref_put+0x37/0x80
[   68.924002]  [<ffffffff8027f187>] free_uid+0xb7/0x110
[   68.928002]  [<ffffffff80292152>] put_cred_rcu+0x62/0xb0
[   68.932003]  [<ffffffff802c6e18>] __rcu_process_callbacks+0x158/0x2e0
[   68.936003]  [<ffffffff802c6fcb>] rcu_process_callbacks+0x2b/0x50
[   68.940003]  [<ffffffff80278bc4>] __do_softirq+0xa4/0x190
[   68.944003]  [<ffffffff8022f56c>] call_softirq+0x1c/0x30
[   68.948002]  [<ffffffff80230e55>] do_softirq+0x95/0xe0
[   68.952003]  [<ffffffff802786ad>] irq_exit+0x5d/0x70
[   68.956003]  [<ffffffff80245cbf>] smp_apic_timer_interrupt+0x6f/0xa0
[   68.960003]  [<ffffffff8022ef43>] apic_timer_interrupt+0x13/0x20
[   68.964001]  <EOI> Press any key to enter the menu

