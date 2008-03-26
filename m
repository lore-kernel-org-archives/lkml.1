Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYCZODv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYCZODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYCZODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:03:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39505 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750724AbYCZODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:03:39 -0400
Date: Wed, 26 Mar 2008 10:03:38 -0400 (EDT)
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
In-Reply-To: <200803252135.04247.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803261001080.4755-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Rafael J. Wysocki wrote:

> > I just thought of another problem.  At the point where
> > local_irq_disable() is called, in between device_suspend() and
> > device_power_down(), it is possible in a preemptible kernel that
> > another task is holding dpm_list_mtx and is in the middle of updating
> > the list pointers.  This would mess up the traversal in
> > device_power_down().
> > 
> > I'm not sure about the best way to prevent this.  Is it legal to call
> > unlock_mutex() while interrupts or preemption are disabled?
> 
> Well, I think it is, but I'm not sure how that can help.
> 
> To prevent the race from happening, we can lock dpm_list_mtx before switching
> interrupts off in kernel/power/main.c:suspend_enter() and analogously in
> kernel/power/disk.c .

That's right.  And once interrupts are turned off you should unlock 
dpm_list_mtx again, in case a noirq method wants to unregister a 
device.  Hence my question: Is it legal to call unlock_mutex() while 
interrupts are disabled?

Alan Stern

