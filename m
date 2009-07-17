Return-Path: <linux-kernel-owner+w=401wt.eu-S933920AbZGQBMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbZGQBMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbZGQBMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:12:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36829 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZGQBMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:12:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
Date: Fri, 17 Jul 2009 03:11:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
References: <1247643516.26272.77.camel@rzhang-dt> <20090715060006.71c2e2b6@infradead.org> <1247709910.26272.159.camel@rzhang-dt>
In-Reply-To: <1247709910.26272.159.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907170312.00006.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009, Zhang Rui wrote:
> On Wed, 2009-07-15 at 21:00 +0800, Arjan van de Ven wrote:
> > On Wed, 15 Jul 2009 15:38:36 +0800
> > Zhang Rui <rui.zhang@intel.com> wrote:
> > 
> > > Introduce the device async action mechanism.
> > > 
> > > In order to speed up Linux suspend/resume/shutdown process,
> > > we introduce the device async action mechanism that allow devices
> > > to suspend/resume/shutdown asynchronously.
> > > 
> > > The basic idea is that,
> > > if the suspend/resume/shutdown process of a device set,
> > > including a root device and its child devices, are independent of
> > > other devices, we create an async domain for this device set,
> > > and make them suspend/resume/shutdown asynchronously.
> > 
> > Hi,
> > 
> > I have some concerns about having an async domain per device(group)
> > rather than having one async domain for all of this, 
> 
> ﻿we create an async domain ONLY if we are sure that the device group is
> independent with the other devices.
> 
> and IMO, using multiple async domains brings real device async actions.
> For example, in S3 resume case, there are two device groups:
> device group1: device1, device2, device3
> device group2: device4, device5, device6
> 
> If they share the global domain, we may get:﻿
> device group1: device1(cookie 1), device2(cookie 4), device3(cookie 5)
> device group2: device4(cookie 2), device5(cookie 3), device6(cookie 6)
> 
> this is not real asynchronous resume because
> device3 needs to call async_synchronize_cookie(5) before resume itself.
> which means that device4 and device5 must be resumed before device3.
> 
> But if multiple async domain is used, we get:
> ﻿device group1: device1(cookie 1), device2(cookie 2), device3(cookie 3)
> device group2: device4(cookie 1), device5(cookie 2), device6(cookie 3)
> 
> device group1 and group2 can be resumed asynchronously.
> 
> 
> Another example, in my previous test,
> 1. sata controller. takes 0.4s to resume.
> 2. usb, including uchi and ehci controller takes 1.4s to resume
> 3. ACPI battery takes 0.3s to resume.
> 3. all the other devices take 0.2s to resume.
> 
> sata, usb and ACPI battery are independent device groups.
> If we use multiple async domains, we can reduce the total device resume
> time from 2.3s to a little more than 1.4s because there are a lot of
> sleep in usb resume process.
> But if we share the global async domain, the total resume time can only
> be reduced to about 2.1s because sata, usb and ACPI battery are actually
> resumed synchronously.

Well, first, I'm not really sure that using the async _boot_ infrastructure for
that is a good choice.  During suspend-resume we know dependencies between
devices beforehand, at least in theory, so we can use them.

In particular, we have to make sure that parent devices will not be suspended
until all of their children have been suspended and children devices will not
be resumed before the parents.  The current code handles this quite
efficiently, so I wonder what you're going to do not to break it.

Second, you seem to think that it only makes sense to execute ->suspend()
and ->resume() asynchronously (or in parallel), while for example in the case
of PCI ->suspend_noirq() and ->resume_noirq() also contain code that
potentially can take quite some time to execute.

Finally, I don't really understand what the code in the $subject patch is
supposed to do.  In particular, what's the purpose of dev_action()?
It only seems to check if func is not NULL right now.  Also, you define
DEV_ASYNC_ACTIONS_ALL as 0, so the condition
if (!(DEV_ASYNC_ACTIONS_ALL & type)) in dev_async_register() is always
satisfied.  There are more things like that in this patch, not to mention
excessive return statements and passing function pointers as (void *).

Can we please discuss this thoroughly before any new patches are sent?

Best,
Rafael
