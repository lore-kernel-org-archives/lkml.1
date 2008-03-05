Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYCERET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYCERET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbYCEREF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:04:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60559 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757682AbYCEREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:04:04 -0500
Date: Wed, 5 Mar 2008 12:04:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <200803042015.43165.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803051145080.4750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:

> On Thursday 21 February 2008, Alan Stern wrote:
> >
> > Okay, so this isn't as bad as it seemed.  I don't have a copy of your 
> > most recent patch, but it seems clear that the watchdog routine must:
> > 
> > 	First remove the circumstances that would cause the controller 
> > 	to set IAA.  I guess that means clearing IAAD; it's not
> > 	entirely clear from the spec whether this will do what we 
> > 	want.
> 
> The spec says that IAAD gets cleared when IAA is set.  Clearing
> IAAD should strictly speaking never be needed if IAA is seen ...
> but my latest patch will do so (on both watchdog and IRQ paths)
> when it's set.  Call it paranoia.

This seems like a good subject to be paranoid about.  :-)

> > 	Then clear IAA (if it happens to be set).
> 
> Yes; I re-ordered that to read IAAD first, to give more useful
> diagnostics in case of an extremely belated trigger of IAA
> that follows reading IAAD.
> 
>  
> > This is the only way to avoid the race, and I know that my original
> > version of the routine does these steps in the wrong order (if at all).  
> > That should be fixed.
> 
> How does the appended patch look?

It looks very good.  Do you think there should be an "else" clause for 
the "if ((status & STS_IAA) || !(cmd & CMD_IAAD))" test?  That's the 
pathway one would observe with a controller that implements IAA very 
slowly or not at all.  There doesn't seem to be anything more the HCD 
can do about it, but you could print a log message.

> > Given sufficiently bizarre hardware we can't be 
> > certain that things won't still go wrong on occasion, but this is the
> > best we can do for now -- weird hardware can be handled as it arises.
> 
> The appended patch does include a bit of paranoia around IAA and IAAD;
> I figure it can't hurt, although at this point I have no particular
> reason to believe anyone except VIA has bugs in those areas.

There's still Bugzilla #8692.  That one appears to be an individual
hardware failure, though, not a systematic bug.

> > The other change to make (which you have already anticipated) is to 
> > guard against ehci->reclaim == NULL in end_unlink_async().  There's no 
> > real need for a warning or stack dump; it should just return silently 
> > when this happens.  If there is a warning, maybe it should be placed at 
> > the site of the caller (for example, in ehci_irq() when STS_IAA is 
> > detected).
> 
> Yeah, that seems like a better place to do it.  All the other callers
> guarantee ehci->reclaim is non-null before calling it.  The fact that
> it happens in this case suggests IAAD and/or IAAD didn't get cleared
> properly.

There is one place where ehci-hcd.c doesn't make that guarantee:

@@ -757,7 +757,7 @@ static void unlink_async (struct ehci_hcd *eh
 static void unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
 	/* failfast */
-	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state))
+	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) && ehci->reclaim)
 		end_unlink_async(ehci);
 
 	/* if it's not linked then there's nothing to do */

But if you take out the WARN_ON at the start of end_unlink_async then 
this isn't needed.

Alan Stern

