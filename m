Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXLWXRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXLWXRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXLWXQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:16:52 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:33272 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbXLWXQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:16:51 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Sun, 23 Dec 2007 16:14:56 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Shaohua Li" <shaohua.li@intel.com>, "Mike Houston" <mikeserv@bmts.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Elvis Pranskevichus" <el@prans.net>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       "Adam Belay" <ambx1@neo.rr.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Thomas Renninger" <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <T7Y1KA73.1198402084.8607320.khali@gcu-squad.org>
In-Reply-To: <T7Y1KA73.1198402084.8607320.khali@gcu-squad.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712231614.58724.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007 2:28:05 am Jean Delvare wrote:
> Le 23/12/2007, Bjorn Helgaas a écrit:
> >On Saturday 22 December 2007 4:21:41 am Jean Delvare wrote:
> >> >This patch makes the it87 driver request only the two ports used for
> >> > the Environment Controller device.
> >>
> >> The problem is that the IT87xxF chips do decode 4 ports (recent chips,
> >> 0x294-0x297) or 8 ports (older chips, 0x290-0x297), not 2 as the
> >> datasheets say. The ITE Super-I/O chips differ from the Winbond
> >> Super-I/O chips in this respect. The it87 driver only needs to access
> >> ports 0x295 and 0x296, true, but the device itself decodes more
> >> addresses than that. So, with this proposed patch, ports which are busy
> >> will be shown as being free. This pretty much voids the point of
> >> resource declarations, doesn't it? This might not cause too much
> >> trouble in practice, but to me this still looks like the wrong way to
> >> go.
> >
> >Yes, all the ports decoded by the chip should certainly be reserved,
> >but I think the entire range should be reserved at a higher level,
> >like the PNP core, and the driver should reserve only the ports it
> >uses.  Then the entire range is reserved even if there is no driver
> >or the driver is not loaded.
>
> The problem is that the it87 driver is used on a variety of motherboards,
> some where the hardware monitoring device I/O ports are reserved by the
> BIOS, some where they aren't. How am I supposed to deal with this?

I assume you mean some boards describe those ports in ACPI, and some
don't?  I think the ideal solution would be to figure out how the
BIOS writers intended the device to be used, and do that.  But the
documentation may be lacking, and it degenerates into an OEM-specific
mess.  Second-best seems like a PNP quirk that pokes enough to determine
that a Super I/O device is present, and then reserves resources for
it.  Then we avoid the collision even if it87 isn't present.

> >That's the approach we use for PCI, e.g.,
> >
> >  e8100000-e81fffff : 0000:00:08.0          <-- reserved by PCI core
> >    e8100000-e8102fff : CS46xx_BA1_data0    <-- reserved by driver
> >    e8110000-e81137ff : CS46xx_BA1_data1
> >    e8120000-e8126fff : CS46xx_BA1_pmem
> >    e8130000-e81300ff : CS46xx_BA1_reg
>
> PCI is an entirely different beast. With PCI you know the PCI device ID
> that is associated with the resources, and for a given device, the
> resources are always declared (if standard BARs are used) or never
> declared; there's no "may be". So it's much easier to handle the
> resources properly.

That's the way PNP is supposed to work, too (more about this below).

> >> The resource declarations made by these motherboard BIOSes are totally
> >> bogus. 0x290-0x29f is much larger than what the chip decodes.
> >> 0x290-0x294 is a subset that doesn't make any sense. The GA-K8N Ultra 9
> >> is even funnier with 0x295-0x314, which again doesn't correspond to
> >> anything real.
> >
> >I agree those declarations are probably wrong.  But at least they're
> >larger than required, so they should be safe.
>
> That's not really safe, no. They may overlap with other device resources
> and prevent those drivers from loading.

True.  If that happens, I think we definitely need some kind of DMI-
based quirk to fix the resources.  My points are (a) the quirk needs
to be at the PNP level; it can't be in a driver, and (b) I'm lazy and
would wait until a problem happens before implementing it, because I
know so little about PNP and the specific board, and by waiting, there's
a chance I'll learn enough to avoid a mistake :-)

> >> All these happen to not intersect with 0x295-0x296 but I
> >> wouldn't count on it. If Gigabyte (and possibly others) care that
> >> little about these declarations, pretty much anything could be seen. So
> >> while your proposed workaround happens to fix the problem at hand, it is
> >> not really correct technically, and could break again soon.
> >>
> >> I'd rather fix the problem at its source, or, as fixing it as the source
> >> isn't very realistic in this case, as near of the source as possible.
> >> That would mean DMI-based quirks for the affected motherboards, that
> >> would discard or adjust the bogus resource declarations.
> >
> >Well, I think the driver change *is* correct, assuming that the
> >entire range can be reserved at a higher level.  In this case,
> >it is, via a PNP0C02 device.
>
> As I wrote above, the problem is that you can't assume that. Some
> motherboards do declare the range at PNP level but some don't. That's
> the reason why the it87 driver (and most other hwmon drivers for
> Super-I/O devices) do declare the I/O resource again.

The overlapping device problem is a subsystem problem, not a
driver problem.  We can't solve it in the driver because we can't
depend on the it87 driver being loaded.

> Another problem is how do I connect this specific I/O port range of the
> PNP0C02 device with the it87 driver? I am by far no PNP expert but it
> looks to me like this PNP device covers more than one actual device, and
> I/O port ranges do not have labels nor identifiers that would let me
> find the one that corresponds to the IT87xxF device (if it exists at
> all.)

The general rule is that you have a PNP device with an identifier
like PNP0500 that means "16550 UART" and some resources underneath
it.  The PNP ID ("PNP0500") tells the OS which driver to bind to the
device, and the resources tell the driver where the device is.  The
serial driver in drivers/serial/8250_pnp.c is a good example of the
"normal" way PNP drivers work.

it87 doesn't fit the model very well because usually the BIOS
doesn't describe the device explicitly.  I think the expectation
is that the OS will get sensor readings some other way, such as
by evaluating ACPI "_TMP" methods, or by using some OEM-specific
ACPI device.

It's very irritating when ACPI is used to take some device that
would otherwise be nicely generic and machine-independent, and
wrap it up into some abstract device that requires an OEM-specific
driver, but I think that's what's happening here.  I suspect it
has to do with the fact that the BIOS wants to retain some
control over the device so it can deal with things like thermal
emergencies, even if the OS driver is missing or broken.

> I'm all for integrating the it87 driver into the PNP subsystem if it is
> going to solve problems, but I just don't know how it works. I you do
> some work in this direction, I'll be happy to help with reviews and
> testing.

You don't see how it works because the BIOS writers have deliberately
obscured things (though no doubt they had good reasons).

Bjorn
