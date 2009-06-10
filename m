Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbZFJXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbZFJXmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbZFJXmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:42:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55536 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757825AbZFJXmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:42:07 -0400
Date: Wed, 10 Jun 2009 19:42:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906102331.14267.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906101933220.29717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Rafael J. Wysocki wrote:

> > You know, it doesn't make any sense to have a suspend and a resume 
> > both pending at the same time.
> >
> > So you could add only a delayed_work structure and use its embedded
> > work_struct for resume requests.
> 
> I thought so too, but I was wrong. ;-)
> 
> If resume is requested while the suspend hasn't completed yet, we should
> queue it (it's totally valid to request a suspending device to resume IMO), but
> the delayed work is still being used by the workqueue code, so we can't modify
> it.

Where is the delayed work still being used?  There's even a comment in 
run_workqueue() that says a work_struct can be freed by the function it 
calls.

> > We might want to do a runtime suspend even if the device's children
> > aren't already suspended.  For example, you could suspend a link while
> > leaving the device on the other end of the link at full power --
> > especially if powering down the device is slow but changing the link's
> > power level is fast.
> 
> Well, this means that the dependencies between devices in the device tree are
> pretty much useless for the run-time PM as far as the core is concerned.  In
> which case, why did you mention them at all?

The dependencies aren't totally useless.  It's still true that before
you resume a device, you have to autoresume its parent.  And it's still
true that when you suspend a device, the parent should be given a
chance to autosuspend.

I guess the real point is that the decision about whether all children
must be suspended should be made by the driver, not the PM core.

> > I haven't checked the details of the code yet.  More later...

One more thought...  The autosuspend and autoresume callbacks need to 
be mutually exclusive with probe and remove.  So somehow the driver 
core will need to block runtime PM calls.

It might also be nice to make sure that the driver core autoresumes a 
device before probing it and autosuspends a device (after some 
reasonable delay) after unbinding its driver.

Alan Stern

