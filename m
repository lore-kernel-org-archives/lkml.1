Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZFWMTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZFWMTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFWMSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:18:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZFWMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:18:42 -0400
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] SFI: add ACPI extensions
From: Andi Kleen <andi@firstfloor.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<505434cf34f7438a65262060df88b0638511684d.1245740912.git.len.brown@intel.com>
Date: Tue, 23 Jun 2009 14:18:42 +0200
In-Reply-To: <505434cf34f7438a65262060df88b0638511684d.1245740912.git.len.brown@intel.com> (Len Brown's message of "Tue, 23 Jun 2009 03:14:04 -0400")
Message-ID: <87my7z16u5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:
>
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 646d39c..921746f 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -277,6 +277,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
>  	struct acpi_table_header *table = NULL;
>  	acpi_size tbl_size;
>  
> +	if (acpi_disabled)
> +		return 1;
> +

This seems like a weird place to hook this in. Shouldn't that be somewhere else, more
high level?


> +#include <linux/acpi.h>
> +#include <linux/kernel.h>
> +#include <linux/sfi.h>
> +#include "sfi_core.h"
> +
> +#undef PREFIX

Nobody should set PREFIX in headers? If they do better fix the headers.


> + * sfi_acpi_parse_xsdt()
> + *
> + * Parse the ACPI XSDT for later access by sfi_acpi_table_parse().
> + */
> +static int __init sfi_acpi_parse_xsdt(struct sfi_table_header *table)
> +{
> +	int num_entries, i;
> +
> +	struct acpi_table_xsdt *xsdt = (struct acpi_table_xsdt *) table;
> +
> +	BUG_ON(!xsdt);


Seems like a pointless BUG_ON, the NULL pointer reference next to it is
obvious enough.

> +
> +	num_entries = (xsdt->header.length - sizeof(struct acpi_table_header) /
> +		sizeof(u64));
> +
> +	pr_debug(PREFIX "XSDT has %d entries\n", num_entries);
> +
> +	for (i = 0; i < num_entries; i++)
> +		sfi_tb_install_table(xsdt->table_offset_entry[i], SFI_ACPI_TABLE);

Shouldn't this have some more sanity checking, e.g. for overflows?


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
