Return-Path: <linux-kernel-owner+w=401wt.eu-S966743AbXG3Q1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966743AbXG3Q1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939609AbXG3QTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:19:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:62702 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939578AbXG3QTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="274404512"
Message-ID: <46AE0F66.7000504@intel.com>
Date: Mon, 30 Jul 2007 09:18:46 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Attila Nagy <bra@fsn.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
References: <46AE0420.4030900@fsn.hu>
In-Reply-To: <46AE0420.4030900@fsn.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 16:19:22.0824 (UTC) FILETIME=[63CEDC80:01C7D2C5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Attila Nagy wrote:
> Hello,
> 
> I have four identical machines, based on Supermicro X7DBE motherboards.
> All of the machines have two Xeon 5130 CPUs, 16GB RAM and two add-on
> cards: an Areca 1261 SATA RAID HBA and a Qlogic QLA2342 fibre channel HBA.
> 
> I would like to use these as file servers (via FC), but during the 
> performance and
> reliabilty tests it turned out that the machines are very unreliable, 
> despite that they
> seemed to be OK hardware-wise (memtest and the usual stuff).
> 
> During the debugging of this (seemingly) high IO load related problem, I 
> have
> observed the following:
> - when MSI is enabled (the first iteration), the machines sometimes 
> "hang", but
> not the whole system, just the SCSI target subsystem (SCST), which makes
> heavy IO on the Areca (arcmsr) and the Qlogic (patched qla2xxx) HBAs
> - when MSI is disabled, I couldn't reproduce that hung up state, instead the
> machines sometimes throw an MCE (see below), but I couldn't find its cause
> - when MSI is disabled, and CONFIG_DEBUG_SHIRQ is enabled, the machines
> can't even boot normally, I get an oops instantly during the kernel 
> initialization
> - with MSI disabled sometimes the machines fail to respond, the ssh 
> sessions terminate
> and on the console I can't type for very long seconds. I have nearly all 
> debugging turned on,
> but can't see anything in the logs or on the console. The machine 
> recovers from this hang
> automatically. The whole thing seems like when a high (eg. network) 
> interrupt activity happens
> on a highly loaded machine, but I could observe this even after a fresh 
> boot, without anything
> (of course minus the standard stuff, sshd, and the others) running on 
> the machine.
> 
> The kernel is 2.6.21.5 (I've tried 2.6.18, the effects are the same), 
> running in 64 bit mode.

something is definately not happy on this system. There was a e1000 fix related 
to DEBUG_SHIRQ in 2.6.22, so I definately advise you to test 2.6.22.1 
immediately - however:

> The oops I get with MSI disabled and CONFIG_DEBUG_SHIRQ enabled:
> 
> [   92.681320] NET: Registered protocol family 17
> [   93.491658] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> [   93.557402]  [<0000000000000000>]
> [   93.626770] PGD 0
> [   93.651106] Oops: 0010 [1] SMP
> [   93.689170] CPU 1
> [   93.713506] Modules linked in:
> [   93.750322] Pid: 1, comm: swapper Not tainted 2.6.21.5 #1
> [   93.815011] RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
> [   93.887187] RSP: 0018:ffff81042fc5dc68  EFLAGS: 00010002
> [   93.950836] RAX: ffff81042fbe6b70 RBX: 0000000000000202 RCX: ffff81042fbe6b70
> [   94.036323] RDX: ffffc20000040000 RSI: ffff81042f51cdf8 RDI: ffff81042fbe6800
> [   94.121812] RBP: ffff81042fc5dd10 R08: 0000000000000000 R09: ffff81042f4c0ea8
> [   94.207298] R10: 0000000000000000 R11: ffff81042fbe6800 R12: 00000000fffffff4
> [   94.292788] R13: ffff81042fbe6000 R14: 0000000000000001 R15: ffffffff80399450
> [   94.378275] FS:  0000000000000000(0000) GS:ffff81042fc694c8(0000) knlGS:0000000000000000
> [   94.475307] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   94.544153] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   94.629643] Process swapper (pid: 1, threadinfo ffff81042fc5c000, task ffff81042fc58040)
> [   94.726673] Stack:  ffffffff80399559 ffff81042fc5dca0 ffffffff802121b2 ffff81042f4c0ea0
> [   94.823603]  ffff81042fc5dca0 ffffffff80221cd7 ffffffff802addb5 ffff81042fbe6800
> [   94.913042]  ffffffff8020c9bc ffff81042fbe6b70 0000000000000246 ffff81042fbe6b70
> [   95.000194] Call Trace:
> [   95.031814]  [<ffffffff80399559>] e1000_intr+0x109/0x590
> [   95.095461]  [<ffffffff802121b2>] poison_obj+0x42/0x60
> [   95.157027]  [<ffffffff80221cd7>] dbg_redzone1+0x17/0x30
> [   95.220676]  [<ffffffff802addb5>] request_irq+0x95/0x150
> [   95.284324]  [<ffffffff8020c9bc>] cache_alloc_debugcheck_after+0x17c/0x1c0
> [   95.366690]  [<ffffffff8020a43d>] kmem_cache_alloc+0xcd/0xf0
> [   95.434500]  [<ffffffff80399450>] e1000_intr+0x0/0x590
> [   95.496067]  [<ffffffff802ade00>] request_irq+0xe0/0x150
> [   95.559716]  [<ffffffff8039558c>] e1000_request_irq+0x3c/0x80
> [   95.628564]  [<ffffffff803985bc>] e1000_open+0x5c/0x100
> [   95.691172]  [<ffffffff8041d937>] dev_open+0x37/0x80
> [   95.750661]  [<ffffffff8041becd>] dev_change_flags+0x6d/0x150
> [   95.819508]  [<ffffffff80616565>] ip_auto_config+0x175/0xea0
> [   95.887317]  [<ffffffff80442f88>] tcp_set_default_congestion_control+0x18/0x70
> [   95.973947]  [<ffffffff80442fcf>] tcp_set_default_congestion_control+0x5f/0x70
> [   96.060582]  [<ffffffff80265236>] _spin_unlock+0x26/0x30
> [   96.124227]  [<ffffffff805f1754>] init+0x1a4/0x2b0
> [   96.181635]  [<ffffffff802a0e7b>] trace_hardirqs_on+0x14b/0x180
> [   96.252563]  [<ffffffff8025ff28>] child_rip+0xa/0x12
> [   96.312051]  [<ffffffff8026563b>] _spin_unlock_irq+0x2b/0x40
> [   96.379859]  [<ffffffff8025f63c>] restore_args+0x0/0x30
> [   96.442467]  [<ffffffff805f15b0>] init+0x0/0x2b0
> [   96.497795]  [<ffffffff8025ff1e>] child_rip+0x0/0x12
> [   96.557282]
> [   96.575170]
> [   96.575171] Code:  Bad RIP value.
> [   96.633203] RIP  [<0000000000000000>]
> [   96.677297]  RSP <ffff81042fc5dc68>
> [   96.719105] CR2: 0000000000000000
> [   96.758835] Kernel panic - not syncing: Attempted to kill init!
> 
> 
> MCE:
> [153103.918654] HARDWARE ERROR
> [153103.918655] CPU 1: Machine Check Exception:                5 Bank 0: 
> b200004010000400
> [153104.066037] RIP !INEXACT! 10:<ffffffff802569e6> {mwait_idle+0x46/0x60}
> [153104.145699] TSC 1167e915e93ce
> [153104.183554] This is not a software problem!
> [153104.234724] Run through mcelog --ascii to decode and contact your 
> hardware vendor
> [153104.325517]
> [153104.325518] HARDWARE ERROR
> [153104.325519] CPU 1: Machine Check Exception:                5 Bank 5: 
> b200221024080400
> [153104.472883] RIP !INEXACT! 10:<ffffffff802569e6> {mwait_idle+0x46/0x60}
> [153104.552546] TSC 1167e915e9ea8
> [153104.590402] This is not a software problem!
> [153104.641572] Run through mcelog --ascii to decode and contact your 
> hardware vendor
> [153104.732365] Kernel panic - not syncing: Machine check

this is serious problems that might not be resolved and be a symptom of a true 
hardware issue. Looking at the time it seems an issue on itself and unrelated to 
the e1000 debug_shirq fix.

> I've got exactly the same errors (only the TSC and the CPU value 
> changing) on all four machines,
> could this really be a hardware error?

yes

> full dmesg: http://people.fsn.hu/~bra/linux/x7dbe-20070730/with_debug_shirq
> dmesg with MSI enabled: 
> http://people.fsn.hu/~bra/linux/x7dbe-20070730/with_msi_and_debug_shirq
> kernel config: http://people.fsn.hu/~bra/linux/x7dbe-20070730/config
> 
> I've tried to disable all possible devices which consume interrupts,
> and placed the cards into various slots (the FC HBA is PCI-X, which the 
> Areca
> is PCI-E). Currently the arcmsr and (one of, it's a dual channel
> HBA) qla2xxx are on a shared IRQ.
> 
> Could you please help?
> Do you think this is related to the strange hang under high IO load, the
> occasional, complete "blackouts", where all ssh network sessions
> time out, but the machine recovers, and the MCEs?


Like I said, please try 2.6.22 which should have the e1000 issue fixed. The MCE 
looks real and a different problem

Auke
