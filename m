Return-Path: <linux-kernel-owner+w=401wt.eu-S934627AbXHOWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627AbXHOWDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbXHOWDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:03:08 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:39584 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbXHOWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:03:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH] (for review and testing first) Implement dynamic allocated array for pnp port/io resources
Date: Wed, 15 Aug 2007 16:01:15 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, abelay@novell.com,
       Andi Kleen <ak@suse.de>, linux-acpi <linux-acpi@vger.kernel.org>
References: <1187186605.8780.669.camel@queen.suse.de>
In-Reply-To: <1187186605.8780.669.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708151601.16136.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2007 08:03:24 am Thomas Renninger wrote:
> This is not a real feature, more a fix.
> Without, PNP IO ports might not get considered. This mainly affects ACPI
> system board devices with HID PNP0C02 (at least I saw this on my and
> some other machines, but it may affect more...).

I think this is definitely the way we should go and a great start.
Thanks a lot for working on this.

> ...
> I expect this is a bit late for 2.6.23?

I think it is too late for 2.6.23, since the problem is not a
regression from 2.6.22.

> We have several options here for 2.6.23:
>   - leave it as it is

I certainly agree that your patch is something we need to do, but
I vote for leaving it as-is for 2.6.23, because I can't think of a
specific problem it would fix.

> ...
>   - Add Bjorn's "Increase statically used IRQ ports from 2 to 4" should
>     be added anyway IMO. This one is really safe, it's here;
>     http://lkml.org/lkml/2007/7/17/335

Increasing IRQs is safe, but of less value than the I/O ports.  AFAIK,
nobody needs more than 2 IRQs at the moment.  I want to increase it so
I can convert hpet from an ACPI driver to a PNP driver, but there's no
hurry for that.

> Some parts where a reviewer should have a closer eye on:
>   - the border limits (got a '>' mixed up with a '>=' or similar)
>   - I removed or better let pnp_init_resource_table invoke
>     pnp_clean_resource_table as the only difference between those was 
>     the additional NULL assignment to the name. Can this really be
>     removed or was this in any way useful :)

pnp_init_resource_table() used to set resource.name = NULL.  I don't
see where that will happen now, and since you use kmalloc/krealloc,
I think we should completely initialize the allocated space.

>   - locking: Andi made me a bit nervous about locking. As I didn't
>     modify much in the design/structure of how it currently is done,
>     I don't expect simultaneous access to the port resource data
>     can happen and additional locking should not be needed,
>     but I am not sure about it.

It's a good thing to think about, but I agree that I don't think you
introduced any additional problems here.

>   - Only field tested with pnpacpi

You removed PNP_MAX_PORT, but ISAPNP still needs it.  Unlike PNPBIOS and
ACPI, the ISAPNP spec does limit the number of resources.  So you might
want to add an ISAPNP_MAX_PORT or similar when you fix up ISAPNP.

> I saw recent Lindentation patches for pnp. I expect they came in after
> -rc2?

You patch applies fine against current upstream, which includes the
Lindent patches you saw (I posted a couple more today, which cause
one conflict with your patch).  But your patch adds a few more Lindent
issues :-)  Extra blank lines, spaces between function name and open
paren, lack of space between function arguments, etc.


> +static void pnp_init_port (struct pnp_resource_table *res, int idx)
> +{
> +	if (idx < res->allocated_ports) {
> +		(res->port_resource + idx)->start = 0;
> +		(res->port_resource + idx)->end = 0;
> +		(res->port_resource + idx)->flags =
> +			IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
> +	}

How about:

  static void pnp_init_port(struct resource *res)
  {
	res->start = 0;
	...
  }

and adjusting the caller?  Then you don't have to check against
allocated_ports both here and in the caller.  Or maybe just fold
into the only call site.

> +			pnp_err ("%s: Cannot allocate port", __FUNCTION__);
> +			/* pretend we were successful so at least the manager won't try again */
> +			return 1;

When this fails, it would be nice if the error message included the
associated device.

>  	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
> +	if (!(pnp_port_flags(dev,idx) & IORESOURCE_AUTO))
>  		return 1;
>  
> -	start = &dev->res.port_resource[idx].start;
> -	end = &dev->res.port_resource[idx].end;
> -	flags = &dev->res.port_resource[idx].flags;
> +	start = &pnp_port_start(dev,idx);
> +	end = &pnp_port_end(dev,idx);
> +	flags = &pnp_port_flags(dev,idx);

I like these changes, but they're really independent of the dynamic
allocation, aren't they?  Maybe a separate patch.

> +#define pnp_port_res_pointer(dev,bar)	((dev->res.allocated_ports > bar) \
> +	? (dev->res.port_resource + bar) : NULL)

Maybe just "pnp_port_resource(dev,bar)"?

> +#define pnp_port_start(dev,bar)		((dev->res.port_resource + bar)->start)

Is it safe to remove the parentheses around "dev" and "bar"?  My
personal preference is for array syntax, e.g.,
  dev->res.port_resource[bar]->start

> +static inline pnp_port_alloc(struct pnp_resource_table *res_table) { return -ENODEV }

Missing return type.

> --- linux-2.6.23-rc2.orig/drivers/pnp/pnpbios/rsparser.c
> +++ linux-2.6.23-rc2/drivers/pnp/pnpbios/rsparser.c
> @@ -97,18 +97,31 @@ static void pnpbios_parse_allocated_iore
>  {
>  	int i = 0;
> ...

These functions (pnpbios_parse_allocated_ioresource() and
pnpacpi_parse_allocated_ioresource()) are almost identical between
PNPBIOS and PNPACPI.  What would it take to factor out this
duplicated code into a pnp_add_port() sort of function?  Maybe
could be a separate patch.


