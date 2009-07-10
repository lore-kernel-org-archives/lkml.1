Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZGJGLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZGJGLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZGJGLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:11:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59594 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGJGLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:11:01 -0400
Date: Fri, 10 Jul 2009 08:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 09/12] SFI: Enable SFI to parse ACPI tables
Message-ID: <20090710061051.GE22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <5ab9dd34acc6209c5b6a3c754075e408e5298a2d.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ab9dd34acc6209c5b6a3c754075e408e5298a2d.1247025117.git.len.brown@intel.com>
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

> +++ b/drivers/sfi/sfi_acpi.c

> +static struct acpi_table_xsdt *xsdt_va;

Should be __read_mostly.

> +static struct acpi_table_header *sfi_acpi_get_table(char *signature,
> +			char *oem_id, char *oem_table_id, unsigned int flags)
> +{
> +	struct acpi_table_header *th;
> +	u32 tbl_cnt, i;
> +	u64 pa;
> +
> +	tbl_cnt = XSDT_GET_NUM_ENTRIES(xsdt_va, u64);
> +
> +	for (i = 0; i < tbl_cnt; i++) {
> +		pa = xsdt_va->table_offset_entry[i];
> +
> +		th = (struct acpi_table_header *)sfi_map_table(pa);
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
> +		return th;      /* success */
> +loop_continue:
> +		sfi_unmap_table((struct sfi_table_header *)th);
> +	}
> +
> +	return NULL;

That loop looks weird and non-standard.

The body should be factored out into a check_table(th) helper 
function, and the loop can thus be written as a very straightforward 
one:

	th = NULL;

	for (i = 0; i < tbl_cnt; i++) {
		pa = xsdt_va->table_offset_entry[i];

		th = check_table(pa, signature, oem_id, oem_table_id))
		if (IS_ERR(th))
			return NULL;
		if (th)
			return th;
	}

	return th;

where check_table() returns PTR_ERR(-EINVAL) on mapping failure, 
NULL on mismatch and a table header on match.

Also, a general comment for the whole series: the various type casts 
between ACPI and SFI table headers look ugly and are a bit fragile. 
It would be better to define explicit type conversion helper inlines 
between ACPI an SFI types - and those would thus be type-safe. 
(right now it's easy to typo a variable name and pass in something 
that is neither an ACPI nor an SFI header.)

So we should have two primitives:

	acpi_to_sfi_table(table)
	sfi_to_acpi_table(table)

> +static void sfi_acpi_put_table(struct acpi_table_header *table)
> +{
> +	sfi_put_table((struct sfi_table_header *)table);
> +}

the above could thus be written as:

static void sfi_acpi_put_table(struct acpi_table_header *table)
{
	sfi_put_table(acpi_to_sfi_table(table));
}

> +/*
> + * sfi_acpi_table_parse()
> + *
> + * find specified table in XSDT, run handler on it and return its return value
> + */
> +int sfi_acpi_table_parse(char *signature, char *oem_id, char *oem_table_id,
> +		 unsigned int flags, int(*handler)(struct acpi_table_header *))
> +{

i'd suggest to define a helper structure for the 'table key' fields 
above. They get passed around repetitively. Also, a 
acpi_handler_fn_t helper would be useful as well. That way the above 
prototype could be written as:

int sfi_acpi_table_parse(struct acpi_table_key key, unsigned int flags,
                         acpi_handler_fn_t *handler);

which is a lot more readable and 'key' could be passed straight to 
the sfi parser.

> +++ b/include/linux/sfi_acpi.h

> +#ifdef	CONFIG_SFI

Small nit: we dont generally put tabs into ifdefs, unless strongly 
warranted (which this one does not seem to be).

	Ingo
