Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbZGQCnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbZGQCnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934037AbZGQCnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:43:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:61349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021AbZGQCnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,415,1243839600"; 
   d="scan'208";a="475665478"
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <200907170312.00006.rjw@sisk.pl>
References: <1247643516.26272.77.camel@rzhang-dt>
	 <20090715060006.71c2e2b6@infradead.org>
	 <1247709910.26272.159.camel@rzhang-dt>  <200907170312.00006.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Fri, 17 Jul 2009 10:44:03 +0800
Message-Id: <1247798643.26272.275.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 09:11 +0800, Rafael J. Wysocki wrote:
> On Thursday 16 July 2009, Zhang Rui wrote:
> > On Wed, 2009-07-15 at 21:00 +0800, Arjan van de Ven wrote:
> > > On Wed, 15 Jul 2009 15:38:36 +0800
> > > Zhang Rui <rui.zhang@intel.com> wrote:
> > > 
> > > > Introduce the device async action mechanism.
> > > > 
> > > > In order to speed up Linux suspend/resume/shutdown process,
> > > > we introduce the device async action mechanism that allow devices
> > > > to suspend/resume/shutdown asynchronously.
> > > > 
> > > > The basic idea is that,
> > > > if the suspend/resume/shutdown process of a device set,
> > > > including a root device and its child devices, are independent of
> > > > other devices, we create an async domain for this device set,
> > > > and make them suspend/resume/shutdown asynchronously.
> > > 
> > > Hi,
> > > 
> > > I have some concerns about having an async domain per device(group)
> > > rather than having one async domain for all of this, 
> > 
> > ﻿we create an async domain ONLY if we are sure that the device group is
> > independent with the other devices.
> > 
> > and IMO, using multiple async domains brings real device async actions.
> > For example, in S3 resume case, there are two device groups:
> > device group1: device1, device2, device3
> > device group2: device4, device5, device6
> > 
> > If they share the global domain, we may get:﻿
> > device group1: device1(cookie 1), device2(cookie 4), device3(cookie 5)
> > device group2: device4(cookie 2), device5(cookie 3), device6(cookie 6)
> > 
> > this is not real asynchronous resume because
> > device3 needs to call async_synchronize_cookie(5) before resume itself.
> > which means that device4 and device5 must be resumed before device3.
> > 
> > But if multiple async domain is used, we get:
> > ﻿device group1: device1(cookie 1), device2(cookie 2), device3(cookie 3)
> > device group2: device4(cookie 1), device5(cookie 2), device6(cookie 3)
> > 
> > device group1 and group2 can be resumed asynchronously.
> > 
> > 
> > Another example, in my previous test,
> > 1. sata controller. takes 0.4s to resume.
> > 2. usb, including uchi and ehci controller takes 1.4s to resume
> > 3. ACPI battery takes 0.3s to resume.
> > 3. all the other devices take 0.2s to resume.
> > 
> > sata, usb and ACPI battery are independent device groups.
> > If we use multiple async domains, we can reduce the total device resume
> > time from 2.3s to a little more than 1.4s because there are a lot of
> > sleep in usb resume process.
> > But if we share the global async domain, the total resume time can only
> > be reduced to about 2.1s because sata, usb and ACPI battery are actually
> > resumed synchronously.
> 
> Well, first, I'm not really sure that using the async _boot_ infrastructure for
> that is a good choice.

IMO, kernel/async.c provides good interfaces that can be used not only
in boot phrase.
it's generic enough for suspend/resume.

>  During suspend-resume we know dependencies between
> devices beforehand, at least in theory, so we can use them.
> 
that's why I use multiple async domains. :)
One domain for a device group.

> In particular, we have to make sure that parent devices will not be suspended
> until all of their children have been suspended and children devices will not
> be resumed before the parents.

that's not enough.
﻿For examples,
ACPI battery and EC are independent devices, but EC must be resumed
before battery because battery driver may access some EC address space
during resume time.
Of course the problem I describe above doesn't exist because ACPI
battery driver doesn't have .resume method right now.
But this is the case that works well in the current code but can not be
converted to async device resume.

> The current code handles this quite
> efficiently, so I wonder what you're going to do not to break it.
> 
sorry I don't quite understand.

> Second, you seem to think that it only makes sense to execute ->suspend()
> and ->resume() asynchronously (or in parallel), while for example in the case
> of PCI ->suspend_noirq() and ->resume_noirq() also contain code that
> potentially can take quite some time to execute.
> 
IMO, this patch set just provides a framework that can be used for
suspend/resume/shutdown optimization, and it doesn't solve all the
problem at one time.

IMO, the next step we should do is:
1. analyze the suspend/resume/shutdown process and find out the hotspot,
   i.e. which drivers suspend/resume slowly
2. If it's software problem that we can fix in the driver, fix it.
   like commit 24920c8a6358bf5532f1336b990b1c0fe2b599ee
3. If the hardware is slow, try to do it asynchronously.
   like I did in patch 8/8.

This framework makes it quite easy to register an async device group.

And even the suspend_noirq and resume_noirq can be covered easily with
this framework.
For example,
1. introduce two new device async actions.
   ﻿DEV_ASYNC_SUSPEND_NOIRQ/DEV_ASYNC_RESUME_NOIRQ
   just like what I did in patch 4/8, 5/8 and 6/8.
2. find out which device is slow in ->suspend_noirq and ->resume_noirq
3. see if we can find an async device group that including this device.
4. if yes, register this new async device group,
   with the type DEV_ASYNC_SUSPEND_NOIRQ/DEV_ASYNC_RESUME_NOIRQ

> Finally, I don't really understand what the code in the $subject patch is
> supposed to do.  In particular, what's the purpose of dev_action()?
> It only seems to check if func is not NULL right now.  Also, you define
> DEV_ASYNC_ACTIONS_ALL as 0, so the condition
> if (!(DEV_ASYNC_ACTIONS_ALL & type)) in dev_async_register() is always
> satisfied.

please refer to patch 4/8 and 5/8 and 6/8

Patch 2/8 is just a framework. No device async action is support yet.
And in Patch 4, 5, 6, we introduced three different types of device
async actions, DEV_ASYNC_SUSPEND, DEV_ASYNC_RESUME and
DEV_ASYNC_SHUTDOWN.
I tried to split a big patch into several small patches.
And it suggests how to adding a new device async type, like
DEV_ASYNC_SUSPEND_NOIRQ, DEV_ASYNC_RESUME_NO_IRQ, etc. :)

> Can we please discuss this thoroughly before any new patches are sent?
> 
do I still need to resend the patch?
If yes, I'll resend patch 2/8, 3/8, 4/8, 5/8, 6/8 as a new big one. :)

thanks,
rui

