Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYCTDfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYCTDfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbYCTDf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:35:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:52130 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYCTDf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:35:27 -0400
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
In-Reply-To: <Pine.LNX.4.44L0.0803191101050.4958-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0803191101050.4958-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 14:33:28 +1100
Message-Id: <1205984008.26869.408.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That was in fact the original plan, before Rafael changed over to
> calling prepare() just prior to suspend().

Heh, ok :-)

> Your analysis is right.  Removal isn't a problem; we don't care if 
> drivers are prohibited from registering new children when they are 
> unbound.  In general we want to make it possible to unregister devices 
> at any time during the suspend-resume procedure (except of course that 
> a device can't be unregistered while one of its methods is running).
> 
> An important point I tried to make in the earlier email is that drivers
> will want a simple way to know when it is illegal for them to register
> new children.  For example, suppose the registration is done by a
> workqueue routine.  The most reliable way for the driver to insure that
> the routine won't try to register new children improperly is to have
> the routine check a flag which gets set _before_ prepare() is called.

I don't totally agree here. Drivers could have their own flag set
internally with appropriate locking. The problem with your approach is
locking. Just setting a flag is mostly useless, -unless- there
appropriate locking between setter and testers. 

For example, the flags we talked about previously, the one set _after_
prepare that causes device_add() to fail, this one must have its setting
done within the same mutex/lock as device_add() internally uses to
protect the list. Or something along those lines.

Now, your idea of having the core set some other flag to tell drivers to
stop doing addition wouldn't work here because the driver would -not-
hold the core device list mutex between testing it and performing the
addition.

As a general matter, the driver would need to internally, using it's own
locking mechanisms, ensure that it will not do any further device_add,
and that's not something the core can help with. In our case, that could
be acheived by flushing the work queues and ensuring we don't queue
another one, or using some driver internal semaphore to set a "stop
adding" flag whatever... 

However, I think this is mostly a non-issue, because the core _does_
provide something here that is useful for drivers who don't want to
bother with the above: The failure return from device_add. If drivers
don't want to do something akin to what I described, they can just be
made to deal gracefully with the failure from device_add that would
happen due to the core internal flag being set after the return from
prepare().

So I don't think we need anything else.

Cheers,
Ben.


