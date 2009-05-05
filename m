Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZEEAIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZEEAIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZEEAHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:07:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZEEAHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:07:53 -0400
Message-ID: <49FF831B.4030302@redhat.com>
Date: Mon, 04 May 2009 21:06:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using
 sysfs
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-21-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-21-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> From: Doug Thompson <dougthompson@xmission.com>
>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |  287 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 287 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index b1a7e8c..4d1076f 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -4621,3 +4621,290 @@ static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
>  
>  #endif	/* DEBUG */
>  
> +#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
> +/*
> + * amd64_inject_section_store
> + *
> + *	accept and store error injection section value
> + *	range: 0..3
> + *		value refers to one of 4 16-byte sections
> + *		within a 64-byte cacheline
> + */
> +static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 10, &value);
> +	if (rc != -EINVAL) {
> +
> +		/* save the 16-byte cache section */
> +		pvt->injection.section = (u32) value;
> +
> +		return count;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * amd64_inject_word_store
> + *
> + *	accept and store error injection word value
> + *	range: 0..8
> + *		value refers to one of 9 16-bit word of the 16-byte section
> + *		128-bit + ECC bits
> + */
> +static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 10, &value);
> +	if (rc != -EINVAL) {
> +
> +		/* save the 16-bit word */
> +		value = (value <= 8) ? value : 0;
> +		pvt->injection.word = (u32) value;
> +
> +		return count;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * amd64_inject_bit_store
> + *
> + *	accept and store error injection hexidecimal bit value
> + *	16-bits of a bit-vector marking which bits to error-out on
> + */
> +static ssize_t amd64_inject_bit_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +
> +		/* save the bit within the 16-bit word */
> +		pvt->injection.bit_map = (u32) value & 0xFFFF;
> +
> +		return count;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * amd64_inject_read_store
> + *
> + *	READ action. When called, assemble staged values in the pvt
> + *	area and format into fields needed by the Injection hardware
> + *	Output to hardware and issue a READ operation
> + */
> +static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	u32 section, word_bits;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 10, &value);
> +	if (rc != -EINVAL) {
> +
> +		/* Form value to choose 16-byte section of cacheline */
> +		section = F10_NB_ARRAY_DRAM_ECC |
> +				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> +		pci_write_config_dword(pvt->misc_f3_ctl,
> +					F10_NB_ARRAY_ADDR, section);
> +
> +		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
> +						pvt->injection.bit_map);
> +
> +		/* Issue 'word' and 'bit' along with the READ request now */
> +		pci_write_config_dword(pvt->misc_f3_ctl,
> +					F10_NB_ARRAY_DATA, word_bits);
> +
> +		debugf0("%s() section=0x%x word_bits=0x%x\n", __func__,
> +			section, word_bits);
> +
> +		return count;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * amd64_inject_write_store
> + *
> + *	WRITE action. When called, assemble staged values in the pvt
> + *	area and format into fields needed by the Injection hardware
> + *	Output to hardware and issue a WRITE operation
> + */
> +static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	u32 section, word_bits;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 10, &value);
> +	if (rc != -EINVAL) {
> +
> +		/* Form value to choose 16-byte section of cacheline */
> +		section = F10_NB_ARRAY_DRAM_ECC |
> +				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> +		pci_write_config_dword(pvt->misc_f3_ctl,
> +					F10_NB_ARRAY_ADDR, section);
> +
> +		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
> +						pvt->injection.bit_map);
> +
> +		/* Issue 'word' and 'bit' along with the READ request now */
> +		pci_write_config_dword(pvt->misc_f3_ctl,
> +					F10_NB_ARRAY_DATA, word_bits);
> +
> +		debugf0("%s() section=0x%x word_bits=0x%x\n", __func__,
> +			section, word_bits);
> +
> +		return count;
> +	}
> +	return 0;
> +}
> +#endif
> +
> +/*
> + * Per MC instance Attribute/Control data control structure
> + *	Can add for debug or for normal use
> + */
> +static struct mcidev_sysfs_attribute amd64_mc_sysfs_ctls_attrs[] = {
> +
> +#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
> +	/* Error injection methods */
> +	{
> +		.attr = {
> +			.name = "z_inject_section",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = NULL,
> +		.store = amd64_inject_section_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "z_inject_word",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = NULL,
> +		.store = amd64_inject_word_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "z_inject_bit_map",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = NULL,
> +		.store = amd64_inject_bit_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "z_inject_write",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = NULL,
> +		.store = amd64_inject_write_store,
> +	},
> +	{
> +		.attr = {
> +			.name = "z_inject_read",
> +			.mode = (S_IRUGO | S_IWUSR)
> +		},
> +		.show = NULL,
> +		.store = amd64_inject_read_store,
> +	},
> +#endif	/* CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION */
> +
> +#ifdef	CONFIG_EDAC_DEBUG
> +	/* RAW register accessors */
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
> +#endif
> +	{
> +		.attr = { .name = NULL}
> +	}
> +};
> +
>   
The code looks fine. I agree with Ingo: It is better to move such large 
#ifdefs present on patches 19 and 20 into a separate c file.

Cheers,
Mauro.
