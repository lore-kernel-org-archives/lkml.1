Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXE1Him@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXE1Him (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXE1Hif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:38:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXE1Hie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:38:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 09:44:00 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272345.04518.rjw@sisk.pl> <20070527220158.GB22687@srcf.ucam.org>
In-Reply-To: <20070527220158.GB22687@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280944.01410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 00:01, Matthew Garrett wrote:
> On Sun, May 27, 2007 at 11:45:03PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 27 May 2007 22:49, Matthew Garrett wrote:
> > > If we remove process freezing in STR, this should just work[1] without the
> > > need to complicate things. 
> > 
> > Under the (optimistic, IMO) assumption that the relevant user space task won't
> > block on I/O with a suspended device involved or something like this.
> 
> Yeah, I forgot the footnote that was going to mention that. Clearly 
> there are issues if this is on some block device that hasn't been 
> resumed yet.

Or worse.  Suppose, for example, that the device which needs the firmware
uploaded is your network adapter and the firmware file is on NFS.

I don't think there's a solution to the "requesting firmware from .resume()"
problem other than copying the firmware into memory _before_ the suspend
and using this copy to upload the firmware in .resume().

> > BTW, I know of two subsystems that want their kernel threads to be frozen for
> > synchronization purposes.  Please see these messages:
> > 
> > 1) https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012592.html
> > (plus follow up)
> > 
> > 2) http://marc.info/?l=linux-kernel&m=117919066830575&w=2
> 
> I'm not entirely sold on this. The issue is that there's the possibility 
> of races during suspend/resume?

Yes.

> It sounds like that should be implemented in the driver, rather than
> depending on a side-effect of process freezing. Otherwise there's no way 
> of selectively suspending that device.

That's true, but we've been using the freezer for so long that at least some
drivers started to rely on it being used.  That's the reason, IMO, why we can't
just drop the freezer right now.

It can be _replaced_ by some other synchronization mechanisms, but not just
dropped.  Moreover, I think that to implement such mechanisms within device
drivers we should first stop using the same .suspend() and .resume() routines
for both hibernation and suspend.

This is the plan right now (ie. to stop using .suspend() and .resume() for
hibernation) and when we're done with that (yes, it'll take some time), then we
can think of dropping the freezer entirely from the suspend code path.

> > Besides, there's the hibernation that needs to freeze tasks for another reason,
> > so it needs some way to ensure that drivers won't request firmware while
> > the user land is frozen.
> 
> I agree that that's an issue right now, but I think we should see if 
> this is repairable without just breaking those drivers.

Well, I don't think we're breaking the drivers.

> One option would be to defer resuming them until userspace is alive again -
> that would be no worse than the suspend to RAM case without process freezing.

Please consider the example with a firmware on NFS. :-)

I think the _solution_ would be to fix the drivers.  The other approaches are
just workarounds, including the $subject patch.

Greetings,
Rafael
