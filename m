Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbZEHKCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbZEHKCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZEHKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:02:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44822 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZEHKCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:02:06 -0400
Date: Fri, 8 May 2009 07:01:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>,
       <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <aris@redhat.com>, edt@aei.ca, <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 03/21] amd64_edac: add debugging/testing code
Message-ID: <20090508070101.4cf54085@pedra.chehab.org>
In-Reply-To: <1241704183-29223-4-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<1241704183-29223-4-git-send-email-borislav.petkov@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 7 May 2009 15:49:25 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> This is for dumping different registers and testing the address mapping
> logic using the ECC syndromes.
> 
> Borislav: split sysfs attrs per file
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/edac/amd64_edac_dbg.c |  288 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 288 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/edac/amd64_edac_dbg.c
> 
> diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
> new file mode 100644
> index 0000000..3741af9
> --- /dev/null
> +++ b/drivers/edac/amd64_edac_dbg.c
> @@ -0,0 +1,288 @@
> +#include "amd64_edac.h"
> +
> +/*
> + * amd64_nbea_store
> + *
> + * 	Accept a hex value and store it into the virutal error
> + *	register file, field:	nbeal and nbeah
> + *
> + *	Assume virtual error values have already been set for:
> + *		NBSL, NBSH and NBCFG
> + *
> + *	Then proceed to map the error values to a:
> + *		MC, CSROW and CHANNEL
> + */
> +static ssize_t amd64_nbea_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long long value;
> +	int rc;
> +
> +	rc = strict_strtoull(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBEA= 0x%llx\n", __func__, value);
> +
> +		/* place the value into the virtual error packet */
> +		pvt->ctl_error_info.nbeal = (u32) value;
> +		value >>= 32;
> +		pvt->ctl_error_info.nbeah = (u32) value;
> +
> +		/* Process the Mapping request */
> +		/* TODO: Add race preventation */
> +		amd64_process_error_info(mci, &pvt->ctl_error_info, 1);
> +
> +		return count;
> +	}
> +	return rc;
> +}
> +
> +/*
> + * amd64_nbea_show
> + *
> + *	display back what the last NBEA address was written
> + */
> +static ssize_t amd64_nbea_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	u64 value;
> +
> +	value = pvt->ctl_error_info.nbeah;
> +	value <<= 32;
> +	value |= pvt->ctl_error_info.nbeal;
> +
> +	return sprintf(data, "%llx\n", value);
> +}
> +
> +/*
> + * amd64_nbsl_store
> + *
> + *	accept and store the NBSL value user desires
> + */
> +static ssize_t amd64_nbsl_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
> +
> +		/* place the NBSL value into the virtual error packet */
> +		pvt->ctl_error_info.nbsl = (u32) value;
> +
> +		return count;
> +	}
> +	return rc;
> +}
> +
> +/*
> + * amd64_nbsl_show
> + *
> + *	display back what the last NBSL value written
> + */
> +static ssize_t amd64_nbsl_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	u32 value;
> +
> +	value = pvt->ctl_error_info.nbsl;
> +
> +	return sprintf(data, "%x\n", value);
> +}
> +
> +/*
> + * amd64_nbsh_store
> + *
> + *	accept and store the NBSH value user desires
> + */
> +static ssize_t amd64_nbsh_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
> +
> +		/* place the NBSL value into the virtual error packet */
> +		pvt->ctl_error_info.nbsh = (u32) value;
> +
> +		return count;
> +	}
> +	return rc;
> +}
> +
> +/*
> + * amd64_nbsh_show
> + *
> + *	display back what the last NBSL value written
> + */
> +static ssize_t amd64_nbsh_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	u32 value;
> +
> +	value = pvt->ctl_error_info.nbsh;
> +
> +	return sprintf(data, "%x\n", value);
> +}
> +
> +/*
> + * amd64_nbcfg_store
> + *
> + *	accept and store the NBSL value user desires
> + */
> +static ssize_t amd64_nbcfg_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBCFG= 0x%lx\n", __func__, value);
> +
> +		/* place the NBSL value into the virtual error packet */
> +		pvt->ctl_error_info.nbcfg = (u32) value;
> +
> +		return count;
> +	}
> +	return rc;
> +}
> +
> +/*
> + *	Various show routines for the controls of a MCI
> + */
> +static ssize_t amd64_nbcfg_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +
> +	return sprintf(data, "%x\n",
> +		pvt->ctl_error_info.nbcfg);
> +}
> +
> +
> +static ssize_t amd64_dhar_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +
> +	return sprintf(data, "%x\n", pvt->dhar);
> +}
> +
> +
> +static ssize_t amd64_dbam_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +
> +	return sprintf(data, "%x\n", pvt->dbam0);
> +}
> +
> +
> +static ssize_t amd64_topmem_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +
> +	return sprintf(data, "%llx\n", pvt->top_mem);
> +}
> +
> +
> +static ssize_t amd64_topmem2_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +
> +	return sprintf(data, "%llx\n", pvt->top_mem2);
> +}
> +
> +static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
> +{
> +	u64 hole_base = 0;
> +	u64 hole_offset = 0;
> +	u64 hole_size = 0;
> +
> +	amd64_get_dram_hole_info(mci, &hole_base, &hole_offset, &hole_size);
> +
> +	return sprintf(data, "%llx %llx %llx\n", hole_base, hole_offset,
> +						 hole_size);
> +}
> +
> +struct mcidev_sysfs_attribute amd64_dbg_attrs[] = {
> +
> +	{
> +		.attr = {
> +			.name = "zctl_nbea",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = amd64_nbea_show,
> +		.store = amd64_nbea_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "zctl_nbsl",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = amd64_nbsl_show,
> +		.store = amd64_nbsl_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "zctl_nbsh",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = amd64_nbsh_show,
> +		.store = amd64_nbsh_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "zctl_nbcfg",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = amd64_nbcfg_show,
> +		.store = amd64_nbcfg_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "zhw_dhar",
> +			.mode = (S_IRUGO)
> +		},
> +		.show = amd64_dhar_show,
> +		.store = NULL,
> +	},
> +	{
> +		.attr = {
> +			.name = "zhw_dbam",
> +			.mode = (S_IRUGO)
> +		},
> +		.show = amd64_dbam_show,
> +		.store = NULL,
> +	},
> +	{
> +		.attr = {
> +			.name = "zhw_topmem",
> +			.mode = (S_IRUGO)
> +		},
> +		.show = amd64_topmem_show,
> +		.store = NULL,
> +	},
> +	{
> +		.attr = {
> +			.name = "zhw_topmem2",
> +			.mode = (S_IRUGO)
> +		},
> +		.show = amd64_topmem2_show,
> +		.store = NULL,
> +	},
> +	{
> +		.attr = {
> +			.name = "zhw_hole",
> +			.mode = (S_IRUGO)
> +		},
> +		.show = amd64_hole_show,
> +		.store = NULL,
> +	},
> +};


-- 

Cheers,
Mauro
