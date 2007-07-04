Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXGDJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXGDJTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGDJTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:19:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45285 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbXGDJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:19:11 -0400
Subject: Re: [Intel IOMMU 01/10] DMAR detection and parsing logic
From: Peter Zijlstra <peterz@infradead.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com
In-Reply-To: <20070619213808.398170000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.398170000@askeshav-devel.jf.intel.com>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 11:18:56 +0200
Message-Id: <1183540736.7054.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 14:37 -0700, Keshavamurthy, Anil S wrote:
> plain text document attachment (dmar_detection.patch)

> +/**
> + * parse_dmar_table - parses the DMA reporting table
> + */
> +static int __init
> +parse_dmar_table(void)
> +{
> +	struct acpi_table_dmar *dmar;
> +	struct acpi_dmar_header *entry_header;
> +	int ret = 0;
> +
> +	dmar = (struct acpi_table_dmar *)dmar_tbl;
> +
> +	if (!dmar->width) {
          ^^^^^^^^^^^^^^^^^^^

That goes *splat* on my opteron box.

> +		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
> +		return -EINVAL;
> +	}
> +
> +	printk (KERN_INFO PREFIX "Host address width %d\n",
> +		dmar->width + 1);
> +
> +	entry_header = (struct acpi_dmar_header *)(dmar + 1);
> +	while (((unsigned long)entry_header) <
> +			(((unsigned long)dmar) + dmar_tbl->length)) {
> +		dmar_table_print_dmar_entry(entry_header);
> +
> +		switch (entry_header->type) {
> +		case ACPI_DMAR_TYPE_HARDWARE_UNIT:
> +			ret = dmar_parse_one_drhd(entry_header);
> +			break;
> +		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
> +			ret = dmar_parse_one_rmrr(entry_header);
> +			break;
> +		default:
> +			printk(KERN_WARNING PREFIX
> +				"Unknown DMAR structure type\n");
> +			ret = 0; /* for forward compatibility */
> +			break;
> +		}
> +		if (ret)
> +			break;
> +
> +		entry_header = ((void *)entry_header + entry_header->length);
> +	}
> +	return ret;
> +}
> +

