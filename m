Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYCTS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYCTS0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYCTS0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:26:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3985 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754619AbYCTS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:26:34 -0400
Date: Thu, 20 Mar 2008 14:26:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
 hibernation callbacks
In-Reply-To: <1205984008.26869.408.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0803201412210.22752-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Benjamin Herrenschmidt wrote:

> > An important point I tried to make in the earlier email is that drivers
> > will want a simple way to know when it is illegal for them to register
> > new children.  For example, suppose the registration is done by a
> > workqueue routine.  The most reliable way for the driver to insure that
> > the routine won't try to register new children improperly is to have
> > the routine check a flag which gets set _before_ prepare() is called.
> 
> I don't totally agree here. Drivers could have their own flag set
> internally with appropriate locking. The problem with your approach is
> locking. Just setting a flag is mostly useless, -unless- there
> appropriate locking between setter and testers. 

Here's an example of what I mean.

One of the things we don't want to do is bind a new driver to a device
after it has gone through the prepare() stage.  Doing so would involve
calling the driver's probe() routine, which is likely to want to
register new children and who knows what else.  The probe routine might 
even end up running after the device was suspended!  Clearly this 
should be avoided.

But the user can force a binding to occur by writing the device's path
to the driver's "bind" attribute in sysfs.  This means that
driver_bind() in drivers/base/bus.c will need to know whether or not
the device has gone through the prepare() stage, which means the device
structure will need to have a flag set before prepare() is called (more 
precisely, the flag must be set before dev->sem is released following 
the call to prepare).

Either that or else driver_bind() must always block whenever a system
sleep is in progress.  That would be easier -- but it's a lot like what 
the freezer would do.  Which would you prefer?

Alan Stern

