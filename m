Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYJTVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYJTVf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYJTVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:35:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:47501 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbYJTVfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:35:15 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20081020113602.GA2697@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
	 <20081020113143.GB14097@elte.hu>  <20081020113602.GA2697@elte.hu>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 08:34:43 +1100
Message-Id: <1224538483.7654.162.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static char *phys_addr_string(char *buf, char *end, phys_addr_t *val, int field_width, int precision, int flags)
> +{
> +	/* room for the actual number, the "0x" and the final zero */
> +	char sym[2*sizeof(phys_addr_t) + 2];

Aren't you missing one byte here ?

Cheers,
Ben.

> +	char *p = sym, *pend = sym + sizeof(sym);
> +	int size = 8;
> +
> +	p = number(p, pend, *val, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
> +	*p = 0;
> +
> +	return string(buf, end, sym, field_width, precision, flags);
> +}
> +
>  /*
>   * Show a '%p' thing.  A kernel extension is that the '%p' is followed
>   * by an extra set of alphanumeric characters that are extended format
> @@ -592,6 +605,8 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
>   * - 'S' For symbolic direct pointers
>   * - 'R' For a struct resource pointer, it prints the range of
>   *       addresses (not the name nor the flags)
> + * - 'P' For a phys_addr_t pointer, it prints the physical
> + *       addresses (with a minimum width of 8 characters)
>   *
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
> @@ -607,6 +622,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
>  		return symbol_string(buf, end, ptr, field_width, precision, flags);
>  	case 'R':
>  		return resource_string(buf, end, ptr, field_width, precision, flags);
> +	case 'P':
> +		return phys_addr_string(buf, end, ptr, field_width, precision, flags);
>  	}
>  	flags |= SMALL;
>  	if (field_width == -1) {
> @@ -627,6 +644,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
>   * %pS output the name of a text symbol
>   * %pF output the name of a function pointer
>   * %pR output the address range in a struct resource
> + * %pP output the address in a pointer to a phys_addr_t type
>   *
>   * The return value is the number of characters which would
>   * be generated for the given input, excluding the trailing
> 
> commit 0d391458be88baf3c079e60c3ea331ebe12902c0
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Mon Oct 20 15:07:37 2008 +1100
> 
>     pci: use new %pR to print resource ranges
>     
>     This converts things in drivers/pci to use %pR to printout the
>     content of a struct resource instead of hand-casted %llx or
>     other variants.
>     
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index c9884bb..dbe9f39 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1358,11 +1358,10 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
>  	return 0;
>  
>  err_out:
> -	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region [%#llx-%#llx]\n",
> +	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
>  		 bar,
>  		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
> -		 (unsigned long long)pci_resource_start(pdev, bar),
> -		 (unsigned long long)pci_resource_end(pdev, bar));
> +		 &pdev->resource[bar]);
>  	return -EBUSY;
>  }
>  
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index dd9161a..d3db8b2 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -304,9 +304,8 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  		} else {
>  			res->start = l64;
>  			res->end = l64 + sz64;
> -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> -				pci_name(dev), pos, (unsigned long long)res->start,
> -				(unsigned long long)res->end);
> +			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: %pR\n",
> +				pci_name(dev), pos, res);
>  		}
>  	} else {
>  		sz = pci_size(l, sz, mask);
> @@ -316,9 +315,10 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  
>  		res->start = l;
>  		res->end = l + sz;
> -		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
> -			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
> -			(unsigned long long)res->start, (unsigned long long)res->end);
> +		printk(KERN_DEBUG "PCI: %s reg %x %s: %pR\n",
> +		       pci_name(dev), pos,
> +		       (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
> +		       res);
>  	}
>  
>   out:
> @@ -389,9 +389,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
>  			res->start = base;
>  		if (!res->end)
>  			res->end = limit + 0xfff;
> -		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
> -			pci_name(dev), (unsigned long long) res->start,
> -			(unsigned long long) res->end);
> +		printk(KERN_DEBUG "PCI: bridge %s io port: %pR\n",
> +		       pci_name(dev), res);
>  	}
>  
>  	res = child->resource[1];
> @@ -403,9 +402,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
>  		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
>  		res->start = base;
>  		res->end = limit + 0xfffff;
> -		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
> -			pci_name(dev), (unsigned long long) res->start,
> -			(unsigned long long) res->end);
> +		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: %pR\n",
> +		       pci_name(dev), res);
>  	}
>  
>  	res = child->resource[2];
> @@ -441,9 +439,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
>  		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
>  		res->start = base;
>  		res->end = limit + 0xfffff;
> -		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
> -			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
> -			(unsigned long long) res->start, (unsigned long long) res->end);
> +		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: %pR\n",
> +		       pci_name(dev),
> +		       (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64":"32", res);
>  	}
>  }
>  
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index d5e2106..471a429 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -356,10 +356,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
>  			order = __ffs(align) - 20;
>  			if (order > 11) {
>  				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
> -				       "%#016llx-%#016llx\n", i,
> -				       (unsigned long long)align,
> -				       (unsigned long long)r->start,
> -				       (unsigned long long)r->end);
> +					 "%pR\n", i, (unsigned long long)align, r);
>  				r->flags = 0;
>  				continue;
>  			}
> @@ -539,11 +536,9 @@ static void pci_bus_dump_res(struct pci_bus *bus)
>                  if (!res)
>                          continue;
>  
> -		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
> -			bus->number, i,
> -			(res->flags & IORESOURCE_IO) ? "io port" : "mmio",
> -			(unsigned long long) res->start,
> -			(unsigned long long) res->end);
> +		printk(KERN_INFO "bus: %02x index %x %s: %pR\n",
> +		       bus->number, i,
> +		       (res->flags & IORESOURCE_IO) ? "io port" : "mmio", res);
>          }
>  }
>  
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 1a5fc83..d4b5c69 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -49,10 +49,8 @@ void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
>  
>  	pcibios_resource_to_bus(dev, &region, res);
>  
> -	dev_dbg(&dev->dev, "BAR %d: got res [%#llx-%#llx] bus [%#llx-%#llx] "
> -		"flags %#lx\n", resno,
> -		 (unsigned long long)res->start,
> -		 (unsigned long long)res->end,
> +	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
> +		"flags %#lx\n", resno, res,
>  		 (unsigned long long)region.start,
>  		 (unsigned long long)region.end,
>  		 (unsigned long)res->flags);
> @@ -114,13 +112,11 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
>  		err = insert_resource(root, res);
>  
>  	if (err) {
> -		dev_err(&dev->dev, "BAR %d: %s of %s [%#llx-%#llx]\n",
> +		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
>  			resource,
>  			root ? "address space collision on" :
>  				"no parent found for",
> -			dtype,
> -			(unsigned long long)res->start,
> -			(unsigned long long)res->end);
> +			dtype, res);
>  	}
>  
>  	return err;
> @@ -139,9 +135,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	align = resource_alignment(res);
>  	if (!align) {
>  		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
> -			"alignment) [%#llx-%#llx] flags %#lx\n",
> -			resno, (unsigned long long)res->start,
> -			(unsigned long long)res->end, res->flags);
> +			"alignment) %pR flags %#lx\n",
> +			resno, res, res->flags);
>  		return -EINVAL;
>  	}
>  
> @@ -162,11 +157,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	}
>  
>  	if (ret) {
> -		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
> -			"[%#llx-%#llx]\n", resno,
> -			res->flags & IORESOURCE_IO ? "I/O" : "mem",
> -			(unsigned long long)res->start,
> -			(unsigned long long)res->end);
> +		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
> +			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
>  	} else {
>  		res->flags &= ~IORESOURCE_STARTALIGN;
>  		if (resno < PCI_BRIDGE_RESOURCES)
> @@ -202,11 +194,8 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
>  	}
>  
>  	if (ret) {
> -		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
> -			"[%#llx-%#llx\n]", resno,
> -			res->flags & IORESOURCE_IO ? "I/O" : "mem",
> -			(unsigned long long)res->start,
> -			(unsigned long long)res->end);
> +		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
> +			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
>  	} else if (resno < PCI_BRIDGE_RESOURCES) {
>  		pci_update_resource(dev, res, resno);
>  	}
> @@ -237,9 +226,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
>  		r_align = resource_alignment(r);
>  		if (!r_align) {
>  			dev_warn(&dev->dev, "BAR %d: bogus alignment "
> -				"[%#llx-%#llx] flags %#lx\n",
> -				i, (unsigned long long)r->start,
> -				(unsigned long long)r->end, r->flags);
> +				"%pR flags %#lx\n",
> +				i, r, r->flags);
>  			continue;
>  		}
>  		for (list = head; ; list = list->next) {
> @@ -287,9 +275,7 @@ int pci_enable_resources(struct pci_dev *dev, int mask)
>  
>  		if (!r->parent) {
>  			dev_err(&dev->dev, "device not available because of "
> -				"BAR %d [%#llx-%#llx] collisions\n", i,
> -				(unsigned long long) r->start,
> -				(unsigned long long) r->end);
> +				"BAR %d %pR collisions\n", i, r);
>  			return -EINVAL;
>  		}
>  
> 
> commit c21f132b1eca94808fe72b31aa159c7f0ad61d25
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Oct 20 15:07:34 2008 +1100
> 
>     vsprintf: implement %pR to print struct resource content
>     
>     Add a %pR option to the kernel vsnprintf that prints the range of
>     addresses inside a struct resource passed by pointer.
>     
>     Padding now defaults to 4 digits for IO and 8 for MEM
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index cceecb6..a013bbc 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -24,6 +24,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kallsyms.h>
>  #include <linux/uaccess.h>
> +#include <linux/ioport.h>
>  
>  #include <asm/page.h>		/* for PAGE_SIZE */
>  #include <asm/div64.h>
> @@ -550,18 +551,51 @@ static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int
>  #endif
>  }
>  
> +static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
> +{
> +#ifndef IO_RSRC_PRINTK_SIZE
> +#define IO_RSRC_PRINTK_SIZE	4
> +#endif
> +
> +#ifndef MEM_RSRC_PRINTK_SIZE
> +#define MEM_RSRC_PRINTK_SIZE	8
> +#endif
> +
> +	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
> +	char sym[4*sizeof(resource_size_t) + 8];
> +	char *p = sym, *pend = sym + sizeof(sym);
> +	int size = -1;
> +
> +	if (res->flags & IORESOURCE_IO)
> +		size = IO_RSRC_PRINTK_SIZE;
> +	else if (res->flags & IORESOURCE_MEM)
> +		size = MEM_RSRC_PRINTK_SIZE;
> +
> +	*p++ = '[';
> +	p = number(p, pend, res->start, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
> +	*p++ = '-';
> +	p = number(p, pend, res->end, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
> +	*p++ = ']';
> +	*p = 0;
> +
> +	return string(buf, end, sym, field_width, precision, flags);
> +}
> +
>  /*
>   * Show a '%p' thing.  A kernel extension is that the '%p' is followed
>   * by an extra set of alphanumeric characters that are extended format
>   * specifiers.
>   *
> - * Right now we just handle 'F' (for symbolic Function descriptor pointers)
> - * and 'S' (for Symbolic direct pointers), but this can easily be
> - * extended in the future (network address types etc).
> + * Right now we handle:
> + *
> + * - 'F' For symbolic function descriptor pointers
> + * - 'S' For symbolic direct pointers
> + * - 'R' For a struct resource pointer, it prints the range of
> + *       addresses (not the name nor the flags)
>   *
> - * The difference between 'S' and 'F' is that on ia64 and ppc64 function
> - * pointers are really function descriptors, which contain a pointer the
> - * real address. 
> + * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
> + * function pointers are really function descriptors, which contain a
> + * pointer to the real address.
>   */
>  static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
>  {
> @@ -571,6 +605,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
>  		/* Fallthrough */
>  	case 'S':
>  		return symbol_string(buf, end, ptr, field_width, precision, flags);
> +	case 'R':
> +		return resource_string(buf, end, ptr, field_width, precision, flags);
>  	}
>  	flags |= SMALL;
>  	if (field_width == -1) {
> @@ -590,6 +626,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
>   * This function follows C99 vsnprintf, but has some extensions:
>   * %pS output the name of a text symbol
>   * %pF output the name of a function pointer
> + * %pR output the address range in a struct resource
>   *
>   * The return value is the number of characters which would
>   * be generated for the given input, excluding the trailing

