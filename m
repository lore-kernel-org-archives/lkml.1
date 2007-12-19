Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXLSXxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXLSXxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXLSXxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:53:41 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:39647 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbXLSXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:53:40 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Houston <mikeserv@bmts.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Wed, 19 Dec 2007 16:53:33 -0700
User-Agent: KMail/1.9.6
Cc: Shaohua Li <shaohua.li@intel.com>, Adrian Bunk <bunk@stusta.de>,
       Elvis Pranskevichus <el@prans.net>, Jean Delvare <khali@linux-fr.org>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20071204215154.7f26285e.mikeserv@bmts.com> <1197253887.27516.2.camel@sli10-desk.sh.intel.com> <20071209230211.1c2077cf.mikeserv@bmts.com>
In-Reply-To: <20071209230211.1c2077cf.mikeserv@bmts.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191653.35223.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 December 2007 09:02:11 pm Mike Houston wrote:
> On Mon, 10 Dec 2007 10:31:27 +0800
> Shaohua Li <shaohua.li@intel.com> wrote:
> > This should exist in previous kernel (before we remove acpi
> > motherboard driver) too. Basically it's a broken BIOS. Could below
> > patch work around it?
> > 
> > Thanks,
> > Shaohua
> > 
> > Index: linux/drivers/pnp/system.c
> > ===================================================================
> > --- linux.orig/drivers/pnp/system.c	2007-12-10
> > 10:17:46.000000000 +0800 +++ linux/drivers/pnp/system.c
> 
> Thanks Shaohua, I tested this as well and it appears to have worked
> around the issue for me.
> 
> Now, in dmesg, I get:
> 
> system 00:01: ioport range 0x290-0x29f has been reserved
> (...)
> system 00:01: ioport range 0x290-0x294 could not be reserved
> 
> In /proc/ioports I see:
> 
> 0290-029f : pnp 00:01
>   0290-0297 : it87
>     0290-0297 : it87
> 
> The it87 sensor now works without disabling acpipnp

This whole thing is too ugly for words.

First of all, it87 only accesses two I/O ports: IT87_ADDR_REG_OFFSET
and IT87_DATA_REG_OFFSET, which are at offsets 5 and 6 from the base.
So if it87 reserved only those ports, e.g., 0x295-0x296, I think things
would work fine (or at least, as well as they used to).

Secondly, it87 ignores any information from the BIOS and grubs around
for a superio chip at a magic address and tries to figure out what's
behind it.  I know this is because we don't know the "real" way to
read those sensors, but it still sucks, and it still means we're likely
to have conflicts with ACPI usage of the device.  And no, I don't have
anything useful like an ACPI driver to offer :-)

Bjorn
