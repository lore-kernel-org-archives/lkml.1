Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXGMQ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXGMQ6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXGMQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:58:45 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:52116 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXGMQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:58:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH - 2/2] Identify native drivers and ACPI subsystem accessing the same resources - Main implementation
Date: Fri, 13 Jul 2007 10:58:11 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, akpm <akpm@linux-foundation.org>
References: <1184331563.3960.107.camel@d88.suse.de>
In-Reply-To: <1184331563.3960.107.camel@d88.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131058.11413.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a number of minor formatting issues:
    - often missing a space before "{", e.g., "struct ioport_res_list{",
      "if (foo){", "else{"
    - use "} else {" rather than "else" on a new line
    - no space between function name and "(", e.g., "dprintk ("
    - block comments missing leading "*" on each line
    - remove blank lines after opening "{" of function, e.g.,
      acpi_enforce_resources_setup()

On Friday 13 July 2007 06:59:23 am Thomas Renninger wrote:
> ...
> +#if 1
> +#define dprintk printk   /* debug */
> +#else
> +#define dprintk(format,args...)
> +#endif

Another printk wrapper ... can you use pr_debug() or some other
already existing one?

> +int acpi_request_region (resource_size_t addr, unsigned int length,
> +			 const char *desc, unsigned int port)
> +{
> +	struct resource *par_res = NULL;
> +	struct resource *new_res;
> +	struct ioport_res_list *io_res_list;
> +
> +	new_res = (struct resource*) kzalloc(sizeof (struct resource), GFP_KERNEL);

No cast needed.

>  static int __init acpi_reserve_resources(void)
>  {
> -	acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block, acpi_gbl_FADT.pm1_event_length,
> -		"ACPI PM1a_EVT_BLK");
> +	acpi_request_region(acpi_gbl_FADT.xpm1a_event_block.address, acpi_gbl_FADT.pm1_event_length,
> +		"ACPI PM1a_EVT_BLK", 1);

Oops, this throws away the information that these regions might be
SYSTEM_MEMORY rather than SYSTEM_IO.

> @@ -1220,15 +1372,90 @@ acpi_status
>  acpi_os_validate_address (
>      u8                   space_id,
>      acpi_physical_address   address,
> -    acpi_size               length)
> +    acpi_size               length,
> +    char *name)
>  {

This function no longer just validates an address.  One should be able to
call a function named "validate_address" many times, without worrying about
leaking memory.  So this needs a new name or different behavior.

(I think it was a poor interface to begin with -- even if it merely
validates the address, it should be called something like
"acpi_os_valid_address()" and return a boolean.)

> +	char *buf;
> +	struct ioport_res_list *res;
> +
> +	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
> +		return AE_OK;
> +
> +	/*
> +	   This will never ever get freed again...
> +	   This could get a problem for dynamic table allocation/removal
> +	   with SSDTs, needs to be handled at later time.
> +	*/
> +	res = (struct ioport_res_list*) kzalloc(sizeof(struct ioport_res_list), GFP_KERNEL);
> +	buf = (char*)kzalloc(strlen(name) + 6, GFP_KERNEL);

No casts needed for kzalloc.

> -    return AE_OK;
> +	if(!buf || !res)
> +		return AE_OK;
> +
> +	res->res.name = buf;
> +	res->res.start = address;
> +	res->res.end = address + length - 1;
> +
> +	sprintf (buf, "ACPI %s", name);
> +	switch (space_id){
> +	case ACPI_ADR_SPACE_SYSTEM_IO:
> +		res->res.flags |= IORESOURCE_IO;
> +		list_add(&res->res_list, &ioport_res_list);
> +		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
> +			res->res.flags |= IORESOURCE_BUSY;
> +		else if (acpi_enforce_resources == ENFORCE_RESOURCES_LAX)
> +			res->res.flags |= IORESOURCE_SHARED;
> +		if (insert_resource(&ioport_resource, &res->res))
> +			printk(KERN_ERR "Could not insert resource: %s\n",
> +			       res->res.name);
> +		else
> +			dprintk ("Added %s %s: IO reg: start: %lX, end: %lX, "
> +				 "name: %s\n",
> +				 (res->res.flags & IORESOURCE_SHARED)
> +				 ? "sharable" : "",
> +				 (res->res.flags & IORESOURCE_BUSY)
> +				 ? "busy" : "",
> +				 (long unsigned int)res->res.start,
> +				 (long unsigned int)res->res.end,
> +				 res->res.name);
> +		break;
> +

acpi_os_validate_address() does not seem like the right interface to be
mucking about requesting resources.  That should be done when we enumerate
devices and when drivers claim devices.

> -static int dmi_osi_not_linux(struct dmi_system_id *d)
> +	static int dmi_osi_not_linux(struct dmi_system_id *d)

Looks like an extra tab snuck in above.

> +#define IORESOURCE_SHARED	0x00100000	/* This IO address appears in ACPI namespace */

This comment should tell me the semantics of IORESOURCE_SHARED, but
doesn't.

> @@ -80,11 +80,12 @@ static int r_show(struct seq_file *m, vo
>  	for (depth = 0, p = r; depth < MAX_IORES_LEVEL; depth++, p = p->parent)
>  		if (p->parent == root)
>  			break;
> -	seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
> +	seq_printf(m, "%*s%0*llx-%0*llx : %s%s - %p\n",
>  			depth * 2, "",
>  			width, (unsigned long long) r->start,
>  			width, (unsigned long long) r->end,
> -			r->name ? r->name : "<BAD>");
> +			r->name ? r->name : "<BAD>", r->flags &
> +		        IORESOURCE_SHARED ? "*" : "",r);

This looks like debugging (at least the extra pointer).  It's
not clear to me that adding a "*" in /proc/io{mem,ports} for these
"shared" resources is a good idea.  I don't think that's something
we want to expose to userspace.

> +++ linux-2.6.22.1/drivers/pnp/system.c
> @@ -22,21 +22,18 @@ static const struct pnp_device_id pnp_de
>  	{	"",			0	}
>  };
>  
> -static void reserve_range(const char *pnpid, resource_size_t start, resource_size_t end, int port)
> +int pnp_reserve_range(resource_size_t start, unsigned int length,
> +		  const char *pnpid, int port)

Since you're using pnp_reserve_range() as a generic PNP service, it should
be moved from the system.c driver to a generic PNP location, like support.c
or resource.c.

