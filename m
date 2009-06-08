Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZFHUfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZFHUfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFHUfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:35:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37164 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753569AbZFHUfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:35:32 -0400
Date: Mon, 8 Jun 2009 16:35:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM:
 Rearrange core suspend code)
In-Reply-To: <200906081329.27047.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906081626120.13888-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Rafael J. Wysocki wrote:

> On Monday 08 June 2009, Oliver Neukum wrote:
> > Am Sonntag, 7. Juni 2009 23:46:59 schrieb Rafael J. Wysocki:
> > > It may be necessary to resume a device synchronously, but I'm still
> > > thinking how to implement that.
> > 
> > This will absolutely be the default. You resume a device because you want
> > it to do something now. It seems to me that you making your problem worse
> > by using a spinlock as a lock. A mutex would make it easier.
> 
> But I need to be able to call __pm_schedule_resume() (at least) from interrupt
> context and I can't use a mutex from there.  Otherwise I'd have used a mutex. :-)
> 
> Anyway, below is a version with synchronous resume.

There are a few things here which need further thought:

The implementation of pm_lock_device() assumes it will never be called 
with interrupts disabled.  This is a bad assumption.

Use of the RPM_UNKNOWN state isn't good.  A bus may have valid reasons 
of its own for not carrying out an autosuspend.  When this happens the 
device's state isn't unknown.

The scheme doesn't include any mechanism for communicating runtime
power information up the device tree.  When a device is autosuspended,
its parent's driver should be told so that the driver can consider
autosuspending the parent.  Likewise, if we want to autoresume a device 
below an autosuspended parent, the parent should be autoresumed first.  
Did you want to make the bus subsystem responsible for all of this?  
What about device's whose parent belongs to a different subsystem?

There should be a sysfs interface (like the one in USB) to allow
userspace to prevent a device from being autosuspended -- and perhaps
also to force it to be suspended.

What about devices that have more than two runtime power states?  For
example, you can't squeeze PCI's {D0,D1,D2,D3hot} range into {running,
suspended}.

That's what I come up with on a first reading.  There may be more later 
on...  :-)

Alan Stern

