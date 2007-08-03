Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbXHCRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbXHCRr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbXHCRrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:47:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43727 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761285AbXHCRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:47:20 -0400
Date: Fri, 3 Aug 2007 13:47:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jikos@jikos.cz>
cc: David Brownell <david-b@pacbell.net>,
       <linux-usb-devel@lists.sourceforge.net>, Dave Jones <davej@redhat.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend
 =?iso-8859-1?q?by=09default_on_certain_device?= classes
In-Reply-To: <Pine.LNX.4.64.0708031725520.26230@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0708031327470.3758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Jiri Kosina wrote:

> What I have been seeing with both these keyboards was: if connected to 
> UHCI controller, root hub not auto-suspended, as soon as they got 
> autosuspended, and keys were pressed on them rapidly, very often some 
> keypressess got lost. I didn't experience this on OHCI, but I remember 
> Alan saying that he triggered it on OHCI too, right?
> 
> Seemed like a timing issue - by lowering the polling timeout we were able 
> to make things much better, but that of course costs us more power etc. 
> and it's even not sure if it is an ultimate solution.

Jiri and I ran a few tests at OLS, and we each did additional testing
on our own.  We looked at a small selection of keyboards; the ones I
tested were by Apple and HP.  Some keyboards had embedded hubs and
others didn't.  Some of our testing was with the keyboard behind an
external hub.  Sometimes only the keyboard controller was suspended,
sometimes the controller and the embedded hub were, sometimes the
external hub and everything downstream of it were, and sometimes the
root hub was.  We tested with both UHCI and OHCI -- I may even have
done some tests with EHCI and a high-speed hub, I don't remember now.

The end result was that some scenarios worked more reliably than 
others.  There were lots of variables and it was hard to tie overall 
behavior with system settings.  It did seem that in situations where 
the topmost suspended device was plugged into a UHCI root hub, 
increasing the the root hub's polling rate helped.  But it didn't 
always help, and in any case we certainly don't want to change a kernel 
timer from 250 ms to 32 ms whenever a device is suspended!

The bad behavior we observed, as Jiri described, was that rapid typing 
on a suspended keyboard would often cause one or more of the keystrokes 
to be lost.  The probability of this happening varied with the 
circumstances, but I don't think I ever found a combination that was 
100% reliable.  It could well be a timing issue, or buffering -- 
there's no real way to know.

An additional drawback to autosuspend for keyboards is the fact that 
the NumLock, CapsLock, etc. LEDs go out.

We didn't test any mice (at least, I didn't).  However it has been
reported that while some suspended mice will send wakeup requests when
they are moved, others won't.  Certainly an optical mouse won't.

All in all, it appears that the simplest and most user-friendly
approach is just not to autosuspend keyboards and mice.

Alan Stern

