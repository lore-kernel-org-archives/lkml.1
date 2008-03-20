Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYCTOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYCTOpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYCTOpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:45:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3487 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755659AbYCTOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:45:40 -0400
Date: Thu, 20 Mar 2008 10:45:38 -0400 (EDT)
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
Message-ID: <Pine.LNX.4.44L0.0803201037590.9468-100000@netrider.rowland.org>
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

I didn't mention locking because it seemed obvious that locking is
needed.  Of course a flag alone is mostly useless.

But we already _do_ have a lock (dev->sem) and we _don't_ have a flag.  
I was pointing out that some drivers will want to have a flag added.
Maybe so many drivers will want it that the flag should be added to the
PM structure, where it will be available for every device.  If only a
few drivers want this new flag, then yes, they can put it in their
private data structures.

> However, I think this is mostly a non-issue, because the core _does_
> provide something here that is useful for drivers who don't want to
> bother with the above: The failure return from device_add. If drivers
> don't want to do something akin to what I described, they can just be
> made to deal gracefully with the failure from device_add that would
> happen due to the core internal flag being set after the return from
> prepare().

Relying on a registration failure to handle this sort of thing is _not_
a good idea.  For example, how would the driver distinguish failure
caused by impending suspend from other sorts of failure?

Alan Stern

