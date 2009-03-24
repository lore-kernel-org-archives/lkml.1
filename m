Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbZCXQSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbZCXQSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbZCXQRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:17:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909AbZCXQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:17:33 -0400
Date: Tue, 24 Mar 2009 17:12:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alex Chiang <achiang@hp.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090324161259.GA5964@redhat.com>
References: <20090320204327.12275.43010.stgit@bob.kio> <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com> <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324092525.GE6605@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Ingo Molnar wrote:
> >
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> >
> > Kenji Kaneshige reported the below lockdep problem when testing
> > my patch on one of his machines.
> >
> > > I still have the following kernel error messages in testing with your
> > > latest set of patches (Jesse's linux-next). The test case is removing
> > > e1000e device or its parent bridge by "echo 1 > /sys/bus/pci/devices/
> > > .../remove".
> > >
> > > [  537.379995] =============================================
> > > [  537.380124] [ INFO: possible recursive locking detected ]
> > > [  537.380128] 2.6.29-rc8-kk #1
> > > [  537.380128] ---------------------------------------------
> > > [  537.380128] events/4/56 is trying to acquire lock:
> > > [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
> > > [  537.380128]
> > > [  537.380128] but task is already holding lock:
> > > [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > > [  537.380128]
> > > [  537.380128] other info that might help us debug this:
> > > [  537.380128] 3 locks held by events/4/56:
> > > [  537.380128]  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > > [  537.380128]  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > > [  537.380128]  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c10d1>] remove_callback+0x21/0x40
> > > [  537.380128]
> > > [  537.380128] stack backtrace:
> > > [  537.380128] Pid: 56, comm: events/4 Not tainted 2.6.29-rc8-kk #1
> > > [  537.380128] Call Trace:
> > > [  537.380128]  [<ffffffff8026dfcd>] validate_chain+0xb7d/0x1260
> > > [  537.380128]  [<ffffffff8026eade>] __lock_acquire+0x42e/0xa40
> > > [  537.380128]  [<ffffffff8026f148>] lock_acquire+0x58/0x80
> > > [  537.380128]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> > > [  537.380128]  [<ffffffff8025800d>] flush_workqueue+0x4d/0xa0
> > > [  537.380128]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> > > [  537.383380]  [<ffffffff80258070>] flush_scheduled_work+0x10/0x20
> > > [  537.383380]  [<ffffffffa0144065>] e1000_remove+0x55/0xfe [e1000e]
> > > [  537.383380]  [<ffffffff8033ee30>] ? sysfs_schedule_callback_work+0x0/0x50
> > > [  537.383380]  [<ffffffff803bfeb2>] pci_device_remove+0x32/0x70
> > > [  537.383380]  [<ffffffff80441da9>] __device_release_driver+0x59/0x90
> > > [  537.383380]  [<ffffffff80441edb>] device_release_driver+0x2b/0x40
> > > [  537.383380]  [<ffffffff804419d6>] bus_remove_device+0xa6/0x120
> > > [  537.384382]  [<ffffffff8043e46b>] device_del+0x12b/0x190
> > > [  537.384382]  [<ffffffff8043e4f6>] device_unregister+0x26/0x70
> > > [  537.384382]  [<ffffffff803ba969>] pci_stop_dev+0x49/0x60
> > > [  537.384382]  [<ffffffff803baab0>] pci_remove_bus_device+0x40/0xc0
> > > [  537.384382]  [<ffffffff803c10d9>] remove_callback+0x29/0x40
> > > [  537.384382]  [<ffffffff8033ee4f>] sysfs_schedule_callback_work+0x1f/0x50
> > > [  537.384382]  [<ffffffff8025769a>] run_workqueue+0x15a/0x230
> > > [  537.384382]  [<ffffffff80257648>] ? run_workqueue+0x108/0x230
> > > [  537.384382]  [<ffffffff8025846f>] worker_thread+0x9f/0x100
> > > [  537.384382]  [<ffffffff8025bce0>] ? autoremove_wake_function+0x0/0x40
> > > [  537.384382]  [<ffffffff802583d0>] ? worker_thread+0x0/0x100
> > > [  537.384382]  [<ffffffff8025b89d>] kthread+0x4d/0x80
> > > [  537.384382]  [<ffffffff8020d4ba>] child_rip+0xa/0x20
> > > [  537.386380]  [<ffffffff8020cebc>] ? restore_args+0x0/0x30
> > > [  537.386380]  [<ffffffff8025b850>] ? kthread+0x0/0x80
> > > [  537.386380]  [<ffffffff8020d4b0>] ? child_rip+0x0/0x20
> > >
> > > I think the cause of this error message is flush_workqueue()
> > > from the work of keventd. When removing device using
> > > "/sys/bus/pci/devices/.../ remove", pci_remove_bus_device() is
> > > executed by the keventd's work through
> > > device_schedule_callback(), and it invokes e1000e's remove
> > > callback. And then, e1000e's remove callback invokes
> > > flush_workqueue().  Actually, the kernel error messages are not
> > > displayed when I changed e1000e driver to not call
> > > flush_workqueue(). In my understanding, flush_workqueue() from
> > > the work must be avoided because it can cause a deadlock.
> > > Please note that this is not a problem of e1000e driver.
> > > Drivers can use flush_workqueue(), of course.
> >
> > I agree with this analysis; the reason we're seeing this lockdep
> > warning is because the sysfs attributed scheduled a removal for
> > itself using device_schedule_callback(). This is necessary
> > because sysfs attributes can't remove themselves due to other
> > locking issues.
> >
> > My question is -- is it a bug to call flush_workqueue during
> > run_workqueue?
>
> Yes, it generally is.
>
> > Conceptually, I don't think it should be a bug; it should be a
> > nop, since run_workqueue _is_ flushing the work queue.

As it was already said, we can deadlock.

Can't e1000_remove() avoid flush_scheduled_work() ? (and it should
be always avoided when possible).

Of course, I don't understand this code. But afaics e1000_remove()
can just cancel its own works (in struct e1000_adapter), no?

cancel_work_sync(work) from run_workqueue() should be OK even if
this work is queued on the same wq. If it is queued on the same CPU
cancel_work_sync() won't block because we are ->current_work.


Btw. Again, I don't understand the code, but this looks suspicious:

	e1000_remove:

		set_bit(__E1000_DOWN, &adapter->state);
		del_timer_sync(&adapter->watchdog_timer);
		flush_scheduled_work();

What if e1000_watchdog_task() is running, has already checked
!test_bit(__E1000_DOWN, &adapter->state), but didn't call
mod_timer(&adapter->phy_info_timer) yet?

Oleg.

