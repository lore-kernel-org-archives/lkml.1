Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXLJDQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXLJDQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXLJDQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:16:23 -0500
Received: from mail.prans.org ([64.79.206.200]:33903 "EHLO mail.prans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXLJDQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:16:22 -0500
X-Greylist: delayed 1571 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 22:16:22 EST
From: Elvis Pranskevichus <el@prans.net>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Sun, 9 Dec 2007 21:49:41 -0500
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@stusta.de>, Jean Delvare <khali@linux-fr.org>,
       Mike Houston <mikeserv@bmts.com>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20071204215154.7f26285e.mikeserv@bmts.com> <20071209220430.GK20441@stusta.de> <1197253887.27516.2.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1197253887.27516.2.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712092149.41640.el@prans.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday December 9 2007 09:31:27 pm Shaohua Li wrote:
> On Sun, 2007-12-09 at 23:04 +0100, Adrian Bunk wrote:
> > On Sun, Dec 09, 2007 at 04:12:25PM -0500, Elvis Pranskevichus wrote:
> > > Jean Delvare wrote:
> > > > Hi Mike,
> > > >
> > > > On Sat, 8 Dec 2007 21:22:34 -0500, Mike Houston wrote:
> > > >> On Sun, 9 Dec 2007 01:05:54 +0100
> > > >>
> > > >> Adrian Bunk <bunk@stusta.de> wrote:
> > > >> > On Tue, Dec 04, 2007 at 09:51:54PM -0500, Mike Houston wrote:
> > > >> > > I finally got around to testing Linux 2.6.24 (2.6.24-rc4) and
> > > >> > > found that the it87 driver fails to probe and consequently, my
> > > >> > > sensors no longer work. This was fine with Linux 2.6.23.8 (the
> > > >> > > last kernel I was using)
> > > >> > >
> > > >> > > The necessary modules load, but:
> > > >> > >
> > > >> > > it87: Found IT8718F chip at 0x290, revision 2
> > > >> > > it87: in3 is VCC (+5V)
> > > >> > > it87 it87.656: Failed to request region 0x290-0x297
> > > >> > > it87: probe of it87.656 failed with error -16
> > > >> > >
> > > >> > > Coretemp still works.
> > > >> > >
> > > >> > > It appears it has something to do with the ioport range being
> > > >> > > reserved for some reason:
> > > >> > >
> > > >> > > system 00:01: ioport range 0x290-0x29f has been reserved
> > > >> >
> > > >> > Thanks for your report.
> > > >> >
> > > >> > Please also provide:
> > > >> > - dmesg from 2.6.23.8
> > > >> > - The output of "cat /proc/ioports" for both kernels
> > > >>
> > > >> Thanks Adrian, here is the information you have requested, for
> > > >> both kernels (I have 2.6.23.9 now though where it87 still works)
> > > >>
> > > >> Linux 2.6.23.9:
> > > >> http://www.mikeserv.com/temp/proc_ioports-2.6.23.9.txt
> > > >> http://www.mikeserv.com/temp/dmesg-2.6.23.9.txt
> > > >> http://www.mikeserv.com/temp/config-2.6.23.9.txt
> > > >>
> > > >> Linux 2.6.24-rc4:
> > > >> http://www.mikeserv.com/temp/proc_ioports-2.6.24-rc4.txt
> > > >> http://www.mikeserv.com/temp/dmesg-2.6.24-rc4.txt
> > > >
> > > > This one shows:
> > > >
> > > > system 00:01: ioport range 0x290-0x29f has been reserved
> > > > (...)
> > > > system 00:01: ioport range 0x290-0x294 has been reserved
> > > >
> > > > This is clearly not correct as both areas overlap. The second
> > > > reservation is responsible for the it87 breakage, because it
> > > > conflicts with what the it87 driver later attempts to request
> > > > (0x290-0x297). The first is wrong as well (the IT87xxF environment
> > > > controller I/O area is 8 port wide, not 16) but shouldn't be a
> > > > problem in practice.
> > > >
> > > > These port reservations weren't happening in 2.6.23.9 according to
> > > > your dmesg output for that kernel. I don't know what changed in this
> > > > area since 2.6.23.9, maybe Bjorn or Adam (Cc'd) can tell.
> > >
> > > Hi,
> > >
> > > I have exactly the same problem here on a Gigabyte GA-965G-DS3
> > > motherboard based box:
> > >
> > > it87: Found IT8718F chip at 0x290, revision 1
> > > it87: in3 is VCC (+5V)
> > > it87 it87.656: Failed to request region 0x290-0x297
> > > it87: probe of it87.656 failed with error -16
> > >
> > > git bisecting revealed the offending commit:
> > >
> > > a7839e960675b54: PNP: increase the maximum number of resources
> > >
> > > Happened between rc3 and rc4.
> >
> > Thanks for doing the work of bisecting!
> >
> > > > Either way, the overlapping areas smell like a BIOS bug, meaning that
> > > > you should look for an updated BIOS for your system first.
> > > >
> > > >> http://www.mikeserv.com/temp/config-2.6.24-rc4.txt
> > >
> > > This indeed looks like a broken ACPI BIOS since the aforementioned
> > > commit touches only the PNP ACPI driver. I'm not sure how to work
> > > around this, though. Ideas?
> >
> > People responsible for this commit + ACPI maintainer added to Cc.
>
> This should exist in previous kernel (before we remove acpi motherboard
> driver) too. Basically it's a broken BIOS. Could below patch work around
> it?
>
> Thanks,
> Shaohua
>
> Index: linux/drivers/pnp/system.c
> ===================================================================
> --- linux.orig/drivers/pnp/system.c	2007-12-10 10:17:46.000000000 +0800
> +++ linux/drivers/pnp/system.c	2007-12-10 10:24:42.000000000 +0800
> @@ -22,7 +22,7 @@ static const struct pnp_device_id pnp_de
>  	{"", 0}
>  };
>
> -static void reserve_range(struct pnp_dev *dev, resource_size_t start,
> +static struct resource* reserve_range(struct pnp_dev *dev, resource_size_t
> start, resource_size_t end, int port)
>  {
>  	char *regionid;
> @@ -31,16 +31,14 @@ static void reserve_range(struct pnp_dev
>
>  	regionid = kmalloc(16, GFP_KERNEL);
>  	if (!regionid)
> -		return;
> +		return NULL;
>
>  	snprintf(regionid, 16, "pnp %s", pnpid);
>  	if (port)
>  		res = request_region(start, end - start + 1, regionid);
>  	else
>  		res = request_mem_region(start, end - start + 1, regionid);
> -	if (res)
> -		res->flags &= ~IORESOURCE_BUSY;
> -	else
> +	if (!res)
>  		kfree(regionid);
>
>  	/*
> @@ -52,12 +50,17 @@ static void reserve_range(struct pnp_dev
>  		port ? "ioport" : "iomem",
>  		(unsigned long long) start, (unsigned long long) end,
>  		res ? "has been" : "could not be");
> +	return res;
>  }
>
>  static void reserve_resources_of_dev(struct pnp_dev *dev)
>  {
>  	int i;
> +	struct resource **res;
>
> +	res = kzalloc(sizeof(struct resource *) * PNP_MAX_PORT, GFP_KERNEL);
> +	if (!res)
> +		return;
>  	for (i = 0; i < PNP_MAX_PORT; i++) {
>  		if (!pnp_port_valid(dev, i))
>  			continue;
> @@ -76,17 +79,28 @@ static void reserve_resources_of_dev(str
>  		if (pnp_port_end(dev, i) < pnp_port_start(dev, i))
>  			continue;	/* invalid */
>
> -		reserve_range(dev, pnp_port_start(dev, i),
> +		res[i] = reserve_range(dev, pnp_port_start(dev, i),
>  			      pnp_port_end(dev, i), 1);
>  	}
> +	for (i = 0; i < PNP_MAX_PORT; i++)
> +		if (res[i])
> +			res[i]->flags &= ~IORESOURCE_BUSY;
> +	kfree(res);
>
> +	res = kzalloc(sizeof(struct resource *) * PNP_MAX_MEM, GFP_KERNEL);
> +	if (!res)
> +		return;
>  	for (i = 0; i < PNP_MAX_MEM; i++) {
>  		if (!pnp_mem_valid(dev, i))
>  			continue;
>
> -		reserve_range(dev, pnp_mem_start(dev, i),
> +		res[i] = reserve_range(dev, pnp_mem_start(dev, i),
>  			      pnp_mem_end(dev, i), 0);
>  	}
> +	for (i = 0; i < PNP_MAX_MEM; i++)
> +		if (res[i])
> +			res[i]->flags &= ~IORESOURCE_BUSY;
> +	kfree(res);
>  }
>
>  static int system_pnp_probe(struct pnp_dev *dev,

Hi Shaohua,

Your patch works for me. /proc/ioports looks sane now:

0290-029f : pnp 00:01
  0290-0297 : it87
    0290-0297 : it87

And it87 doesn't complain anymore.

Thanks!
-- 
                Elvis
