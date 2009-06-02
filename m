Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbZFBV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbZFBV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFBV0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:26:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZFBV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:26:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] usb: avoid PM error messages during resume if a device was disconnected
Date: Tue, 2 Jun 2009 23:26:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0903241004160.3162-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0903241004160.3162-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906022326.34491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, sorry for the delayed response.  Frans has just reminded me about this
thread.

On Tuesday 24 March 2009, Alan Stern wrote:
> On Mon, 23 Mar 2009, Frans Pop wrote:
> 
> > > Or do you think maybe it would be better to move this test up into the
> > > PM core?  After all, other subsystems will face the same issue.  I
> > > think that would be the best approach.  Yes?
> > 
> > I did look at that option, but implementing it in the USB subsystem seemed
> > more logical to me, for example as other subsystems possibly would want to
> > display an info message.
> 
> They still can...
> 
> > And is -ENODEV safe to ignore in all cases? Would there be other errors that
> > should be ignored too?
> 
> In general, the PM core ignores _all_ errors during resume -- in the
> sense that it doesn't try to recover from them or do anything to handle
> them.  All it does is put a message in the log.
> 
> So your question becomes: For which errors should a message be added to 
> the system log?  The most logical answer seems to be that we want an 
> error message whenever something bad or unexpected occurs.
> 
> Removal of a hot-unpluggable device isn't really bad or unexpected.  
> Removal of a non-hot-unpluggable device might be bad, but on the other
> hand the system isn't really "hot" while it is suspended.  Besides, the
> appropriate subsystem can print an error message.  Furthermore the
> kernel can't easily tell which devices are hot-unpluggable and which
> aren't.
> 
> Anything else amounts to failure resuming a device that still exists.  
> As such, it probably deserves an error message.

Returning 0 from usb_external_resume_device() if the device is not present
any more doesn't seem wrong.  It's not really an error condition, IMO, because
it's rather normal that the devices may be removed while suspended.

OTOH, I don't think we can ignore -ENODEV universally in the core, because
its meaning may depend on the bus type.  For example, for PCI it sometimes
means a hardware problem has occured (other than the device being not present
any more).

> > if Rafael would be happy with a generic test for -ENODEV, it could be done.
> > If not, maybe some other special error code would need to be used but then
> > you'd still need to test in the subsystem to set that error.
> > Disadvantage is also that it would make resume_device() and related PM
> > driver core functions quite a bit less clean than they currently are.
> > 
> > Implementing the test in USB was quite a bit simpler (for me at least ;-)
> 
> We should get Rafael's opinion.

I'd vote in favor of the Frans' patch, at least for now.

So, Frans, please resubmit with the changelog modified as requested by Alan.

Best,
Rafael
