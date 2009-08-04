Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbZHDQV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbZHDQV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbZHDQV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:21:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879AbZHDQV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:21:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Tue, 4 Aug 2009 18:21:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
References: <1248404514.2670.107.camel@rzhang-dt> <200908032318.35070.rjw@sisk.pl> <1249356937.2670.335.camel@rzhang-dt>
In-Reply-To: <1249356937.2670.335.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908041821.26578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Zhang Rui wrote:
> On Tue, 2009-08-04 at 05:18 +0800, Rafael J. Wysocki wrote:
> > On Friday 24 July 2009, Zhang Rui wrote:
> > > Hi,
> > 
> > Hi,
> > 
> > > this is the patch set I made to speed up the device
> > > suspend/resume/shutdown process.
> > > 
> > > A new mechanism called Device Async Actions is introduced
> > > in this patch set.
> > 
> > Well, I'm not sure we'll need that.
> > 
> > > The basic idea is that,
> > > if the suspend/resume/shutdown process of a device group, including
> > > a root device and its child devices, are independent of other devices,
> > > we create an async domain for this device group,
> > > and make them suspend/resume/shutdown asynchronously.    
> > 
> > I don't really think this is the right approach.  IMO, we should rather try to
> > identify groups of devices for which the PM callbacks (forget about .shutdown()
> > for now) can be executed in parallel.
> 
> hah, I see.
> You want to execute as more PM callbacks﻿ at one time as possible,
> right?

Not only that.  I'd like to simplify the design, because IMO using one async
domain would be much more straightforward than using multiple ones.

> I'm afraid this won't bring as many benefits as it looks like because
> most of the suspend/resume time is cost on several specified devices.

That shouldn't matter.  As long as there's one driver that waits long enough
for the others' devices to be handled while it's waiting, we are not going
to be hurt by this and the design is going to be simpler IMO.

> Take the dmesg I attached for example.
> 
> total device suspend time is 1.532s.
> serio2		0.407s
> sd 0.0.0.0	0.452s
> serio0		0.103s
> 0b.4.2		0.114s
> 00.1f.2		0.080s
> 00.19.0		0.072s
> all the others	0.304s
> 
> total device resume time is 2.899s
> PNP0C0A:00(bat)	0.896s
> 00.19.0		0.056s
> 0b.4.0		0.139s
> 0b.1.1		0.064s
> usb1		0.052s
> usb2		0.051s
> usb3		0.042s
> usb8		0.248s
> sd 0.0.0.0	0.118s
> usb 3-1		0.261s
> usb 8-1		0.511s
> all the others	0.461s
> 
> We can see that these several devices take 80%~85% suspend/resume time,
> while all the other (nearly 500) devices take 20%.

OK, so it doesn't matter how we run the suspend/resume of the 500 'fast'
devices as long as it doesn't take more than 0.896s total.  In particular, it
seems we can do that in parallel just fine.

> Running a lot device PM callbacks at one time is not equal to saving a
> lot time if the devices listed above still run synchronously.
> 
> So I think the key point to speed up suspend/resume is to invoke the PM
> callbacks of these devices asynchronously.
> And I use the asynchronous functions for two reasons.
> 1. devices with dependency are in the same asynchronous domain so that
>    their PM callbacks run in-order.
> ﻿2. PM callbacks of the devices without any dependency run
> asynchronously
>    by using different asynchronous domains.

If I understand the async framework correctly, the domains are only used for
synchronization, ie. if you want to wait for a group of async operations to
complete, you can put them all into one domain and then call
async_synchronize_full_domain() to wait for them all together.

You don't need multiple domains to run multiple things in parallel.

> > One such group is leaf devices, ie.
> > devices that have no children.  Of course, some of them will depend of the
> > other indirectly, so we should make it possible to declare (in the driver)
> > whether the device can be suspended/resumed asynchronously and use the
> > following logic (at the core level), in pseudo code:
> > 
> > if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
> >     async_resume(dev);
> > else
> >     resume(dev);
> > 
> > and analogously for suspend.  Then, we can easily use one async domain for all
> > of these devices.
> 
> > Later, we can add async domains for devices that have children, but can be
> > suspended and woken up in parallel with each other.
> >   IOW, I think the async
> > domains should span the levels rather than branches of the device
> > tree.
> > 
> 
> Hmm, as I said above,
> this approach works only if we can make sure that the specified devices
> are put in the same async domain, i.e. run in parallel.

Sure and that's the point.

For starters, let's put all devices (or rather drivers) without any
dependencies into one async domain and call suspend/resume for them using the
async framework (they will be suspended/resumed in parallel with each other as
well as in parallel with the rest).  Then, let's call
async_synchronize_full_domain() for that domain when we've finished executing
all of the suspend/resume callbacks.

We can easily do such a thing for each phase of suspend/resume or hibernation
without causing any problems to happen IMO, as long as the 'async' drivers
really have no dependencies.

> are there any prototype patches available?

No, because I didn't have the time to prepare any.  If you give me a couple of
days, I can write something.  I think.

Thanks,
Rafael
