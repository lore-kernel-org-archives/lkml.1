Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbXCKQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbXCKQL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 12:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXCKQL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 12:11:56 -0400
Received: from mxl144v74.mxlogic.net ([208.65.144.74]:40347 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbXCKQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 12:11:55 -0400
Date: Sun, 11 Mar 2007 18:12:31 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland Dreier <roland.list@gmail.com>,
       Tziporet Koren <tziporet@mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup detected on CPU#0!)
Message-ID: <20070311161231.GC13817@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il> <1173626719.5182.10.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173626719.5182.10.camel@lappy>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 11 Mar 2007 16:14:46.0110 (UTC) FILETIME=[62A0E7E0:01C763F8]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--15.833900-4.000000-31
X-Spam: [F=0.5022257472; S=0.502(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [63.251.237.3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Zijlstra <a.p.zijlstra@chello.nl>:
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: softlockup detected on CPU#0!)

> On Sun, 2007-03-11 at 15:50 +0200, Michael S. Tsirkin wrote:
> > > Quoting Roland Dreier <roland.list@gmail.com>:
> > > Subject: Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!
> > > 
> > > >Feb 27 17:47:52 sw169 kernel:  [<ffffffff8053aaf1>] _spin_lock_irqsave+0x15/0x24
> > > >Feb 27 17:47:52 sw169 kernel:  [<ffffffff88067a23>] :ib_ipoib:ipoib_neigh_destructor+0xc2/0x139
> > > 
> > > It looks like this is deadlocking trying to take priv->lock in ipoib_neigh_destructor().
> > > One idea I just had would be to build a kernel with CONFIG_PROVE_LOCKING 
> > > turned on, and then rerun this test.  There's a good chance that this would
> > > diagnose the deadlock.  (I don't have good access to my test machines right now, or
> > > else I would do it myself)
> > 
> > OK, I did that. But I get
> > 	[13440.761857] INFO: trying to register non-static key.
> > 	[13440.766903] the code is fine but needs lockdep annotation.
> > 	[13440.772455] turning off the locking correctness validator.
> > and I am not sure what triggers this, or how to fix it to have the
> > validator actually do its job.
> 
> It usually indicates a spinlock is not properly initialized. Like
> __SPIN_LOCK_UNLOCKED() used in a non-static context, use
> spin_lock_init() in these cases.
> 
> However looking at the code, ipoib_neight_destructor only uses
> &priv->lock, and that seems to get properly initialized in ipoib_setup()
> using spin_lock_init().
> 
> So either there are other sites that instanciate those objects and
> forget about the lock init, or the object is corrupted (use after free?)

OK, thanks for the hint. So I added this:

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f9dbc6f..2eea467 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -821,8 +821,15 @@ static void ipoib_neigh_destructor(struct neighbour *n)
 	unsigned long flags;
 	struct ipoib_ah *ah = NULL;
 
+	if (n->dev->type != ARPHRD_INFINIBAND) {
+		printk(KERN_ERR "ipoib_neigh_destructor lock %p wrong type %d !!!!!!!!!!\n",
+		       &priv->lock, n->dev->type);
+		BUG_ON(n->dev->type != ARPHRD_INFINIBAND);
+		return;
+	}
+
 	ipoib_dbg(priv,
 		  "neigh_destructor for %06x " IPOIB_GID_FMT "\n",
 		  IPOIB_QPN(n->ha),
 		  IPOIB_GID_RAW_ARG(n->ha + 4));
 
And sure enough it triggers:

[  858.503010] ipoib_neigh_destructor lock c0687880 wrong type 772 !!!!!!!!!!
[  858.510036] ------------[ cut here ]------------
[  858.514723] kernel BUG at drivers/infiniband/ulp/ipoib/ipoib_main.c:827!
[  858.521486] invalid opcode: 0000 [#1]
[  858.525212] SMP
[  858.527173] Modules linked in: rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ibv
[  858.538736] CPU:    0
[  858.538737] EIP:    0060:[<f899bfa5>]    Not tainted VLI
[  858.538738] EFLAGS: 00010206   (2.6.21-rc3-i686-dbg #4)
[  858.551755] EIP is at ipoib_neigh_destructor+0x40/0x178 [ib_ipoib]
[  858.557996] eax: c0687300   ebx: f240e880   ecx: c0223114   edx: c064f280
[  858.564851] esi: f240e880   edi: f240e880   ebp: c0687880   esp: c06c7e9c
[  858.571702] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  858.577602] Process swapper (pid: 0, ti=c06c6000 task=c064f280 task.ti=c06c6000)
[  858.584883] Stack: f89a37be c0687880 00000304 c022af6e c064f280 00000000 00000000 0000
[  858.593573]        00000000 c06a2554 00000000 c064f280 00000001 00000000 c064f280 0000
[  858.602259]        c0860be0 c2a1fba0 00000246 c06a2554 f240e880 00000000 f240e880 c04a
[  858.610946] Call Trace:
[  858.613723]  [<c022af6e>] run_timer_softirq+0x37/0x16b
[  858.618959]  [<c04a1c0f>] dst_run_gc+0x0/0x118
[  858.623498]  [<c04a3eab>] neigh_destroy+0xbe/0x104
[  858.628382]  [<c04a1bb1>] dst_destroy+0x4d/0xab
[  858.632998]  [<c04a1c64>] dst_run_gc+0x55/0x118
[  858.637620]  [<c022b03f>] run_timer_softirq+0x108/0x16b
[  858.642934]  [<c0227634>] __do_softirq+0x5a/0xd5
[  858.647648]  [<c023b435>] trace_hardirqs_on+0x106/0x141
[  858.652970]  [<c0227643>] __do_softirq+0x69/0xd5
[  858.657677]  [<c02276e6>] do_softirq+0x37/0x4d
[  858.662210]  [<c02167b0>] smp_apic_timer_interrupt+0x6b/0x77
[  858.667965]  [<c02029ef>] default_idle+0x3b/0x54
[  858.672681]  [<c02029ef>] default_idle+0x3b/0x54
[  858.677391]  [<c0204c33>] apic_timer_interrupt+0x33/0x38
[  858.682796]  [<c02029ef>] default_idle+0x3b/0x54
[  858.687505]  [<c02029f1>] default_idle+0x3d/0x54
[  858.692211]  [<c0202aaa>] cpu_idle+0xa2/0xbb
[  858.696569]  [<c06cd7c3>] start_kernel+0x40b/0x413
[  858.701453]  [<c06cd1b3>] unknown_bootoption+0x0/0x205
[  858.706678]  =======================
[  858.710321] Code: 66 83 f8 20 74 29 0f b7 c0 89 44 24 08 89 6c 24 04 c7 04 24 be 37 9a
[  858.730997] EIP: [<f899bfa5>] ipoib_neigh_destructor+0x40/0x178 [ib_ipoib] SS:ESP 0068c
[  858.740271] Kernel panic - not syncing: Fatal exception in interrupt

Either something is corrupting neighbour dev pointer, or somehow a neighbour
not related to infiniband is assigned ipoib_neigh_destructor.

-- 
MST
