Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYCYEET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYCYEET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYCYEEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:04:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:46681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYCYEEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:04:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jack Steiner <steiner@sgi.com>, asit.k.mallick@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: [RFC 4/8] x86_64: Parsing for ACPI "SAPIC" table
Date: Tue, 25 Mar 2008 00:03:32 -0400
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080324182114.GA28060@sgi.com>
In-Reply-To: <20080324182114.GA28060@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803250003.32661.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIR the x2apic scheme entails using the legacy entries for the
first 256 entries, and extended entries for the processors above that, no?

Here we seem to be assuming all lapic or all sapic entries.

-Len


On Monday 24 March 2008, Jack Steiner wrote:
> 
> Add kernel support for new ACPI "sapic" tables that contain 16-bit APICIDs.
> This patch simply adds parsing of an optional SAPIC table if present.
> Otherwise, the traditional local APIC table is used.
> 
> Note: the SAPIC table is not a new ACPI table - it exists on other architectures
> but is not currently recognized by x86_64.
> 
> 
> 	Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> 
> ---
>  arch/x86/kernel/acpi/boot.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/acpi/boot.c	2008-03-21 15:37:05.000000000 -0500
> +++ linux/arch/x86/kernel/acpi/boot.c	2008-03-21 15:40:46.000000000 -0500
> @@ -261,6 +261,24 @@ acpi_parse_lapic(struct acpi_subtable_he
>  }
>  
>  static int __init
> +acpi_parse_sapic(struct acpi_subtable_header *header, const unsigned long end)
> +{
> +	struct acpi_madt_local_sapic *processor = NULL;
> +
> +	processor = (struct acpi_madt_local_sapic *)header;
> +
> +	if (BAD_MADT_ENTRY(processor, end))
> +		return -EINVAL;
> +
> +	acpi_table_print_madt_entry(header);
> +
> +	mp_register_lapic((processor->id << 8) | processor->eid,/* APIC ID */
> +		processor->lapic_flags & ACPI_MADT_ENABLED);	/* Enabled? */
> +
> +	return 0;
> +}
> +
> +static int __init
>  acpi_parse_lapic_addr_ovr(struct acpi_subtable_header * header,
>  			  const unsigned long end)
>  {
> @@ -753,8 +771,12 @@ static int __init acpi_parse_madt_lapic_
>  
>  	mp_register_lapic_address(acpi_lapic_addr);
>  
> -	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC, acpi_parse_lapic,
> -				      MAX_APICS);
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
> +				      acpi_parse_sapic, MAX_APICS);
> +
> +	if (!count)
> +		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
> +					      acpi_parse_lapic, MAX_APICS);
>  	if (!count) {
>  		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
>  		/* TBD: Cleanup to allow fallback to MPS */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


