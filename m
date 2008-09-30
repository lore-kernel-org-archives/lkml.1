Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYI3A4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYI3A4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYI3A4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:56:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:57838 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYI3Az7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vADOeV4jdMHVd9kjPhMFh0vVxBkUugedm1Xn4+Jn6ymEIZDM0znTX49SVkmPmUN8lK
         QRGHv2LdVbu3IzLWkLsAh6SAAn142MAG9wM/XjCCvSZIuY6AK/tGhOh56vEIhuwXu3Nz
         tbxy9P8MM9FbSCFKU8LLO/3bGe85HkP6qowpQ=
Subject: Re: Put unused PCI devices in D3
From: "Jeffrey W. Baker" <jwbaker@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080930000923.GA29775@srcf.ucam.org>
References: <1222719064.19236.129.camel@squeak.gghcwest.com>
	 <20080930000923.GA29775@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 17:55:47 -0700
Message-Id: <1222736147.21516.12.camel@stinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 01:09 +0100, Matthew Garrett wrote: 
> On Mon, Sep 29, 2008 at 01:11:03PM -0700, Jeffrey W. Baker wrote:
> 
> > Currently it looks to me from browsing the code that D3 is only used in
> > Linux when the whole machine is headed for S3, and the drivers are asked
> > to suspend.  I think the drivers should be able to enter D3 in other
> > circumstances:
> > 
> > * During pci_unregister_driver ... i.e. on module unload
> 
> The fact that Linux isn't using a device doesn't inherently mean that 
> the system isn't using it. For example, the smbus controller will 
> probably still be used by ACPI even if there's no Linux driver loaded.

True.  On my hardware, the smbus controller doesn't advertise power
management capabilities, so this would not be a problem. 

> > * When a network interface is downed
> 
> Yes. Drivers are moving towards this model.

Very cool.  netbsd-current apparently  has this already (and a
kernel-wide topological representation of PCI power management
generally).

> > * If the device is a bridge or hub with no downstream device
> 
> Potential problems with hotplugging? But sure, this kind of thing is 
> being implemented in USB and SCSI.
> 
> > * Whenever userspace requests D3 via sysfs
> 
> This functionality was explicitly removed a few years back.

I sure would like to have it back, if only just for experimentation.
Right now, I don't even know what kind of power savings could be
achieved from D3, I'm just speculating.  As you rightfully point out,
it's possible that the driver could put the device into an ultra-low
power saving state while still operating in D0, and that D3 savings
would be negligible.

> > So, what fundamental problem prevents me from, for example, calling
> > pci_set_power_state() from ohci1394's __exit?
> 
> Nothing I'm aware of. It sounds pretty safe in that case. But that would 
> require you to load and unload the driver - better to have the driver 
> loaded the entire time and make sure it does as much runtime power 
> management as possible. I don't know enough about the firewire OHCI 
> hardware, but can you power down most of the chip and still get hotplug 
> events?

No, you couldn't, but that isn't really the point.  If I have my laptop
on a transoceanic flight it may be useful for me to be able to set a
power policy turning off all the extraneous junk on my machine, because
I know /a priori/ that no hotplug events will happen.  There's no way
the kernel could know that, but userspace can tell the kernel to turn
off an unneeded device.

Think of it this way.  Putting the machine into S3 prevents it from
checking my email, but the capability exists.  All I want to do is
extend that concept to the PCI device level.

Anyway, ohci1394 is pretty easy to understand, and it's not likely to
hose up the system too badly, so I'm going to perform surgery there.

-jwb

