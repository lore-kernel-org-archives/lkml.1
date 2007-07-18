Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbXGRWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbXGRWNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXGRWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:13:00 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:34637 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbXGRWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:12:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH - 0/2] Identify native drivers and ACPI subsystem accessing the same resources
Date: Wed, 18 Jul 2007 16:10:43 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
References: <1184331492.3960.100.camel@d88.suse.de> <200707131056.46193.bjorn.helgaas@hp.com> <1184781038.15328.109.camel@queen.suse.de>
In-Reply-To: <1184781038.15328.109.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181610.43418.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 11:50:38 am Thomas Renninger wrote:
> On Fri, 2007-07-13 at 10:56 -0600, Bjorn Helgaas wrote:
> > The PNP core does not request resources for devices that are active
> > at boot.  Those resources currently don't get requested until a driver
> > claims the device.  I think this is a bug that we should fix.
> Yep, this is also a problem for the ACPI variables (in fact not really,
> as long as not overlapping like the rtc resource) and probably the
> reason why pnpacpi ignores addresses below 0x100?

By "ACPI variables," do you mean PM1a_EVT_BLK and the like?  Those
should be subsets of the _CRS resources for some device.

> IMO:
>   - Making sure ACPI claimed regions do not interfere with native
>     drivers is very important and will get much more important in near 
>     future

I agree with this.  I know some of these native drivers (lm-sensors, etc)
are pretty essential right now.  But they just aren't safe because they
use resources that ACPI thinks it owns.  I think the drivers should be
changed to explicitly override (with appropriate KERN_WARN messages)
any prior ACPI resource reservations.

> > >     The rtc driver seems to request the whole rtc space (0x70-0x77)
> > >     which fails because 0x72-0x73 has already been requested SHARED by
> > >     an ACPI SystemIO variable. At least parts of the rtc space got
> > >     requested (rtc0), I haven't checked whether the device was working
> > >     correctly...
> > 
> > I tripped over a couple of these when I changed the PNP core to request
> > resources for active devices.  The RTC is one; often BIOS says the RTC
> > is at 0x70-0x71 and 0x72-0x73, but the rtc drivers like to claim 0x8
> > (RTC_IO_EXTENT) ports.  However, I think the driver only *uses* two
> > ports, so we should change the driver to only request what it is
> > using.

> But there could be more?

I think the PNP core should request all the ports the device responds
to (as reported by the BIOS).  The driver should request only the ports
it uses.  If the rtc driver only uses two ports, there's no reason for
it to request all eight.

> Argggggh, normally it should be:
> 5000-50fe : ACPI PMIO
> ...
>   50c0-50df : pnp 00:07
>   50e0-50ff : pnp 00:07       # this one is missing because
>                               # it's bigger than the parent
>     50e0-50ef : amd756_smbus

IMO, this is backwards.  "pnp 00:07" should be the parent and should
be reserved by the PNP core.  A side-effect of this is that
drivers/pnp/system.c would not be needed at all.

> > > Summary:
> > > ...
> > >   - Not fixable (maybe someone has an idea): If ACPI IO region declares
> > >     a smaller IO part than the later native driver (e.g. example above
> > >     with rtc driver), the partially overlapping resource cannot be
> > >     registered and the native driver fails to load with strict and lax
> > >     option.
> > 
> > Assuming the BIOS describes the region correctly, I'd say a driver
> > that claims a larger region is buggy and should be fixed.
> 
> Yep, but a temporary solution where everything just works fine and a
> message: "This driver needs fixing" is needed IMO (if the code gets
> accepted... It's possible, but ...).

How about something like this:  We fix all the native drivers we know
about.  We make the PNP and ACPI cores request resources for all active
devices by default, but add a flag like "pnp=no_reservations" that turns
this off.  Then native drivers that request conflicting resources
will fail, but the user can limp along by using the boot-time option.

Bjorn


