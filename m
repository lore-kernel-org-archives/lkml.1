Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbXGRRuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbXGRRuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbXGRRum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:50:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:40745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbXGRRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:50:40 -0400
Subject: Re: [PATCH - 0/2] Identify native drivers and ACPI subsystem
	accessing the same resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <200707131056.46193.bjorn.helgaas@hp.com>
References: <1184331492.3960.100.camel@d88.suse.de>
	 <200707131056.46193.bjorn.helgaas@hp.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 18 Jul 2007 19:50:38 +0200
Message-Id: <1184781038.15328.109.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 10:56 -0600, Bjorn Helgaas wrote:
> On Friday 13 July 2007 06:58:12 am Thomas Renninger wrote:
> > This patch should:
> > a) Identify machines where potentially ACPI interference can happen and
> >    tell the user which legacy drivers are affected.
> > b) Identify drivers/HW where we might need an ACPI driver in future
> > c) If it works out (if not too much important drivers are affected)
> >    enforce that native, non-ACPI drivers using the same IO/System
> >    memory addresses as declared in ACPI namespace fail to load.
> 
> I like some of the ideas here, but as you say, there are some
> issues to work out.
That sounds promising...

> > There are two kind of IO/System memory declarations in ACPI ASL
> > language: general variables and device specific resource
> > declarations.
> > The latter is already handled by pnpacpi and resources get requested 
> > from pnpacpi already. These resources can (with this patch) partly
> > already be requested by the general ACPI declarations and this patch
> > should handle this gracefully.
> 
> The PNP core does not request resources for devices that are active
> at boot.  Those resources currently don't get requested until a driver
> claims the device.  I think this is a bug that we should fix.
Yep, this is also a problem for the ACPI variables (in fact not really,
as long as not overlapping like the rtc resource) and probably the
reason why pnpacpi ignores addresses below 0x100?
> 
> > ACPI drivers (e.g. pnpacpi and others) are allowed to request these
> > resources (marked IORESOURCE_SHARED) through acpi_request_region().
> 
> I'm not a fan of IORESOURCE_SHARED.  I think that will make people
> think it's acceptable to share a device between several drivers.  It
> would be better to keep the ugliness of forcibly taking over a resource,
> just as an incentive to clean up the drivers.
It's only purpose is to implement the lax option (insure everything
works as before, but show offending drivers which is, as I said, my
favorite default).
Your suggestion is to just enforce the drivers getting cleaned up or
they won't be functional, just offering
acpi_enforce_resources=[no,strict]?
I fear then this patch will be in mm for ever

IMO:
  - Making sure ACPI claimed regions do not interfere with native
    drivers is very important and will get much more important in near 
    future
  - We need a step by step transition to fix up driver specific things
    smoothly. What about an ugly implementation (the lax option with
    IORESOURCE_SHARED code in kernel/resources.c), that gets reverted
    some kernel iterations later when we can be sure nothing sever
    breaks?

> > Here two examples of not nice things that could happen with lax option:
> > 
> >  a) legacy drivers (in this case arch/x86_64/setup.c) request resources
> >     before ACPI variables (shared resources) are requested:
> > (/proc/ioports):
> > 0080-008f : dma page reg
> >   0080-0080 : ACPI DEB0*
> >     In this case it's working as "dma page reg" includes the ACPI 
> >     SystemIO variable's space. If the ACPI variable is bigger, I expect
> >     the ACPI variable would not get inserted...
> 
> I think the best thing would be to reserve the PNP (including ACPI)
> resources first, then the legacy things from setup.c.  I haven't looked
> into that to see whether it's feasible.  Then you might have something
> like this:
> 
>   0080-008f : 00:07 PNP0200
>     0080-008f : dma page reg
> 
> >  b) A legacy driver requests resources bigger than the ACPI SystemIO 
> >     variable, but the ACPI resource variable lies within the requested
> >     space. Example:
> > (/proc/ioports):
> > 0070-0071 : rtc0
> > 0072-0073 : ACPI KSB0*
> > (syslog):
> > IO region [rtc] conflicts with [ACPI KSB0].  Ignoring.., system might
> > run unstable.
> > rtc: I/O resource 70 is not free.
> > 
> >     The rtc driver seems to request the whole rtc space (0x70-0x77)
> >     which fails because 0x72-0x73 has already been requested SHARED by
> >     an ACPI SystemIO variable. At least parts of the rtc space got
> >     requested (rtc0), I haven't checked whether the device was working
> >     correctly...
> 
> I tripped over a couple of these when I changed the PNP core to request
> resources for active devices.  The RTC is one; often BIOS says the RTC
> is at 0x70-0x71 and 0x72-0x73, but the rtc drivers like to claim 0x8
> (RTC_IO_EXTENT) ports.  However, I think the driver only *uses* two
> ports, so we should change the driver to only request what it is
> using.
But there could be more?
I have an idea how to implement that so that lax option still works as
expected, but this would be even more ugly than IORESOURCE_SHARED (in
fact extend the IORESOURCE_SHARED code in kernel/resource.c):
If e.g. rtc requests ports already requested by an ACPI variable (marked
IORESOURCE_SHARED or whatever), the marked one gets released and rtc
driver is allowed to claim them (with the message: "IO region [rtc]
conflicts with [ACPI KSB0].  Ignoring.., system might run unstable.")

acpi_request_resource() must check for vanishing entries then (should do
so anyways, forgot that...).

I need to think some more about this, maybe I give it a proof-of-concept
and very-ugly implementation try...

> Another case is the "dma1" region from e820.c.  Currently this is
> 0x0-0x1f, but most PNP0c02 devices only respond from 0x10-0x1f.  So
> I think we should start by splitting "dma1" into 0x0-0xf and 0x10-0x1f.
> 
> > Another issue that needs fix up is that the motherboad driver is not
> > requesting it's resources anymore (which it still did with 2.6.18 - I
> > didn't dig here anymore, maybe someone can comment why this has changed)
> 
> I don't know what's up here; I haven't looked at this recently.
Ok, that was because of too low PNP_MAX_PORT value...
Now I get:
5000-50fe : ACPI PMIO
  5000-50bf : pnp 00:07
    5000-5003 : ACPI PM1a_EVT_BLK
    5004-5005 : ACPI PM1a_CNT_BLK
    5008-500b : ACPI PM_TMR
    5020-5023 : ACPI GPE0_BLK
    50b0-50b7 : ACPI GPE1_BLK
  50c0-50df : pnp 00:07
  50e0-50ef : amd756_smbus

Argggggh, normally it should be:
5000-50fe : ACPI PMIO
...
  50c0-50df : pnp 00:07
  50e0-50ff : pnp 00:07       # this one is missing because
                              # it's bigger than the parent
    50e0-50ef : amd756_smbus


this is because:
AML:
    Name (SMBS, 0x50E0)
    Name (SMBL, 0x20)
    ...
    IO (Decode16,             // values get filled below
          0x0000,             // Range Minimum
          0x0000,             // Range Maximum
          0x00,               // Alignment
          0x00,               // Length
    _Y0D)
    ...
    If (SMBS)
    {
           CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y0E._MIN, GP10)
           CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y0E._MAX, GP11)
           CreateByteField (CRS, \_SB.PCI0.SBRG.RMSC._Y0E._LEN, GP1L)
           Store (SMBS, GP10)
           Store (SMBS, GP11)
           Store (SMBL, GP1L)
    }
that means this pnp region (filled with SMBS and SMBL values)
(0x50e0-0x50ff, starting at 0x50e0 and length of 0x20) inside the pnp
device is one byte longer than the one claimed by the ACPI variable PMIO
(0x5000-0x50fe) -> partially overlapping -> cannot be added as a child.

If this should work at all it must be possible to add pnpacpi devices to
an ACPI variable, even it exceeds the variable's border...
(Or the first machine I used has a buggy DSDT table :) ).

If this patch gets extended to allow the overlapping of ACPI SystemIO
Operation Regions and ACPI resource declarations (which would make the
code even more ugly, but I think this should be done), it still had the
functionality to identify native driver interference and all could work
as intended... But, if there is an ACPI kernel driver serving the ACPI
device (and it should be allowed to access its resources...), it's not
possible to ensure this one does not access the same resources than some
arbitrary executed AML code at the same time (this can only be ensured
if ACPI spec forbids that device resources and OperationRegion
declarations can overlap...).

Thanks,

    Thomas

> > Summary:
> > ...
> >   - Not fixable (maybe someone has an idea): If ACPI IO region declares
> >     a smaller IO part than the later native driver (e.g. example above
> >     with rtc driver), the partially overlapping resource cannot be
> >     registered and the native driver fails to load with strict and lax
> >     option.
> 
> Assuming the BIOS describes the region correctly, I'd say a driver
> that claims a larger region is buggy and should be fixed.

Yep, but a temporary solution where everything just works fine and a
message: "This driver needs fixing" is needed IMO (if the code gets
accepted... It's possible, but ...).

