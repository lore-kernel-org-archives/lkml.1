Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYJXOaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYJXOaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYJXO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:29:49 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60306 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYJXO3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:29:48 -0400
Subject: Re: [PATCH 1/1] (v2) SYSVIPC - Fix the ipc structures
	initialization
From: Nadia Derbey <Nadia.Derbey@bull.net>
To: cboulte@gmail.com
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
       linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
In-Reply-To: <4f3ee3290810240705j3fd107d4v45c38c1e1c229079@mail.gmail.com>
References: <20081024060022.897705758@bull.net>
	 <20081024060040.700343046@bull.net>
	 <4f3ee3290810240705j3fd107d4v45c38c1e1c229079@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 16:29:07 +0200
Message-Id: <1224858547.2595.180.camel@frecb000730.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:05 +0200, cboulte@gmail.com wrote:
> On Fri, Oct 24, 2008 at 8:00 AM,  <Nadia.Derbey@bull.net> wrote:
> >
> > This patch is a fix for Bugzilla bug
> > http://bugzilla.kernel.org/show_bug.cgi?id=11796.
> >
> > To summarize, a simple testcase is concurrently running an infinite loop on
> > msgctl(IPC_STAT) and a call to msgget():
> >
> > while (1)
> >   msgctl(id, IPC_STAT)    1
> >                           |
> >                           |
> >                           |
> >                           2 id = msgget(key, IPC_CREAT)
> >                           |
> >                           |
> >                           |
> >
> > In the interval [1-2], the id doesn't exist yet.
> >
> > In that test, the problem is the following:
> > When we are calling ipc_addid() from msgget() the msq structure is not
> > completely initialized. So idr_get_new() is inserting a pointer into the
> > idr tree, and the structure which is pointed to has, among other fields,
> > its lock uninitialized.
> >
> > Since msgctl(IPC_STAT) is looping while (1), idr_find() returns the
> > pointer as soon as it is inserted into the IDR tree. And ipc_lock()
> > calls spin_lock(&mqs->lock), while we have not initialized that lock
> > yet.
> >
> > This patch moves the spin_lock_init() before the call to ipc_addid().
> > It also sets the "deleted" flag to 1 in the window between ipc structure
> > allocation and its locking in ipc_addid().
> >
> > Regards,
> > Nadia
> >
> >
> > Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> >
> > ---
> >  ipc/util.c |   12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6.27/ipc/util.c
> > ===================================================================
> > --- linux-2.6.27.orig/ipc/util.c        2008-10-23 15:20:46.000000000 +0200
> > +++ linux-2.6.27/ipc/util.c     2008-10-24 09:03:06.000000000 +0200
> > @@ -266,6 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
> >        if (ids->in_use >= size)
> >                return -ENOSPC;
> >
> > +       spin_lock_init(&new->lock);
> > +
> > +       /*
> > +        * We have a window between the time new is inserted into the idr
> > +        * tree and the time it is actually locked.
> > +        * In order to be safe during that window set the new ipc structure
> > +        * as deleted: a concurrent ipc_lock() will see it as not present
> > +        * until the initialization phase is complete.
> > +        */
> > +       new->deleted = 1;
> > +
> >        err = idr_get_new(&ids->ipcs_idr, new, &id);
> >        if (err)
> >                return err;
> > @@ -280,7 +291,6 @@ int ipc_addid(struct ipc_ids* ids, struc
> >                ids->seq = 0;
> >
> >        new->id = ipc_buildid(id, new->seq);
> > -       spin_lock_init(&new->lock);
> >        new->deleted = 0;
> >        rcu_read_lock();
> >        spin_lock(&new->lock);
> >
> > --
> >
> 
> I tried the test with your patch (on a 2.6.27), and got a soft lockup
> again (the test ran during 5 minutes).

Well, it has been running for much much more than 5 minutes on my
victim...

>  It was harder to reproduce (it
> took longer) but still there. Output:
> 
> [ 1476.099160] INFO: trying to register non-static key.
> [ 1476.100507] the code is fine but needs lockdep annotation.
> [ 1476.100507] turning off the locking correctness validator.
> [ 1476.100507] Pid: 3082, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #6
> [ 1476.100507]
> [ 1476.100507] Call Trace:
> [ 1476.100507]  [<ffffffff802585d2>] static_obj+0x51/0x68
> [ 1476.100507]  [<ffffffff8025b913>] __lock_acquire+0xe0a/0x153a
> [ 1476.100507]  [<ffffffff8020c83e>] restore_args+0x0/0x30
> [ 1476.100507]  [<ffffffff80212dd1>] sched_clock+0x5/0x7
> [ 1476.100507]  [<ffffffff8025c0d8>] lock_acquire+0x95/0xc2
> [ 1476.100507]  [<ffffffff803036aa>] ipc_lock+0x63/0x9b
> [ 1476.100507]  [<ffffffff80459c77>] _spin_lock+0x2d/0x59
> [ 1476.100507]  [<ffffffff803036aa>] ipc_lock+0x63/0x9b
> [ 1476.100507]  [<ffffffff803036aa>] ipc_lock+0x63/0x9b
> [ 1476.100507]  [<ffffffff80303647>] ipc_lock+0x0/0x9b
> [ 1476.100507]  [<ffffffff803036ee>] ipc_lock_check+0xc/0x57
> [ 1476.100507]  [<ffffffff80304ac9>] sys_msgctl+0x18e/0x502
> [ 1476.100507]  [<ffffffff8045786c>] thread_return+0x3d/0xbe
> [ 1476.100507]  [<ffffffff80255e3c>] tick_dev_program_event+0x2d/0x95
> [ 1476.100507]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1476.100507]  [<ffffffff8025a201>] trace_hardirqs_on_caller+0xff/0x12a
> [ 1476.100507]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1476.100507]  [<ffffffff8025a201>] trace_hardirqs_on_caller+0xff/0x12a
> [ 1476.100507]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1476.100507]  [<ffffffff80212dd1>] sched_clock+0x5/0x7
> [ 1476.100507]  [<ffffffff8020bfca>] system_call_fastpath+0x16/0x1b
> [ 1476.100507]
> [ 1540.820503] BUG: soft lockup - CPU#1 stuck for 61s! [sysv_test2:3082]
> [ 1540.820506] Modules linked in: autofs4 video output ac battery ipv6
> nfs lockd nfs_acl sunrpc dm_snapshot dm_mirror dm_log dm_mod loop
> snd_pcsp snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801
> rng_core serio_raw i2c_core psmouse iTCO_wdt shpchp pci_hotplug button
> e752x_edac edac_core joydev evdev ext3 jbd mbcache sd_mod sg sr_mod
> cdrom ata_generic usbhid hid ff_memless ata_piix libata dock mptspi
> mptscsih mptbase ide_pci_generic scsi_transport_spi uhci_hcd ehci_hcd
> ide_core tg3 scsi_mod libphy thermal processor fan thermal_sys
> [ 1540.820506] irq event stamp: 2117257
> [ 1540.820506] hardirqs last  enabled at (2117257):
> [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1540.820506] hardirqs last disabled at (2117256):
> [<ffffffff8045971c>] trace_hardirqs_off_thunk+0x3a/0x3c
> [ 1540.820506] softirqs last  enabled at (2111724):
> [<ffffffff8020da0c>] call_softirq+0x1c/0x28
> [ 1540.820506] softirqs last disabled at (2111719):
> [<ffffffff8020da0c>] call_softirq+0x1c/0x28
> [ 1540.820506] CPU 1:
> [ 1540.820506] Modules linked in: autofs4 video output ac battery ipv6
> nfs lockd nfs_acl sunrpc dm_snapshot dm_mirror dm_log dm_mod loop
> snd_pcsp snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801
> rng_core serio_raw i2c_core psmouse iTCO_wdt shpchp pci_hotplug button
> e752x_edac edac_core joydev evdev ext3 jbd mbcache sd_mod sg sr_mod
> cdrom ata_generic usbhid hid ff_memless ata_piix libata dock mptspi
> mptscsih mptbase ide_pci_generic scsi_transport_spi uhci_hcd ehci_hcd
> ide_core tg3 scsi_mod libphy thermal processor fan thermal_sys
> [ 1540.820506] Pid: 3082, comm: sysv_test2 Not tainted 2.6.27-ipc_lock #6
> [ 1540.820506] RIP: 0010:[<ffffffff80213529>]  [<ffffffff80213529>]
> native_read_tsc+0x8/0x1d
> [ 1540.820506] RSP: 0018:ffff8801458c1db8  EFLAGS: 00000286
> [ 1540.820506] RAX: 0000000050aadc78 RBX: ffff88014452fb70 RCX: 0000000050aadb8a
> [ 1540.820506] RDX: 0000000000000446 RSI: ffffffff805425bc RDI: 0000000000000001
> [ 1540.820506] RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
> [ 1540.820506] R10: ffffffff80250954 R11: ffffffff8033fa39 R12: ffff88002f312160
> [ 1540.820506] R13: ffff8800aeae6000 R14: ffff8801458c0000 R15: ffffffff8082c810
> [ 1540.820506] FS:  00007ffbced256e0(0000) GS:ffff880147054d18(0000)
> knlGS:0000000000000000
> [ 1540.820506] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1540.820506] CR2: 00007ffbce890c70 CR3: 0000000144d05000 CR4: 00000000000006e0
> [ 1540.820506] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1540.820506] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1540.820506]
> [ 1540.820506] Call Trace:
> [ 1540.820506]  [<ffffffff8033fa51>] delay_tsc+0x18/0x51
> [ 1540.820506]  [<ffffffff80220ebd>] __ticket_spin_trylock+0x5/0x18
> [ 1540.820506]  [<ffffffff8034301b>] _raw_spin_lock+0x96/0x102
> [ 1540.820506]  [<ffffffff80459c98>] _spin_lock+0x4e/0x59
> [ 1540.820506]  [<ffffffff803036aa>] ipc_lock+0x63/0x9b
> [ 1540.820506]  [<ffffffff803036aa>] ipc_lock+0x63/0x9b
> [ 1540.820506]  [<ffffffff80303647>] ipc_lock+0x0/0x9b
> [ 1540.820506]  [<ffffffff803036ee>] ipc_lock_check+0xc/0x57
> [ 1540.820506]  [<ffffffff80304ac9>] sys_msgctl+0x18e/0x502
> [ 1540.820506]  [<ffffffff8045786c>] thread_return+0x3d/0xbe
> [ 1540.820506]  [<ffffffff80255e3c>] tick_dev_program_event+0x2d/0x95
> [ 1540.820506]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1540.820506]  [<ffffffff8025a201>] trace_hardirqs_on_caller+0xff/0x12a
> [ 1540.820506]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1540.820506]  [<ffffffff8025a201>] trace_hardirqs_on_caller+0xff/0x12a
> [ 1540.820506]  [<ffffffff804596dd>] trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1540.820506]  [<ffffffff80212dd1>] sched_clock+0x5/0x7
> [ 1540.820506]  [<ffffffff8020bfca>] system_call_fastpath+0x16/0x1b
> [ 1540.820506]
> [ 1606.320502] BUG: soft lockup - CPU#1 stuck for 61s
> 
> Inspired by your patch I wrote this one on top of yours:
> ---
>  ipc/util.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: bug-sysv/ipc/util.c
> ===================================================================
> --- bug-sysv.orig/ipc/util.c
> +++ bug-sysv/ipc/util.c
> @@ -267,6 +267,8 @@ int ipc_addid(struct ipc_ids* ids, struc
>                 return -ENOSPC;
> 
>         spin_lock_init(&new->lock);
> +       rcu_read_lock();
> +       spin_lock(&new->lock);
> 
>         /*
>          * We have a window between the time new is inserted into the idr
> @@ -292,8 +294,6 @@ int ipc_addid(struct ipc_ids* ids, struc
> 
>         new->id = ipc_buildid(id, new->seq);
>         new->deleted = 0;
> -       rcu_read_lock();
> -       spin_lock(&new->lock);
>         return id;
>  }
> 
> And I don't see any soft lockup for the moment (the test runs during
> 30 minutes). But I'm far from being confidant about this code. I'm
> just surprise that new is inserted into the list without all its
> attributes initialized.

Well, the fields we need to be initialized when new is inserted into the
list are 1. its lock 2. the deleted field: prior to any access,
ipc_lock / ipc_lock_check will be called and they need these 2 fields.

>  Besides, assiging new->delete = 0 without
> locking the ipc seems strange.

Oh oh! I missed that one. It's true that it should be done after taking
the lock. 

Will run the test with my patch + ->deleted=0 after taking the lock
during the whole week-end, and let you know.

Regards,
Nadia

> 
> c.
> 
-- 
Nadia Derbey <Nadia.Derbey@bull.net>

