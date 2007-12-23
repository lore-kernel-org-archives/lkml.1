Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbXLWDmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbXLWDmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 22:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXLWDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 22:42:24 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42632 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXLWDmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 22:42:22 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Sat, 22 Dec 2007 20:40:30 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Shaohua Li" <shaohua.li@intel.com>, "Mike Houston" <mikeserv@bmts.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Elvis Pranskevichus" <el@prans.net>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, "Adam Belay" <ambx1@neo.rr.com>,
       "Zhao Yakui" <yakui.zhao@intel.com>, "Thomas Renninger" <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <w9NvZsoO.1198322501.4301280.khali@gcu-squad.org>
In-Reply-To: <w9NvZsoO.1198322501.4301280.khali@gcu-squad.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712222040.32079.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 December 2007 4:21:41 am Jean Delvare wrote:
> >This patch makes the it87 driver request only the two ports used for the
> >Environment Controller device.
>
> The problem is that the IT87xxF chips do decode 4 ports (recent chips,
> 0x294-0x297) or 8 ports (older chips, 0x290-0x297), not 2 as the
> datasheets say. The ITE Super-I/O chips differ from the Winbond
> Super-I/O chips in this respect. The it87 driver only needs to access
> ports 0x295 and 0x296, true, but the device itself decodes more
> addresses than that. So, with this proposed patch, ports which are busy
> will be shown as being free. This pretty much voids the point of
> resource declarations, doesn't it? This might not cause too much
> trouble in practice, but to me this still looks like the wrong way to go.

Yes, all the ports decoded by the chip should certainly be reserved,
but I think the entire range should be reserved at a higher level,
like the PNP core, and the driver should reserve only the ports it
uses.  Then the entire range is reserved even if there is no driver
or the driver is not loaded.  That's the approach we use for PCI,
e.g.,

  e8100000-e81fffff : 0000:00:08.0          <-- reserved by PCI core
    e8100000-e8102fff : CS46xx_BA1_data0    <-- reserved by driver
    e8110000-e81137ff : CS46xx_BA1_data1
    e8120000-e8126fff : CS46xx_BA1_pmem
    e8130000-e81300ff : CS46xx_BA1_reg

> The resource declarations made by these motherboard BIOSes are totally
> bogus. 0x290-0x29f is much larger than what the chip decodes.
> 0x290-0x294 is a subset that doesn't make any sense. The GA-K8N Ultra 9
> is even funnier with 0x295-0x314, which again doesn't correspond to
> anything real.

I agree those declarations are probably wrong.  But at least they're
larger than required, so they should be safe.

> All these happen to not intersect with 0x295-0x296 but I 
> wouldn't count on it. If Gigabyte (and possibly others) care that
> little about these declarations, pretty much anything could be seen. So
> while your proposed workaround happens to fix the problem at hand, it is
> not really correct technically, and could break again soon.
>
> I'd rather fix the problem at its source, or, as fixing it as the source
> isn't very realistic in this case, as near of the source as possible.
> That would mean DMI-based quirks for the affected motherboards, that
> would discard or adjust the bogus resource declarations.

Well, I think the driver change *is* correct, assuming that the
entire range can be reserved at a higher level.  In this case,
it is, via a PNP0C02 device.

I think a DMI-based quirk to fix the PNP0C02 resources would be
a good approach, but we shouldn't do that until those resources
cause some other problem.

> I also don't fully understand what pnpacpi is useful for. I have heard
> about PCI drivers that might request resources that the motherboard
> doesn't want them to touch, but I don't know the details, I also
> don't know if it is a theoretical issue or if it really happens on some
> systems, and I don't know if there are other uses for pnpacpi.

It is a real issue.  It's probably not very common because many ACPI
devices use "legacy" resources like ports below 0x1000, and the kernel
has heuristics to avoid placing other devices there.  But I have seen
the kernel place a CardBus device on top of an ACPI device, so it does
happen.

Apart from preventing resource conflicts, PNP has framework for
driver/device binding, suspend/resume, etc.  Without PNPACPI,
we'll fall back to PNPBIOS, but my guess is that nowadays, the
ACPI namespace is better-tested than PNPBIOS.  And I wouldn't
be surprised if PNPBIOS disappears from new boxes.

> I'm 
> asking because I want to know if forcing pnpacpi=off on the faulty
> motherboards would be good enough or if we really need finer-grained
> quirks (assuming that we go the DMI-based quirks route at all.) The
> former would obviously be easier.

I'm sure these boxes still have PNPBIOS, so pnpacpi=off would
probably work fine.  But it feels like a bigger hammer than
necessary for this problem.

Bjorn
