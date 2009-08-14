Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZHNL6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZHNL6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZHNL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:58:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbZHNL62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:58:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Fri, 14 Aug 2009 13:58:54 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org> <200908132008.26508.rjw@sisk.pl> <1250220244.1804.9.camel@rzhang-dt>
In-Reply-To: <1250220244.1804.9.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908141358.54129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Zhang Rui wrote:
> On Fri, 2009-08-14 at 02:08 +0800, Rafael J. Wysocki wrote:
> > On Thursday 13 August 2009, Zhang Rui wrote:
> > > On Thu, 2009-08-13 at 05:43 +0800, Rafael J. Wysocki wrote:
> > > > On Wednesday 12 August 2009, Alan Stern wrote:
> > > > > On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > The following patches introduce a mechanism allowing us to execute device
> > > > > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > > > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > > > > message.
> > > > > > 
> > > > > > Comments welcome.
> > > > > 
> > > > > I get the idea.  Not bad.
> > > > 
> > > > Thanks!
> > > > 
> > > > > Have you tried it in a serious way?  For example, turning on the
> > > > > async_suspend flag for every device?
> > > > 
> > > > No, I've only tested it with a few selected drivers.  I'm going to try the
> > > > "async everyone" scenario, though.
> > > > 
> > > > > In one way it isn't as efficient as it could be.  You fire off a bunch
> > > > > of async threads and then make many of them wait for parent or child
> > > > > devices.  They could be doing useful work instead.
> > > > 
> > > ﻿﻿are you talking about this scenario, or I find another problem of this
> > > approach:
> > > there is a part of dpm_list, dev1->dev_aaa->...->dev_bbb->dev2
> > > 
> > > dev2 is dev1's first child.
> > > dev1 resume takes 1s
> > > dev_aaa~dev_bbb resume takes 0.1s.
> > > 
> > > if we call ﻿device_enable_async_suspend(dev1, true) in order to resume
> > > device1 asynchronously, the real asynchronous resume only happens
> > > between dev1 and dev_aaa to dev_bbb because dev2 needs to wait until
> > > dev1 resume finished.
> > 
> > Yes, that's how it works, but I would call it a limitation rather than a
> > problem.  It partially stems from the fact that __async_schedule() executes
> > ptr() synchronously in some circumstances (e.g. async_enabled unset), so the
> > suspend and resume callbacks have to be scheduled in the same order, in which
> > they would have been called synchronously.
> > 
> > > so kernel schedules dev1 resume in an async thread first, and then takes
> > > 0.1s to finish the dev_aaa to dev_bbb resume, and then sleep 0.9s
> > > 
> > > > I kind of agree, but then the patches would be more complicated.
> > > > 
> > > The problem is that we need to invoke device_resume for every device
> > > synchronously.
> > 
> > Yes, we do.
> > 
> > > I wonder if we can make the child devices inherit the
> > > parent's ﻿dev->power.async_suspend flag, so that devices that need to
> > > wait are resumed asynchronously, i.e. we never wait/sleep when parsing
> > > the dpm_list.
> > > 
> > > this doesn't bring too much benefit in suspend case but it can speed up
> > > the resume process a lot.
> > 
> > We can do that at the core level,
> 
> I think you mean we can't do that at the core level.

That's correct, sorry for the mistake.

> >  because there may be dependencies between
> > the children the core doesn't know about.  Subsystems are free to set
> > async_suspend for the entire branches of device hierarchy if they are known
> > not to contain any off-tree dependencies, but the core has no information
> > about that.
> > 
> hmm, but the current patch doesn't handle the off-tree dependencies
> neither.
> e.g.
> dev1, dev2, dev3
> dev2 depends on dev1, dev3 is dev1's first child,
> we only promise that dev1 has been resumed before resuming dev3 in the
> current proposal.

Sure, and that's why I said "if they are known not to contain any off-tree
dependencies".  IOW, if a subsystem (e.g. platform) knows that none of its
devices have any off-tree dependencies, it can safely set async_suspend for
all of them.

> anyway, this is not a problem after the pm_connection stuff is
> implemented. :)

Well, that's going to take some time I guess.

Thanks,
Rafael
