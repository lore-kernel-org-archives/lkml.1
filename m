Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbZHUU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbZHUU56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbZHUU55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:57:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57416 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbZHUU54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:57:56 -0400
To: David Dillow <dave@thedillows.org>
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?Q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
References: <200903041828.49972.m.bueker@berlin.de>
	<1242001754.4093.12.camel@obelisk.thedillows.org>
	<200905112248.44868.mb@bu3sch.de> <200905112310.08534.mb@bu3sch.de>
	<1242077392.3716.15.camel@lap75545.ornl.gov>
	<4A09DC3E.2080807@googlemail.com>
	<1242268709.4979.7.camel@obelisk.thedillows.org>
	<4A0C6504.8000704@googlemail.com>
	<1242328457.32579.12.camel@lap75545.ornl.gov>
	<4A0C7443.1010000@googlemail.com>
	<1243042174.3580.23.camel@obelisk.thedillows.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 21 Aug 2009 13:57:49 -0700
In-Reply-To: <1243042174.3580.23.camel@obelisk.thedillows.org> (David Dillow's message of "Fri\, 22 May 2009 21\:29\:34 -0400")
Message-ID: <m1skfkrik2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: dave@thedillows.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, m.bueker@berlin.de, rsantos@grupopie.com, romieu@fr.zoreil.com, mb@bu3sch.de, michael.riepe@googlemail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> writes:

> The 8169 chip only generates MSI interrupts when all enabled event
> sources are quiescent and one or more sources transition to active. If
> not all of the active events are acknowledged, or a new event becomes
> active while the existing ones are cleared in the handler, we will not
> see a new interrupt.
>
> The current interrupt handler masks off the Rx and Tx events once the
> NAPI handler has been scheduled, which opens a race window in which we
> can get another Rx or Tx event and never ACK'ing it, stopping all
> activity until the link is reset (ifconfig down/up). Fix this by always
> ACK'ing all event sources, and loop in the handler until we have all
> sources quiescent.
>
> Signed-off-by: David Dillow <dave@thedillows.org>
> ---
> This fixes the lockups I've seen. Both MSI and level-triggered interrupt
> configurations survive over an hour of testing when it would lockup in
> under 90 seconds before. I am certain of the analysis of the root cause,
> but there may be better ways to fix it. There may also be a theoretical
> race window between the ending of a NAPI poll cycle and a link change
> interrupt coming in, but I'm not sure it would matter. 
>
> Some variant of this should also be applied to the currently running
> stable trees, as the problem is long-standing.

I have what at first glance looks like a problem caused by this
patch.  For the last month since upgrading one of my machines from
2.6.28 to 2.6.30 it has been becomming inaccessible from the
network and I have a few:

NETDEV WATCHDOG: eth0 (r8169): transmit timed out

in my logs and a lot soft lockups that always have rtl8169_interrupt
as the thing that is running.   I suspect your patch has introduced
a near infinite loop in the interrupt handler and is causing these
soft lockups.

Any ideas?

Eric

BUG: soft lockup - CPU#3 stuck for 61s! [swapper:0]
CPU 3:
Pid: 0, comm: swapper Tainted: G        W  2.6.30-170263.2006.Arora.fc11.x86_64 #1 G33M-S2
RIP: 0010:[<ffffffffa01deacd>]  [<ffffffffa01deacd>] rtl8169_interrupt+0x26f/0x2b7 [r8169]
RSP: 0018:ffff880028070cb0  EFLAGS: 00000206
RAX: 0000000000000050 RBX: ffff880028070d10 RCX: ffff88002807b9e0
RDX: ffffc2000065c03e RSI: ffff88012d79a000 RDI: 0000000000000246
RBP: ffffffff8100c9d3 R08: ffff88012fae0000 R09: ffff880028070ec0
R10: 077321422cb06619 R11: 000000003c5efb73 R12: ffff880028070c30
R13: ffff88012d79a000 R14: ffff88012d79a600 R15: 077321422cb06619
FS:  0000000000000000(0000) GS:ffff88002806d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fc10010c000 CR3: 0000000000201000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>  [<ffffffff81093f0b>] ? handle_IRQ_event+0x6a/0x13f
 [<ffffffff810219fa>] ? apic_write+0x24/0x3a
 [<ffffffff8109607a>] ? handle_edge_irq+0xdb/0x138
 [<ffffffff81012fbd>] ? native_sched_clock+0x2d/0x54
 [<ffffffff8100e996>] ? handle_irq+0x95/0xb7
 [<ffffffff8100df42>] ? do_IRQ+0x6a/0xe9
 [<ffffffff8100c853>] ? ret_from_intr+0x0/0x11
 [<ffffffff8104ba16>] ? __do_softirq+0x5e/0x1b0
 [<ffffffff8100cfcc>] ? call_softirq+0x1c/0x28
 [<ffffffff8100e721>] ? do_softirq+0x51/0xae
 [<ffffffff8104b6d2>] ? irq_exit+0x52/0xa3
 [<ffffffff81020f11>] ? smp_apic_timer_interrupt+0x94/0xb8
 [<ffffffff8100c9d3>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff81014096>] ? mwait_idle+0x9b/0xcc
 [<ffffffff81014038>] ? mwait_idle+0x3d/0xcc
 [<ffffffff8100ae08>] ? enter_idle+0x33/0x49
 [<ffffffff8100aece>] ? cpu_idle+0xb0/0xf3
 [<ffffffff8136f30c>] ? start_secondary+0x19c/0x1b7


