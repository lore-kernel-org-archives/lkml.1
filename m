Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZHKMtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZHKMtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZHKMs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:48:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:1185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbZHKMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,358,1246863600"; 
   d="scan'208";a="174431830"
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
In-Reply-To: <200908080222.03172.rjw@sisk.pl>
References: <1248404514.2670.107.camel@rzhang-dt>
	 <200908041821.26578.rjw@sisk.pl> <1249439048.2670.454.camel@rzhang-dt>
	 <200908080222.03172.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Tue, 11 Aug 2009 14:22:03 +0800
Message-Id: <1249971723.7853.37.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 08:22 +0800, Rafael J. Wysocki wrote:
> > >
> > something like this?
> >
> > 1. device suspend/resume are split into several stages. And the PM
> > callbacks of every device should be put into one of these stage.
> 
> That's correct.
> 
> > 2. run all the PM callbacks in current stage asynchronously, in the
> > global domain.
> 
> Yes, except that not all of the PM callbacks at given stage may be run in
> parallel with each other.
> 

No, every PM callbacks in the same stage should be run in parallel,
or else we need to use the async cookies to handle the device
dependency, right?
If this is true, I'm afraid we can not do REAL asynchronous resume in a
certain stage.

For example,
device 3 depends on device 2, device 2 depends on device 1.
device 6 depends on device 5, device 5 depends on device 4.
device 1,2,3 and device 4,5,6 can resume in parallel.

﻿If they share the global domain, we may get:﻿
device1(cookie 1), device2(cookie 4), device3(cookie 5)
device4(cookie 2), device5(cookie 3), device6(cookie 6)

this is not real asynchronous resume because
device3 needs to call async_synchronize_cookie(5) before resume itself.
which means that device4 and device5 must be resumed before device3.

while this is not a problem if multiple async domain is used,
domain1: device1(cookie 1), device2(cookie 2), device3(cookie 3)
domain2: device4(cookie 1), device5(cookie 2), device6(cookie 3)

> Generally speaking, it should be possible to divide the device tree into
> layers, where each layer contains devices for which the PM callbacks can be
> executed in parallel and where the PM callbacks from layer 1 should be executed
> before the PM callbacks from layer 2 and so on.
> 
yes.

> Now the question is how to determine which layer to put given device into.

right.
My concern is that we can not find such generic layers except the leaf
device, especially we should make sure that
1. all the devices in the same layer CAN run in parallel
2. all the slow devices are put into the same layer

> Of course the leaf devices with no dependencies and the other devices is the
> simplest possible way of dividing devices into such layers, but in principle
> it should be possible to identify more layers.
> 
I'm not sure.

> Alternatively we can identify branches of the device tree that can be handled
> in parallel, which I think was your idea, wasn't it?  It also might work, but
> for this purpose we'd have to divide dpm_list into several lists and call
> dpm_resume() etc. for them in parallel.  Seems doable too.
> 
yes.
I know this proposal is not generic enough, but fortunately we don't
need to identify the branches for all the devices, neither.
Because several SLOW devices cost most of the suspend/resume time, and
we can focus on these devices only. :)

> > 3. run async_synchronize_full to finish the current state.
> 
> Yes.
> 
> > 4. stage++, and goto step 2.
> 
> Something like this.
> 
> > > > I'm afraid this won't bring as many benefits as it looks like because
> > > > most of the suspend/resume time is cost on several specified devices.
> > >
> > > That shouldn't matter.  As long as there's one driver that waits long enough
> > > for the others' devices to be handled while it's waiting, we are not going
> > > to be hurt by this and the design is going to be simpler IMO.
> > >
> > > > Take the dmesg I attached for example.
> > > >
> > > > total device suspend time is 1.532s.
> > > > serio2            0.407s
> > > > sd 0.0.0.0        0.452s
> > > > serio0            0.103s
> > > > 0b.4.2            0.114s
> > > > 00.1f.2           0.080s
> > > > 00.19.0           0.072s
> > > > all the others    0.304s
> > > >
> > > > total device resume time is 2.899s
> > > > PNP0C0A:00(bat)   0.896s
> > > > 00.19.0           0.056s
> > > > 0b.4.0            0.139s
> > > > 0b.1.1            0.064s
> > > > usb1              0.052s
> > > > usb2              0.051s
> > > > usb3              0.042s
> > > > usb8              0.248s
> > > > sd 0.0.0.0        0.118s
> > > > usb 3-1           0.261s
> > > > usb 8-1           0.511s
> > > > all the others    0.461s
> > > >
> > > > We can see that these several devices take 80%~85% suspend/resume time,
> > > > while all the other (nearly 500) devices take 20%.
> > >
> > > OK, so it doesn't matter how we run the suspend/resume of the 500 'fast'
> > > devices as long as it doesn't take more than 0.896s total.  In particular, it
> > > seems we can do that in parallel just fine.
> > >
> > > > Running a lot device PM callbacks at one time is not equal to saving a
> > > > lot time if the devices listed above still run synchronously.
> > > >
> > > > So I think the key point to speed up suspend/resume is to invoke the PM
> > > > callbacks of these devices asynchronously.
> > > > And I use the asynchronous functions for two reasons.
> > > > 1. devices with dependency are in the same asynchronous domain so that
> > > >    their PM callbacks run in-order.
> > > > ﻿2. PM callbacks of the devices without any dependency run
> > > > asynchronously
> > > >    by using different asynchronous domains.
> > >
> > > If I understand the async framework correctly, the domains are only used for
> > > synchronization, ie. if you want to wait for a group of async operations to
> > > complete, you can put them all into one domain and then call
> > > async_synchronize_full_domain() to wait for them all together.
> > >
> > yes, you're right.
> > please ignore my previous reply in this thread.
> >
> > > You don't need multiple domains to run multiple things in parallel.
> > >
> > > > > One such group is leaf devices, ie.
> > > > > devices that have no children.  Of course, some of them will depend of the
> > > > > other indirectly, so we should make it possible to declare (in the driver)
> > > > > whether the device can be suspended/resumed asynchronously and use the
> > > > > following logic (at the core level), in pseudo code:
> > > > >
> > > > > if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
> > > > >     async_resume(dev);
> > > > > else
> > > > >     resume(dev);
> > > > >
> > > > > and analogously for suspend.  Then, we can easily use one async domain for all
> > > > > of these devices.
> > > >
> > > > > Later, we can add async domains for devices that have children, but can be
> > > > > suspended and woken up in parallel with each other.
> > > > >   IOW, I think the async
> > > > > domains should span the levels rather than branches of the device
> > > > > tree.
> > > > >
> > > >
> > > > Hmm, as I said above,
> > > > this approach works only if we can make sure that the specified devices
> > > > are put in the same async domain, i.e. run in parallel.
> > >
> > > Sure and that's the point.
> > >
> > > For starters, let's put all devices (or rather drivers) without any
> > > dependencies
> >
> > you still mean the leaf devices here, don't you?
> 
> Yes.
> 
> > >  into one async domain and call suspend/resume for them using the
> > > async framework (they will be suspended/resumed in parallel with each other as
> > > well as in parallel with the rest).  Then, let's call
> > > async_synchronize_full_domain() for that domain when we've finished executing
> > > all of the suspend/resume callbacks.
> > >
> > right.
> > but I'm afraid it's not easy to find a group of non-leaf devices without any
> > dependency.
> >
> > > We can easily do such a thing for each phase of suspend/resume
> > >  or hibernation
> > > without causing any problems to happen IMO, as long as the 'async' drivers
> > > really have no dependencies.
> > >
> > sure, the proposal is good.
> > But my concern is how to find out these async domains? i.e. how to find
> > out groups of devices without dependency so that we can suspend/resume
> > devices in the same group in parallel?
> >
> > You said that ﻿the async domains should span the levels rather than
> > branches of the device tree.
> > do you mean suspend/resume all the devices in the same level in
> > parallel?
> >
> > > > are there any prototype patches available?
> > >
> > > No, because I didn't have the time to prepare any.  If you give me a couple of
> > > days, I can write something.  I think.
> > >
> > Sure. don't forget to CC me when you send them out.
> 
> OK, the patch below illustrates my idea, but it's only done for "leaf devices
> with no dependencies" and "other devices".

Hmm, the patch only works for the "other devices" (i8042 and ACPI
battery), which are also leaf devices at the same time.
So the patch doesn't invoke any async functions.

thanks,
rui

>   It only contains the resume part
> which is simpler to implement.
> 



