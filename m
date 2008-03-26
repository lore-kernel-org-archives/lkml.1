Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbYCZUgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbYCZUgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758962AbYCZUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:36:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43881 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758043AbYCZUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:36:43 -0400
Date: Wed, 26 Mar 2008 16:36:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 3)
In-Reply-To: <200803262126.58357.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803261633190.9881-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Rafael J. Wysocki wrote:

> On Wednesday, 26 of March 2008, Alan Stern wrote:
> > On Tue, 25 Mar 2008, Rafael J. Wysocki wrote:
> > 
> > > > I just thought of another problem.  At the point where
> > > > local_irq_disable() is called, in between device_suspend() and
> > > > device_power_down(), it is possible in a preemptible kernel that
> > > > another task is holding dpm_list_mtx and is in the middle of updating
> > > > the list pointers.  This would mess up the traversal in
> > > > device_power_down().
> > > > 
> > > > I'm not sure about the best way to prevent this.  Is it legal to call
> > > > unlock_mutex() while interrupts or preemption are disabled?
> > > 
> > > Well, I think it is, but I'm not sure how that can help.
> > > 
> > > To prevent the race from happening, we can lock dpm_list_mtx before switching
> > > interrupts off in kernel/power/main.c:suspend_enter() and analogously in
> > > kernel/power/disk.c .
> > 
> > That's right.  And once interrupts are turned off you should unlock 
> > dpm_list_mtx again, in case a noirq method wants to unregister a 
> > device.
> 
> Why would a noirq method want to do that?  IMO, it's not a big deal if noirq
> methods are not allowed to unregister devices.

Okay, that's fine.  It keeps things simple.

> > Hence my question: Is it legal to call unlock_mutex() while interrupts are
> > disabled? 
> 
> Well, I suspect that will confuse lockdep quite a bit.  Otherwise, I don't see
> a problem with it (it's just changing the value of a shared variable after
> all).

Then you have your answer.  Perhaps have device_suspend() exit with the
mutex held and have device_resume() release it (with appropriate
handling for error situations, of course).

Alan Stern

