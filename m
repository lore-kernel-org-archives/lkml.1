Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbXGCHkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbXGCHkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXGCHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:40:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:60310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbXGCHkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:40:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [PATCH 0/3] ACPI autoloading
Date: Tue, 3 Jul 2007 03:40:30 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Kay Sievers <kasievers@suse.de>
References: <1182111724.4204.0.camel@noname>
In-Reply-To: <1182111724.4204.0.camel@noname>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030340.31094.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A) Cannot pass acpi_device_id through ops.add (probe equivalent func)
> ---------------------------------------------------------------------
> 
> int acpi_match_device_ids(..)
> should be:
> const acpi_device_id *acpi_match_device_ids
> and the matching device id should get passed to the acpi driver's .add
> function.
> This would ease up the code in the ACPI driver a lot (e.g. see button.c,
> it is compared again which device (HID) has been found. Theoretically
> the drivers also needs to check CIDs...).
> 
> The problem is that in scan.c ACPI driver is abstracted to use .match
> and .probe "struct bus_type" functions and I have no idea how the
> matching acpi_device_id should get passed or stored from
> acpi_match_device_ids (.match) to ops.add (invoked in .probe).
> Currently:
>         kernel_ulong_t driver_data;
> of acpi_device_id got added, but is not used at all atm.
>
> B) Thermal module always gets loaded
> ------------------------------------
> 
> This is because _TZ_ (scope?!?) always gets added, but is declared as a
> device or at least pops up as a thermal device.
> This is in drivers/acpi/utilities/utglobal.c:
> 
> /*
>  * Predefined ACPI Names (Built-in to the Interpreter)
>  *
>  * NOTES:
>  * 1) _SB_ is defined to be a device to allow \_SB_._INI to be run
>  *    during the initialization sequence.
>  * 2) _TZ_ is defined to be a thermal zone in order to allow ASL code to
>  *    perform a Notify() operation on it.
>  */
> 
> Any idea how to get rid of that is very welcome.
> Is this to be able to process buggy ASL code of this kind?:
> "Notify ("_TZ_", 0x80)"
> While _TZ_ is not a real device, but a scope operator and gets
> statically declared as a device here to solve such things?

ThermalZone objects hang under _TZ, whether TZ it be global, or under _SB
I would think that if there are no ThermalZone objects,
then we'd not need to bind the thermal driver.

However, this would be a custom binding method (like acpi video.c)
rather than a HID based one.

I'm really not sure about the _TZ_ syntax -- we'll have to ask Bob
where that came from when he returns -- but I don't think it matters
for the issue at hand.

> C) Renaming/Unifying of HID strings
> -----------------------------------
> 
> This shouldn't be a problem. Consequence is that the new ACPI sysfs
> structure will show other names, but as it got introduced recently this
> shouldn't hurt anyone?

I agree that it is still new and that it is unlikely that a re-name
now would be a significant compatibility issue.

> For better readability we could map all HIDs to a device name through a
> HID <-> Device Name - enum and table. And then export "battery" again
> through /sys instead of "PNP0C0A".
> This was a bit mixed up. If, this should get implemented soon as the
> sysfs structure should not get altered that often...
> If wanted, I can send an on top patch later...

We've had this discussion before.

I'm inclined to keep the kernel as simple as possible, and let
some user-space thingie look up standard strings in some user-space table.
I don't want to get into the game of trying to make sysfs
so user-friendly, that a kernel re-build is necessary to add/translate
a new string...

that said, if we have to _invent_ a new string, it might as well
be something meaningful to a human.

> D) Why renaming struct acpi_device_id to struct __acpi_device_id
> 
> Not a problem, just for understanding why I have done this:
> struct acpi_device_id already exists in ACPICA. The module aliasing
> interface requires that struct "SUBSYSTEM"_device_id is used as name.
> This is not that obvious (include/linux/module.h):
> #define MODULE_GENERIC_TABLE(gtype,name) and
> #define MODULE_DEVICE_TABLE(type,name)

it is really irritating to end up with two nearly identical definitions.
it is also irritating to diverge from ACPICA for syntax reasons.

I don't really have a better idea -- though I'd be inclined to call it
acpica_device_id instead of __acpi_device_id if we're stuck with that route.

-Len

