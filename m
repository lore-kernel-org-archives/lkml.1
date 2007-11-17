Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXKQTke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXKQTke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbXKQTk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:40:27 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:23501 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbXKQTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RSsmIfZ29RjDc5R5QlgaqIInvKvQbEBfFI4YrrXtFCHw4LY+H/6lXohaZ3FDAqZPqUCPY2vSpi2/YhJJfgp3IaPoTBVUww8KzdcWyc9mTRCIZVbrTyk5jE1dop6ntkKCkUpb3TDeEIbYAPb+eArQKChKK6TrNA21iPOHfBK9gr8=
Message-ID: <64bb37e0711171140w5f1451e0qea081a4fbc7a45f7@mail.gmail.com>
Date: Sat, 17 Nov 2007 20:40:22 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jan Blunck" <jblunck@suse.de>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071117101957.7562639d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <20071117180946.GA14055@elte.hu>
	 <20071117101957.7562639d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 7:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sat, 17 Nov 2007 19:09:46 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> >
> > * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> >
> > > Sadly lockdep does not work for me, as it gets turned off early:
> > > [   39.851594] ---------------------------------
> > > [   39.855963] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> > > [   39.861981] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> > > [   39.866963]  (&n->list_lock){-+..}, at: [<ffffffff802935c1>]
> >
> > hey, that means it found a bug - which is not sad at all :-)

It was sad, that it found a bug that I was not searching for. ;)

> mutter.
>
> Torsten, you could try CONFIG_SLAB=y, CONFIG_SLUB=n to see if you can make
> some progress on the NFS problem.

I should had thought of that myself... OK anyway here is the result:

The hang is reproducable, emerge froze the system again after download
the source.
Lockdep triggers immedetly before the freeze, but the result is still
not helpful:

[  221.565011] INFO: trying to register non-static key.
[  221.566999] the code is fine but needs lockdep annotation.
[  221.569206] turning off the locking correctness validator.
[  221.571404]
[  221.571405] Call Trace:
[  221.572996]  [<ffffffff8025a1b4>] __lock_acquire+0x4c4/0x1140
[  221.575298]  [<ffffffff8025ae85>] lock_acquire+0x55/0x70
[  221.577429]  [<ffffffff8022d6fd>] __wake_up+0x2d/0x70
[  221.579457]  [<ffffffff805c5f04>] _spin_lock_irqsave+0x34/0x50
[  221.581800]  [<ffffffff805c5e45>] _spin_unlock_irqrestore+0x55/0x70
[  221.584317]  [<ffffffff8022d6fd>] __wake_up+0x2d/0x70
[  221.586344]  [<ffffffff805a88b0>] rpc_async_schedule+0x0/0x10
[  221.588648]  [<ffffffff802fface>] nfs_free_unlinkdata+0x1e/0x50
[  221.591023]  [<ffffffff805a7e96>] rpc_release_calldata+0x26/0x50
[  221.593428]  [<ffffffff8024778f>] run_workqueue+0x16f/0x210
[  221.595662]  [<ffffffff80259731>] trace_hardirqs_on+0xc1/0x160
[  221.598004]  [<ffffffff802483d0>] worker_thread+0x0/0xb0
[  221.600130]  [<ffffffff802483d0>] worker_thread+0x0/0xb0
[  221.602265]  [<ffffffff8024843d>] worker_thread+0x6d/0xb0
[  221.604431]  [<ffffffff8024bfc0>] autoremove_wake_function+0x0/0x30
[  221.606939]  [<ffffffff802483d0>] worker_thread+0x0/0xb0
[  221.609067]  [<ffffffff802483d0>] worker_thread+0x0/0xb0
[  221.611199]  [<ffffffff8024bbeb>] kthread+0x4b/0x80
[  221.613156]  [<ffffffff8020cb98>] child_rip+0xa/0x12
[  221.615151]  [<ffffffff8020c2af>] restore_args+0x0/0x30
[  221.617247]  [<ffffffff8024bba0>] kthread+0x0/0x80
[  221.619162]  [<ffffffff8020cb8e>] child_rip+0x0/0x12
[  221.621147]
[  221.621749] INFO: lockdep is turned off.
[  226.369259] SysRq : Emergency Sync
[  226.331342] Emergency Sync complete
[  227.064545] SysRq : Emergency Remount R/O
[  228.193491] SysRq : Emergency Sync
[  228.155593] Emergency Sync complete
[  228.767931] SysRq : Resetting

I also had another BUG output during system startup, but that should
be unrelated:
[  103.254681] BUG: sleeping function called from invalid context at
kernel/rwsem.c:20
[  103.257757] in_atomic():0, irqs_disabled():1
[  103.259469] 1 lock held by artsd/5883:
[  103.259470]  #0:  (pm_qos_lock){....}, at: [<ffffffff80250efb>]
pm_qos_add_requirement+0x6b/0xf0
[  103.263316] irq event stamp: 49712
[  103.263318] hardirqs last  enabled at (49711): [<ffffffff802941ed>]
__kmalloc+0x10d/0x180
[  103.263321] hardirqs last disabled at (49712): [<ffffffff805c5eea>]
_spin_lock_irqsave+0x1a/0x50
[  103.263326] softirqs last  enabled at (48820): [<ffffffff805954d9>]
unix_release_sock+0x79/0x240
[  103.263330] softirqs last disabled at (48818): [<ffffffff805c5b89>]
_write_lock_bh+0x9/0x30
[  103.263333]
[  103.263333] Call Trace:
[  103.263335]  [<ffffffff8024fc25>] down_read+0x15/0x40
[  103.263338]  [<ffffffff802507e6>] __blocking_notifier_call_chain+0x46/0x90
[  103.263341]  [<ffffffff80250f23>] pm_qos_add_requirement+0x93/0xf0
[  103.263344]  [<ffffffff804fdc4a>] snd_pcm_hw_params+0x2fa/0x380
[  103.263347]  [<ffffffff804fe93c>] snd_pcm_common_ioctl1+0xb4c/0xdc0
[  103.263350]  [<ffffffff8027b167>] __do_fault+0x227/0x470
[  103.263353]  [<ffffffff8025a435>] __lock_acquire+0x745/0x1140
[  103.263357]  [<ffffffff805c5e45>] _spin_unlock_irqrestore+0x55/0x70
[  103.263359]  [<ffffffff80259731>] trace_hardirqs_on+0xc1/0x160
[  103.263362]  [<ffffffff804fee88>] snd_pcm_playback_ioctl1+0x48/0x240
[  103.263365]  [<ffffffff804ffa36>] snd_pcm_playback_ioctl+0x36/0x50
[  103.263367]  [<ffffffff802a80bf>] vfs_ioctl+0x2f/0xa0
[  103.263369]  [<ffffffff802a8390>] do_vfs_ioctl+0x260/0x2e0
[  103.263371]  [<ffffffff80259731>] trace_hardirqs_on+0xc1/0x160
[  103.263373]  [<ffffffff802a84a1>] sys_ioctl+0x91/0xb0
[  103.263376]  [<ffffffff8020bc5e>] system_call+0x7e/0x83
[  103.263379]

Torsten
