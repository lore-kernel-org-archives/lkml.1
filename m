Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZCXJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZCXJ0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZCXJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:26:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZCXJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:26:06 -0400
Date: Tue, 24 Mar 2009 10:25:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Chiang <achiang@hp.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090324092525.GE6605@elte.hu>
References: <20090320204327.12275.43010.stgit@bob.kio> <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com> <20090324032304.GB6175@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324032304.GB6175@ldl.fc.hp.com>
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


( Cc:-ed a few more interested parties - the thread is about 
  workqueue dependency lockdep coverage. )

* Alex Chiang <achiang@hp.com> wrote:

> Hi Ingo,
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > Alex Chiang wrote:
> >> This patch adds an attribute named "remove" to a PCI device's sysfs
> >> directory.  Writing a non-zero value to this attribute will remove the PCI
> >> device and any children of it.
> >>
> >> Trent Piepho wrote the original implementation and documentation.
> >>
> >> Thanks to Vegard Nossum for testing under kmemcheck and finding locking
> >> issues with the sysfs interface.
> >>
> >> Cc: Trent Piepho <xyzzy@speakeasy.org>
> >> Signed-off-by: Alex Chiang <achiang@hp.com>
> 
> [snip part of patch]
> 
> >>  diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> >> index be7468a..e16990e 100644
> >> --- a/drivers/pci/pci-sysfs.c
> >> +++ b/drivers/pci/pci-sysfs.c
> >> @@ -243,6 +243,39 @@ struct bus_attribute pci_bus_attrs[] = {
> >>  	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store),
> >>  	__ATTR_NULL
> >>  };
> >> +
> >> +static void remove_callback(struct device *dev)
> >> +{
> >> +	struct pci_dev *pdev = to_pci_dev(dev);
> >> +
> >> +	mutex_lock(&pci_remove_rescan_mutex);
> >> +	pci_remove_bus_device(pdev);
> >> +	mutex_unlock(&pci_remove_rescan_mutex);
> >> +}
> >> +
> >> +static ssize_t
> >> +remove_store(struct device *dev, struct device_attribute *dummy,
> >> +	     const char *buf, size_t count)
> >> +{
> >> +	int ret = 0;
> >> +	unsigned long val;
> >> +	struct pci_dev *pdev = to_pci_dev(dev);
> >> +
> >> +	if (strict_strtoul(buf, 0, &val) < 0)
> >> +		return -EINVAL;
> >> +
> >> +	if (pci_is_root_bus(pdev->bus))
> >> +		return -EBUSY;
> >> +
> >> +	/* An attribute cannot be unregistered by one of its own methods,
> >> +	 * so we have to use this roundabout approach.
> >> +	 */
> >> +	if (val)
> >> +		ret = device_schedule_callback(dev, remove_callback);
> >> +	if (ret)
> >> +		count = ret;
> >> +	return count;
> >> +}
> >>  #endif
> >>  
> 
> Kenji Kaneshige reported the below lockdep problem when testing
> my patch on one of his machines.
> 
> > I still have the following kernel error messages in testing with your
> > latest set of patches (Jesse's linux-next). The test case is removing
> > e1000e device or its parent bridge by "echo 1 > /sys/bus/pci/devices/
> > .../remove".
> >
> > [  537.379995] =============================================
> > [  537.380124] [ INFO: possible recursive locking detected ]
> > [  537.380128] 2.6.29-rc8-kk #1
> > [  537.380128] ---------------------------------------------
> > [  537.380128] events/4/56 is trying to acquire lock:
> > [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
> > [  537.380128]
> > [  537.380128] but task is already holding lock:
> > [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > [  537.380128]
> > [  537.380128] other info that might help us debug this:
> > [  537.380128] 3 locks held by events/4/56:
> > [  537.380128]  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > [  537.380128]  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > [  537.380128]  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c10d1>] remove_callback+0x21/0x40
> > [  537.380128]
> > [  537.380128] stack backtrace:
> > [  537.380128] Pid: 56, comm: events/4 Not tainted 2.6.29-rc8-kk #1
> > [  537.380128] Call Trace:
> > [  537.380128]  [<ffffffff8026dfcd>] validate_chain+0xb7d/0x1260
> > [  537.380128]  [<ffffffff8026eade>] __lock_acquire+0x42e/0xa40
> > [  537.380128]  [<ffffffff8026f148>] lock_acquire+0x58/0x80
> > [  537.380128]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> > [  537.380128]  [<ffffffff8025800d>] flush_workqueue+0x4d/0xa0
> > [  537.380128]  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
> > [  537.383380]  [<ffffffff80258070>] flush_scheduled_work+0x10/0x20
> > [  537.383380]  [<ffffffffa0144065>] e1000_remove+0x55/0xfe [e1000e]
> > [  537.383380]  [<ffffffff8033ee30>] ? sysfs_schedule_callback_work+0x0/0x50
> > [  537.383380]  [<ffffffff803bfeb2>] pci_device_remove+0x32/0x70
> > [  537.383380]  [<ffffffff80441da9>] __device_release_driver+0x59/0x90
> > [  537.383380]  [<ffffffff80441edb>] device_release_driver+0x2b/0x40
> > [  537.383380]  [<ffffffff804419d6>] bus_remove_device+0xa6/0x120
> > [  537.384382]  [<ffffffff8043e46b>] device_del+0x12b/0x190
> > [  537.384382]  [<ffffffff8043e4f6>] device_unregister+0x26/0x70
> > [  537.384382]  [<ffffffff803ba969>] pci_stop_dev+0x49/0x60
> > [  537.384382]  [<ffffffff803baab0>] pci_remove_bus_device+0x40/0xc0
> > [  537.384382]  [<ffffffff803c10d9>] remove_callback+0x29/0x40
> > [  537.384382]  [<ffffffff8033ee4f>] sysfs_schedule_callback_work+0x1f/0x50
> > [  537.384382]  [<ffffffff8025769a>] run_workqueue+0x15a/0x230
> > [  537.384382]  [<ffffffff80257648>] ? run_workqueue+0x108/0x230
> > [  537.384382]  [<ffffffff8025846f>] worker_thread+0x9f/0x100
> > [  537.384382]  [<ffffffff8025bce0>] ? autoremove_wake_function+0x0/0x40
> > [  537.384382]  [<ffffffff802583d0>] ? worker_thread+0x0/0x100
> > [  537.384382]  [<ffffffff8025b89d>] kthread+0x4d/0x80
> > [  537.384382]  [<ffffffff8020d4ba>] child_rip+0xa/0x20
> > [  537.386380]  [<ffffffff8020cebc>] ? restore_args+0x0/0x30
> > [  537.386380]  [<ffffffff8025b850>] ? kthread+0x0/0x80
> > [  537.386380]  [<ffffffff8020d4b0>] ? child_rip+0x0/0x20
> >
> > I think the cause of this error message is flush_workqueue()
> > from the work of keventd. When removing device using
> > "/sys/bus/pci/devices/.../ remove", pci_remove_bus_device() is
> > executed by the keventd's work through
> > device_schedule_callback(), and it invokes e1000e's remove
> > callback. And then, e1000e's remove callback invokes
> > flush_workqueue().  Actually, the kernel error messages are not
> > displayed when I changed e1000e driver to not call
> > flush_workqueue(). In my understanding, flush_workqueue() from
> > the work must be avoided because it can cause a deadlock.
> > Please note that this is not a problem of e1000e driver.
> > Drivers can use flush_workqueue(), of course.
> 
> I agree with this analysis; the reason we're seeing this lockdep
> warning is because the sysfs attributed scheduled a removal for
> itself using device_schedule_callback(). This is necessary
> because sysfs attributes can't remove themselves due to other
> locking issues.
> 
> My question is -- is it a bug to call flush_workqueue during 
> run_workqueue?

Yes, it generally is.

> Conceptually, I don't think it should be a bug; it should be a
> nop, since run_workqueue _is_ flushing the work queue.
> 
> Thoughts?

well ... but running a work item holds up further processing of the 
queue - and there lies the deadlock potential. (but ... i have not 
looked deeply, there's always the possibility of a false positive.)

	Ingo
> 
> > BTW, I also have another worry about executing pci_remove_bus_device()
> > by the work of keventd. The pci_remove_bus_device() will take a long
> > time  especially when the bridge device near the root bus is specified.
> > The long delay of keventd's work will have bad effects to other works
> > on the workqueue.
> 
> The real fix is to fix sysfs so that attributes can remove
> themselves directly. I will work with Tejun Heo on getting this
> working sooner rather than later. That will avoid the locking
> issue you discovered above as well as the concern you point out
> about putting long running tasks in the keventd work queue.


