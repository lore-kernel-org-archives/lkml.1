Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZHMITj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZHMITj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZHMITi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:19:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:36065 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZHMITh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:19:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,373,1246863600"; 
   d="scan'208";a="438607201"
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <200908122343.20554.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org>
	 <200908122343.20554.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Aug 2009 16:18:29 +0800
Message-Id: <1250151509.2906.61.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 05:43 +0800, Rafael J. Wysocki wrote:
> On Wednesday 12 August 2009, Alan Stern wrote:
> > On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> > 
> > > Hi,
> > > 
> > > The following patches introduce a mechanism allowing us to execute device
> > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > message.
> > > 
> > > Comments welcome.
> > 
> > I get the idea.  Not bad.
> 
> Thanks!
> 
> > Have you tried it in a serious way?  For example, turning on the
> > async_suspend flag for every device?
> 
> No, I've only tested it with a few selected drivers.  I'm going to try the
> "async everyone" scenario, though.
> 
> > In one way it isn't as efficient as it could be.  You fire off a bunch
> > of async threads and then make many of them wait for parent or child
> > devices.  They could be doing useful work instead.
> 
﻿﻿are you talking about this scenario, or I find another problem of this
approach:
there is a part of dpm_list, dev1->dev_aaa->...->dev_bbb->dev2

dev2 is dev1's first child.
dev1 resume takes 1s
dev_aaa~dev_bbb resume takes 0.1s.

if we call ﻿device_enable_async_suspend(dev1, true) in order to resume
device1 asynchronously, the real asynchronous resume only happens
between dev1 and dev_aaa to dev_bbb because dev2 needs to wait until
dev1 resume finished.

so kernel schedules dev1 resume in an async thread first, and then takes
0.1s to finish the dev_aaa to dev_bbb resume, and then sleep 0.9s

> I kind of agree, but then the patches would be more complicated.
> 
The problem is that we need to invoke device_resume for every device
synchronously.
I wonder if we can make the child devices inherit the
parent's ﻿dev->power.async_suspend flag, so that devices that need to
wait are resumed asynchronously, i.e. we never wait/sleep when parsing
the dpm_list.

this doesn't bring too much benefit in suspend case but it can speed up
the resume process a lot.

Of cause, this is not a problem if we turn on the async_suspend flag for
every device.

> > It would be interesting to invent a way of representing explicitly the 
> > non-tree dependencies -- assuming there aren't too many of them!  (I 
> > can just hear the TI guys hollering about power and timer domains...)
> 
> I have an idea.
> 
> Every such dependency involves two devices, one of which is a "master"
> and the second of which is a "slave", meaning that the "slave" have to be
> suspended before the "master" and cannot be resumed before it.  In principle
> we could give each device two lists of "dependency objects", one containing
> "dependency objects" where the device is the "master" and the other containing
> "dependency objects" where the device is the "slave".  Then, each "dependency
> object" could be represented as
> 
> struct pm_connection {
>     struct device *master;
>     struct list_head master_hook;
>     struct device *slave;
>     struct list_head slave_hook;
> };
> 
> Add some locking, helpers for adding / removing "dependency objects" etc.
> and it should work.  Instead of checking the parent, walk the list of
> "masters", instead of walking the list of children, walk the list of "slaves".
> 
> The core could create those objects for parent-child relationships
> automatically, the other ones would have to be added by platforms / bus types /
> drivers etc.
> 
﻿this sounds great. :)

thanks,
rui

> This approach has a problem that it's prone to adding circular dependencies by
> mistake, but then I think it would apply to any other approach just as well.
> 
> Best,
> Rafael

