Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXLRR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXLRR7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXLRR7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:59:22 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:4734 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbXLRR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:59:21 -0500
Date: Tue, 18 Dec 2007 18:59:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, Elvis Pranskevichus <el@prans.net>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Message-ID: <20071218185918.5d2d4c7d@hyperion.delvare>
In-Reply-To: <200712171014.44360.bjorn.helgaas@hp.com>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209230211.1c2077cf.mikeserv@bmts.com>
	<1197856779.7782.2.camel@sli10-desk.sh.intel.com>
	<200712171014.44360.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Mon, 17 Dec 2007 10:14:43 -0700, Bjorn Helgaas wrote:
> On Sunday 16 December 2007 06:59:39 pm Shaohua Li wrote:
> > On Sun, 2007-12-09 at 23:02 -0500, Mike Houston wrote:
> > > On Mon, 10 Dec 2007 10:31:27 +0800
> > > Shaohua Li <shaohua.li@intel.com> wrote:
> > > > This should exist in previous kernel (before we remove acpi
> > > > motherboard driver) too. Basically it's a broken BIOS. Could below
> > > > patch work around it?
> > > > 
> > > > Thanks,
> > > > Shaohua
> > > > 
> > > > Index: linux/drivers/pnp/system.c
> > > > ===================================================================
> > > > --- linux.orig/drivers/pnp/system.c	2007-12-10
> > > > 10:17:46.000000000 +0800 +++ linux/drivers/pnp/system.c
> > > 
> > > Thanks Shaohua, I tested this as well and it appears to have worked
> > > around the issue for me.
> > > 
> > > Now, in dmesg, I get:
> > > 
> > > system 00:01: ioport range 0x290-0x29f has been reserved
> > > (...)
> > > system 00:01: ioport range 0x290-0x294 could not be reserved
> > > 
> > > In /proc/ioports I see:
> > > 
> > > 0290-029f : pnp 00:01
> > >   0290-0297 : it87
> > >     0290-0297 : it87
> >
> > Unfortunately this can't solve all such issues.

I don't see any issue here, but anyway it doesn't really matter as the
proposed patch is not sufficient for all affected motherboards.

> > 
> > Adam & Bjorn,
> > Could we just reserve IO ports >= 0x1000 in pnp system driver? The
> > purpose of the driver is to avoid resource conflict with PCI device, and
> > PCI device can't user io port < 0x1000.
> 
> The purpose of the PNP system driver is to avoid conflicts with
> *all* devices.  And if the PNP core were a little smarter, we
> wouldn't need the system driver at all.  We don't have one for
> PCI -- the PCI core manages resources for all PCI devices, even
> ones that have no driver.
> 
> Why is 0x1000 a magic number?  drivers/acpi/motherboard.c used to
> ignore IO port ranges that ended below PCIBIOS_MIN_IO (== 0x1000 for
> most architectures).  I don't think Linux will assign IO ports below
> PCIBIOS_MIN_IO to a PCI device, but the BIOS could, and I've seen
> CardBus devices below PCIBIOS_MIN_IO.
> 
> I think having drivers/pnp/system.c ignore resources below
> PCIBIOS_MIN_IO would be a hack that happens to cover up problems
> like this without understanding the real cause.

The real cause is pretty clear here: broken BIOS. In an ideal world we
would ask the manufacturer for a fixed BIOS and they would give that to
us, unfortunately my experience is that it won't happen. So, unless we
accept that idea that some users won't be able to use some of their
devices because of broken resource enumeration in their BIOS, we will
have to find a workaround, whatever it is.

My initial idea was to identify the faulty motherboard using DMI and to
force pnpacpi=off on the faulty motherboards. If this is considered too
aggressive, maybe we can just reject resource declarations that
intersect (but don't match) 0x290-0x297 for these motherboards. Either
way, we have to do something, and we have to do it quickly. 2.6.24
final isn't too far away, and more importantly, the patch that revealed
the problem has been backported to 2.6.23.10 so people are experiencing
regressions already.

-- 
Jean Delvare
