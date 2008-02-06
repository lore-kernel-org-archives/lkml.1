Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYBFOjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYBFOjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYBFOiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:38:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:60995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYBFOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:38:48 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc - Yet
	another Version
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <1202235600.14573.283.camel@queen.suse.de>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>
	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>
	 <1201536284.20940.424.camel@queen.suse.de> <479E19C9.7020201@keyaccess.nl>
	 <1201547548.20940.435.camel@queen.suse.de> <479E4531.9050600@keyaccess.nl>
	 <1202235600.14573.283.camel@queen.suse.de>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 06 Feb 2008 15:38:45 +0100
Message-Id: <1202308725.7977.92.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 19:20 +0100, Thomas Renninger wrote:
> On Mon, 2008-01-28 at 22:12 +0100, Rene Herman wrote:
> > On 28-01-08 20:12, Thomas Renninger wrote:
> > 
> > > This was more a step backward, hopefully this one (on top), gets the
> > > area bugfree?
> 
> This one includes findings from tests with Rene on a isa system.
> It handles possible NULL pointers and checks them inside the
> pnp_{mem,dma,irq,port}_{start,end,flags}. Which is a must for now with
> dynamic allocated resources. I first thought this could be checked
> inside the drivers with pnp_*_valid, but for now this is safer and
> easier to do.
> 
> I also integrated a suggestion from Bjorn and eliminated the not needed
> pnp_*_ok macros and used pnp_*_valid instead.
> Testcompiled with one example .config. I still build with different
> configs, I will let you know if anything did not build tomorrow (if not
> it builds).

Arg, it does not build when PNP_CONFIG is not set (and it is broken...).
The problem is (include/linux/pnp.h):
#define pnp_port_start(dev,bar)   (pnp_port_valid((dev),(bar)) ? (dev)->res.port_resource[(bar)].start \
				   : pnp_dbg("WARN: Port start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))

If PNP_CONFIG is not set, pnp_dbg is:
#define pnp_dbg(format, arg...) do {} while (0)

Not sure how this could be implemented in the nicest way.
Having at least a debug warning here should be added because it could
point to BIOS bugs.
E.g. (what I expect also happens on Rene's machine), drivers are
checking for port, mem, irq, dma resources they need. Without dynamic
allocation they could just access the array and check whether there are
unused/unfilled resources (they now also can with this patch (if done
correctly..) with the pnp_port_valid inside the pnp_port_start macro).

I expect on Rene's machine (might be something else, but this probably
often happens), BIOS exports dma and IO ports. The irq seem to be
missing and the driver does not use pnp_irq_valid, but pnp_irq. It
realizes it has no sane or an uninitialized value and makes up and uses
an irq which the driver thinks is best.
So having a message when a driver is trying to access a resource which
it seem to expect from BIOS, but has not been exported is a thing we
want to have, at least in PNP_DEBUG case.
Best would be to fix up all drivers..., but IMO this should at least be
split up in two steps and this check and the message in the pnp layer
should be added anyway.

Here an idea (thanks for hints go to Bernhard Walle), but it's still not
perfect (pnp.h would get quite big with it...), maybe someone has a
better idea:

static inline int pnp_port_start_f(dev, bar, fun, line)
{
        if (pnp_port_valid(dev,bar))
                return (dev)->res.port_resource[(bar)].start;
        else {
                pnp_dbg("WARN: Port end %d - [%s] invalid - %s:%d", (bar), (dev->name), fun, line);
                return 0;
        }
}
#define pnp_port_start(dev,bar)   pnp_port_f(start, dev, bar, __FUNCTION__, __LINE__)

Like that, one would get a hint which drivers (in which func and line)
tries to access a resource which it seem to expect gets exported by
BIOS, but did not.

I wait now for some response/ideas before polluting the list even
more...

   Thomas

> ------------
> 
> Allocate pnp resources dynamically via krealloc
> 
> Latest BIOS ACPI PNP device resource descriptions may have (especially on the
> general device PNP0c02) more than 20 IO port resources.
> Reserve the space in a static array wastes a lot of memory on every PNP device
> and is not a real option as the number of IO ports could be much greater than
> 20.
> 
> This approach allocates the memory for PNP resources at runtime.
> The memory is reallocated in e.g. 8 (for IO port) resource portions.
> That means that the previously allocated pointers will get a new address.
> Therefore this address must not be stored and/or used as long as krealloc
> might still allocate new resources.
> >From what I have seen, there is a patch in -mm that gets rid of
> registering resources automatically and pass the pointers from
> pnp_resource_table to request_region.
> While this should still work (only disabled devices where the regions
> should have been unregistered should be modifyable) it is potential
> dangereous: once you realloc pnp_resource_table pointers you end up
> with invalid pointers in the kernel/resource.c implemented list.
> Finding this could get difficult as you get really ugly phenomenons with
> corrupted memory...
> 
> 
> The patch also needs another patch from Rene Herman:
> "[PATCH] sound/isa: kill pnp_resource_change."
> Sent to the alsa-devel list and it's already included in Takashi's tree
> for 2.6.25 inclusion.
> The function pnp_resource_change is a nop now and immediately returns to avoid
> compile errors. It can be removed as soon as everything is merged together.
> 
> This has been tested on rather new machines on i386 and x86_64.
> The first with pnpbios also compiled in and forced a test with pnpacpi=off.
> 
> isapnp was partly tested by Rene. Whether this latest version works there
> still needs a test.
> Also the sysfs interface is rather untested.
> 
> I tried to play a bit with the sysfs interface and wanted override
> resources without much success:
> Unloaded parport_pc driver, then the corresponding pnp device changed state
> from active to disabled and now I should have been able to modify BIOS
> settings, but it did not work. I expect this is rather unused and could have
> been broken before and I did not want to loose more time with it.
> Maybe someone else knows more here.
> 
> 
> ---
>  drivers/pnp/core.c             |    2 
>  drivers/pnp/interface.c        |   44 ++-
>  drivers/pnp/isapnp/core.c      |   58 +++-
>  drivers/pnp/manager.c          |  549 +++++++++++++++++++++++++++++++----------
>  drivers/pnp/pnpacpi/rsparser.c |  151 +++++------
>  drivers/pnp/pnpbios/rsparser.c |  112 ++++----
>  drivers/pnp/resource.c         |   16 -
>  drivers/pnp/support.c          |   11 
>  drivers/pnp/system.c           |    4 
>  include/linux/pnp.h            |   78 +++--
>  10 files changed, 694 insertions(+), 331 deletions(-)
> 
> Index: linux-acpi-2.6/drivers/pnp/core.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/core.c
> +++ linux-acpi-2.6/drivers/pnp/core.c
> @@ -129,6 +129,7 @@ int __pnp_add_device(struct pnp_dev *dev
>  		return ret;
>  
>  	pnp_interface_attach_device(dev);
> +	pnp_dump_resources(dev);
>  	return 0;
>  }
>  
> @@ -148,6 +149,7 @@ int pnp_add_device(struct pnp_dev *dev)
>  	dev->dev.parent = &dev->protocol->dev;
>  	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
>  		dev->number);
> +	pnp_dbg("Adding device %s - %s", dev->name, dev->dev.bus_id);
>  	ret = __pnp_add_device(dev);
>  	if (ret)
>  		return ret;
> Index: linux-acpi-2.6/drivers/pnp/interface.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/interface.c
> +++ linux-acpi-2.6/drivers/pnp/interface.c
> @@ -264,7 +264,7 @@ static ssize_t pnp_show_current_resource
>  	else
>  		pnp_printf(buffer, "disabled\n");
>  
> -	for (i = 0; i < PNP_MAX_PORT; i++) {
> +	for (i = 0; pnp_port_valid(dev, i); i++) {
>  		if (pnp_port_valid(dev, i)) {
>  			pnp_printf(buffer, "io");
>  			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
> @@ -277,7 +277,7 @@ static ssize_t pnp_show_current_resource
>  									    i));
>  		}
>  	}
> -	for (i = 0; i < PNP_MAX_MEM; i++) {
> +	for (i = 0; pnp_mem_valid(dev, i); i++) {
>  		if (pnp_mem_valid(dev, i)) {
>  			pnp_printf(buffer, "mem");
>  			if (pnp_mem_flags(dev, i) & IORESOURCE_DISABLED)
> @@ -290,7 +290,7 @@ static ssize_t pnp_show_current_resource
>  									   i));
>  		}
>  	}
> -	for (i = 0; i < PNP_MAX_IRQ; i++) {
> +	for (i = 0; pnp_irq_valid(dev, i); i++) {
>  		if (pnp_irq_valid(dev, i)) {
>  			pnp_printf(buffer, "irq");
>  			if (pnp_irq_flags(dev, i) & IORESOURCE_DISABLED)
> @@ -300,7 +300,7 @@ static ssize_t pnp_show_current_resource
>  					   (unsigned long long)pnp_irq(dev, i));
>  		}
>  	}
> -	for (i = 0; i < PNP_MAX_DMA; i++) {
> +	for (i = 0; pnp_dma_valid(dev, i); i++) {
>  		if (pnp_dma_valid(dev, i)) {
>  			pnp_printf(buffer, "dma");
>  			if (pnp_dma_flags(dev, i) & IORESOURCE_DISABLED)
> @@ -381,6 +381,13 @@ pnp_set_current_resources(struct device 
>  				buf += 2;
>  				while (isspace(*buf))
>  					++buf;
> +				if (!pnp_port_valid(dev, nport)) {
> +					buf++;
> +					pnp_err("Cannot manually set port"
> +						"resource %d for device %s",
> +						nport, dev->name);
> +					continue;
> +				}
>  				dev->res.port_resource[nport].start =
>  				    simple_strtoul(buf, &buf, 0);
>  				while (isspace(*buf))
> @@ -397,14 +404,19 @@ pnp_set_current_resources(struct device 
>  				dev->res.port_resource[nport].flags =
>  				    IORESOURCE_IO;
>  				nport++;
> -				if (nport >= PNP_MAX_PORT)
> -					break;
>  				continue;
>  			}
>  			if (!strnicmp(buf, "mem", 3)) {
>  				buf += 3;
>  				while (isspace(*buf))
>  					++buf;
> +				if (!pnp_mem_valid(dev, nmem)) {
> +					buf++;
> +					pnp_err("Cannot manually set mem "
> +						"resource %d for device %s",
> +						nmem, dev->name);
> +					continue;
> +				}
>  				dev->res.mem_resource[nmem].start =
>  				    simple_strtoul(buf, &buf, 0);
>  				while (isspace(*buf))
> @@ -421,36 +433,44 @@ pnp_set_current_resources(struct device 
>  				dev->res.mem_resource[nmem].flags =
>  				    IORESOURCE_MEM;
>  				nmem++;
> -				if (nmem >= PNP_MAX_MEM)
> -					break;
>  				continue;
>  			}
>  			if (!strnicmp(buf, "irq", 3)) {
>  				buf += 3;
>  				while (isspace(*buf))
>  					++buf;
> +				if (!pnp_irq_valid(dev, nirq)) {
> +					buf++;
> +					pnp_err("Cannot manually set irq "
> +						"resource %d for device %s",
> +						nirq, dev->name);
> +					continue;
> +				}
>  				dev->res.irq_resource[nirq].start =
>  				    dev->res.irq_resource[nirq].end =
>  				    simple_strtoul(buf, &buf, 0);
>  				dev->res.irq_resource[nirq].flags =
>  				    IORESOURCE_IRQ;
>  				nirq++;
> -				if (nirq >= PNP_MAX_IRQ)
> -					break;
>  				continue;
>  			}
>  			if (!strnicmp(buf, "dma", 3)) {
>  				buf += 3;
>  				while (isspace(*buf))
>  					++buf;
> +				if (!pnp_dma_valid(dev, ndma)) {
> +					buf++;
> +					pnp_err("Cannot manually set dma "
> +						"resource %d for device %s",
> +						ndma, dev->name);
> +					continue;
> +				}
>  				dev->res.dma_resource[ndma].start =
>  				    dev->res.dma_resource[ndma].end =
>  				    simple_strtoul(buf, &buf, 0);
>  				dev->res.dma_resource[ndma].flags =
>  				    IORESOURCE_DMA;
>  				ndma++;
> -				if (ndma >= PNP_MAX_DMA)
> -					break;
>  				continue;
>  			}
>  			break;
> Index: linux-acpi-2.6/drivers/pnp/isapnp/core.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/isapnp/core.c
> +++ linux-acpi-2.6/drivers/pnp/isapnp/core.c
> @@ -42,6 +42,7 @@
>  #include <linux/init.h>
>  #include <linux/isapnp.h>
>  #include <linux/mutex.h>
> +
>  #include <asm/io.h>
>  
>  #if 0
> @@ -65,6 +66,12 @@ module_param(isapnp_verbose, int, 0);
>  MODULE_PARM_DESC(isapnp_verbose, "ISA Plug & Play verbose mode");
>  MODULE_LICENSE("GPL");
>  
> +/* ISAPNP is restricted to these limits by spec */
> +#define PNP_MAX_PORT		8
> +#define PNP_MAX_MEM		4
> +#define PNP_MAX_IRQ		2
> +#define PNP_MAX_DMA		2
> +
>  #define _PIDXR		0x279
>  #define _PNPWRP		0xa79
>  
> @@ -942,41 +949,58 @@ static int isapnp_read_resources(struct 
>  				 struct pnp_resource_table *res)
>  {
>  	int tmp, ret;
> +	struct resource new_res;
>  
>  	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
>  	if (dev->active) {
> -		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
> +		for (tmp = 0; pnp_port_valid(dev, tmp); tmp++) {
>  			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
>  			if (!ret)
>  				continue;
> -			res->port_resource[tmp].start = ret;
> -			res->port_resource[tmp].flags = IORESOURCE_IO;
> +			new_res.start = ret;
> +			new_res.flags = IORESOURCE_IO;
> +			if (pnp_assign_resource(res, &new_res))
> +				pnp_err("Bug in %s", __FUNCTION__);
> +			if (tmp > PNP_MAX_PORT)
> +				pnp_warn("ISA exceeds spec max port");
>  		}
> -		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
> +		for (tmp = 0; pnp_mem_valid(dev, tmp); tmp++) {
>  			ret =
>  			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
>  			if (!ret)
>  				continue;
> -			res->mem_resource[tmp].start = ret;
> -			res->mem_resource[tmp].flags = IORESOURCE_MEM;
> +			new_res.start = ret;
> +			new_res.flags = IORESOURCE_MEM;
> +			if (pnp_assign_resource(res, &new_res))
> +				pnp_err("Bug in %s", __FUNCTION__);
> +			if (tmp > PNP_MAX_MEM)
> +				pnp_warn("ISA exceeds spec max mem");
>  		}
> -		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
> +		for (tmp = 0; pnp_irq_valid(dev, tmp); tmp++) {
>  			ret =
>  			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
>  			     8);
>  			if (!ret)
>  				continue;
> -			res->irq_resource[tmp].start =
> -			    res->irq_resource[tmp].end = ret;
> -			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
> +			new_res.start = new_res.end = ret;
> +			new_res.flags = IORESOURCE_IRQ;
> +			if (pnp_assign_resource(res, &new_res))
> +				pnp_err("Bug in %s", __FUNCTION__);
> +			if (tmp > PNP_MAX_IRQ)
> +				pnp_warn("ISA exceeds spec max irq");
> +
>  		}
> -		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
> +		for (tmp = 0; pnp_dma_valid(dev, tmp); tmp++) {
>  			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
>  			if (ret == 4)
>  				continue;
>  			res->dma_resource[tmp].start =
> -			    res->dma_resource[tmp].end = ret;
> -			res->dma_resource[tmp].flags = IORESOURCE_DMA;
> +			new_res.start = new_res.end = ret;
> +			new_res.flags = IORESOURCE_DMA;
> +			if (pnp_assign_resource(res, &new_res))
> +				pnp_err("Bug in %s", __FUNCTION__);
> +			if (tmp > PNP_MAX_DMA)
> +				pnp_warn("ISA exceeds spec max dma");
>  		}
>  	}
>  	return 0;
> @@ -1002,14 +1026,14 @@ static int isapnp_set_resources(struct p
>  	isapnp_cfg_begin(dev->card->number, dev->number);
>  	dev->active = 1;
>  	for (tmp = 0;
> -	     tmp < PNP_MAX_PORT
> +	     pnp_port_valid(dev, tmp)
>  	     && (res->port_resource[tmp].
>  		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
>  	     tmp++)
>  		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
>  				  res->port_resource[tmp].start);
>  	for (tmp = 0;
> -	     tmp < PNP_MAX_IRQ
> +	     pnp_irq_valid(dev, tmp)
>  	     && (res->irq_resource[tmp].
>  		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
>  	     tmp++) {
> @@ -1019,14 +1043,14 @@ static int isapnp_set_resources(struct p
>  		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
>  	}
>  	for (tmp = 0;
> -	     tmp < PNP_MAX_DMA
> +	     pnp_dma_valid(dev, tmp)
>  	     && (res->dma_resource[tmp].
>  		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
>  	     tmp++)
>  		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
>  				  res->dma_resource[tmp].start);
>  	for (tmp = 0;
> -	     tmp < PNP_MAX_MEM
> +	     pnp_mem_valid(dev, tmp)
>  	     && (res->mem_resource[tmp].
>  		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
>  	     tmp++)
> Index: linux-acpi-2.6/drivers/pnp/manager.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/manager.c
> +++ linux-acpi-2.6/drivers/pnp/manager.c
> @@ -14,104 +14,427 @@
>  #include <linux/bitmap.h>
>  #include "base.h"
>  
> +/* Defines the amount of struct resources that will get (re-)alloced
> + * if the resource table runs out of allocated ports/irqs/dma/mems
> + */
> +#define PNP_ALLOC_PORT		8
> +#define PNP_ALLOC_MEM		4
> +#define PNP_ALLOC_IRQ		2
> +#define PNP_ALLOC_DMA		2
> +
>  DECLARE_MUTEX(pnp_res_mutex);
>  
> -static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
> +#ifdef CONFIG_PNP_DEBUG
> +void pnp_dump_resources(struct pnp_dev *dev)
>  {
> -	resource_size_t *start, *end;
> -	unsigned long *flags;
> -
> -	if (idx >= PNP_MAX_PORT) {
> -		dev_err(&dev->dev, "too many I/O port resources\n");
> -		/* pretend we were successful so at least the manager won't try again */
> -		return 1;
> +	int i;
> +	pnp_dbg("Resource table dump:");
> +	pnp_dbg("Allocted: ports: %d [%p - %p]",
> +		dev->res.allocated_ports, dev->res.port_resource,
> +		dev->res.port_resource + (dev->res.allocated_ports *
> +					   sizeof(struct resource)));
> +	for (i = 0; pnp_port_valid(dev, i); i++) {
> +		pnp_dbg("Port %d: start: 0x%lx - end: 0x%lx - flags: %lu", i,
> +			(unsigned long)pnp_port_start(dev, i),
> +			(unsigned long)pnp_port_end(dev, i),
> +			pnp_port_flags(dev, i));
> +	}
> +	pnp_dbg("Allocted: mems: %d [%p - %p]",
> +		dev->res.allocated_mems, dev->res.mem_resource,
> +		dev->res.mem_resource + (dev->res.allocated_mems *
> +					   sizeof(struct resource)));
> +	for (i = 0; pnp_mem_valid(dev, i); i++) {
> +		pnp_dbg("Mem %d: start: 0x%lx - end: 0x%lx - flags: %lu", i,
> +			(unsigned long)pnp_mem_start(dev, i),
> +			(unsigned long)pnp_mem_end(dev, i),
> +			pnp_mem_flags(dev, i));
> +	}
> +	pnp_dbg("Allocted: irqs: %d [%p - %p]",
> +		dev->res.allocated_irqs, dev->res.irq_resource,
> +		dev->res.irq_resource + (dev->res.allocated_irqs *
> +					 sizeof(struct resource)));
> +	for (i = 0; pnp_irq_valid(dev, i); i++) {
> +		pnp_dbg("Irq %d: start: 0x%lx - flags: %lu", i,
> +			(unsigned long)pnp_irq(dev, i),
> +			pnp_irq_flags(dev, i));
> +	}
> +	pnp_dbg("Allocted: dmas: %d [%p - %p]",
> +		dev->res.allocated_dmas, dev->res.dma_resource,
> +		dev->res.dma_resource + (dev->res.allocated_dmas *
> +					 sizeof(struct resource)));
> +	for (i = 0; pnp_dma_valid(dev, i); i++) {
> +		pnp_dbg("Dma %d: start: 0x%lx - flags: %lu", i,
> +			(unsigned long)pnp_dma(dev, i),
> +			pnp_dma_flags(dev, i));
>  	}
> +}
> +#endif
> +
> +static void pnp_init_io(struct resource *res)
> +{
> +	res->name = NULL;
> +	res->start = 0;
> +	res->end = 0;
> +	res->flags = IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
> +}
> +static void pnp_init_mem(struct resource *res)
> +{
> +	res->name = NULL;
> +	res->start = 0;
> +	res->end = 0;
> +	res->flags = IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
> +}
> +static void pnp_init_irq(struct resource *res)
> +{
> +	res->name = NULL;
> +	res->start = -1;
> +	res->end = -1;
> +	res->flags = IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
> +}
> +static void pnp_init_dma(struct resource *res)
> +{
> +	res->name = NULL;
> +	res->start = -1;
> +	res->end = -1;
> +	res->flags = IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
> +}
> +
> +/****************************************************************
> + *
> + * pnp_alloc_{port,dma,irq,mem}
> + *
> + * These functions must only be when a device is not active and
> + * can therefore not have any resources requested via kernel/resource.c
> + * If the pnp resource table has not enough (or none) resources of
> + * a specific type allocated, the memory of the array is increased
> + * via krealloc, which results in changed pointers of all already
> + * allocated struct resources in the table.
> + * This would invalidate the addresses passed to request/insert_resource
> + */
> +
> +static int pnp_alloc_port(struct pnp_resource_table *res)
> +{
> +	int i;
> +	void *ret;
> +
> +	ret = krealloc(res->port_resource,
> +	       (sizeof(struct resource) * res->allocated_ports)
> +	       + (sizeof(struct resource) * PNP_ALLOC_PORT), GFP_KERNEL);
> +
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	res->port_resource = ret;
> +
> +	res->allocated_ports += PNP_ALLOC_PORT;
> +	for (i = res->allocated_ports - PNP_ALLOC_PORT;
> +	     i < res->allocated_ports; i++)
> +		pnp_init_io(&res->port_resource[i]);
> +
> +	pnp_dbg("Port allocate: %p - %p; Allocated: %lu bytes, size of"
> +		"struct: %lu - allocated ports: %d",
> +		res->port_resource,
> +		res->port_resource
> +		+ (sizeof(struct resource) * res->allocated_ports)
> +		+ (sizeof(struct resource) * PNP_ALLOC_PORT),
> +		(unsigned long) (sizeof(struct resource) * res->allocated_ports)
> +		+ (sizeof(struct resource) * PNP_ALLOC_PORT),
> +		(unsigned long) sizeof(struct resource),
> +		res->allocated_ports);
> +
> +	return 0;
> +}
> +
> +static int pnp_alloc_mem(struct pnp_resource_table *res)
> +{
> +	int i;
> +	void *ret;
> +
> +	ret = krealloc(res->mem_resource,
> +	       (sizeof(struct resource) * res->allocated_mems)
> +	       + (sizeof(struct resource)	* PNP_ALLOC_MEM), GFP_KERNEL);
> +
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	res->mem_resource = ret;
> +
> +	res->allocated_mems += PNP_ALLOC_MEM;
> +
> +	for (i = res->allocated_mems - PNP_ALLOC_MEM; i < res->allocated_mems;
> +	     i++)
> +		pnp_init_mem(&res->mem_resource[i]);
> +
> +	pnp_dbg("Mem allocate: %p - %p; Allocated: %lu bytes, size of"
> +		"struct: %lu - allocated mems: %d",
> +		res->mem_resource,
> +		res->mem_resource
> +		+ (sizeof(struct resource) * res->allocated_mems)
> +		+ (sizeof(struct resource) * PNP_ALLOC_MEM),
> +		(unsigned long) (sizeof(struct resource) * res->allocated_mems)
> +		+ (sizeof(struct resource) * PNP_ALLOC_MEM),
> +		(unsigned long) sizeof(struct resource),
> +		res->allocated_mems);
> +
> +	return 0;
> +}
> +
> +static int pnp_alloc_irq(struct pnp_resource_table *res)
> +{
> +	int i;
> +	void *ret;
> +
> +	ret = krealloc(res->irq_resource,
> +	       (sizeof(struct resource) * res->allocated_irqs)
> +	       + (sizeof(struct resource)	* PNP_ALLOC_IRQ), GFP_KERNEL);
> +
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	res->irq_resource = ret;
> +
> +	res->allocated_irqs += PNP_ALLOC_IRQ;
> +	for (i = res->allocated_irqs - PNP_ALLOC_IRQ; i < res->allocated_irqs;
> +	     i++)
> +		pnp_init_irq(&res->irq_resource[i]);
> +
> +	pnp_dbg("Irq allocate: %p - %p; Allocated: %lu bytes, size of"
> +		"struct: %lu - allocated irqs: %d",
> +		res->irq_resource,
> +		res->irq_resource
> +		+ (sizeof(struct resource) * res->allocated_irqs)
> +		+ (sizeof(struct resource) * PNP_ALLOC_IRQ),
> +		(unsigned long) (sizeof(struct resource) * res->allocated_irqs)
> +		+ (sizeof(struct resource) * PNP_ALLOC_IRQ),
> +		(unsigned long) sizeof(struct resource),
> +		res->allocated_irqs);
> +	return 0;
> +}
> +
> +static int pnp_alloc_dma(struct pnp_resource_table *res)
> +{
> +	int i;
> +	void *ret;
> +
> +	ret = krealloc(res->dma_resource,
> +	       (sizeof(struct resource) * res->allocated_dmas)
> +	       + (sizeof(struct resource)	* PNP_ALLOC_DMA), GFP_KERNEL);
> +
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	res->dma_resource = ret;
> +
> +	res->allocated_dmas += PNP_ALLOC_DMA;
> +	for (i = res->allocated_dmas - PNP_ALLOC_DMA; i < res->allocated_dmas;
> +	     i++)
> +		pnp_init_dma(&res->dma_resource[i]);
> +
> +	pnp_dbg("Dma allocate: %p - %p; Allocated: %lu bytes, size of"
> +		"struct: %lu - allocated dmas: %d",
> +		res->dma_resource,
> +		res->dma_resource
> +		+ (sizeof(struct resource) * res->allocated_dmas)
> +		+ (sizeof(struct resource) * PNP_ALLOC_DMA),
> +		(unsigned long) (sizeof(struct resource) * res->allocated_dmas)
> +		+ (sizeof(struct resource) * PNP_ALLOC_DMA),
> +		(unsigned long) sizeof(struct resource),
> +		res->allocated_dmas);
> +
> +	return 0;
> +}
> +
> +#define pnp_print_alloc_err(type, val, x)				\
> +	pnp_dbg("%s - cannot allocate new resource: %d in func %s "	\
> +		" - alloc: %d", type, val, __FUNCTION__, x)
> +
> +
> +/*
> + * Assign a resource (IO, MEM, IRQ, DMA) to the resource table.
> + * Searches for an IORESOURCE_UNSET resource entry in the table or reallocs
> + * new resource entries as needed and copies the given resource there.
> + */
> +int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res)
> +{
> +	int i = 0, ret;
> +
> +	if (!table || !res)
> +		return -EINVAL;
> +
> +	if (res->flags & IORESOURCE_IO) {
> +		/* find the next unused table entry */
> +		while (i < table->allocated_ports) {
> +			if (!(table->port_resource[i].flags
> +			      & IORESOURCE_UNSET))
> +				i++;
> +			else
> +				break;
> +		}
> +		/* No unused table entry anymore, allocate new ones */
> +		if (table->allocated_ports <= i) {
> +			ret = pnp_alloc_port(table);
> +			if (ret) {
> +				pnp_print_alloc_err("Port", ret, i);
> +				return ret;
> +			}
> +		}
> +		memcpy(&table->port_resource[i], res, sizeof(struct resource));
> +	} else 	if (res->flags & IORESOURCE_MEM) {
> +		while (i < table->allocated_mems) {
> +			if (!(table->mem_resource[i].flags & IORESOURCE_UNSET))
> +				i++;
> +			else
> +				break;
> +		}
> +
> +		if (table->allocated_mems <= i) {
> +			ret = pnp_alloc_mem(table);
> +			if (ret) {
> +				pnp_print_alloc_err("System Memory", ret, i);
> +				return ret;
> +			}
> +		}
> +		memcpy(&table->mem_resource[i], res, sizeof(struct resource));
> +	} else if (res->flags & IORESOURCE_IRQ) {
> +		while (i < table->allocated_irqs) {
> +			if (!(table->irq_resource[i].flags & IORESOURCE_UNSET))
> +				i++;
> +			else
> +				break;
> +		}
> +
> +		if (table->allocated_irqs <= i) {
> +			ret = pnp_alloc_irq(table);
> +			if (ret) {
> +				pnp_print_alloc_err("Irq", ret, i);
> +				return ret;
> +			}
> +		}
> +		memcpy(&table->irq_resource[i], res, sizeof(struct resource));
> +	} else	if (res->flags & IORESOURCE_DMA) {
> +		while (i < table->allocated_dmas) {
> +			if (!(table->dma_resource[i].flags & IORESOURCE_UNSET))
> +				i++;
> +			else
> +				break;
> +		}
> +
> +		if (table->allocated_dmas <= i) {
> +			ret = pnp_alloc_dma(table);
> +			if (ret) {
> +				pnp_print_alloc_err("DMA", ret, i);
> +				return ret;
> +			}
> +		}
> +		memcpy(&table->dma_resource[i], res, sizeof(struct resource));
> +	} else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +#define pnp_print_assign_err(type, val)					\
> +	pnp_dbg("%s resource %d not allocated, cannot assign value",	\
> +		type, val);
> +
> +
> +
> +static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
> +{
> +	struct resource res;
>  
>  	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
> +	if (pnp_port_valid(dev, idx) && !(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
>  		return 1;
>  
> -	start = &dev->res.port_resource[idx].start;
> -	end = &dev->res.port_resource[idx].end;
> -	flags = &dev->res.port_resource[idx].flags;
> +	if (pnp_port_valid(dev, idx)) {
> +		/* This resource index already got some values assigned,
> +		   take them as init */
> +		res.start = dev->res.port_resource[idx].start;
> +		res.end = dev->res.port_resource[idx].end;
> +		res.flags = dev->res.port_resource[idx].flags;
> +	} else
> +		/* This index in the table does not exist, initialize the new
> +		   resource and be carefuly to never access
> +		   dev->res.port_resource[idx] */
> +		pnp_init_io(&res);
>  
>  	/* set the initial values */
> -	*flags |= rule->flags | IORESOURCE_IO;
> -	*flags &= ~IORESOURCE_UNSET;
> +	res.flags |= rule->flags | IORESOURCE_IO;
> +	res.flags &= ~IORESOURCE_UNSET;
>  
>  	if (!rule->size) {
> -		*flags |= IORESOURCE_DISABLED;
> +		res.flags |= IORESOURCE_DISABLED;
> +		pnp_assign_resource(&dev->res, &res);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
> -	*start = rule->min;
> -	*end = *start + rule->size - 1;
> +	res.start = rule->min;
> +	res.end = res.start + rule->size - 1;
>  
>  	/* run through until pnp_check_port is happy */
>  	while (!pnp_check_port(dev, idx)) {
> -		*start += rule->align;
> -		*end = *start + rule->size - 1;
> -		if (*start > rule->max || !rule->align)
> -			return 0;
> +		res.start += rule->align;
> +		res.end = res.start + rule->size - 1;
> +		if (res.start > rule->max || !rule->align)
> +			return pnp_assign_resource(&dev->res, &res);
>  	}
> +	pnp_assign_resource(&dev->res, &res);
>  	return 1;
>  }
>  
>  static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
>  {
> -	resource_size_t *start, *end;
> -	unsigned long *flags;
> -
> -	if (idx >= PNP_MAX_MEM) {
> -		dev_err(&dev->dev, "too many memory resources\n");
> -		/* pretend we were successful so at least the manager won't try again */
> -		return 1;
> -	}
> +	struct resource res;
>  
>  	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
> +	if (pnp_mem_valid(dev, idx) && !(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
>  		return 1;
>  
> -	start = &dev->res.mem_resource[idx].start;
> -	end = &dev->res.mem_resource[idx].end;
> -	flags = &dev->res.mem_resource[idx].flags;
> +	if (pnp_mem_valid(dev, idx)) {
> +		res.start = dev->res.mem_resource[idx].start;
> +		res.end = dev->res.mem_resource[idx].end;
> +		res.flags = dev->res.mem_resource[idx].flags;
> +	} else
> +		pnp_init_mem(&res);
>  
>  	/* set the initial values */
> -	*flags |= rule->flags | IORESOURCE_MEM;
> -	*flags &= ~IORESOURCE_UNSET;
> +	res.flags |= rule->flags | IORESOURCE_MEM;
> +	res.flags &= ~IORESOURCE_UNSET;
>  
>  	/* convert pnp flags to standard Linux flags */
>  	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
> -		*flags |= IORESOURCE_READONLY;
> +		res.flags |= IORESOURCE_READONLY;
>  	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
> -		*flags |= IORESOURCE_CACHEABLE;
> +		res.flags |= IORESOURCE_CACHEABLE;
>  	if (rule->flags & IORESOURCE_MEM_RANGELENGTH)
> -		*flags |= IORESOURCE_RANGELENGTH;
> +		res.flags |= IORESOURCE_RANGELENGTH;
>  	if (rule->flags & IORESOURCE_MEM_SHADOWABLE)
> -		*flags |= IORESOURCE_SHADOWABLE;
> +		res.flags |= IORESOURCE_SHADOWABLE;
>  
>  	if (!rule->size) {
> -		*flags |= IORESOURCE_DISABLED;
> +		res.flags |= IORESOURCE_DISABLED;
> +		pnp_assign_resource(&dev->res, &res);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
> -	*start = rule->min;
> -	*end = *start + rule->size - 1;
> +	res.start = rule->min;
> +	res.end = res.start + rule->size - 1;
>  
>  	/* run through until pnp_check_mem is happy */
>  	while (!pnp_check_mem(dev, idx)) {
> -		*start += rule->align;
> -		*end = *start + rule->size - 1;
> -		if (*start > rule->max || !rule->align)
> -			return 0;
> +		res.start += rule->align;
> +		res.end = res.start + rule->size - 1;
> +		if (res.start > rule->max || !rule->align)
> +			return pnp_assign_resource(&dev->res, &res);
>  	}
> +	pnp_assign_resource(&dev->res, &res);
>  	return 1;
>  }
>  
>  static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
>  {
> -	resource_size_t *start, *end;
> -	unsigned long *flags;
> +	struct resource res;
>  	int i;
>  
>  	/* IRQ priority: this table is good for i386 */
> @@ -119,49 +442,47 @@ static int pnp_assign_irq(struct pnp_dev
>  		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
>  	};
>  
> -	if (idx >= PNP_MAX_IRQ) {
> -		dev_err(&dev->dev, "too many IRQ resources\n");
> -		/* pretend we were successful so at least the manager won't try again */
> -		return 1;
> -	}
> -
>  	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
> +	if (pnp_irq_valid(dev, idx) && !(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
>  		return 1;
>  
> -	start = &dev->res.irq_resource[idx].start;
> -	end = &dev->res.irq_resource[idx].end;
> -	flags = &dev->res.irq_resource[idx].flags;
> +	if (pnp_irq_valid(dev, idx)) {
> +		res.start = dev->res.irq_resource[idx].start;
> +		res.end = dev->res.irq_resource[idx].end;
> +		res.flags = dev->res.irq_resource[idx].flags;
> +	} else
> +		pnp_init_irq(&res);
>  
>  	/* set the initial values */
> -	*flags |= rule->flags | IORESOURCE_IRQ;
> -	*flags &= ~IORESOURCE_UNSET;
> +	res.flags |= rule->flags | IORESOURCE_IRQ;
> +	res.flags &= ~IORESOURCE_UNSET;
>  
>  	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
> -		*flags |= IORESOURCE_DISABLED;
> +		res.flags |= IORESOURCE_DISABLED;
> +		pnp_assign_resource(&dev->res, &res);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
>  	/* TBD: need check for >16 IRQ */
> -	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
> -	if (*start < PNP_IRQ_NR) {
> -		*end = *start;
> +	res.start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
> +	if (res.start < PNP_IRQ_NR) {
> +		res.end = res.start;
> +		pnp_assign_resource(&dev->res, &res);
>  		return 1;
>  	}
>  	for (i = 0; i < 16; i++) {
>  		if (test_bit(xtab[i], rule->map)) {
> -			*start = *end = xtab[i];
> +			res.start = res.end = xtab[i];
>  			if (pnp_check_irq(dev, idx))
>  				return 1;
>  		}
>  	}
> -	return 0;
> +	return pnp_assign_resource(&dev->res, &res);
>  }
>  
>  static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
>  {
> -	resource_size_t *start, *end;
> -	unsigned long *flags;
> +	struct resource res;
>  	int i;
>  
>  	/* DMA priority: this table is good for i386 */
> @@ -169,34 +490,35 @@ static void pnp_assign_dma(struct pnp_de
>  		1, 3, 5, 6, 7, 0, 2, 4
>  	};
>  
> -	if (idx >= PNP_MAX_DMA) {
> -		dev_err(&dev->dev, "too many DMA resources\n");
> -		return;
> -	}
> -
>  	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
> +	if (pnp_dma_valid(dev, idx) && !(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
>  		return;
>  
> -	start = &dev->res.dma_resource[idx].start;
> -	end = &dev->res.dma_resource[idx].end;
> -	flags = &dev->res.dma_resource[idx].flags;
> +	if (pnp_dma_valid(dev, idx)) {
> +		res.start = dev->res.dma_resource[idx].start;
> +		res.end = dev->res.dma_resource[idx].end;
> +		res.flags = dev->res.dma_resource[idx].flags;
> +	} else
> +		pnp_init_dma(&res);
>  
>  	/* set the initial values */
> -	*flags |= rule->flags | IORESOURCE_DMA;
> -	*flags &= ~IORESOURCE_UNSET;
> +	res.flags |= rule->flags | IORESOURCE_DMA;
> +	res.flags &= ~IORESOURCE_UNSET;
>  
>  	for (i = 0; i < 8; i++) {
>  		if (rule->map & (1 << xtab[i])) {
> -			*start = *end = xtab[i];
> -			if (pnp_check_dma(dev, idx))
> +			res.start = res.end = xtab[i];
> +			if (pnp_check_dma(dev, idx)){
> +				pnp_assign_resource(&dev->res, &res);
>  				return;
> +			}
>  		}
>  	}
>  #ifdef MAX_DMA_CHANNELS
> -	*start = *end = MAX_DMA_CHANNELS;
> +	res.start = res.end = MAX_DMA_CHANNELS;
>  #endif
> -	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
> +	res.flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
> +	pnp_assign_resource(&dev->res, &res);
>  }
>  
>  /**
> @@ -207,28 +529,28 @@ void pnp_init_resource_table(struct pnp_
>  {
>  	int idx;
>  
> -	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
> +	for (idx = 0; idx < table->allocated_irqs; idx++) {
>  		table->irq_resource[idx].name = NULL;
>  		table->irq_resource[idx].start = -1;
>  		table->irq_resource[idx].end = -1;
>  		table->irq_resource[idx].flags =
>  		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
> +	for (idx = 0; idx < table->allocated_dmas; idx++) {
>  		table->dma_resource[idx].name = NULL;
>  		table->dma_resource[idx].start = -1;
>  		table->dma_resource[idx].end = -1;
>  		table->dma_resource[idx].flags =
>  		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
> +	for (idx = 0; idx < table->allocated_ports; idx++) {
>  		table->port_resource[idx].name = NULL;
>  		table->port_resource[idx].start = 0;
>  		table->port_resource[idx].end = 0;
>  		table->port_resource[idx].flags =
>  		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
> +	for (idx = 0; idx < table->allocated_mems; idx++) {
>  		table->mem_resource[idx].name = NULL;
>  		table->mem_resource[idx].start = 0;
>  		table->mem_resource[idx].end = 0;
> @@ -245,7 +567,7 @@ static void pnp_clean_resource_table(str
>  {
>  	int idx;
>  
> -	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
> +	for (idx = 0; idx < res->allocated_irqs; idx++) {
>  		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
>  			continue;
>  		res->irq_resource[idx].start = -1;
> @@ -253,7 +575,7 @@ static void pnp_clean_resource_table(str
>  		res->irq_resource[idx].flags =
>  		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
> +	for (idx = 0; idx < res->allocated_dmas; idx++) {
>  		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
>  			continue;
>  		res->dma_resource[idx].start = -1;
> @@ -261,7 +583,7 @@ static void pnp_clean_resource_table(str
>  		res->dma_resource[idx].flags =
>  		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
> +	for (idx = 0; idx < res->allocated_ports; idx++) {
>  		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
>  			continue;
>  		res->port_resource[idx].start = 0;
> @@ -269,7 +591,7 @@ static void pnp_clean_resource_table(str
>  		res->port_resource[idx].flags =
>  		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
>  	}
> -	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
> +	for (idx = 0; idx < res->allocated_mems; idx++) {
>  		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
>  			continue;
>  		res->mem_resource[idx].start = 0;
> @@ -386,46 +708,12 @@ fail:
>  int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
>  			  int mode)
>  {
> -	int i;
> -	struct pnp_resource_table *bak;
> -
> -	if (!pnp_can_configure(dev))
> -		return -ENODEV;
> -	bak = pnp_alloc(sizeof(struct pnp_resource_table));
> -	if (!bak)
> -		return -ENOMEM;
> -	*bak = dev->res;
> -
> -	down(&pnp_res_mutex);
> -	dev->res = *res;
> -	if (!(mode & PNP_CONFIG_FORCE)) {
> -		for (i = 0; i < PNP_MAX_PORT; i++) {
> -			if (!pnp_check_port(dev, i))
> -				goto fail;
> -		}
> -		for (i = 0; i < PNP_MAX_MEM; i++) {
> -			if (!pnp_check_mem(dev, i))
> -				goto fail;
> -		}
> -		for (i = 0; i < PNP_MAX_IRQ; i++) {
> -			if (!pnp_check_irq(dev, i))
> -				goto fail;
> -		}
> -		for (i = 0; i < PNP_MAX_DMA; i++) {
> -			if (!pnp_check_dma(dev, i))
> -				goto fail;
> -		}
> -	}
> -	up(&pnp_res_mutex);
> -
> -	kfree(bak);
> -	return 0;
> +	/* We must never end up here, these functions are poisson for dynamic
> +	   allocation via pointer array.
> +	*/
> +	BUG_ON(1);
> +	return 1;
>  
> -fail:
> -	dev->res = *bak;
> -	up(&pnp_res_mutex);
> -	kfree(bak);
> -	return -EINVAL;
>  }
>  
>  /**
> @@ -563,6 +851,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
>  void pnp_resource_change(struct resource *resource, resource_size_t start,
>  			 resource_size_t size)
>  {
> +	return;
>  	resource->flags &= ~(IORESOURCE_AUTO | IORESOURCE_UNSET);
>  	resource->start = start;
>  	resource->end = start + size - 1;
> Index: linux-acpi-2.6/drivers/pnp/pnpacpi/rsparser.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
> +++ linux-acpi-2.6/drivers/pnp/pnpacpi/rsparser.c
> @@ -73,23 +73,16 @@ static void pnpacpi_parse_allocated_irqr
>  						u32 gsi, int triggering,
>  						int polarity, int shareable)
>  {
> -	int i = 0;
>  	int irq;
>  	int p, t;
> -	static unsigned char warned;
> +
> +	struct resource new_res = {
> +		.flags = IORESOURCE_IRQ,
> +	};
>  
>  	if (!valid_IRQ(gsi))
>  		return;
>  
> -	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
> -	       i < PNP_MAX_IRQ)
> -		i++;
> -	if (i >= PNP_MAX_IRQ && !warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> -				"resources: %d \n", PNP_MAX_IRQ);
> -		warned = 1;
> -		return;
> -	}
>  	/*
>  	 * in IO-APIC mode, use overrided attribute. Two reasons:
>  	 * 1. BIOS bug in DSDT
> @@ -107,20 +100,26 @@ static void pnpacpi_parse_allocated_irqr
>  		}
>  	}
>  
> -	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
> -	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
> +	new_res.flags |= irq_flags(triggering, polarity);
>  	irq = acpi_register_gsi(gsi, triggering, polarity);
>  	if (irq < 0) {
> -		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
>  		return;
>  	}
>  
>  	if (shareable)
> -		res->irq_resource[i].flags |= IORESOURCE_IRQ_SHAREABLE;
> +		new_res.flags |= IORESOURCE_IRQ_SHAREABLE;
>  
> -	res->irq_resource[i].start = irq;
> -	res->irq_resource[i].end = irq;
> +	new_res.start = irq;
> +	new_res.end = irq;
>  	pcibios_penalize_isa_irq(irq, 1);
> +
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static int dma_flags(int type, int bus_master, int transfer)
> @@ -170,81 +169,71 @@ static void pnpacpi_parse_allocated_dmar
>  						u32 dma, int type,
>  						int bus_master, int transfer)
>  {
> -	int i = 0;
> -	static unsigned char warned;
> -
> -	while (i < PNP_MAX_DMA &&
> -	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
> -		i++;
> -	if (i < PNP_MAX_DMA) {
> -		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
> -		res->dma_resource[i].flags |=
> -		    dma_flags(type, bus_master, transfer);
> -		if (dma == -1) {
> -			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->dma_resource[i].start = dma;
> -		res->dma_resource[i].end = dma;
> -	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
> -				"resources: %d \n", PNP_MAX_DMA);
> -		warned = 1;
> -	}
> +	struct resource new_res = {
> +		.flags = IORESOURCE_DMA,
> +	};
> +
> +	new_res.flags |= dma_flags(type, bus_master, transfer);
> +	if (dma == -1) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
> +	}
> +	new_res.start = dma;
> +	new_res.end = dma;
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
>  					       u64 io, u64 len, int io_decode)
>  {
> -	int i = 0;
> -	static unsigned char warned;
> -
> -	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
> -	       i < PNP_MAX_PORT)
> -		i++;
> -	if (i < PNP_MAX_PORT) {
> -		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
> -		if (io_decode == ACPI_DECODE_16)
> -			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
> -		if (len <= 0 || (io + len - 1) >= 0x10003) {
> -			res->port_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->port_resource[i].start = io;
> -		res->port_resource[i].end = io + len - 1;
> -	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
> -				"resources: %d \n", PNP_MAX_PORT);
> -		warned = 1;
> -	}
> +	struct resource new_res = {
> +		.flags = IORESOURCE_IO,
> +	};
> +
> +	if (io_decode == ACPI_DECODE_16)
> +		new_res.flags |= PNP_PORT_FLAG_16BITADDR;
> +	if (len <= 0 || (io + len - 1) >= 0x10003) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
> +	}
> +	new_res.start = io;
> +	new_res.end = io + len - 1;
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
>  						u64 mem, u64 len,
>  						int write_protect)
>  {
> -	int i = 0;
> -	static unsigned char warned;
> -
> -	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
> -	       (i < PNP_MAX_MEM))
> -		i++;
> -	if (i < PNP_MAX_MEM) {
> -		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
> -		if (len <= 0) {
> -			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		if (write_protect == ACPI_READ_WRITE_MEMORY)
> -			res->mem_resource[i].flags |= IORESOURCE_MEM_WRITEABLE;
> -
> -		res->mem_resource[i].start = mem;
> -		res->mem_resource[i].end = mem + len - 1;
> -	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
> -				"resources: %d\n", PNP_MAX_MEM);
> -		warned = 1;
> -	}
> +	struct resource new_res = {
> +		.flags = IORESOURCE_MEM,
> +	};
> +
> +	if (len <= 0) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
> +	}
> +	if (write_protect == ACPI_READ_WRITE_MEMORY)
> +		new_res.flags |= IORESOURCE_MEM_WRITEABLE;
> +
> +	new_res.start = mem;
> +	new_res.end = mem + len - 1;
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
> Index: linux-acpi-2.6/drivers/pnp/pnpbios/rsparser.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/pnpbios/rsparser.c
> +++ linux-acpi-2.6/drivers/pnp/pnpbios/rsparser.c
> @@ -56,78 +56,84 @@ inline void pcibios_penalize_isa_irq(int
>  static void pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res,
>  						int irq)
>  {
> -	int i = 0;
> -
> -	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
> -	       && i < PNP_MAX_IRQ)
> -		i++;
> -	if (i < PNP_MAX_IRQ) {
> -		res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
> -		if (irq == -1) {
> -			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->irq_resource[i].start =
> -		    res->irq_resource[i].end = (unsigned long)irq;
> -		pcibios_penalize_isa_irq(irq, 1);
> +	struct resource new_res = {
> +		.flags = IORESOURCE_IRQ,
> +	};
> +
> +	if (irq == -1) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
>  	}
> +	new_res.start = new_res.end = (unsigned long)irq;
> +	pcibios_penalize_isa_irq(irq, 1);
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res,
>  						int dma)
>  {
> -	int i = 0;
> -
> -	while (i < PNP_MAX_DMA &&
> -	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
> -		i++;
> -	if (i < PNP_MAX_DMA) {
> -		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
> -		if (dma == -1) {
> -			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->dma_resource[i].start =
> -		    res->dma_resource[i].end = (unsigned long)dma;
> +	struct resource new_res = {
> +		.flags = IORESOURCE_DMA,
> +	};
> +
> +	if (dma == -1) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
>  	}
> +	new_res.start = new_res.end = (unsigned long)dma;
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res,
>  					       int io, int len)
>  {
> -	int i = 0;
> -
> -	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
> -	       && i < PNP_MAX_PORT)
> -		i++;
> -	if (i < PNP_MAX_PORT) {
> -		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
> -		if (len <= 0 || (io + len - 1) >= 0x10003) {
> -			res->port_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->port_resource[i].start = (unsigned long)io;
> -		res->port_resource[i].end = (unsigned long)(io + len - 1);
> +	struct resource new_res = {
> +		.flags = IORESOURCE_IO,
> +	};
> +
> +	if (len <= 0 || (io + len - 1) >= 0x10003) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
>  	}
> +	new_res.start = (unsigned long)io;
> +	new_res.end = (unsigned long)(io + len - 1);
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static void pnpbios_parse_allocated_memresource(struct pnp_resource_table *res,
>  						int mem, int len)
>  {
> -	int i = 0;
> -
> -	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
> -	       && i < PNP_MAX_MEM)
> -		i++;
> -	if (i < PNP_MAX_MEM) {
> -		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
> -		if (len <= 0) {
> -			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
> -			return;
> -		}
> -		res->mem_resource[i].start = (unsigned long)mem;
> -		res->mem_resource[i].end = (unsigned long)(mem + len - 1);
> +	struct resource new_res = {
> +		.flags = IORESOURCE_MEM,
> +	};
> +
> +	if (len <= 0) {
> +		/* <trenn> Check: Do we need to allocate and assign
> +		   this resource at all? */
> +		new_res.flags |= IORESOURCE_DISABLED;
> +		if (pnp_assign_resource(res, &new_res))
> +			pnp_err("Bug in %s", __FUNCTION__);
> +		return;
>  	}
> +	new_res.start = (unsigned long)mem;
> +	new_res.end = (unsigned long)(mem + len - 1);
> +	if (pnp_assign_resource(res, &new_res))
> +		pnp_err("Bug in %s", __FUNCTION__);
>  }
>  
>  static unsigned char *pnpbios_parse_allocated_resource_data(unsigned char *p,
> Index: linux-acpi-2.6/drivers/pnp/resource.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/resource.c
> +++ linux-acpi-2.6/drivers/pnp/resource.c
> @@ -242,7 +242,7 @@ int pnp_check_port(struct pnp_dev *dev, 
>  	}
>  
>  	/* check for internal conflicts */
> -	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
> +	for (tmp = 0; pnp_port_valid(dev, tmp) && tmp != idx; tmp++) {
>  		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
>  			tport = &dev->res.port_resource[tmp].start;
>  			tend = &dev->res.port_resource[tmp].end;
> @@ -255,7 +255,7 @@ int pnp_check_port(struct pnp_dev *dev, 
>  	pnp_for_each_dev(tdev) {
>  		if (tdev == dev)
>  			continue;
> -		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
> +		for (tmp = 0; pnp_port_valid(tdev, tmp); tmp++) {
>  			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
>  				if (cannot_compare
>  				    (tdev->res.port_resource[tmp].flags))
> @@ -300,7 +300,7 @@ int pnp_check_mem(struct pnp_dev *dev, i
>  	}
>  
>  	/* check for internal conflicts */
> -	for (tmp = 0; tmp < PNP_MAX_MEM && tmp != idx; tmp++) {
> +	for (tmp = 0; pnp_mem_valid(dev, tmp) && tmp != idx; tmp++) {
>  		if (dev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
>  			taddr = &dev->res.mem_resource[tmp].start;
>  			tend = &dev->res.mem_resource[tmp].end;
> @@ -313,7 +313,7 @@ int pnp_check_mem(struct pnp_dev *dev, i
>  	pnp_for_each_dev(tdev) {
>  		if (tdev == dev)
>  			continue;
> -		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
> +		for (tmp = 0; pnp_mem_valid(tdev, tmp); tmp++) {
>  			if (tdev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
>  				if (cannot_compare
>  				    (tdev->res.mem_resource[tmp].flags))
> @@ -355,7 +355,7 @@ int pnp_check_irq(struct pnp_dev *dev, i
>  	}
>  
>  	/* check for internal conflicts */
> -	for (tmp = 0; tmp < PNP_MAX_IRQ && tmp != idx; tmp++) {
> +	for (tmp = 0; pnp_irq_valid(dev, tmp) && tmp != idx; tmp++) {
>  		if (dev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
>  			if (dev->res.irq_resource[tmp].start == *irq)
>  				return 0;
> @@ -388,7 +388,7 @@ int pnp_check_irq(struct pnp_dev *dev, i
>  	pnp_for_each_dev(tdev) {
>  		if (tdev == dev)
>  			continue;
> -		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
> +		for (tmp = 0; pnp_irq_valid(tdev, tmp); tmp++) {
>  			if (tdev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
>  				if (cannot_compare
>  				    (tdev->res.irq_resource[tmp].flags))
> @@ -424,7 +424,7 @@ int pnp_check_dma(struct pnp_dev *dev, i
>  	}
>  
>  	/* check for internal conflicts */
> -	for (tmp = 0; tmp < PNP_MAX_DMA && tmp != idx; tmp++) {
> +	for (tmp = 0; pnp_dma_valid(dev, tmp) && tmp != idx; tmp++) {
>  		if (dev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
>  			if (dev->res.dma_resource[tmp].start == *dma)
>  				return 0;
> @@ -443,7 +443,7 @@ int pnp_check_dma(struct pnp_dev *dev, i
>  	pnp_for_each_dev(tdev) {
>  		if (tdev == dev)
>  			continue;
> -		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
> +		for (tmp = 0; pnp_dma_valid(tdev, tmp); tmp++) {
>  			if (tdev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
>  				if (cannot_compare
>  				    (tdev->res.dma_resource[tmp].flags))
> Index: linux-acpi-2.6/drivers/pnp/support.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/support.c
> +++ linux-acpi-2.6/drivers/pnp/support.c
> @@ -14,11 +14,16 @@
>   *	resources
>   * @dev: pointer to the desired PnP device
>   */
> +
> +/* <trenn> This interface is only used by pnpbios and one driver:
> +   sound/isa/sscape.c
> +   drivers can check for pnp_port_valid... anyway
> +   This one is not needed.
> +*/
>  int pnp_is_active(struct pnp_dev *dev)
>  {
> -	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
> -	    !pnp_mem_start(dev, 0) && pnp_mem_len(dev, 0) <= 1 &&
> -	    pnp_irq(dev, 0) == -1 && pnp_dma(dev, 0) == -1)
> +	if (dev->res.allocated_ports <= 0 && dev->res.allocated_mems <= 0 &&
> +	    dev->res.allocated_irqs <= 0 && dev->res.allocated_dmas <= 0)
>  		return 0;
>  	else
>  		return 1;
> Index: linux-acpi-2.6/drivers/pnp/system.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/pnp/system.c
> +++ linux-acpi-2.6/drivers/pnp/system.c
> @@ -58,7 +58,7 @@ static void reserve_resources_of_dev(str
>  {
>  	int i;
>  
> -	for (i = 0; i < PNP_MAX_PORT; i++) {
> +	for (i = 0; pnp_port_valid(dev, i); i++) {
>  		if (!pnp_port_valid(dev, i))
>  			continue;
>  		if (pnp_port_start(dev, i) == 0)
> @@ -80,7 +80,7 @@ static void reserve_resources_of_dev(str
>  			      pnp_port_end(dev, i), 1);
>  	}
>  
> -	for (i = 0; i < PNP_MAX_MEM; i++) {
> +	for (i = 0; pnp_mem_valid(dev, i); i++) {
>  		if (!pnp_mem_valid(dev, i))
>  			continue;
>  
> Index: linux-acpi-2.6/include/linux/pnp.h
> ===================================================================
> --- linux-acpi-2.6.orig/include/linux/pnp.h
> +++ linux-acpi-2.6/include/linux/pnp.h
> @@ -13,10 +13,6 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
>  
> -#define PNP_MAX_PORT		40
> -#define PNP_MAX_MEM		12
> -#define PNP_MAX_IRQ		2
> -#define PNP_MAX_DMA		2
>  #define PNP_NAME_LEN		50
>  
>  struct pnp_protocol;
> @@ -26,12 +22,24 @@ struct pnp_dev;
>   * Resource Management
>   */
>  
> -/* Use these instead of directly reading pnp_dev to get resource information */
> -#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
> -#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
> -#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
> -#define pnp_port_valid(dev,bar) \
> -	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
> +/*
> + * NULL pointer alarm: always check with pnp_port_valid or pnp_port_valid before
> + * accessing start/end/flags/len values or you might access not allocated mem.
> + * Same for mem, irq and dma macros
> + *
> + * Pointers are not static and they might change, do not store addresses
> + * of resources in the pnp resource table!
> + */
> +
> +#define pnp_port_start(dev,bar)   (pnp_port_valid((dev),(bar)) ? (dev)->res.port_resource[(bar)].start \
> +				   : pnp_dbg("WARN: Port start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_port_end(dev,bar)     (pnp_port_valid((dev),(bar)) ? (dev)->res.port_resource[(bar)].end \
> +				   : pnp_dbg("WARN: Port end %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_port_flags(dev,bar)   (pnp_port_valid((dev),(bar)) ? (dev)->res.port_resource[(bar)].flags \
> +				    : pnp_dbg("WARN: Port flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_port_valid(dev,bar)	     \
> +	(((dev)->res.allocated_ports > (bar)) &&			\
> +	 (((dev)->res.port_resource[(bar)].flags) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
>  		== IORESOURCE_IO)
>  #define pnp_port_len(dev,bar) \
>  	((pnp_port_start((dev),(bar)) == 0 &&	\
> @@ -41,11 +49,15 @@ struct pnp_dev;
>  	 (pnp_port_end((dev),(bar)) -		\
>  	  pnp_port_start((dev),(bar)) + 1))
>  
> -#define pnp_mem_start(dev,bar)   ((dev)->res.mem_resource[(bar)].start)
> -#define pnp_mem_end(dev,bar)     ((dev)->res.mem_resource[(bar)].end)
> -#define pnp_mem_flags(dev,bar)   ((dev)->res.mem_resource[(bar)].flags)
> +#define pnp_mem_start(dev,bar)   (pnp_mem_valid((dev),(bar)) ? (dev)->res.mem_resource[(bar)].start \
> +				   : pnp_dbg("Mem start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_mem_end(dev,bar)     (pnp_mem_valid((dev),(bar)) ? (dev)->res.mem_resource[(bar)].end \
> +				   : pnp_dbg("Mem end %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_mem_flags(dev,bar)   (pnp_mem_valid((dev),(bar)) ? (dev)->res.mem_resource[(bar)].flags \
> +				    : pnp_dbg("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
>  #define pnp_mem_valid(dev,bar) \
> -	((pnp_mem_flags((dev),(bar)) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
> +	(((dev)->res.allocated_mems > (bar)) && \
> +	 (((dev)->res.mem_resource[(bar)].flags) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
>  		== IORESOURCE_MEM)
>  #define pnp_mem_len(dev,bar) \
>  	((pnp_mem_start((dev),(bar)) == 0 &&	\
> @@ -55,16 +67,22 @@ struct pnp_dev;
>  	 (pnp_mem_end((dev),(bar)) -		\
>  	  pnp_mem_start((dev),(bar)) + 1))
>  
> -#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
> -#define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
> +#define pnp_irq(dev,bar)	 (pnp_irq_valid((dev),(bar)) ? (dev)->res.irq_resource[(bar)].start \
> +				   : pnp_dbg("Irq start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_irq_flags(dev,bar)	 (pnp_irq_valid((dev),(bar)) ? (dev)->res.irq_resource[(bar)].flags \
> +				    : pnp_dbg("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
>  #define pnp_irq_valid(dev,bar) \
> -	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
> +	(((dev)->res.allocated_irqs > (bar)) && \
> +	 (((dev)->res.irq_resource[(bar)].flags) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
>  		== IORESOURCE_IRQ)
>  
> -#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
> -#define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
> +#define pnp_dma(dev,bar)	 (pnp_dma_valid((dev),(bar)) ? (dev)->res.dma_resource[(bar)].start \
> +				   : pnp_dbg("Dma start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
> +#define pnp_dma_flags(dev,bar)	 (pnp_dma_valid((dev),(bar)) ? (dev)->res.dma_resource[(bar)].flags \
> +				    : pnp_dbg("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
>  #define pnp_dma_valid(dev,bar) \
> -	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
> +	(((dev)->res.allocated_dmas > (bar)) && \
> +	 (((dev)->res.dma_resource[(bar)].flags) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
>  		== IORESOURCE_DMA)
>  
>  #define PNP_PORT_FLAG_16BITADDR	(1<<0)
> @@ -119,10 +137,14 @@ struct pnp_option {
>  };
>  
>  struct pnp_resource_table {
> -	struct resource port_resource[PNP_MAX_PORT];
> -	struct resource mem_resource[PNP_MAX_MEM];
> -	struct resource dma_resource[PNP_MAX_DMA];
> -	struct resource irq_resource[PNP_MAX_IRQ];
> +	struct resource *port_resource;
> +	unsigned int allocated_ports;
> +	struct resource *mem_resource;
> +	unsigned int allocated_mems;
> +	struct resource *dma_resource;
> +	unsigned int allocated_dmas;
> +	struct resource *irq_resource;
> +	unsigned int allocated_irqs;
>  };
>  
>  /*
> @@ -364,6 +386,7 @@ int pnp_device_attach(struct pnp_dev *pn
>  void pnp_device_detach(struct pnp_dev *pnp_dev);
>  extern struct list_head pnp_global;
>  extern int pnp_platform_devices;
> +extern int pnp_bios_data_parsed;
>  
>  /* multidevice card support */
>  int pnp_add_card(struct pnp_card *card);
> @@ -398,6 +421,8 @@ int pnp_activate_dev(struct pnp_dev *dev
>  int pnp_disable_dev(struct pnp_dev *dev);
>  void pnp_resource_change(struct resource *resource, resource_size_t start,
>  			 resource_size_t size);
> +int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res);
> +
>  
>  /* protocol helpers */
>  int pnp_is_active(struct pnp_dev *dev);
> @@ -445,6 +470,7 @@ static inline int pnp_stop_dev(struct pn
>  static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
>  static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
>  static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
> +static inline int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res) { }
>  
>  /* protocol helpers */
>  static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
> @@ -460,9 +486,11 @@ static inline void pnp_unregister_driver
>  #define pnp_warn(format, arg...) printk(KERN_WARNING "pnp: " format "\n" , ## arg)
>  
>  #ifdef CONFIG_PNP_DEBUG
> -#define pnp_dbg(format, arg...) printk(KERN_DEBUG "pnp: " format "\n" , ## arg)
> +#define pnp_dbg(format, arg...) printk(KERN_INFO "pnp: " format "\n" , ## arg)
> +void pnp_dump_resources(struct pnp_dev *dev);
>  #else
>  #define pnp_dbg(format, arg...) do {} while (0)
> +static inline void pnp_dump_resources(struct pnp_dev *dev) { }
>  #endif
>  
>  #endif /* __KERNEL__ */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

