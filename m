Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKDNA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKDNA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZKDNA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:00:56 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:54260 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZKDNAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sAOV8HPmWWwtOwrftEYggnZKpUsDX/8LLqYtaZMuN7Iwk8c0rEpxhRNE+oHojT51SJ
         wxedU/axuiIpjiIKZh3bpKAFRf30rgJYN6MltrXoKnU6fATq/I5cEiLhCY/fn51Yha2f
         iSEXX/vQgf2jxIImCIkqPoOqcZ/UKgvP3LSnQ=
MIME-Version: 1.0
In-Reply-To: <2674af740911040449h14eaac35y2ec3016862479bc6@mail.gmail.com>
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com>
	 <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
	 <alpine.LFD.2.00.0911041016070.12138@localhost.localdomain>
	 <2674af740911040449h14eaac35y2ec3016862479bc6@mail.gmail.com>
Date: Wed, 4 Nov 2009 21:01:00 +0800
Message-ID: <2674af740911040501p4ef8b6c5jcbd11f1a57dbf8b7@mail.gmail.com>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 83ee4c7591aae764f1656bd68f6e95ae112e2e7a Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang0@gmail.com>
Date: Wed, 4 Nov 2009 20:52:45 +0800
Subject: [PATCH] genirq: try_one_irq() should be called with irq disabled

Prarit report this:
Booting 2.6.32-rc5 on some IBM systems results in

Disabling IRQ #19

=================================
[ INFO: inconsistent lock state ]
2.6.32-rc5 #1
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&irq_desc_lock_class){?.-...}, at: [<ffffffff810c264e>] try_one_irq+0x32/0x138
{IN-HARDIRQ-W} state was registered at:
 [<ffffffff81095160>] __lock_acquire+0x2fc/0xd5d
 [<ffffffff81095cb4>] lock_acquire+0xf3/0x12d
 [<ffffffff814cdadd>] _spin_lock+0x40/0x89
 [<ffffffff810c3389>] handle_level_irq+0x30/0x105
 [<ffffffff81014e0e>] handle_irq+0x95/0xb7
 [<ffffffff810141bd>] do_IRQ+0x6a/0xe0
 [<ffffffff81012813>] ret_from_intr+0x0/0x16
irq event stamp: 195096
hardirqs last  enabled at (195096): [<ffffffff814cd7f7>]
_spin_unlock_irq+0x3a/0x5c
hardirqs last disabled at (195095): [<ffffffff814cdbdd>]
_spin_lock_irq+0x29/0x95
softirqs last  enabled at (195088): [<ffffffff81068c92>]
__do_softirq+0x1c1/0x1ef
softirqs last disabled at (195093): [<ffffffff8101304c>] call_softirq+0x1c/0x30

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (kernel/irq/spurious.c:21){+.-...}, at: [<ffffffff81070cf2>]
run_timer_softirq+0x1a9/0x315

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.32-rc5 #1
Call Trace:
 <IRQ>  [<ffffffff81093e94>] valid_state+0x187/0x1ae
 [<ffffffff81096c7b>] ? check_usage_backwards+0x0/0xa3
 [<ffffffff81093fe4>] mark_lock+0x129/0x253
 [<ffffffff810951d4>] __lock_acquire+0x370/0xd5d
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff8109329d>] ? save_trace+0x4e/0xcd
 [<ffffffff81095cb4>] lock_acquire+0xf3/0x12d
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff81070cf2>] ? run_timer_softirq+0x1a9/0x315
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff814cdadd>] _spin_lock+0x40/0x89
 [<ffffffff810c264e>] ? try_one_irq+0x32/0x138
 [<ffffffff810c264e>] try_one_irq+0x32/0x138
 [<ffffffff810c2795>] poll_all_shared_irqs+0x41/0x6d
 [<ffffffff810c27dd>] poll_spurious_irqs+0x1c/0x49
 [<ffffffff81070d82>] run_timer_softirq+0x239/0x315
 [<ffffffff81070cf2>] ? run_timer_softirq+0x1a9/0x315
 [<ffffffff810c27c1>] ? poll_spurious_irqs+0x0/0x49
 [<ffffffff81068bd3>] __do_softirq+0x102/0x1ef
 [<ffffffff8108eccf>] ? tick_dev_program_event+0x46/0xcc
 [<ffffffff8101304c>] call_softirq+0x1c/0x30
 [<ffffffff81014b65>] do_softirq+0x59/0xca
 [<ffffffff810686ad>] irq_exit+0x58/0xae
 [<ffffffff81029b84>] smp_apic_timer_interrupt+0x94/0xba
 [<ffffffff81012a33>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff8101a7b5>] ? mwait_idle+0x8c/0xb5
 [<ffffffff8101a7ac>] ? mwait_idle+0x83/0xb5
 [<ffffffff81010e55>] ? cpu_idle+0xbe/0x100
 [<ffffffff814c4270>] ? start_secondary+0x219/0x270

The reason is that try_one_irq() is called both from hardirq context
and softirq context. And by default the timer handler
poll_all_shared_irqs() is called with irq enabled.
Then the two usage will cause inconsistent.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/irq/spurious.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..bd7273e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -121,7 +121,9 @@ static void poll_all_shared_irqs(void)
 		if (!(status & IRQ_SPURIOUS_DISABLED))
 			continue;

+		local_irq_disable();
 		try_one_irq(i, desc);
+		local_irq_enable();
 	}
 }

-- 
1.6.3.3
