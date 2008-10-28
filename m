Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYJ1LGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYJ1LGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYJ1LFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:05:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47228 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJ1LFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:05:54 -0400
Subject: Re: [PATCH 1/1] (v3) SYSVIPC - Fix the ipc structures
	initialization
From: Nadia Derbey <Nadia.Derbey@bull.net>
To: cboulte@gmail.com
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4f3ee3290810280244ua378523kf77cfaed8a1ebc38@mail.gmail.com>
References: <20081027072826.266777838@bull.net>
	 <20081027072836.438113395@bull.net>
	 <4f3ee3290810270332p56e1f99q24a5eea818e626ee@mail.gmail.com>
	 <1225105450.2595.215.camel@frecb000730.frec.bull.fr>
	 <1225122161.2595.248.camel@frecb000730.frec.bull.fr>
	 <4f3ee3290810280244ua378523kf77cfaed8a1ebc38@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 12:05:00 +0100
Message-Id: <1225191900.2595.264.camel@frecb000730.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 10:44 +0100, cboulte@gmail.com wrote:
> On Mon, Oct 27, 2008 at 4:42 PM, Nadia Derbey <Nadia.Derbey@bull.net> wrote:
> > On Mon, 2008-10-27 at 12:04 +0100, Nadia Derbey wrote:
> >> On Mon, 2008-10-27 at 11:32 +0100, cboulte@gmail.com wrote:
> >> > On Mon, Oct 27, 2008 at 8:28 AM,  <Nadia.Derbey@bull.net> wrote:
> >> > >
> >> > > This patch is a fix for Bugzilla bug
> >> > > http://bugzilla.kernel.org/show_bug.cgi?id=11796.
> >> > >
> >> > > To summarize, a simple testcase is concurrently running an infinite loop on
> >> > > msgctl(IPC_STAT) and a call to msgget():
> >> > >
> >> > > while (1)
> >> > >   msgctl(id, IPC_STAT)    1
> >> > >                           |
> >> > >                           |
> >> > >                           |
> >> > >                           2 id = msgget(key, IPC_CREAT)
> >> > >                           |
> >> > >                           |
> >> > >                           |
> >> > >
> >> > > In the interval [1-2], the id doesn't exist yet.
> >> > >
> >> > > In that test, the problem is the following:
> >> > > When we are calling ipc_addid() from msgget() the msq structure is not
> >> > > completely initialized. So idr_get_new() is inserting a pointer into the
> >> > > idr tree, and the structure which is pointed to has, among other fields,
> >> > > its lock uninitialized.
> >> > >
> >> > > Since msgctl(IPC_STAT) is looping while (1), idr_find() returns the
> >> > > pointer as soon as it is inserted into the IDR tree. And ipc_lock()
> >> > > calls spin_lock(&mqs->lock), while we have not initialized that lock
> >> > > yet.
> >> > >
> >> > > This patch moves the spin_lock_init() before the call to ipc_addid().
> >> > > It also sets the "deleted" flag to 1 in the window between msg structure
> >> > > allocation and msg structure locking in ipc_addid().
> >> > >
> >> > >
> >> > > Regards,
> >> > > Nadia
> >> > >
> >> > >
> >> > > Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> >> > >
> >> > > ---
> >> > >  ipc/util.c |   16 ++++++++++++++--
> >> > >  1 file changed, 14 insertions(+), 2 deletions(-)
> >> > >
> >> > > Index: linux-2.6.27/ipc/util.c
> >> > > ===================================================================
> >> > > --- linux-2.6.27.orig/ipc/util.c        2008-10-23 15:20:46.000000000 +0200
> >> > > +++ linux-2.6.27/ipc/util.c     2008-10-24 17:48:33.000000000 +0200
> >> > > @@ -266,6 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
> >> > >        if (ids->in_use >= size)
> >> > >                return -ENOSPC;
> >> > >
> >> > > +       spin_lock_init(&new->lock);
> >> > > +
> >> > > +       /*
> >> > > +        * We have a window between the time new is inserted into the idr
> >> > > +        * tree and the time it is actually locked.
> >> > > +        * In order to be safe during that window set the new ipc structure
> >> > > +        * as deleted: a concurrent ipc_lock() will see it as not present
> >> > > +        * until the initialization phase is complete.
> >> > > +        */
> >> > > +       new->deleted = 1;
> >> > > +
> >> > >        err = idr_get_new(&ids->ipcs_idr, new, &id);
> >> > >        if (err)
> >> > >                return err;
> >> > > @@ -280,10 +291,11 @@ int ipc_addid(struct ipc_ids* ids, struc
> >> > >                ids->seq = 0;
> >> > >
> >> > >        new->id = ipc_buildid(id, new->seq);
> >> > > -       spin_lock_init(&new->lock);
> >> > > -       new->deleted = 0;
> >> > >        rcu_read_lock();
> >> > >        spin_lock(&new->lock);
> >> > > +
> >> > > +       new->deleted = 0;
> >> > > +
> >> > >        return id;
> >> > >  }
> >> > >
> >> > >
> >> > > --
> >> > >
> >> >
> >> > Still got the lock... I'm using a 4 cpus node: Intel Xeon @ 2.8GHz...
> >> > don't know if it has an impact.
> >> ???
> >> The bad new, is that it becomes unreprodicible on my side.
> >> For my part, I've got 2 2.8 GHz Xeon CPUs.
> >>
> >> Will review the code once more.
> >>
> >> Thanks!
> >> Nadia
> >>
> >> > The only way I found to have no lock, it's to spin_lock the ipc
> >> > _before_ inserting it into the idr.
> >> >
> >> > Best regards, c.
> >> >
> >
> > I agree with you that it's more logical and correct to take the lock
> > before inserting the ipc structure (i.e. making it visible to readers).
> >
> > But I wanted to understand what's wrong with
> > 1. new->lock init
> > 2. new->deleted = 1
> > 3. insert(new)
> >
> > I've been looking at the code again and again and the only thing I see
> > could have happened, is that instructions have been reordered and the
> > insertion done before the lock actually being initialized.
> > This means that a memory barrier is missing (this would explain why your
> > fix works: the spin_lock acts as a barrier).
> > But this memory barrier is supposed to be invoked by
> > rcu_assign_pointer() in idr_get_new(). So may be there's a problem with
> > the idr code.
> > Before going into a review of this code, I'd like to confirm what I'm
> > saying, doing the following (I'm sorry to ask you do it, but I can't
> > reproduce the problem in my side anymore): would you mind adding a
> > smp_wmb() just before the idr_get_new in ipc_addid() and tell me if this
> > solves the problem.
> > (BTW, I didn't ask you before, but I guess you're getting the same call
> > trace?)
> >
> > Regards,
> > Nadia
> >
> > --
> > Nadia Derbey <Nadia.Derbey@bull.net>
> >
> >
> 
> I tried this patch:
> Index: bug-sysv/ipc/util.c
> ===================================================================
> --- bug-sysv.orig/ipc/util.c    2008-10-27 09:21:44.000000000 +0100
> +++ bug-sysv/ipc/util.c 2008-10-27 19:04:33.000000000 +0100
> @@ -266,6 +266,19 @@ int ipc_addid(struct ipc_ids* ids, struc
>         if (ids->in_use >= size)
>                 return -ENOSPC;
> 
> +       spin_lock_init(&new->lock);
> +
> +       /*
> +        * We have a window between the time new is inserted into the idr
> +        * tree and the time it is actually locked.
> +        * In order to be safe during that window set the new ipc structure
> +        * as deleted: a concurrent ipc_lock() will see it as not present
> +        * until the initialization phase is complete.
> +        */
> +       new->deleted = 1;
> +
> +       smp_wmb();
> +
>         err = idr_get_new(&ids->ipcs_idr, new, &id);
>         if (err)
>                 return err;
> @@ -280,10 +293,11 @@ int ipc_addid(struct ipc_ids* ids, struc
>                 ids->seq = 0;
> 
>         new->id = ipc_buildid(id, new->seq);
> -       spin_lock_init(&new->lock);
> -       new->deleted = 0;
>         rcu_read_lock();
>         spin_lock(&new->lock);
> +
> +       new->deleted = 0;
> +
>         return id;
>  }
> 
> And got the lock (the node is still usuable but I guess it's because
> only 1 cpu out of 4 is locked):
> 
> [  400.393024] INFO: trying to register non-static key.
> [  400.397005] the code is fine but needs lockdep annotation.
> [  400.397005] turning off the locking correctness validator.
> [  400.397005] Pid: 4207, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #1
> [  400.397005]
> [  400.397005] Call Trace:
> [  400.397005]  [<ffffffff80257055>] static_obj+0x60/0x77
> [  400.397005]  [<ffffffff8025af59>] __lock_acquire+0x1c8/0x779
> [  400.397005]  [<ffffffff8025b59f>] lock_acquire+0x95/0xc2
> [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [  400.397005]  [<ffffffff8045117d>] _spin_lock+0x2d/0x5a
> [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [  400.397005]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [  400.397005]  [<ffffffff802feaa5>] ipc_lock+0x0/0x99
> [  400.397005]  [<ffffffff802feb46>] ipc_lock_check+0x8/0x53
> [  400.397005]  [<ffffffff803002c3>] sys_msgctl+0x188/0x461
> [  400.397005]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [  400.397005]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> [  400.397005]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [  400.397005]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [  400.397005]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> [  400.397005]  [<ffffffff80213021>] native_sched_clock+0x8c/0xa5
> [  400.397005]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [  400.397005]  [<ffffffff8020bf7a>] system_call_fastpath+0x16/0x1b
> [  400.397005]
> [  464.933003] BUG: soft lockup - CPU#2 stuck for 61s! [sysv_test2:4207]
> [  464.933006] Modules linked in: ipv6 nfs lockd nfs_acl sunrpc button
> battery ac loop dm_mod md_mod usbkbd usbhid hid ff_memless mptctl
> evdev tg3 libphy iTCO_wdt e752x_edac edac_core uhci_hcd rng_core
> shpchp i2c_i801 pci_hotplug i2c_core ehci_hcd reiserfs edd fan thermal
> processor thermal_sys mptspi mptscsih sg mptbase scsi_transport_spi
> sr_mod cdrom ata_piix libata dock sd_mod scsi_mod [last unloaded:
> freq_table]
> [  464.933006] irq event stamp: 2136363
> [  464.933006] hardirqs last  enabled at (2136363):
> [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> [  464.933006] hardirqs last disabled at (2136361):
> [<ffffffff8023ea01>] __do_softirq+0xa3/0xf7
> [  464.933006] softirqs last  enabled at (2136362):
> [<ffffffff8020d9bc>] call_softirq+0x1c/0x28
> [  464.933006] softirqs last disabled at (2136357):
> [<ffffffff8020d9bc>] call_softirq+0x1c/0x28
> [  464.933006] CPU 2:
> [  464.933006] Modules linked in: ipv6 nfs lockd nfs_acl sunrpc button
> battery ac loop dm_mod md_mod usbkbd usbhid hid ff_memless mptctl
> evdev tg3 libphy iTCO_wdt e752x_edac edac_core uhci_hcd rng_core
> shpchp i2c_i801 pci_hotplug i2c_core ehci_hcd reiserfs edd fan thermal
> processor thermal_sys mptspi mptscsih sg mptbase scsi_transport_spi
> sr_mod cdrom ata_piix libata dock sd_mod scsi_mod [last unloaded:
> freq_table]
> [  464.933006] Pid: 4207, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #1
> [  464.933006] RIP: 0010:[<ffffffff8033dc6b>]  [<ffffffff8033dc6b>]
> _raw_spin_lock+0x98/0x100
> [  464.933006] RSP: 0018:ffff880145473e48  EFLAGS: 00000206
> [  464.933006] RAX: 00000000000000cb RBX: 000000001830d3f9 RCX:
> 00000000ffffffff[  464.933006] RDX: 0000018500000000 RSI:
> ffffffff8053d176 RDI: 0000000000000001[  464.933006] RBP:
> 0000000000000000 R08: 0000000000000002 R09: 0000000000000000[
> 464.933006] R10: 0000000000000000 R11: ffffffff8033a6fe R12:
> 0000000000000000[  464.933006] R13: ffffffff8033a6fe R14:
> ffffffff8020c7ee R15: 0000000000000002[  464.933006] FS:
> 00007f40899b86d0(0000) GS:ffff88014707f508(0000)
> knlGS:0000000000000000
> [  464.933006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  464.933006] CR2: 00007f408974aae0 CR3: 0000000143003000 CR4:
> 00000000000006e0[  464.933006] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000[  464.933006] DR3:
> 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400[
> 464.933006]
> [  464.933006] Call Trace:
> [  464.933006]  [<ffffffff8033dc6b>] _raw_spin_lock+0x98/0x100
> [  464.933006]  [<ffffffff8045119e>] _spin_lock+0x4e/0x5a
> [  464.933006]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [  464.933006]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [  464.933006]  [<ffffffff802feaa5>] ipc_lock+0x0/0x99
> [  464.933006]  [<ffffffff802feb46>] ipc_lock_check+0x8/0x53
> [  464.933006]  [<ffffffff803002c3>] sys_msgctl+0x188/0x461
> [  464.933006]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [  464.933006]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> [  464.933006]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [  464.933006]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [  464.933006]  [<ffffffff80450d49>] trace_hardirqs_on_thunk+0x3a/0x3f
> [  464.933006]  [<ffffffff80213021>] native_sched_clock+0x8c/0xa5
> [  464.933006]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [  464.933006]  [<ffffffff8020bf7a>] system_call_fastpath+0x16/0x1b
> [  464.933006]
> 
> I checked it with two different distributions: Debian Lenny and Sles 10 SP 1.
> 
> Regards, c.

Thanks a lot! Going on checking the code.


Regards,
Nadia

> 
-- 
Nadia Derbey <Nadia.Derbey@bull.net>

