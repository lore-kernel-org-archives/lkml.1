Return-Path: <linux-kernel-owner+w=401wt.eu-S965525AbXDBOdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525AbXDBOdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXDBOdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:33:13 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:35174 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965525AbXDBOdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:33:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH] Correctly report PnP 64bit resources
Date: Mon, 2 Apr 2007 08:33:01 -0600
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, ambx1@neo.rr.com, linux-kernel@vger.kernel.org
References: <20070331091237.GA32332@vana.vc.cvut.cz>
In-Reply-To: <20070331091237.GA32332@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020833.01290.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 03:12, Petr Vandrovec wrote:
> Hello,
>   today I noticed that kernel with 64bit I/O resources reports
> incorrect /proc/iomem due to resource_size_t => int => resource_size_t
> conversion in drivers/pnp/system.c, turning addresses 2-4GB into
> very huge addresses at the top of 64bit address space.

Your patch looks good to me.

> Differences between old and new /proc/iomem and dmesg are below, as well
> as a patch (for current git tree).  After this change kernel with 64bit 
> resources now reports same errors as one built with 32bit resources only -
> - which is apparently correct behavior.
> 
> If you are interested, these ranges failed to be reserved:
> ceee0000-ceefffff are ACPI tables,
> cf000000-cfffffff is shared memory for on-board videocard, 
> f0000000-f3ffffff is MMCONFIG, and
> feff0000-feff00ff is part of HPET (seems to be violation of spec)
> 
> --- memres-before	2007-03-31 01:41:40.000000000 -0700
> +++ memres-after	2007-03-31 01:43:47.000000000 -0700
> @@ -48,12 +48,8 @@
>    fe02f000-fe02ffff : ohci_hcd
>  fec00000-fec00fff : IOAPIC 0
>  fee00000-fee00fff : Local APIC
> +fefe0000-fefe01ff : pnp 00:01
> +fefe1000-fefe10ff : pnp 00:01
>  feff0000-feff03ff : HPET 0
> +ffff0000-ffffffff : pnp 00:0c
>  100000000-12fffffff : System RAM
> -ffffffffceee0000-ffffffffceefffff : pnp 00:0c
> -ffffffffcf000000-ffffffffcfffffff : pnp 00:01
> -fffffffff0000000-fffffffff3ffffff : pnp 00:0b
> -fffffffffefe0000-fffffffffefe01ff : pnp 00:01
> -fffffffffefe1000-fffffffffefe10ff : pnp 00:01
> -fffffffffeff0000-fffffffffeff00ff : pnp 00:0c
> -ffffffffffff0000-ffffffffffffffff : pnp 00:0c
> 
> --- dmesg-before	2007-03-31 00:18:50.000000000 -0700
> +++ dmesg-after	2007-03-31 01:46:20.000000000 -0700
> @@ -225,11 +225,11 @@
>  pnp: 00:01: iomem range 0x0-0x0 could not be reserved
>  pnp: 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
>  pnp: 00:01: iomem range 0xfefe1000-0xfefe10ff has been reserved
> -pnp: 00:01: iomem range 0xcf000000-0xcfffffff has been reserved
> -pnp: 00:0b: iomem range 0xf0000000-0xf3ffffff has been reserved
> +pnp: 00:01: iomem range 0xcf000000-0xcfffffff could not be reserved
> +pnp: 00:0b: iomem range 0xf0000000-0xf3ffffff could not be reserved
>  pnp: 00:0c: iomem range 0xf0000-0xfffff could not be reserved
> -pnp: 00:0c: iomem range 0xfeff0000-0xfeff00ff has been reserved
> -pnp: 00:0c: iomem range 0xceee0000-0xceefffff has been reserved
> +pnp: 00:0c: iomem range 0xfeff0000-0xfeff00ff could not be reserved
> +pnp: 00:0c: iomem range 0xceee0000-0xceefffff could not be reserved
>  pnp: 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
>  PCI: Bridge: 0000:00:04.0
>    IO window: b000-bfff
> 
> 						Thanks,
> 							Petr Vandrovec
> 
> 
> ----
> Change PnP resource handling code to use proper type for resource start and length.  
> Fixes bogus regions reported in /proc/iomem.
> 
> I've also made some pointer constant, as they are constant...
> 
> Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
> 
> diff -uprdN linux/drivers/pnp/system.c linux/drivers/pnp/system.c
> --- linux/drivers/pnp/system.c	2007-03-30 22:31:34.000000000 -0700
> +++ linux/drivers/pnp/system.c	2007-03-31 01:40:03.000000000 -0700
> @@ -22,7 +22,7 @@ static const struct pnp_device_id pnp_de
>  	{	"",			0	}
>  };
>  
> -static void reserve_range(char *pnpid, int start, int end, int port)
> +static void reserve_range(const char *pnpid, resource_size_t start, resource_size_t end, int port)
>  {
>  	struct resource *res;
>  	char *regionid;
> @@ -32,9 +32,9 @@ static void reserve_range(char *pnpid, i
>  		return;
>  	snprintf(regionid, 16, "pnp %s", pnpid);
>  	if (port)
> -		res = request_region(start,end-start+1,regionid);
> +		res = request_region(start, end-start+1, regionid);
>  	else
> -		res = request_mem_region(start,end-start+1,regionid);
> +		res = request_mem_region(start, end-start+1, regionid);
>  	if (res == NULL)
>  		kfree(regionid);
>  	else
> @@ -45,12 +45,13 @@ static void reserve_range(char *pnpid, i
>  	 * have double reservations.
>  	 */
>  	printk(KERN_INFO
> -		"pnp: %s: %s range 0x%x-0x%x %s reserved\n",
> -		pnpid, port ? "ioport" : "iomem", start, end,
> +		"pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
> +		pnpid, port ? "ioport" : "iomem",
> +                (unsigned long long)start, (unsigned long long)end,
>  		NULL != res ? "has been" : "could not be");
>  }
>  
> -static void reserve_resources_of_dev(struct pnp_dev *dev)
> +static void reserve_resources_of_dev(const struct pnp_dev *dev)
>  {
>  	int i;
>  
> 
