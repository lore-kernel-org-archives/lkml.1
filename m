Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZFICt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZFICt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZFICtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:49:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60233 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752987AbZFICtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:49:19 -0400
Date: Mon, 8 Jun 2009 22:49:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM:
 Rearrange core suspend code)
In-Reply-To: <200906082331.58933.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Rafael J. Wysocki wrote:

> > Use of the RPM_UNKNOWN state isn't good.  A bus may have valid reasons 
> > of its own for not carrying out an autosuspend.  When this happens the 
> > device's state isn't unknown.
> 
> I'm not sure what you mean exactly.
> 
> If ->autosuspend() fails, the device power state may be known, but the core
> can't be sure if the device is active.  This information is available to the
> driver and/or the bus type, which should change the status to whatever is
> appropriate.

But no matter what the driver or bus type sets the state to, your 
pm_autosuspend() will change it to one of RPM_UNKNOWN or RPM_SUSPENDED.  
Neither might be right.

> The name of this constant may be confusing, but I didn't have any better ideas.

It's not clear what RPM_ACTIVE, RPM_IDLE, and RPM_SUSPENDED are 
supposed to mean; this should be documented in the code.  Also, why 
isn't there RPM_RESUMING?

By the way, a legitimate reason for aborting an autosuspend is if the
device's driver requires remote wakeup to be enabled during suspend but
the user has disabled it.

> > The scheme doesn't include any mechanism for communicating runtime
> > power information up the device tree.  When a device is autosuspended,
> > its parent's driver should be told so that the driver can consider
> > autosuspending the parent.
> 
> I thought the bus type's ->autosuspend() callback could take care of this.

Shouldn't this happen after the device's state has changed to 
RPM_SUSPENDED?  That's not until after the callback returns.

> > There should be a sysfs interface (like the one in USB) to allow
> > userspace to prevent a device from being autosuspended -- and perhaps
> > also to force it to be suspended.
> 
> To prevent a device from being suspended - yes.  To force it to stay suspended
> - I'm not sure.

I'm not sure either.  Oliver Neukum requested it originally and it has
been useful for debugging, but I haven't seen many places where it
would come in useful in practice.

> > What about devices that have more than two runtime power states?  For
> > example, you can't squeeze PCI's {D0,D1,D2,D3hot} range into {running,
> > suspended}.
> 
> That has to be bus type-specific.
> 
> In the case of PCI all of the low power states (D1-D3) are in fact substates of
> "suspended", because we generally need to quiesce the device before putting
> it into any of these states.
> 
> I'm not sure if we can introduce more "levels of suspension", so to speak, at
> the core level, but in any case we can easily distinguish between "device
> quiesced and in a low power state" and "device fully active".
> 
> So, in this picture the device is "suspended" from the core's point of view
> once it's bus type's ->autosuspend() callback has been successfully executed. 

This too should be documented in the code.  Or in a Documentation file.

Alan Stern

