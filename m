Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZGJHk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZGJHk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZGJHkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:40:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZGJHks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:40:48 -0400
Date: Fri, 10 Jul 2009 09:40:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 05/12] SFI: add core support
Message-ID: <20090710074028.GI22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <10fb28adc204382cb3b1acc99eabbb369d378a0f.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10fb28adc204382cb3b1acc99eabbb369d378a0f.1247025117.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> drivers/sfi/sfi_core.c contains the generic SFI implementation.
> It has a private header, sfi_core.h, for its own use and the
> private use of future files in drivers/sfi/
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/Makefile       |    1 +
>  drivers/sfi/Makefile   |    1 +
>  drivers/sfi/sfi_core.c |  385 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/sfi/sfi_core.h |   44 ++++++
>  4 files changed, 431 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/sfi/Makefile
>  create mode 100644 drivers/sfi/sfi_core.c
>  create mode 100644 drivers/sfi/sfi_core.h
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index bc4205d..ccfa259 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
>  obj-y				+= video/
>  obj-$(CONFIG_ACPI)		+= acpi/
> +obj-$(CONFIG_SFI)		+= sfi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
>  # was used and do nothing if so
>  obj-$(CONFIG_PNP)		+= pnp/
> diff --git a/drivers/sfi/Makefile b/drivers/sfi/Makefile
> new file mode 100644
> index 0000000..f176470
> --- /dev/null
> +++ b/drivers/sfi/Makefile
> @@ -0,0 +1 @@
> +obj-y	+= sfi_core.o
> diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
> new file mode 100644
> index 0000000..f9a9849
> --- /dev/null
> +++ b/drivers/sfi/sfi_core.c
> @@ -0,0 +1,385 @@
> +/* sfi_core.c Simple Firmware Interface - core internals */
> +
> +/*
> + * Copyright (C) 2009, Intel Corp.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> + *    substantially similar to the "NO WARRANTY" disclaimer below
> + *    ("Disclaimer") and any redistribution must be conditioned upon
> + *    including a substantially similar Disclaimer requirement for further
> + *    binary redistribution.
> + * 3. Neither the names of the above-listed copyright holders nor the names
> + *    of any contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2 as published by the Free
> + * Software Foundation.
> + *
> + * NO WARRANTY
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> + * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + * POSSIBILITY OF SUCH DAMAGES.
> + */
> +
> +#define KMSG_COMPONENT "SFI"
> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> +
> +#include <linux/bootmem.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/acpi.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/smp.h>
> +#include <linux/sfi.h>
> +
> +#include <asm/pgtable.h>
> +
> +#include "sfi_core.h"
> +
> +#define ON_SAME_PAGE(addr1, addr2) \
> +	(((unsigned long)(addr1) & PAGE_MASK) == \
> +	((unsigned long)(addr2) & PAGE_MASK))
> +#define TABLE_ON_PAGE(page, table, size) (ON_SAME_PAGE(page, table) && \
> +				ON_SAME_PAGE(page, table + size))

these two should be written in C, not CPP.

> +int sfi_disabled __read_mostly;
> +EXPORT_SYMBOL(sfi_disabled);
> +
> +static u64 syst_pa __read_mostly;
> +static struct sfi_table_simple *syst_va __read_mostly;
> +
> +/*
> + * FW creates and saves the SFI tables in memory. When these tables get
> + * used, they may need to be mapped to virtual address space, and the mapping
> + * can happen before or after the ioremap() is ready, so a flag is needed
> + * to indicating this
> + */
> +static u32 sfi_use_ioremap __read_mostly;
> +
> +static void __iomem *sfi_map_memory(u64 phys, u32 size)
> +{
> +	if (!phys || !size)
> +		return NULL;
> +
> +	if (sfi_use_ioremap)
> +		return ioremap(phys, size);
> +	else
> +		return early_ioremap(phys, size);
> +}
> +
> +static void sfi_unmap_memory(void __iomem *virt, u32 size)
> +{
> +	if (!virt || !size)
> +		return;
> +
> +	if (sfi_use_ioremap)
> +		iounmap(virt);
> +	else
> +		early_iounmap(virt, size);
> +}
> +
> +static void sfi_print_table_header(unsigned long long pa,
> +				struct sfi_table_header *header)
> +{
> +	pr_info("%4.4s %llX, %04X (v%d %6.6s %8.8s)\n",
> +		header->signature, pa,
> +		header->length, header->revision, header->oem_id,
> +		header->oem_table_id);
> +}
> +
> +/*
> + * sfi_verify_table()
> + * sanity check table lengh, calculate checksum
> + */
> +static __init int sfi_verify_table(struct sfi_table_header *table)
> +{
> +
> +	u8 checksum = 0;
> +	u8 *puchar = (u8 *)table;
> +	u32 length = table->length;
> +
> +	/* Sanity check table length against arbitrary 1MB limit */
> +	if (length > 0x100000) {
> +		pr_err("Invalid table length 0x%x\n", length);
> +		return -1;
> +	}
> +
> +	while (length--)
> +		checksum += *puchar++;
> +
> +	if (checksum) {
> +		pr_err("Checksum %2.2X should be %2.2X\n",
> +			table->checksum, table->checksum - checksum);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * sfi_map_table()
> + *
> + * Return address of mapped table
> + * Check for common case that we can re-use mapping to SYST,
> + * which requires syst_pa, syst_va to be initialized.
> + */
> +struct sfi_table_header *sfi_map_table(u64 pa)
> +{
> +	struct sfi_table_header *th;
> +	u32 length;
> +
> +	if (!TABLE_ON_PAGE(syst_pa, pa, sizeof(struct sfi_table_header)))
> +		th = sfi_map_memory(pa, sizeof(struct sfi_table_header));
> +	else
> +		th = (void *)syst_va - (syst_pa - pa);

The '- (syst_pa - pa)' arithmetics is correct but rather unreadable 
- it should be something like:

		th = (void *)syst_va + (pa - syst_pa);

To show that we return an offset into the SYST table - instead of 
the double negation.

> +
> +	 /* If table fits on same page as its header, we are done */
> +	if (TABLE_ON_PAGE(th, th, th->length))
> +		return th;
> +
> +	/* entire table does not fit on same page as SYST */

Nit: please capitalize comments consistently, by starting them with 
a capital letter.

> +	length = th->length;
> +	if (!TABLE_ON_PAGE(syst_pa, pa, sizeof(struct sfi_table_header)))
> +		sfi_unmap_memory(th, sizeof(struct sfi_table_header));
> +
> +	return sfi_map_memory(pa, length);

tricky.

> +}
> +
> +/*
> + * sfi_unmap_table()
> + *
> + * undoes effect of sfi_map_table() by unmapping table
> + * if it did not completely fit on same page as SYST.
> + */
> +void sfi_unmap_table(struct sfi_table_header *th)
> +{
> +	if (!TABLE_ON_PAGE(syst_va, th, th->length))
> +		sfi_unmap_memory(th, TABLE_ON_PAGE(th, th, th->length) ?
> +					sizeof(*th) : th->length);
> +}
> +
> +/*
> + * sfi_get_table()
> + *
> + * Search SYST for the specified table.
> + * return the mapped table
> + */
> +static struct sfi_table_header *sfi_get_table(char *signature, char *oem_id,
> +		char *oem_table_id, unsigned int flags)
> +{
> +	struct sfi_table_header *th;
> +	u32 tbl_cnt, i;
> +
> +	tbl_cnt = SFI_GET_NUM_ENTRIES(syst_va, u64);
> +
> +	for (i = 0; i < tbl_cnt; i++) {
> +		th = sfi_map_table(syst_va->pentry[i]);
> +		if (!th)
> +			return NULL;
> +
> +		if (strncmp(th->signature, signature, SFI_SIGNATURE_SIZE))
> +			goto loop_continue;
> +
> +		if (oem_id && strncmp(th->oem_id, oem_id, SFI_OEM_ID_SIZE))
> +			goto loop_continue;
> +
> +		if (oem_table_id && strncmp(th->oem_table_id, oem_table_id,
> +						SFI_OEM_TABLE_ID_SIZE))
> +			goto loop_continue;
> +
> +		return th;	/* success */
> +loop_continue:
> +		sfi_unmap_table(th);
> +	}
> +
> +	return NULL;
> +}

This loop should be cleaned up in the same fashion as i suggested 
for sfi_acpi_get_table().

> +
> +void sfi_put_table(struct sfi_table_header *table)
> +{
> +	if (!ON_SAME_PAGE(((void *)table + table->length),
> +		(void *)syst_va + syst_va->header.length)
> +		&& !ON_SAME_PAGE(table, syst_va))
> +		sfi_unmap_memory(table, table->length);

syst_va should probably be a void * to begin with - that avoids the 
second cast.

I'm quite uneasy about the many open-coded ON_SAME_PAGE() 
conditions. That logic should perhaps be in sfi_map/unmap_memory() 
instead? (with an additional 'finegrained_len' argument to it or 
so.)

> +}
> +
> +/* find table with signature, run handler on it */
> +int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
> +			unsigned int flags, sfi_table_handler handler)
> +{
> +	int ret = 0;
> +	struct sfi_table_header *table = NULL;
> +
> +	if (sfi_disabled || !handler || !signature)
> +		return -EINVAL;
> +
> +	table = sfi_get_table(signature, oem_id, oem_table_id, flags);
> +	if (!table)
> +		return -EINVAL;
> +
> +	ret = handler(table);
> +	sfi_put_table(table);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sfi_table_parse);

the error conditions could be written cleaner and shorter as:

int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
			unsigned int flags, sfi_table_handler handler)
{
	struct sfi_table_header *table = NULL;
	int ret = -EINVAL;

	if (sfi_disabled || !handler || !signature)
		goto err;

	table = sfi_get_table(signature, oem_id, oem_table_id, flags);
	if (!table)
		goto err;

	ret = handler(table);
	sfi_put_table(table);
err:
	return ret;
}

Thanks,

	Ingo
