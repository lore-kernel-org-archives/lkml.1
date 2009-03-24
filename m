Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbZCXRYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbZCXRYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbZCXRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:24:05 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6047 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761264AbZCXRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:23:58 -0400
Date: Tue, 24 Mar 2009 11:23:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090324172354.GB17297@ldl.fc.hp.com>
References: <20090320204327.12275.43010.stgit@bob.kio> <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com> <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu> <20090324034659.9e1f97dc.akpm@linux-foundation.org> <1237897972.4320.79.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237897972.4320.79.camel@johannes.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2009-03-24 at 03:46 -0700, Andrew Morton wrote:
> 
> > But I don't think we've seen a coherent description of what's actually
> > _wrong_ with the current code.  flush_cpu_workqueue() has been handling
> > this case for many years with no problems reported as far as I know.
> > 
> > So what has caused this sudden flurry of reports?  Did something change in
> > lockdep?  What is this
> > 
> > [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
> > [  537.380128]
> > [  537.380128] but task is already holding lock:
> > [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> > 
> > supposed to mean?  "events" isn't a lock - it's the name of a kernel
> > thread, isn't it?  If this is supposed to be deadlockable then how?
> 
> events is indeed the schedule_work workqueue thread name -- I just used
> that for lack of a better name.
> 
> > Because I don't immediately see what's wrong with e1000_remove() calling
> > flush_work().  It's undesirable, and we can perhaps improve it via some
> > means, but where is the bug?
> 
> There is no bug -- it's a false positive in a way. I've pointed this out
> in the original thread, see
> http://thread.gmane.org/gmane.linux.kernel/550877/focus=550932

I'm actually a bit confused now.

Peter explained why flushing a workqueue from the same queue is
bad, and in general I agree, but what do you mean by "false
positive"?

By the way, this scenario:

	code path 1:
	  my_function() -> lock(L1); ...; flush_workqueue(); ...

	code path 2:
	  run_workqueue() -> my_work() -> ...; lock(L1); ...

is _not_ what is happening here.

sysfs_schedule_callback() is an ugly piece of code that exists
because a sysfs attribute cannot remove itself without
deadlocking. So the callback mechanism was created to allow a
different kernel thread to remove the sysfs attribute and avoid
deadlock.

So what you really have going on is:

	sysfs callback -> add remove callback to global workqueue
	remove callback fires off (pci_remove_bus_device) and we do...
	    device_unregister
	    driver's ->remove method called
	    driver's ->remove method calls flush_scheduled_work

Yes, after read the thread I agree that generically calling
flush_workqueue in the middle of run_workqueue is bad, but the
lockdep warning that Kenji showed us really won't deadlock.

This is because pci_remove_bus_device() will not acquire any lock
L1 that an individual device driver will attempt to acquire in
the remove path. If that were the case, we would deadlock every
time you rmmod'ed a device driver's module or every time you shut
your machine down.

I think from my end, there are 2 things I need to do:

	a) make sysfs_schedule_callback() use its own work queue
	   instead of global work queue, because too many drivers
	   call flush_scheduled_work in their remove path

	b) give sysfs attributes the ability to commit suicide

(a) is short term work, 2.6.30 timeframe, since it doesn't
involve any large conceptual changes.

(b) is picking up Tejun Heo's existing work, but that was a bit
controversial last time, and I'm not sure it will make it during
this merge window.

Question for the lockdep folks though -- given what I described,
do you agree that the warning we saw was a false positive? Or am
I off in left field?

Thanks.

/ac

