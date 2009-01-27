Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZA0PxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZA0PxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZA0PxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:53:05 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3850 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZA0PxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:53:01 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: How should I handle device with two PNP-BIOS ids?
Date: Tue, 27 Jan 2009 08:52:51 -0700
User-Agent: KMail/1.9.10
Cc: Adam Belay <abelay@mit.edu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <497d80991ef709.35340258@wp.pl> <200901261513.32348.bjorn.helgaas@hp.com> <20090127094255.fc038987.krzysztof.h1@wp.pl>
In-Reply-To: <20090127094255.fc038987.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901270852.52153.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 01:42:55 am Krzysztof Helt wrote:
> On Mon, 26 Jan 2009 15:13:31 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > Systems with the old chip probably report the device with a single
> > PNP ID.  For PNPBIOS, that would be the "device product identifier."
> > For ACPI, it would be the _HID.
> > 
> > Systems with the new chip should report both PNP IDs.  The PNPBIOS
> > device product identifier or the ACPI _HID should be the new ID, and
> > the older ID for backward compatibility should be reported in the
> > PNPBIOS "compatible device identifiers" list or the ACPI _CID.
> > 
> > The driver would list both IDs in the pnp_device_id table, and it
> > looks like the driver probe routine gets called with the ID that
> > matched.
> > 
> > I don't see any drivers that actually do this, but I think the
> > probe routine should be able to look at the ID that matched and
> > determine whether the additional I/O range is present.
> 
> The laptop in question is the Dell Latitude CPi and it does not
> have ACPI only the PnP BIOS. 
> The both ids are reported as unrelated (two separate nodes in 
> the /sys/bus/pnp/).

Oh.  That sounds like a BIOS bug.  If there's only one actual
chip, the BIOS should not report it as two separate devices.
I guess it might report two devices if only one of them is
enabled at a time.  In that case, there might be a BIOS setup
switch to toggle between them.

Can you turn on CONFIG_PNP_DEBUG_MESSAGES and boot with the
pnp.debug kernel parameter?  Then collect the dmesg log and
the output of "grep . /sys/devices/pnp*/*/*".

> I don't know how to set up the "compatible device  
> identifiers" list. It is not defined in the include/linux/pnp.h.
> If I know that I will test this.

The compatible device identifiers list is built by the kernel
based on the information from the BIOS.  Drivers don't have to
worry about it.

> > Oops, looking at match_device() in drivers/pnp/driver.c, I think
> > we look at all the device IDs supported by the driver, but we only
> > look at the first ID associated with the device.  That means an old
> > driver that only knows about the old device ID would fail to claim
> > a new device (the new device will have the new ID first and old IDs
> > in the compatibility list).  That looks like a bug in the PNP core --
> > the old driver should be able to claim any new compatible devices.
> > 
> > Let me know if you think you're seeing this bug, and I'll look into
> > it some more.
> 
> Currently, I iterate over pnpbios_protocol to find out if the second 
> id exists. It is not elegant but works.

Can you point me to the driver?

If this is a BIOS defect, we might be able to write a quirk to work
around it so the driver doesn't have to get messy.

Bjorn
