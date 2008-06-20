Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYFTP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYFTP2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbYFTP2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:28:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbYFTP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:28:09 -0400
Date: Fri, 20 Jun 2008 17:27:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Message-ID: <20080620152748.GA21245@elte.hu>
References: <1213739834.3803.137.camel@johannes.berg> <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org> <1213774177.3803.164.camel@johannes.berg> <20080620134637.GA8135@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620134637.GA8135@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Subject: clean up and comment local_bh_enable code
> > 
> > There's no need to use local_irq_save() over local_irq_disable() in 
> > the local_bh_enable code since it is a bug to call it with irqs 
> > disabled and do_softirq will enable irqs if there is any pending 
> > work. Consolidate the code from local_bh_enable and ..._ip to avoid 
> > having a disconnect between them in the warnings they trigger that 
> > is currently there. Also always trigger the warning on in_irq(), not 
> > just in the trace-irqflags case.
> 
> applied to tip/core/softirq for testing, thanks Johannes.

ok, -tip testing found that your patch triggers a new warning on an old 
testbox that uses 3c59x vortex and netlogging:

----->
calling  vortex_init+0x0/0xb0
PCI: Found IRQ 10 for device 0000:00:0b.0
PCI: Sharing IRQ 10 with 0000:00:0a.0
PCI: Sharing IRQ 10 with 0000:00:0b.1
3c59x: Donald Becker and others.
0000:00:0b.0: 3Com PCI 3c556 Laptop Tornado at e0800400.
PCI: Enabling bus mastering for device 0000:00:0b.0
initcall vortex_init+0x0/0xb0 returned 0 after 47 msecs
...
calling  init_netconsole+0x0/0x1b0
netconsole: local port 4444
netconsole: local IP 10.0.1.9
netconsole: interface eth0
netconsole: remote port 4444
netconsole: remote IP 10.0.1.16
netconsole: remote ethernet address 00:19:xx:xx:xx:xx
netconsole: device eth0 not up yet, forcing it
eth0:  setting half-duplex.
eth0:  setting full-duplex.
------------[ cut here ]------------
WARNING: at kernel/softirq.c:137 local_bh_enable_ip+0xd1/0xe0()
Pid: 1, comm: swapper Not tainted 2.6.26-rc6-tip #2091
 [<c0125ecf>] warn_on_slowpath+0x4f/0x70
 [<c0126834>] ? release_console_sem+0x1b4/0x1d0
 [<c0126d00>] ? vprintk+0x2a0/0x450
 [<c012fde5>] ? __mod_timer+0xa5/0xc0
 [<c046f7fd>] ? mdio_sync+0x3d/0x50
 [<c0160ef6>] ? marker_probe_cb+0x46/0xa0
 [<c0126ed7>] ? printk+0x27/0x50
 [<c046f4c3>] ? vortex_set_duplex+0x43/0xc0
 [<c046f521>] ? vortex_set_duplex+0xa1/0xc0
 [<c0471b92>] ? vortex_timer+0xe2/0x3e0
 [<c012b361>] local_bh_enable_ip+0xd1/0xe0
 [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
 [<c0471b92>] vortex_timer+0xe2/0x3e0
 [<c014743b>] ? trace_hardirqs_on+0xb/0x10
 [<c0147358>] ? trace_hardirqs_on_caller+0x88/0x160
 [<c012f8b2>] run_timer_softirq+0x162/0x1c0
 [<c0471ab0>] ? vortex_timer+0x0/0x3e0
 [<c012b361>] local_bh_enable_ip+0xd1/0xe0
 [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
 [<c0471b92>] vortex_timer+0xe2/0x3e0
 [<c014743b>] ? trace_hardirqs_on+0xb/0x10
 [<c0147358>] ? trace_hardirqs_on_caller+0x88/0x160
 [<c012f8b2>] run_timer_softirq+0x162/0x1c0
 [<c0471ab0>] ? vortex_timer+0x0/0x3e0
 [<c0471ab0>] ? vortex_timer+0x0/0x3e0
 [<c012b60a>] __do_softirq+0x9a/0x160
 [<c012b570>] ? __do_softirq+0x0/0x160
 [<c0106775>] call_on_stack+0x15/0x30
 [<c012b4f5>] ? irq_exit+0x55/0x60
 [<c0106e85>] ? do_IRQ+0x85/0xd0
 [<c0147391>] ? trace_hardirqs_on_caller+0xc1/0x160
 [<c0104888>] ? common_interrupt+0x28/0x30
 [<c08d8ac8>] ? mutex_unlock+0x8/0x10
 [<c08d8180>] ? _cond_resched+0x10/0x30
 [<c07a3be7>] ? netpoll_setup+0x117/0x390
 [<c0cbfcfe>] ? init_netconsole+0x14e/0x1b0
 [<c013d539>] ? ktime_get+0x19/0x40
 [<c0c9bab2>] ? kernel_init+0x1b2/0x2c0
 [<c0cbfbb0>] ? init_netconsole+0x0/0x1b0
 [<c0396aa4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103f12>] ? restore_nocheck_notrace+0x0/0xe
 [<c0c9b900>] ? kernel_init+0x0/0x2c0
 [<c0c9b900>] ? kernel_init+0x0/0x2c0
 [<c0104aa7>] ? kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 37f9c502aff112e0 ]---
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1b0 returned 0 after 2914 msecs

real bug or false positive?

config is at:

  http://redhat.com/~mingo/misc/config-Fri_Jun_20_16_51_07_CEST_2008.bad

	Ingo
