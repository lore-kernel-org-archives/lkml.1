Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZHUHm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZHUHm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZHUHm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:42:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:42104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbZHUHm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:42:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,249,1249282800"; 
   d="scan'208";a="543473148"
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg KH <gregkh@suse.de>
In-Reply-To: <200908192302.31453.rjw@sisk.pl>
References: <200908122218.13975.rjw@sisk.pl>
	 <200908190158.09623.rjw@sisk.pl> <1250643929.17853.11.camel@rzhang-dt>
	 <200908192302.31453.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Aug 2009 15:40:34 +0800
Message-Id: <1250840434.17853.176.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 05:02 +0800, Rafael J. Wysocki wrote:
> On Wednesday 19 August 2009, Zhang Rui wrote:
> > On Wed, 2009-08-19 at 07:58 +0800, Rafael J. Wysocki wrote:
> > > On Tuesday 18 August 2009, Rafael J. Wysocki wrote:
> > > > On Tuesday 18 August 2009, Zhang Rui wrote:
> > > > > On Mon, 2009-08-17 at 08:15 +0800, Rafael J. Wysocki wrote:
> > > > > > On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > The following patches introduce a mechanism allowing us to execute device
> > > > > > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > > > > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > > > > > message.
> > > > > > 
> > > > > > Changes:
> > > > > > 
> > > > > > * Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
> > > > > >   (this is a 2.6.32 candidate).
> > > > > > 
> > > > > > * Added [2/7] adding a framework for representing PM link (idea described
> > > > > >   in the patch message).
> > > > > > 
> > > > > > * [3/7] is the async resume patch (idea described in the patch message).
> > > > > > 
> > > > > > * [4/7] is the async suspend patch.
> > > > > > 
> > > > > > * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> > > > > > 
> > > > > > The patches have been tested on HP nx6325.
> > > > > > 
> > > > > I tried this patch set and it does work. :)
> > > > > But unfortunately it doesn't save too much time.
> > > > > 
> > > > > I still think that the child device should inherit its parent's
> > > > > async_suspend flag to do the asynchronous resume more efficiently.
> > > > > 
> > > > > or at least we should provide such an interface
> > > > > in ﻿drivers/base/power/common.c, so that device can tell the device core
> > > > > to inherit this flag if there is no off-tree dependency.
> > > > 
> > > > Well, I'd prefer to identify all of the off-tree dependencies that have to be
> > > > taken into account and handle all devices asynchronously.
> > > 
> > > Anyway, I have tested the appended patch on top of [1/7]-[7/7] and my test box
> > > appears to work fine with it, although it doesn't work in the "async for all"
> > > case.
> > > 
> > > I guess the next step will be to see which devices are not handled
> > > asynchronously with the patch below and try to figure out which of them
> > > break(s) things.
> > > 
> > > Thanks,
> > > Rafael
> > > 
> > > ---
> > >  drivers/base/power/common.c |    6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6/drivers/base/power/common.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/base/power/common.c
> > > +++ linux-2.6/drivers/base/power/common.c
> > > @@ -32,7 +32,11 @@ void device_pm_add(struct device *dev)
> > >  	pr_debug("PM: Adding info for %s:%s\n",
> > >  		 dev->bus ? dev->bus->name : "No Bus",
> > >  		 kobject_name(&dev->kobj));
> > > -	pm_link_add(dev, dev->parent);
> > > +	if (dev->parent) {
> > > +		pm_link_add(dev, dev->parent);
> > > +		if (dev->parent->power.async_suspend)
> > > +			dev->power.async_suspend = true;
> > > +	}
> > 
> > to use this, we must make sure that ﻿device_enable_async_suspend is
> > called before any of its child device being registered, right?
> > should we check this in ﻿﻿device_enable_async_suspend?
> > or at least we should add the comments stating this issue.
> 
> That's correct in general, but I added the patch for testing purposes only.
> 
> The goal still is to identify all of the dependencies that need to be taken
> care of and to represent them appropriately, so that we can safely set
> async_suspend for all devices.
> 
> I wonder if you get any improvement with this patch applied?
> 
No, it doesn't work.
the system hangs during suspend.
I have not figured out the root cause.

thanks,
rui


