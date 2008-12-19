Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYLSW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYLSW00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLSW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:26:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbYLSW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:26:06 -0500
Date: Fri, 19 Dec 2008 14:19:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       a.p.zijlstra@chello.nl, mingo@elte.hu, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, ego@in.ibm.com,
       andi@firstfloor.org, davecb@sun.com, tconnors@astro.swin.edu.au,
       maxk@qualcomm.com, gregory.haskins@gmail.com, pavel@suse.cz,
       rusty@rustcorp.com.au
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-Id: <20081219141928.3c2939ef.akpm@linux-foundation.org>
In-Reply-To: <20081219135508.9c6217ba.akpm@linux-foundation.org>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	<20081218175622.29812.69201.stgit@drishya.in.ibm.com>
	<20081219135508.9c6217ba.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 13:55:08 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 18 Dec 2008 23:26:22 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > When the system utilisation is low and more cpus are idle,
> > then the process waking up from sleep should prefer to
> > wakeup an idle cpu from semi-idle cpu package (multi core
> > package) rather than a completely idle cpu package which
> > would waste power.
> > 
> > Use the sched_mc balance logic in find_busiest_group() to
> > nominate a preferred wakeup cpu.
> > 
> > This info can be sored in appropriate sched_domain, but
> > updating this info in all copies of sched_domain is not
> > practical.  Hence this information is stored in root_domain
> > struct which is one copy per partitioned sched domain.
> > The root_domain can be accessed from each cpu's runqueue
> > and there is one copy per partitioned sched domain.
> > 
> 
> kernel/sched.c: In function 'find_busiest_group':
> kernel/sched.c:3403: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
> 
> 
> kernel/sched.c: In function 'schedule':
> kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> 

I left those unfixed and...

[   62.307607] initcall init_nfsd+0x0/0xe2 [nfsd] returned 0 after 251 usecs
[   62.399426] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   74.009934] divide error: 0000 [#1] SMP 
[   74.010085] last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:02.0/0000:05:00.1/irq
[   74.010147] CPU 1 
[   74.010241] Modules linked in: nfsd auth_rpcgss exportfs lockd nfs_acl autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_multipath dm_mod rfkill input_polldev sbs sbshc battery ac parport_pc lp parport snd_hda_codec_realtek sg snd_hda_intel floppy snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ide_cd_mod cdrom snd_pcm_oss snd_mixer_oss serio_raw snd_pcm button shpchp snd_timer i2c_i801 i2c_core snd soundcore snd_page_alloc pcspkr ehci_hcd ohci_hcd uhci_hcd
[   74.012821] Pid: 0, comm: swapper Not tainted 2.6.28-rc9-mm1 #1
[   74.012875] RIP: 0010:[<ffffffff802375d8>]  [<ffffffff802375d8>] tg_shares_up+0x113/0x1f1
[   74.012982] RSP: 0018:ffff88025e057d88  EFLAGS: 00010246
[   74.013038] RAX: 0000000000000000 RBX: ffff880028063900 RCX: ffff880028058dc0
[   74.013095] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000ff
[   74.013152] RBP: ffff88025e057dd8 R08: 0000000000000000 R09: 0000000000000000
[   74.013209] R10: ffff880028067640 R11: 0000000000000022 R12: ffff880028063900
[   74.013264] R13: ffffffff802374c5 R14: ffffffff8022c546 R15: ffffffff8079b4a0
[   74.013321] FS:  0000000000000000(0000) GS:ffff88025e0385c0(0000) knlGS:0000000000000000
[   74.013381] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   74.013435] CR2: 00007fdb795af8f0 CR3: 0000000000201000 CR4: 00000000000006e0
[   74.013489] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   74.013545] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   74.013602] Process swapper (pid: 0, threadinfo ffff88025e050000, task ffff88025e03f870)
[   74.013661] Stack:
[   74.013708]  0000000000000000 ffff880028063a00 0000000000000000 0000000000000000
[   74.013893]  0000000000000008 ffffffff8079b4a0 ffff880028063900 ffffffff802374c5
[   74.013893]  ffffffff8022c546 0000000000000030 ffff88025e057e08 ffffffff8022c530
[   74.013893] Call Trace:
[   74.013893]  <IRQ> <0> [<ffffffff802374c5>] ? tg_shares_up+0x0/0x1f1
[   74.013893]  [<ffffffff8022c546>] ? tg_nop+0x0/0x8
[   74.013893]  [<ffffffff8022c530>] walk_tg_tree+0x5f/0x75
[   74.013893]  [<ffffffff8022c65c>] update_shares+0x46/0x4a
[   74.013893]  [<ffffffff80235fe4>] run_rebalance_domains+0x192/0x522
[   74.013893]  [<ffffffff802543eb>] ? getnstimeofday+0x3d/0x9e
[   74.013893]  [<ffffffff8052bd73>] ? _spin_unlock_irq+0x9/0xc
[   74.013893]  [<ffffffff8024057f>] __do_softirq+0xa3/0x164
[   74.013893]  [<ffffffff8020d0bc>] call_softirq+0x1c/0x28
[   74.013893]  [<ffffffff8020e19d>] do_softirq+0x31/0x73
[   74.013893]  [<ffffffff802402ca>] irq_exit+0x3f/0x41
[   74.013893]  [<ffffffff8021e71d>] smp_apic_timer_interrupt+0x94/0xad
[   74.013893]  [<ffffffff8020caf3>] apic_timer_interrupt+0x13/0x20
[   74.013893]  <EOI> <0>Code: 8b 47 08 4a 8b 0c 00 48 85 c9 0f 84 c3 00 00 00 49 8b 47 10 4a 8b 04 00 48 8b 80 a8 00 00 00 48 85 c0 74 13 48 0f af 45 c8 31 d2 <48> f7 75 c0 49 89 c6 48 89 c6 eb 16 48 63 55 d0 48 8b 45 c8 45 
[   74.013893] RIP  [<ffffffff802375d8>] tg_shares_up+0x113/0x1f1
[   74.013893]  RSP <ffff88025e057d88>
[   74.020022] ---[ end trace 2fc4046e394f2312 ]---
[   74.020188] Kernel panic - not syncing: Fatal exception in interrupt

config: http://userweb.kernel.org/~akpm/config-akpm2.txt

I'll try hacking some div-by-zero avoidance into update_group_shares_cpu().
