Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYLFVht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYLFVht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYLFVhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:37:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYLFVhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:37:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 22:36:43 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062236.44111.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Saturday, 6 of December 2008, Alan Stern wrote:
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> > On Saturday, 6 of December 2008, Linus Torvalds wrote:
> > > 
> > > On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > > > 
> > > > USB doesn't use that for PCI suspend-resume, it uses it for suspend-resume of
> > > > USB devices behind the controller.
> > > 
> > > Oh, in that case there are no PCI users of this at all, and what the PCI 
> > > driver does is immaterial ;)
> > > 
> > > > But then we will save the device's registers in the "sleeping" state. 
> > > 
> > > No no. The rule would be that a PCI driver - if it uses the new 
> > > infrastructure, which apparently nobody does _as_ a PCI driver - simply 
> > > would never do the whole "pci_set_power_state(PCI_D3hot)" etc crud AT ALL.
> > 
> > Now _that_ sounds good. :-)
> > 
> > > So a PCI driver would only do higher-level stuff in its suspend/resume 
> > > code. For example, a USB host controller would initiate the USB bus level 
> > > stuff, and likely just stop the controller (not suspend it - just stop 
> > > it).
> > 
> > I like this idea very much.
> 
> Rafael, I'd be happy to help with fixing up the USB PCI PM code.  At
> this point I'm not sure exactly what's needed, though.  For instance,
> is there any compelling reason to switch over to the new dev_pm_ops
> approach?

Certainly not at the moment.  There will be a reason some time after .29.

That said, it apparently is possible to clean up the resume callbacks of PCI
USB controllers, as mentioned here: http://lkml.org/lkml/2008/12/6/38

> And what should the correct sequence of calls be?

Well, that's something I'm not exactly sure about myself.  Surely it seems
reasonable to call pci_restore_state() with interrupts disabled and do the rest
of resume after that.  Also, I think that the core could execute things like
pci_enable_device() during resume and pci_set_power_state()/pci_enable_wake()
on suspend so that the drivers didn't have to.  This way we could reduce code
duplication quite a bit.

However, I'm not quite sure about the freeing and requesting IRQs during
suspend and resume.  Many drivers do that, many others don't.  Still,
apparently some drivers don't work correctly after resume if this is not done.
So, if that should generally be done, I also think that moving it to the core
might be a good idea.

Thanks,
Rafael
