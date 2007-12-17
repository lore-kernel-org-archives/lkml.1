Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbXLQRPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbXLQRPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXLQROu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:14:50 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2504 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXLQROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:14:49 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Mon, 17 Dec 2007 10:14:43 -0700
User-Agent: KMail/1.9.6
Cc: Mike Houston <mikeserv@bmts.com>, Adrian Bunk <bunk@stusta.de>,
       Elvis Pranskevichus <el@prans.net>, Jean Delvare <khali@linux-fr.org>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20071204215154.7f26285e.mikeserv@bmts.com> <20071209230211.1c2077cf.mikeserv@bmts.com> <1197856779.7782.2.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1197856779.7782.2.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171014.44360.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2007 06:59:39 pm Shaohua Li wrote:
> On Sun, 2007-12-09 at 23:02 -0500, Mike Houston wrote:
> > On Mon, 10 Dec 2007 10:31:27 +0800
> > Shaohua Li <shaohua.li@intel.com> wrote:
> > > This should exist in previous kernel (before we remove acpi
> > > motherboard driver) too. Basically it's a broken BIOS. Could below
> > > patch work around it?
> > > 
> > > Thanks,
> > > Shaohua
> > > 
> > > Index: linux/drivers/pnp/system.c
> > > ===================================================================
> > > --- linux.orig/drivers/pnp/system.c	2007-12-10
> > > 10:17:46.000000000 +0800 +++ linux/drivers/pnp/system.c
> > 
> > Thanks Shaohua, I tested this as well and it appears to have worked
> > around the issue for me.
> > 
> > Now, in dmesg, I get:
> > 
> > system 00:01: ioport range 0x290-0x29f has been reserved
> > (...)
> > system 00:01: ioport range 0x290-0x294 could not be reserved
> > 
> > In /proc/ioports I see:
> > 
> > 0290-029f : pnp 00:01
> >   0290-0297 : it87
> >     0290-0297 : it87
> Unfortunately this can't solve all such issues.
> 
> Adam & Bjorn,
> Could we just reserve IO ports >= 0x1000 in pnp system driver? The
> purpose of the driver is to avoid resource conflict with PCI device, and
> PCI device can't user io port < 0x1000.

The purpose of the PNP system driver is to avoid conflicts with
*all* devices.  And if the PNP core were a little smarter, we
wouldn't need the system driver at all.  We don't have one for
PCI -- the PCI core manages resources for all PCI devices, even
ones that have no driver.

Why is 0x1000 a magic number?  drivers/acpi/motherboard.c used to
ignore IO port ranges that ended below PCIBIOS_MIN_IO (== 0x1000 for
most architectures).  I don't think Linux will assign IO ports below
PCIBIOS_MIN_IO to a PCI device, but the BIOS could, and I've seen
CardBus devices below PCIBIOS_MIN_IO.

I think having drivers/pnp/system.c ignore resources below
PCIBIOS_MIN_IO would be a hack that happens to cover up problems
like this without understanding the real cause.

Bjorn
