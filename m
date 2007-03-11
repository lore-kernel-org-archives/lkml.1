Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXCKOQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXCKOQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933659AbXCKOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:16:54 -0400
Received: from mxl144v74.mxlogic.net ([208.65.144.74]:35885 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933647AbXCKOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:16:53 -0400
X-Greylist: delayed 1565 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 10:16:53 EDT
Date: Sun, 11 Mar 2007 15:50:51 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Roland Dreier <roland.list@gmail.com>
Cc: Tziporet Koren <tziporet@mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep question (was Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!)
Message-ID: <20070311135051.GA31985@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 11 Mar 2007 13:53:05.0252 (UTC) FILETIME=[97B8EA40:01C763E4]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--7.017000-4.000000-31
X-Spam: [F=0.5001154812; S=0.500(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [63.251.237.3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <roland.list@gmail.com>:
> Subject: Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!
> 
> >Feb 27 17:47:52 sw169 kernel:  [<ffffffff8053aaf1>] _spin_lock_irqsave+0x15/0x24
> >Feb 27 17:47:52 sw169 kernel:  [<ffffffff88067a23>] :ib_ipoib:ipoib_neigh_destructor+0xc2/0x139
> 
> It looks like this is deadlocking trying to take priv->lock in ipoib_neigh_destructor().
> One idea I just had would be to build a kernel with CONFIG_PROVE_LOCKING 
> turned on, and then rerun this test.  There's a good chance that this would
> diagnose the deadlock.  (I don't have good access to my test machines right now, or
> else I would do it myself)

OK, I did that. But I get
	[13440.761857] INFO: trying to register non-static key.
	[13440.766903] the code is fine but needs lockdep annotation.
	[13440.772455] turning off the locking correctness validator.
and I am not sure what triggers this, or how to fix it to have the
validator actually do its job.

Ingo, what key does the message refer to?

The stack dump seems to point to drivers/infiniband/ulp/ipoib/ipoib_main.c line
829.

Full message below:
	
[13440.761857] INFO: trying to register non-static key.
[13440.766903] the code is fine but needs lockdep annotation.
[13440.772455] turning off the locking correctness validator.
[13440.778008]  [<c023c082>] __lock_acquire+0xae4/0xbb9
[13440.783078]  [<c023c43d>] lock_acquire+0x56/0x71
[13440.787784]  [<f899bff2>] ipoib_neigh_destructor+0xd0/0x132 [ib_ipoib]
[13440.794412]  [<c051ad41>] _spin_lock_irqsave+0x32/0x41
[13440.799649]  [<f899bff2>] ipoib_neigh_destructor+0xd0/0x132 [ib_ipoib]
[13440.806275]  [<f899bff2>] ipoib_neigh_destructor+0xd0/0x132 [ib_ipoib]
[13440.812897]  [<c04a1c1b>] dst_run_gc+0xc/0x118
[13440.817439]  [<c022af6e>] run_timer_softirq+0x37/0x16b
[13440.822673]  [<c04a1c0f>] dst_run_gc+0x0/0x118
[13440.827221]  [<c04a3eab>] neigh_destroy+0xbe/0x104
[13440.832114]  [<c04a1bb1>] dst_destroy+0x4d/0xab
[13440.836751]  [<c04a1c64>] dst_run_gc+0x55/0x118
[13440.841384]  [<c022b03f>] run_timer_softirq+0x108/0x16b
[13440.846711]  [<c0227634>] __do_softirq+0x5a/0xd5
[13440.851427]  [<c023b435>] trace_hardirqs_on+0x106/0x141
[13440.856754]  [<c0227643>] __do_softirq+0x69/0xd5
[13440.861470]  [<c02276e6>] do_softirq+0x37/0x4d
[13440.866016]  [<c02167b0>] smp_apic_timer_interrupt+0x6b/0x77
[13440.871774]  [<c02029ef>] default_idle+0x3b/0x54
[13440.876491]  [<c02029ef>] default_idle+0x3b/0x54
[13440.881211]  [<c0204c33>] apic_timer_interrupt+0x33/0x38
[13440.886624]  [<c02029ef>] default_idle+0x3b/0x54
[13440.891342]  [<c02029f1>] default_idle+0x3d/0x54
[13440.896061]  [<c0202aaa>] cpu_idle+0xa2/0xbb
[13440.900436]  =======================
[13768.711447] BUG: spinlock lockup on CPU#1, swapper/0, c0687880
[13768.717353]  [<c031f919>] _raw_spin_lock+0xda/0xfd
[13768.722247]  [<c051ad48>] _spin_lock_irqsave+0x39/0x41
[13768.727486]  [<f899bff2>] ipoib_neigh_destructor+0xd0/0x132 [ib_ipoib]
[13768.734110]  [<f899bff2>] ipoib_neigh_destructor+0xd0/0x132 [ib_ipoib]
[13768.740735]  [<c04a1c1b>] dst_run_gc+0xc/0x118
[13768.745276]  [<c022af6e>] run_timer_softirq+0x37/0x16b
[13768.750517]  [<c04a1c0f>] dst_run_gc+0x0/0x118
[13768.755061]  [<c04a3eab>] neigh_destroy+0xbe/0x104
[13768.759955]  [<c04a1bb1>] dst_destroy+0x4d/0xab
[13768.764586]  [<c04a1c64>] dst_run_gc+0x55/0x118
[13768.769218]  [<c022b03f>] run_timer_softirq+0x108/0x16b
[13768.774542]  [<c0227634>] __do_softirq+0x5a/0xd5
[13768.779261]  [<c023b435>] trace_hardirqs_on+0x106/0x141
[13768.784588]  [<c0227643>] __do_softirq+0x69/0xd5
[13768.789308]  [<c02276e6>] do_softirq+0x37/0x4d
[13768.793851]  [<c02167b0>] smp_apic_timer_interrupt+0x6b/0x77
[13768.799609]  [<c02029ef>] default_idle+0x3b/0x54
[13768.804326]  [<c02029ef>] default_idle+0x3b/0x54
[13768.809054]  [<c0204c33>] apic_timer_interrupt+0x33/0x38
[13768.814471]  [<c02029ef>] default_idle+0x3b/0x54
[13768.819187]  [<c02029f1>] default_idle+0x3d/0x54
[13768.823903]  [<c0202aaa>] cpu_idle+0xa2/0xbb
[13768.828279]  =======================


-- 
MST
