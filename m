Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYKKWQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYKKWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYKKWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:16:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbYKKWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:16:44 -0500
Date: Tue, 11 Nov 2008 14:16:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cboulte@gmail.com
Cc: Nadia.Derbey@bull.net, manfred@colorfullife.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
Message-Id: <20081111141603.f0e7fa8d.akpm@linux-foundation.org>
In-Reply-To: <4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com>
References: <20081028145952.620752409@bull.net>
	<20081028150041.857635775@bull.net>
	<4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 10:11:06 +0100
cboulte@gmail.com wrote:

> On Tue, Oct 28, 2008 at 3:59 PM,  <Nadia.Derbey@bull.net> wrote:
> >
> > A problem was found while reviewing the code after Bugzilla bug
> > http://bugzilla.kernel.org/show_bug.cgi?id=11796.
> >
> > In ipc_addid(), the newly allocated ipc structure is inserted into the ipcs
> > tree (i.e made visible to readers) without locking it.
> > This is not correct since its initialization continues after it has been
> > inserted in the tree.
> >
> > This patch moves the ipc structure lock initialization + locking before
> > the actual insertion.
> >
> > Regards,
> > Nadia
> >
> >
> > Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> >
> > ---
> >  ipc/util.c |   14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >
> > Index: linux-2.6.27/ipc/util.c
> > ===================================================================
> > --- linux-2.6.27.orig/ipc/util.c        2008-10-23 15:20:46.000000000 +0200
> > +++ linux-2.6.27/ipc/util.c     2008-10-28 16:52:17.000000000 +0100
> > @@ -266,9 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
> >        if (ids->in_use >= size)
> >                return -ENOSPC;
> >
> > +       spin_lock_init(&new->lock);
> > +       new->deleted = 0;
> > +       rcu_read_lock();
> > +       spin_lock(&new->lock);
> > +
> >        err = idr_get_new(&ids->ipcs_idr, new, &id);
> > -       if (err)
> > +       if (err) {
> > +               spin_unlock(&new->lock);
> > +               rcu_read_unlock();
> >                return err;
> > +       }
> >
> >        ids->in_use++;
> >
> > @@ -280,10 +288,6 @@ int ipc_addid(struct ipc_ids* ids, struc
> >                ids->seq = 0;
> >
> >        new->id = ipc_buildid(id, new->seq);
> > -       spin_lock_init(&new->lock);
> > -       new->deleted = 0;
> > -       rcu_read_lock();
> > -       spin_lock(&new->lock);
> >        return id;
> >  }
> >
> >
> > --
> >
> 
> Sorry but the bug is still present. It takes longer to show up...
> 
> [ 4028.704877] INFO: trying to register non-static key.
> [ 4028.708007] the code is fine but needs lockdep annotation.
> [ 4028.708007] turning off the locking correctness validator.
> [ 4028.708007] Pid: 8051, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #2
> [ 4028.708007]
> [ 4028.708007] Call Trace:
> [ 4028.708007]  [<ffffffff80257055>] static_obj+0x60/0x77
> [ 4028.708007]  [<ffffffff8025af59>] __lock_acquire+0x1c8/0x779
> [ 4028.708007]  [<ffffffff8025b4ac>] __lock_acquire+0x71b/0x779
> [ 4028.708007]  [<ffffffff8025b59f>] lock_acquire+0x95/0xc2
> [ 4028.708007]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [ 4028.708007]  [<ffffffff8045119d>] _spin_lock+0x2d/0x5a
> [ 4028.708007]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [ 4028.708007]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [ 4028.708007]  [<ffffffff802feaa5>] ipc_lock+0x0/0x99
> [ 4028.708007]  [<ffffffff803002e3>] sys_msgctl+0x188/0x461
> [ 4028.708007]  [<ffffffff802feb46>] ipc_lock_check+0x8/0x53
> [ 4028.708007]  [<ffffffff803002e3>] sys_msgctl+0x188/0x461
> [ 4028.708007]  [<ffffffff8044ef84>] thread_return+0x3e/0xa8
> [ 4028.708007]  [<ffffffff80450d69>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 4028.708007]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [ 4028.708007]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [ 4028.708007]  [<ffffffff80450d69>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 4028.708007]  [<ffffffff80213021>] native_sched_clock+0x8c/0xa5
> [ 4028.708007]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [ 4028.708007]  [<ffffffff8020bf7a>] system_call_fastpath+0x16/0x1b
> [ 4028.708007]
> [ 4094.180003] BUG: soft lockup - CPU#0 stuck for 61s! [sysv_test2:8051]
> [ 4094.180007] Modules linked in: ipv6 nfs lockd nfs_acl sunrpc button
> battery ac loop dm_mod md_mod usbkbd usbhid hid ff_memless mptctl
> evdev tg3 iTCO_wdt libphy shpchp i2c_i801 i2c_core ehci_hcd
> pci_hotplug rng_core uhci_hcd e752x_edac edac_core reiserfs edd fan
> thermal processor thermal_sys mptspi mptscsih sg mptbase sr_mod cdrom
> scsi_transport_spi ata_piix libata dock sd_mod scsi_mod [last
> unloaded: freq_table]
> [ 4094.180007] irq event stamp: 2118797
> [ 4094.180007] hardirqs last  enabled at (2118797):
> [<ffffffff80450d69>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 4094.180007] hardirqs last disabled at (2118796):
> [<ffffffff80450da8>] trace_hardirqs_off_thunk+0x3a/0x3c
> [ 4094.180007] softirqs last  enabled at (2117034):
> [<ffffffff8020d9bc>] call_softirq+0x1c/0x28
> [ 4094.180007] softirqs last disabled at (2117029):
> [<ffffffff8020d9bc>] call_softirq+0x1c/0x28
> [ 4094.180007] CPU 0:
> [ 4094.180007] Modules linked in: ipv6 nfs lockd nfs_acl sunrpc button
> battery ac loop dm_mod md_mod usbkbd usbhid hid ff_memless mptctl
> evdev tg3 iTCO_wdt libphy shpchp i2c_i801 i2c_core ehci_hcd
> pci_hotplug rng_core uhci_hcd e752x_edac edac_core reiserfs edd fan
> thermal processor thermal_sys mptspi mptscsih sg mptbase sr_mod cdrom
> scsi_transport_spi ata_piix libata dock sd_mod scsi_mod [last
> unloaded: freq_table]
> [ 4094.180007] Pid: 8051, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #2
> [ 4094.180007] RIP: 0010:[<ffffffff80213541>]  [<ffffffff80213541>]
> native_read_tsc+0x8/0x18
> [ 4094.180007] RSP: 0018:ffff88014580fe20  EFLAGS: 00000206
> [ 4094.180007] RAX: 00000000f432530c RBX: fffffffff4325241 RCX:
> 00000000ffffffff[ 4094.180007] RDX: 0000000000000ac2 RSI:
> ffffffff8053d176 RDI: 0000000000000001[ 4094.180007] RBP:
> 0000000000000000 R08: 0000000000000002 R09: 0000000000000000[
> 4094.180007] R10: 0000000000000000 R11: ffffffff8033a71e R12:
> ffff88002f1861a0[ 4094.180007] R13: ffff8800ae95f000 R14:
> ffff88014580e000 R15: ffffffff80827890[ 4094.180007] FS:
> 00007fa497b416d0(0000) GS:ffffffff80622a80(0000)
> knlGS:0000000000000000
> [ 4094.180007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 4094.180007] CR2: 00007fa4978d3ae0 CR3: 000000013f980000 CR4:
> 00000000000006e0[ 4094.180007] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000[ 4094.180007] DR3:
> 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400[
> 4094.180007]
> [ 4094.180007] Call Trace:
> [ 4094.180007]  [<ffffffff8033a73c>] delay_tsc+0x1e/0x45
> [ 4094.180007]  [<ffffffff8033dc8b>] _raw_spin_lock+0x98/0x100
> [ 4094.180007]  [<ffffffff804511be>] _spin_lock+0x4e/0x5a
> [ 4094.180007]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [ 4094.180007]  [<ffffffff802feb07>] ipc_lock+0x62/0x99
> [ 4094.180007]  [<ffffffff802feaa5>] ipc_lock+0x0/0x99
> [ 4094.180007]  [<ffffffff803002e3>] sys_msgctl+0x188/0x461
> [ 4094.180007]  [<ffffffff802feb46>] ipc_lock_check+0x8/0x53
> [ 4094.180007]  [<ffffffff803002e3>] sys_msgctl+0x188/0x461
> [ 4094.180007]  [<ffffffff8044ef84>] thread_return+0x3e/0xa8
> [ 4094.180007]  [<ffffffff80450d69>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 4094.180007]  [<ffffffff80259ac7>] trace_hardirqs_on_caller+0x100/0x12a
> [ 4094.180007]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [ 4094.180007]  [<ffffffff80450d69>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 4094.180007]  [<ffffffff80213021>] native_sched_clock+0x8c/0xa5
> [ 4094.180007]  [<ffffffff80212e09>] sched_clock+0x5/0x7
> [ 4094.180007]  [<ffffffff8020bf7a>] system_call_fastpath+0x16/0x1b
> [ 4094.180007]
> 
> I don't understand what's going on... I hope I'm not the only one who
> still get it because I doubt about this bug.
> 

Time is starting to press on this one.  Is there something which we can
revert which would fix this bug?

Thanks.

