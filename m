Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZHRX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZHRX53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZHRX52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:57:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZHRX51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:57:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Wed, 19 Aug 2009 01:58:09 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <1250579793.5351.79.camel@rzhang-dt> <200908182201.11489.rjw@sisk.pl>
In-Reply-To: <200908182201.11489.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908190158.09623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Rafael J. Wysocki wrote:
> On Tuesday 18 August 2009, Zhang Rui wrote:
> > On Mon, 2009-08-17 at 08:15 +0800, Rafael J. Wysocki wrote:
> > > On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > The following patches introduce a mechanism allowing us to execute device
> > > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > > message.
> > > 
> > > Changes:
> > > 
> > > * Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
> > >   (this is a 2.6.32 candidate).
> > > 
> > > * Added [2/7] adding a framework for representing PM link (idea described
> > >   in the patch message).
> > > 
> > > * [3/7] is the async resume patch (idea described in the patch message).
> > > 
> > > * [4/7] is the async suspend patch.
> > > 
> > > * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> > > 
> > > The patches have been tested on HP nx6325.
> > > 
> > I tried this patch set and it does work. :)
> > But unfortunately it doesn't save too much time.
> > 
> > I still think that the child device should inherit its parent's
> > async_suspend flag to do the asynchronous resume more efficiently.
> > 
> > or at least we should provide such an interface
> > in ﻿drivers/base/power/common.c, so that device can tell the device core
> > to inherit this flag if there is no off-tree dependency.
> 
> Well, I'd prefer to identify all of the off-tree dependencies that have to be
> taken into account and handle all devices asynchronously.

Anyway, I have tested the appended patch on top of [1/7]-[7/7] and my test box
appears to work fine with it, although it doesn't work in the "async for all"
case.

I guess the next step will be to see which devices are not handled
asynchronously with the patch below and try to figure out which of them
break(s) things.

Thanks,
Rafael

---
 drivers/base/power/common.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/common.c
===================================================================
--- linux-2.6.orig/drivers/base/power/common.c
+++ linux-2.6/drivers/base/power/common.c
@@ -32,7 +32,11 @@ void device_pm_add(struct device *dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-	pm_link_add(dev, dev->parent);
+	if (dev->parent) {
+		pm_link_add(dev, dev->parent);
+		if (dev->parent->power.async_suspend)
+			dev->power.async_suspend = true;
+	}
 	device_pm_list_add(dev);
 }
 
