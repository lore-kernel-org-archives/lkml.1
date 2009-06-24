Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZFXVXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZFXVXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZFXVWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:22:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZFXVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:22:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM of I/O devices
Date: Wed, 24 Jun 2009 23:23:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906241604510.22054-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906241604510.22054-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242323.15409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Alan Stern wrote:
> On Wed, 24 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > The difficulty is that some USB interface drivers require remote wakeup
> > > to be enabled while their interfaces are suspended.  But remote wakeup
> > > is a global setting; it doesn't take effect until the entire physical
> > > device is suspended.  (To put it another way, USB has no notion of
> > > suspending interfaces.)  This means we must not allow these interfaces
> > > to be suspended before the whole device is.  But the whole device is
> > > the parent of the interfaces -- if we can't suspend the children before
> > > suspending the parent then we're stuck.
> > 
> > Not if we use the power.ignore_children flag on the parent.
> > 
> > > Clearly this is something the USB stack has to deal with; it shouldn't
> > > affect the general PM framework.  However the only solution I can think
> > > of involves subverting the framework, which isn't very nice.  The idea
> > > is to ignore runtime_suspend callbacks for these interface drivers;
> > > allow them to keep on running even though the PM core thinks they are
> > > suspended.  Then suspend and resume them as part of the callbacks for
> > > the entire device.  (For interface drivers that don't require remote
> > > wakeup there is no problem; it doesn't matter when they get suspended.)
> > > 
> > > This will work, but it's a hack.  Does anybody have a better idea?
> > 
> > Well, as I said above, you can set power.ignore_children on the device
> > and then it can be suspended even if the interfaces aren't.
> 
> Hmm.  The hard part still remains: to make sure that the interfaces 
> don't get suspended without the device also getting suspended.
> 
> I suppose we could attack this by making the device do a runtime_get on
> each of the interfaces, which would be released in the device's
> runtime_suspend method.  But then conversely, each interface driver
> would have to do its gets and puts on the _device's_ resume_counter.  
> If they used the interface counters then the values would never go to 0
> and so nothing would ever be suspended.
> 
> You've got to admit, this does sound rather bizarre.  :-)

Yeah.

> But it ought to work...

Alternatively, there can be a USB-specific flag for the interfaces meaning
"device suspended" if set.  Then, the device driver will have to set that flag
for all the interfaces so that they can be suspended and the interface drivers
as well as the device driver will use the device's resume counter to block
suspends of the whole thing.

Best,
Rafael
