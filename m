Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXGMRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXGMRK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXGMRKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:10:19 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:48947 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXGMRKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:10:17 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH - 0/2] Identify native drivers and ACPI subsystem accessing the same resources
Date: Fri, 13 Jul 2007 10:56:45 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
References: <1184331492.3960.100.camel@d88.suse.de>
In-Reply-To: <1184331492.3960.100.camel@d88.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131056.46193.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007 06:58:12 am Thomas Renninger wrote:
> This patch should:
> a) Identify machines where potentially ACPI interference can happen and
>    tell the user which legacy drivers are affected.
> b) Identify drivers/HW where we might need an ACPI driver in future
> c) If it works out (if not too much important drivers are affected)
>    enforce that native, non-ACPI drivers using the same IO/System
>    memory addresses as declared in ACPI namespace fail to load.

I like some of the ideas here, but as you say, there are some
issues to work out.

> There are two kind of IO/System memory declarations in ACPI ASL
> language: general variables and device specific resource
> declarations.
> The latter is already handled by pnpacpi and resources get requested 
> from pnpacpi already. These resources can (with this patch) partly
> already be requested by the general ACPI declarations and this patch
> should handle this gracefully.

The PNP core does not request resources for devices that are active
at boot.  Those resources currently don't get requested until a driver
claims the device.  I think this is a bug that we should fix.

> ACPI drivers (e.g. pnpacpi and others) are allowed to request these
> resources (marked IORESOURCE_SHARED) through acpi_request_region().

I'm not a fan of IORESOURCE_SHARED.  I think that will make people
think it's acceptable to share a device between several drivers.  It
would be better to keep the ugliness of forcibly taking over a resource,
just as an incentive to clean up the drivers.

> Here two examples of not nice things that could happen with lax option:
> 
>  a) legacy drivers (in this case arch/x86_64/setup.c) request resources
>     before ACPI variables (shared resources) are requested:
> (/proc/ioports):
> 0080-008f : dma page reg
>   0080-0080 : ACPI DEB0*
>     In this case it's working as "dma page reg" includes the ACPI 
>     SystemIO variable's space. If the ACPI variable is bigger, I expect
>     the ACPI variable would not get inserted...

I think the best thing would be to reserve the PNP (including ACPI)
resources first, then the legacy things from setup.c.  I haven't looked
into that to see whether it's feasible.  Then you might have something
like this:

  0080-008f : 00:07 PNP0200
    0080-008f : dma page reg

>  b) A legacy driver requests resources bigger than the ACPI SystemIO 
>     variable, but the ACPI resource variable lies within the requested
>     space. Example:
> (/proc/ioports):
> 0070-0071 : rtc0
> 0072-0073 : ACPI KSB0*
> (syslog):
> IO region [rtc] conflicts with [ACPI KSB0].  Ignoring.., system might
> run unstable.
> rtc: I/O resource 70 is not free.
> 
>     The rtc driver seems to request the whole rtc space (0x70-0x77)
>     which fails because 0x72-0x73 has already been requested SHARED by
>     an ACPI SystemIO variable. At least parts of the rtc space got
>     requested (rtc0), I haven't checked whether the device was working
>     correctly...

I tripped over a couple of these when I changed the PNP core to request
resources for active devices.  The RTC is one; often BIOS says the RTC
is at 0x70-0x71 and 0x72-0x73, but the rtc drivers like to claim 0x8
(RTC_IO_EXTENT) ports.  However, I think the driver only *uses* two
ports, so we should change the driver to only request what it is
using.

Another case is the "dma1" region from e820.c.  Currently this is
0x0-0x1f, but most PNP0c02 devices only respond from 0x10-0x1f.  So
I think we should start by splitting "dma1" into 0x0-0xf and 0x10-0x1f.

> Another issue that needs fix up is that the motherboad driver is not
> requesting it's resources anymore (which it still did with 2.6.18 - I
> didn't dig here anymore, maybe someone can comment why this has changed)

I don't know what's up here; I haven't looked at this recently.

> Summary:
> ...
>   - Not fixable (maybe someone has an idea): If ACPI IO region declares
>     a smaller IO part than the later native driver (e.g. example above
>     with rtc driver), the partially overlapping resource cannot be
>     registered and the native driver fails to load with strict and lax
>     option.

Assuming the BIOS describes the region correctly, I'd say a driver
that claims a larger region is buggy and should be fixed.

Bjorn
