Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZEHKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZEHKCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763107AbZEHKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:02:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762934AbZEHKCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:02:16 -0400
Date: Fri, 8 May 2009 07:01:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>,
       <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <aris@redhat.com>, edt@aei.ca, <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 04/21] amd64_edac: add DRAM error injection logic using
 sysfs
Message-ID: <20090508070118.099769ab@pedra.chehab.org>
In-Reply-To: <1241704183-29223-5-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<1241704183-29223-5-git-send-email-borislav.petkov@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 7 May 2009 15:49:26 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/edac/amd64_edac_inj.c |  200 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 200 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/edac/amd64_edac_inj.c
> 
> diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
> new file mode 100644
> index 0000000..7f978cb
> --- /dev/null
> +++ b/drivers/edac/amd64_edac_inj.c
> @@ -0,0 +1,200 @@
> +#include "amd64_edac.h"
> +
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
> +
> +struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
> +
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
> +};


-- 

Cheers,
Mauro
