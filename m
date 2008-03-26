Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYCZU2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYCZU2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYCZU1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:27:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbYCZU1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:27:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Wed, 26 Mar 2008 21:26:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803261001080.4755-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803261001080.4755-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803262126.58357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, Alan Stern wrote:
> On Tue, 25 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > I just thought of another problem.  At the point where
> > > local_irq_disable() is called, in between device_suspend() and
> > > device_power_down(), it is possible in a preemptible kernel that
> > > another task is holding dpm_list_mtx and is in the middle of updating
> > > the list pointers.  This would mess up the traversal in
> > > device_power_down().
> > > 
> > > I'm not sure about the best way to prevent this.  Is it legal to call
> > > unlock_mutex() while interrupts or preemption are disabled?
> > 
> > Well, I think it is, but I'm not sure how that can help.
> > 
> > To prevent the race from happening, we can lock dpm_list_mtx before switching
> > interrupts off in kernel/power/main.c:suspend_enter() and analogously in
> > kernel/power/disk.c .
> 
> That's right.  And once interrupts are turned off you should unlock 
> dpm_list_mtx again, in case a noirq method wants to unregister a 
> device.

Why would a noirq method want to do that?  IMO, it's not a big deal if noirq
methods are not allowed to unregister devices.

> Hence my question: Is it legal to call unlock_mutex() while interrupts are
> disabled? 

Well, I suspect that will confuse lockdep quite a bit.  Otherwise, I don't see
a problem with it (it's just changing the value of a shared variable after
all).

Thanks,
Rafael
