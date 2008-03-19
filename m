Return-Path: <linux-kernel-owner+w=401wt.eu-S938163AbYCSWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938163AbYCSWQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934830AbYCSUq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:46:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2199 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755027AbYCSUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:46:26 -0400
Date: Wed, 19 Mar 2008 11:19:43 -0400 (EDT)
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
In-Reply-To: <1205898542.26869.268.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0803191101050.4958-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Benjamin Herrenschmidt wrote:

> Hi Alan !

Hi!

> On Tue, 2008-03-18 at 22:44 -0400, Alan Stern wrote:

> Now, about the issue vs. device insertion, I believe it's solvable
> unless I missed something:
> 
> So it's the responsibility of bus drivers such as khubd to stop
> inserting new devices in the tree from prepare(). There we agree. The
> problem is about -enforcing- it in the core right ? That is, making
> device addition actually fail if a bogus bus driver tries to insert a
> device at the wrong time.
> 
> This does indeed have an issue of when precisely do we stick that flag
> (that tells the core to fail) since before calling the bus driver
> prepare() is too early and after is potentially too late.
> 
> Now, I think this is not really a problem if prepare() calls the drivers
> from top to bottom:

That was in fact the original plan, before Rafael changed over to
calling prepare() just prior to suspend().

>  In that case, we would set the flag after the bus
> driver returns from prepare(). That means that there is a small window
> where a bogus bus driver can still insert a new child, but I think that
> isn't an issue, specifically because we walk from parent to child:
> 
> If the sequence is:
> 
> 	1- prepare() returns
> 	2- we set the "no new addition" flag
> 	3- we start walking children
> 
> You see that the only place the where the "bad" bus driver can still
> attempt to insert without failing is between 1 and 2. However, that
> happens before we start prepare()'ing the children. So that means that
> anything that has successfully been added -will- have it's prepare()
> called, and thus becomes a normal part of the suspend/resume process.
> Any attempt at adding after 2 would fail, thus we are sure the children
> list is sane here (won't get new things right in between. Removal might
> still happen I suppose, we'll have to look into this closely).

Your analysis is right.  Removal isn't a problem; we don't care if 
drivers are prohibited from registering new children when they are 
unbound.  In general we want to make it possible to unregister devices 
at any time during the suspend-resume procedure (except of course that 
a device can't be unregistered while one of its methods is running).

An important point I tried to make in the earlier email is that drivers
will want a simple way to know when it is illegal for them to register
new children.  For example, suppose the registration is done by a
workqueue routine.  The most reliable way for the driver to insure that
the routine won't try to register new children improperly is to have
the routine check a flag which gets set _before_ prepare() is called.

This means there would have to be _two_ flags: one set before calling 
prepare() and one set afterward.  Only the second would be checked by 
the PM core when deciding whether to allow new child registrations.

> > In the other direction, it ought to be okay to allow new children to 
> > be registered during resume().  There's no need to wait for complete().
> 
> There are pros and cons here. A lot of drivers may rely on
> request_firmware() and such, and will possibly deadlock or timeout if
> called during resume before storage is available (i've seen that
> happening with today scheme). It might be better to be safe here, but I
> agree, it's generally less of a concern.

That's up to the individual driver.  If it wants to wait until its 
complete method runs, then fine.  But if it doesn't want to wait, the 
PM core shouldn't force new registrations to fail.

Alan Stern

