Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYEGNDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYEGNDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYEGNDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:03:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:57302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYEGNDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:03:36 -0400
Date: Wed, 7 May 2008 15:05:50 +0200
From: Holger Macht <hmacht@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080507130550.GA3491@homac>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506151846.GA22828@khazad-dum.debian.net> <1210122279.27316.2.camel@sli10-desk.sh.intel.com> <20080507011354.GA8163@khazad-dum.debian.net> <1210123658.30944.6.camel@sli10-desk.sh.intel.com> <20080507123715.GA19475@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507123715.GA19475@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07. May - 09:37:15, Henrique de Moraes Holschuh wrote:
> On Wed, 07 May 2008, Shaohua Li wrote:
> > On Tue, 2008-05-06 at 22:13 -0300, Henrique de Moraes Holschuh wrote:
> > > On Wed, 07 May 2008, Shaohua Li wrote:
> > > > On Tue, 2008-05-06 at 12:18 -0300, Henrique de Moraes Holschuh wrote:
> > > > > On Tue, 06 May 2008, Shaohua Li wrote:
> > > > > > The bay driver is duplicated with libata, I thought we should delete it.
> > > > > > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> > > > > 
> > > > > The bay driver is currently useless, BUT it should handle a lot of stuff
> > > > > libata won't, such as bay batteries, bay floppies, and anything else in
> > > > > a bay that is not a hard disk.
> > > > > 
> > > > > The fact that the driver currently looks only after disks is just a bug.
> > > > > It should, in fact, bind to any ejectable device not already handled by
> > > > > a different driver.
> > > > Isn't this the job of acpi dock driver?
> > > 
> > > No, but I actually fail to see why do we even care about the difference
> > > from a dock to a bay.  Dock *could* be made to handle both.
> > It appears some systems haven't a dock but a bay. In a thinkpad, you
> > could hotplug cdrom/battery/harddisk in the slot of cdrom, but it's not
> > a dock. libata should handle it well (but it doesn't handle _EJ0
> > currently, I have a patch in above bugzilla).
> > 
> > But you are right, acpi dock driver should be extended to support bay.
> > I'll give it a try.
> 
> Thanks.  Here's what I know about bays (and docks).  I expect you know
> most, if not all of what I'll write, but what the heck, it is good to
> have these things in the clear :-)
> 
> 
> 1. Bay and dock notifications are NOT standard.  You need to feed them
> to a notification chain AND generate uevents, and expect a reply before
> you can actually do something.
> 
> There are two big classes of machines here:
> 
>   1a) those which notify you that the bay/dock is BEING ejected
>   1b) those which notify you the user wants to eject, and wait for
>       a command to power down the bay/dock and let the user know
>       she can remove the device.
> 
> Thinkpads are on the 1b class.  See (4) below.
> 
> 2. Even if a bay can take different types of devices, the same bay may
> appear as a number of different EJ0 handlers.  In that case, the
> firmware is to know which handler to use based on which type of device
> is inside the bay.  Thinkpads do this.
> 
> 3. IMO, "eject" really should be a device property, and not something
> tied to a bay.  For docks, this is a lot more difficult to do right,
> since a dock has multiple devices (and usually at least one BUS, and
> often more than one. Thinkpads have PCI, PCIe and USB buses through the
> dock) behind it, so it is probably best to have dock ejects as a
> property of a "dock" platform device, and bay ejects as a property of
> whatever device is inside the bay.  This should be an userspace AND
> kernel API.
> 
> 4. bay ejection notifications can take two forms (see (1) above):
> 
>   4a) device removal (we already have this)
>   4b) device removal REQUEST
> 
> Thinkpads should do 4b, then IF AND ONLY IF the user or a kernel
> platform driver uses (3) to command the ejection, they do 4a.
> 
> Some laptops will just do 4a, doing (3) before the user yanks the device
> requires the user to not be an yahoo (i.e. just like USB pen-drives).
> 
> And for laptops that do 4b for docks, one should probably replicate the
> "request undock" notification for every device inside the dock, and not
> just for the dock device.
> 
> What value you get from an ACPI NOTIFY for 4a or 4b is NOT standard,
> you will need a platform device OR userspace to interpret it for you.
> 
> 5. bay and dock notifications (at least on thinkpads) are issued to the
> ACPI node of the real device, not to the APCI EJ0 node.  This is what is
> causing issues between bay and libata (both want to register a notify
> hook to the same node, and ACPICA allows only one driver per node).
> 
> I am not really sure the "ACPI driver model" is the right way to tie bay
> functionality to the system.  A hook and notifier system inside ACPICA
> to implement it as a service of the ACPI sybsystem might work better.
> 

Please also consider the following thread:

  http://www.spinics.net/lists/linux-ide/msg22927.html

Regards,
	Holger
