Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYCTWeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYCTWeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbYCTWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:34:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:44699 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbYCTWeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:34:03 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.44L0.0803201037590.9468-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0803201037590.9468-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 09:32:00 +1100
Message-Id: <1206052320.8420.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 10:45 -0400, Alan Stern wrote:
> 
> I didn't mention locking because it seemed obvious that locking is
> needed.  Of course a flag alone is mostly useless.
> 
> But we already _do_ have a lock (dev->sem) and we _don't_ have a flag.  
> I was pointing out that some drivers will want to have a flag added.
> Maybe so many drivers will want it that the flag should be added to the
> PM structure, where it will be available for every device.  If only a
> few drivers want this new flag, then yes, they can put it in their
> private data structures.

What I'm saying is that a flag set prior to prepare() would be almost
impossible to get right in term of locking for the reasons I explained.

I think this should be under driver reponsibility, using it's own
internal locking. Or else, drivers can rely on failure.

> > However, I think this is mostly a non-issue, because the core _does_
> > provide something here that is useful for drivers who don't want to
> > bother with the above: The failure return from device_add. If drivers
> > don't want to do something akin to what I described, they can just be
> > made to deal gracefully with the failure from device_add that would
> > happen due to the core internal flag being set after the return from
> > prepare().
> 
> Relying on a registration failure to handle this sort of thing is _not_
> a good idea.  For example, how would the driver distinguish failure
> caused by impending suspend from other sorts of failure?

By the precise error code of course. But as I said, I would expect most
bus drivers to have their own proper implementation that does the right
thing, it's not like it was hard and there aren't that many bus drivers.
Relying on failure is a possibility for simple ones that don't want to
care much, in which case, there is little need to differenciate the
failure caused by suspend from other failures other than maybe printing
some garbage in the log vs. not :-)

Ben.

