Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbZHNUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbZHNUEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbZHNUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:04:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbZHNUEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:04:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Date: Fri, 14 Aug 2009 22:05:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0908141032070.2987-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908141032070.2987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908142205.20093.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Alan Stern wrote:
> On Thu, 13 Aug 2009, Matthew Garrett wrote:
> 
> > On Thu, Aug 13, 2009 at 11:22:44AM -0400, Alan Stern wrote:
> >
> > > You have to call the HCD's pci_suspend method!  Not to mention calling
> > > synchronize_irq and all the other stuff in hcd_pci_suspend and
> > > hcd_pci_suspend_noirq.
> >
> > The bus level code does this, assuming that the driver-level code
> > doesn't return an error.
> 
> So it does; my mistake.
> 
> 
> On Fri, 14 Aug 2009, Matthew Garrett wrote:
> 
> > On Thu, Aug 13, 2009 at 10:47:01PM +0100, Matthew Garrett wrote:
> > 
> > > Ugh. I'd really prefer us to assume that drivers are able to cope unless 
> > > proven otherwise. Userspace policy makes sense where we don't have any 
> > > idea whether something will work or not, but I'd really expect that most 
> > > PCI drivers will either cope (in which case they'll have enabling code) 
> > > or won't (in which case they won't). Why would we want userspace to 
> > > influence this?
> > 
> > Though, thinking about it, you're right that setting this does override 
> > user policy. I think we need an additional flag to indicate that the 
> > device supports runtime wakeup and test that as well when doing 
> > device_may_wakeup().
> 
> You are suggesting separate flag sets for system-wide wakeup and
> runtime wakeup?  I don't disagree, but implementing them will be
> problematical.
> 
> That's because it's not always possible to change a device's wakeup 
> setting while it is suspended.  Thus if a device was runtime suspended 
> with wakeup enabled, and then we want to do a system sleep and change 
> the device's wakeup setting to disabled, we would have to wake the 
> device back up in order to do it.

Well, sometimes the user may want a device to be power managed at run time
and not to be able to wake up the system from sleep states.  For example,
I'd like the USB controller in my box to be suspended at run time whenever it's
not used, but surely I wouldn't like it to do system-wide wakeup, because it
does that when I move the mouse which is a cordless one.  Simply turning the
mouse on causes the system to wake up. :-)

So, I don't think we have a choice here.  If the user forbids the device to
wake up the system from sleep states, we have to do what he wants, even if
that means the devices has to be resumed before putting the system into a
sleep state.

Why don't we add a flag indicating whether or not the device is allowed to
be power managed at run time, something like runtime_forbidden, that the
user space will be able to set through sysfs?

If the user space does that, we can't power manage the device at run time,
so it can't do runtime wakeup as well.  Otherwise, the device is power
manageable at run time, which implies runtime wakeup if supported.

Thanks,
Rafael
