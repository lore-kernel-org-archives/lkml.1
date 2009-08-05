Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbZHEEMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbZHEEMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZHEEMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:12:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:21793 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZHEEMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:12:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="172382089"
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
In-Reply-To: <200908041821.26578.rjw@sisk.pl>
References: <1248404514.2670.107.camel@rzhang-dt>
	 <200908032318.35070.rjw@sisk.pl> <1249356937.2670.335.camel@rzhang-dt>
	 <200908041821.26578.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Aug 2009 10:24:08 +0800
Message-Id: <1249439048.2670.454.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 00:21 +0800, Rafael J. Wysocki wrote:
> On Tuesday 04 August 2009, Zhang Rui wrote:
> > On Tue, 2009-08-04 at 05:18 +0800, Rafael J. Wysocki wrote:
> > > On Friday 24 July 2009, Zhang Rui wrote:
> > > > Hi,
> > > 
> > > Hi,
> > > 
> > > > this is the patch set I made to speed up the device
> > > > suspend/resume/shutdown process.
> > > > 
> > > > A new mechanism called Device Async Actions is introduced
> > > > in this patch set.
> > > 
> > > Well, I'm not sure we'll need that.
> > > 
> > > > The basic idea is that,
> > > > if the suspend/resume/shutdown process of a device group, including
> > > > a root device and its child devices, are independent of other devices,
> > > > we create an async domain for this device group,
> > > > and make them suspend/resume/shutdown asynchronously.    
> > > 
> > > I don't really think this is the right approach.  IMO, we should rather try to
> > > identify groups of devices for which the PM callbacks (forget about .shutdown()
> > > for now) can be executed in parallel.
> > 
> > hah, I see.
> > You want to execute as more PM callbacks﻿ at one time as possible,
> > right?
> 
> Not only that.  I'd like to simplify the design, because IMO using one async
> domain would be much more straightforward than using multiple ones.
> 
something like this?

1. device suspend/resume are split into several stages. And the PM
callbacks of every device should be put into one of these stage.

2. run all the PM callbacks in current stage asynchronously, in the
global domain.

3. run async_synchronize_full to finish the current state.

4. stage++, and goto step 2.

> > I'm afraid this won't bring as many benefits as it looks like because
> > most of the suspend/resume time is cost on several specified devices.
> 
> That shouldn't matter.  As long as there's one driver that waits long enough
> for the others' devices to be handled while it's waiting, we are not going
> to be hurt by this and the design is going to be simpler IMO.
> 
> > Take the dmesg I attached for example.
> > 
> > total device suspend time is 1.532s.
> > serio2		0.407s
> > sd 0.0.0.0	0.452s
> > serio0		0.103s
> > 0b.4.2		0.114s
> > 00.1f.2		0.080s
> > 00.19.0		0.072s
> > all the others	0.304s
> > 
> > total device resume time is 2.899s
> > PNP0C0A:00(bat)	0.896s
> > 00.19.0		0.056s
> > 0b.4.0		0.139s
> > 0b.1.1		0.064s
> > usb1		0.052s
> > usb2		0.051s
> > usb3		0.042s
> > usb8		0.248s
> > sd 0.0.0.0	0.118s
> > usb 3-1		0.261s
> > usb 8-1		0.511s
> > all the others	0.461s
> > 
> > We can see that these several devices take 80%~85% suspend/resume time,
> > while all the other (nearly 500) devices take 20%.
> 
> OK, so it doesn't matter how we run the suspend/resume of the 500 'fast'
> devices as long as it doesn't take more than 0.896s total.  In particular, it
> seems we can do that in parallel just fine.
> 
> > Running a lot device PM callbacks at one time is not equal to saving a
> > lot time if the devices listed above still run synchronously.
> > 
> > So I think the key point to speed up suspend/resume is to invoke the PM
> > callbacks of these devices asynchronously.
> > And I use the asynchronous functions for two reasons.
> > 1. devices with dependency are in the same asynchronous domain so that
> >    their PM callbacks run in-order.
> > ﻿2. PM callbacks of the devices without any dependency run
> > asynchronously
> >    by using different asynchronous domains.
> 
> If I understand the async framework correctly, the domains are only used for
> synchronization, ie. if you want to wait for a group of async operations to
> complete, you can put them all into one domain and then call
> async_synchronize_full_domain() to wait for them all together.
> 
yes, you're right.
please ignore my previous reply in this thread.

> You don't need multiple domains to run multiple things in parallel.
> 
> > > One such group is leaf devices, ie.
> > > devices that have no children.  Of course, some of them will depend of the
> > > other indirectly, so we should make it possible to declare (in the driver)
> > > whether the device can be suspended/resumed asynchronously and use the
> > > following logic (at the core level), in pseudo code:
> > > 
> > > if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
> > >     async_resume(dev);
> > > else
> > >     resume(dev);
> > > 
> > > and analogously for suspend.  Then, we can easily use one async domain for all
> > > of these devices.
> > 
> > > Later, we can add async domains for devices that have children, but can be
> > > suspended and woken up in parallel with each other.
> > >   IOW, I think the async
> > > domains should span the levels rather than branches of the device
> > > tree.
> > > 
> > 
> > Hmm, as I said above,
> > this approach works only if we can make sure that the specified devices
> > are put in the same async domain, i.e. run in parallel.
> 
> Sure and that's the point.
> 
> For starters, let's put all devices (or rather drivers) without any
> dependencies

you still mean the leaf devices here, don't you?

>  into one async domain and call suspend/resume for them using the
> async framework (they will be suspended/resumed in parallel with each other as
> well as in parallel with the rest).  Then, let's call
> async_synchronize_full_domain() for that domain when we've finished executing
> all of the suspend/resume callbacks.
> 
right.
but I'm afraid it's not easy to find a group of non-leaf devices without any
dependency.

> We can easily do such a thing for each phase of suspend/resume
>  or hibernation
> without causing any problems to happen IMO, as long as the 'async' drivers
> really have no dependencies.
> 
sure, the proposal is good.
But my concern is how to find out these async domains? i.e. how to find
out groups of devices without dependency so that we can suspend/resume
devices in the same group in parallel?

You said that ﻿the async domains should span the levels rather than
branches of the device tree.
do you mean suspend/resume all the devices in the same level in
parallel?

> > are there any prototype patches available?
> 
> No, because I didn't have the time to prepare any.  If you give me a couple of
> days, I can write something.  I think.
> 
Sure. don't forget to CC me when you send them out.

thanks,
rui

