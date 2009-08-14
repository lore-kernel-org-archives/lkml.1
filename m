Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbZHNDZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbZHNDZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZHNDZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:25:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:41485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbZHNDZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:25:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,378,1246863600"; 
   d="scan'208";a="716722564"
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <200908132008.26508.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org>
	 <200908122343.20554.rjw@sisk.pl> <1250151509.2906.61.camel@rzhang-dt>
	 <200908132008.26508.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Aug 2009 11:24:04 +0800
Message-Id: <1250220244.1804.9.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 02:08 +0800, Rafael J. Wysocki wrote:
> On Thursday 13 August 2009, Zhang Rui wrote:
> > On Thu, 2009-08-13 at 05:43 +0800, Rafael J. Wysocki wrote:
> > > On Wednesday 12 August 2009, Alan Stern wrote:
> > > > On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > The following patches introduce a mechanism allowing us to execute device
> > > > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > > > message.
> > > > > 
> > > > > Comments welcome.
> > > > 
> > > > I get the idea.  Not bad.
> > > 
> > > Thanks!
> > > 
> > > > Have you tried it in a serious way?  For example, turning on the
> > > > async_suspend flag for every device?
> > > 
> > > No, I've only tested it with a few selected drivers.  I'm going to try the
> > > "async everyone" scenario, though.
> > > 
> > > > In one way it isn't as efficient as it could be.  You fire off a bunch
> > > > of async threads and then make many of them wait for parent or child
> > > > devices.  They could be doing useful work instead.
> > > 
> > ﻿﻿are you talking about this scenario, or I find another problem of this
> > approach:
> > there is a part of dpm_list, dev1->dev_aaa->...->dev_bbb->dev2
> > 
> > dev2 is dev1's first child.
> > dev1 resume takes 1s
> > dev_aaa~dev_bbb resume takes 0.1s.
> > 
> > if we call ﻿device_enable_async_suspend(dev1, true) in order to resume
> > device1 asynchronously, the real asynchronous resume only happens
> > between dev1 and dev_aaa to dev_bbb because dev2 needs to wait until
> > dev1 resume finished.
> 
> Yes, that's how it works, but I would call it a limitation rather than a
> problem.  It partially stems from the fact that __async_schedule() executes
> ptr() synchronously in some circumstances (e.g. async_enabled unset), so the
> suspend and resume callbacks have to be scheduled in the same order, in which
> they would have been called synchronously.
> 
> > so kernel schedules dev1 resume in an async thread first, and then takes
> > 0.1s to finish the dev_aaa to dev_bbb resume, and then sleep 0.9s
> > 
> > > I kind of agree, but then the patches would be more complicated.
> > > 
> > The problem is that we need to invoke device_resume for every device
> > synchronously.
> 
> Yes, we do.
> 
> > I wonder if we can make the child devices inherit the
> > parent's ﻿dev->power.async_suspend flag, so that devices that need to
> > wait are resumed asynchronously, i.e. we never wait/sleep when parsing
> > the dpm_list.
> > 
> > this doesn't bring too much benefit in suspend case but it can speed up
> > the resume process a lot.
> 
> We can do that at the core level,

I think you mean we can't do that at the core level.

>  because there may be dependencies between
> the children the core doesn't know about.  Subsystems are free to set
> async_suspend for the entire branches of device hierarchy if they are known
> not to contain any off-tree dependencies, but the core has no information
> about that.
> 
hmm, but the current patch doesn't handle the off-tree dependencies
neither.
e.g.
dev1, dev2, dev3
dev2 depends on dev1, dev3 is dev1's first child,
we only promise that dev1 has been resumed before resuming dev3 in the
current proposal.

anyway, this is not a problem after the pm_connection stuff is
implemented. :)

thanks,
rui
> > Of cause, this is not a problem if we turn on the async_suspend flag for
> > every device.
> 
> Yes, but we cannot do that at this point.
> 
> > > > It would be interesting to invent a way of representing explicitly the 
> > > > non-tree dependencies -- assuming there aren't too many of them!  (I 
> > > > can just hear the TI guys hollering about power and timer domains...)
> > > 
> > > I have an idea.
> > > 
> > > Every such dependency involves two devices, one of which is a "master"
> > > and the second of which is a "slave", meaning that the "slave" have to be
> > > suspended before the "master" and cannot be resumed before it.  In principle
> > > we could give each device two lists of "dependency objects", one containing
> > > "dependency objects" where the device is the "master" and the other containing
> > > "dependency objects" where the device is the "slave".  Then, each "dependency
> > > object" could be represented as
> > > 
> > > struct pm_connection {
> > >     struct device *master;
> > >     struct list_head master_hook;
> > >     struct device *slave;
> > >     struct list_head slave_hook;
> > > };
> > > 
> > > Add some locking, helpers for adding / removing "dependency objects" etc.
> > > and it should work.  Instead of checking the parent, walk the list of
> > > "masters", instead of walking the list of children, walk the list of "slaves".
> > > 
> > > The core could create those objects for parent-child relationships
> > > automatically, the other ones would have to be added by platforms / bus types /
> > > drivers etc.
> > > 
> > ﻿this sounds great. :)
> 
> It can only be the next step, though, because it will affect the runtime PM as
> well,  among other things.
> 



> Thanks,
> Rafael

