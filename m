Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYLBWT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYLBWT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYLBWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:19:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35602 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYLBWTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:19:50 -0500
Subject: Re: [PATCH 1/6] integrity: TPM internel kernel interface
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@br.ibm.com>
In-Reply-To: <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 14:19:40 -0800
Message-Id: <1228256380.2971.176.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 16:47 -0500, Mimi Zohar wrote:
> This patch adds internal kernel support for:
>   - reading/extending a pcr value
>   - looking up the tpm_chip for a given chip number and type
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@br.ibm.com>
> ---
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 9c47dc4..17d2849 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1,11 +1,12 @@
>  /*
> - * Copyright (C) 2004 IBM Corporation
> + * Copyright (C) 2004,2007,2008 IBM Corporation
>   *
>   * Authors:
>   * Leendert van Doorn <leendert@watson.ibm.com>
>   * Dave Safford <safford@watson.ibm.com>
>   * Reiner Sailer <sailer@watson.ibm.com>
>   * Kylene Hall <kjhall@us.ibm.com>
> + * Debora Velarde <dvelarde@us.ibm.com>
>   *
>   * Maintained by: <tpmdd-devel@lists.sourceforge.net>
>   *
> @@ -28,6 +29,14 @@
>  #include <linux/spinlock.h>
>  #include <linux/smp_lock.h>
>  
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/crypto.h>
> +#include <linux/fs.h>
> +#include <linux/scatterlist.h>
> +#include <linux/rcupdate.h>
> +#include <asm/unaligned.h>
>  #include "tpm.h"
>  
>  enum tpm_const {
> @@ -50,6 +59,8 @@ enum tpm_duration {
>  static LIST_HEAD(tpm_chip_list);
>  static DEFINE_SPINLOCK(driver_lock);
>  static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
> +#define TPM_CHIP_NUM_MASK       0x0000ffff
> +#define TPM_CHIP_TYPE_SHIFT     16
>  
>  /*
>   * Array with one entry per ordinal defining the maximum amount
> @@ -366,8 +377,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
>  /*
>   * Internal kernel interface to transmit TPM commands
>   */
> -static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> -			    size_t bufsiz)
> +ssize_t tpm_transmit(struct tpm_chip *chip, char *buf, size_t bufsiz)
>  {
>  	ssize_t rc;
>  	u32 count, ordinal;
> @@ -425,6 +435,7 @@ out:
>  	mutex_unlock(&chip->tpm_mutex);
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(tpm_transmit);
>  
>  #define TPM_DIGEST_SIZE 20
>  #define TPM_ERROR_SIZE 10
> @@ -717,6 +728,7 @@ ssize_t tpm_show_temp_deactivated(struct device * dev,
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
>  
> +#define READ_PCR_RESULT_SIZE 30
>  static const u8 pcrread[] = {
>  	0, 193,			/* TPM_TAG_RQU_COMMAND */
>  	0, 0, 0, 14,		/* length */
> @@ -772,6 +784,128 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_pcrs);
>  
> +/*
> + * tpm_chip_lookup - return tpm_chip for given chip number and type
> + *
> + * Must be called with rcu_read_lock.
> + */
> +static struct tpm_chip *tpm_chip_lookup(int chip_num, int chip_typ)
> +{
> +	struct tpm_chip *pos;
> +	int rc;
> +
> +	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
> +		rc = (chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
> +		    && (chip_typ == TPM_ANY_TYPE);
> +		if (rc)
> +			return pos;
> +	}
> +	return NULL;
> +}

If you have to respin these patches could you consider simplifying that
loop?  I find that really hard to read.  I think it's much easier to
read if written out something like this:

	/* Dunno why they *must* specify TPM_ANY_TYPE, but they do */
	if (chip_typ != TPM_ANY_TYPE)
		continue;

	if (chip_num == TPM_ANY_NUM)
		return pos;
	if (pos->dev_num == chip_num)
		return pos;

> +
> +/**
> + * tpm_pcr_read - read a pcr value
> + * @chip_id: 	tpm chip identifier
> + * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
> + * 		Lower 2 bytes: tpm idx # or AN&
> + * @pcr_idx:	pcr idx to retrieve
> + * @res_buf: 	TPM_PCR value
> + * 		size of res_buf is 20 bytes (or NULL if you don't care)
> + *
> + * The TPM driver should be built-in, but for whatever reason it
> + * isn't, protect against the chip disappearing, by incrementing
> + * the module usage count.
> + */
> +int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf)
> +{
> +	u8 data[READ_PCR_RESULT_SIZE];
> +	int rc;
> +	__be32 index;
> +	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +	struct tpm_chip *chip;
> +
> +	rcu_read_lock();
> +	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
> +	if (chip == NULL) {
> +		rcu_read_unlock();
> +		return -ENODEV;
> +	}
> +	if (!try_module_get(chip->dev->driver->owner)) {
> +		rcu_read_unlock();
> +		return -ENODEV;
> +	}
> +	rcu_read_unlock();

This little bit of lookup, check for NULL, and try_module_get() looks
cut-n-pasted in the next two functions.  Should be consolidated.

Also, if you need to shift down the chip_id every time anyway, why not
just do it inside the lookup function?

> +	BUILD_BUG_ON(sizeof(pcrread) > READ_PCR_RESULT_SIZE);
> +	memcpy(data, pcrread, sizeof(pcrread));
> +	index = cpu_to_be32(pcr_idx);
> +	memcpy(data + 10, &index, 4);
> +	rc = tpm_transmit(chip, data, sizeof(data));
> +	if (rc > 0)
> +		rc = get_unaligned_be32((__be32 *) (data + 6));
> +
> +	if (rc == 0 && res_buf)
> +		memcpy(res_buf, data + 10, TPM_DIGEST_SIZE);
> +
> +	module_put(chip->dev->driver->owner);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm_pcr_read);
> +
> +#define EXTEND_PCR_SIZE 34
> +static const u8 pcrextend[] = {
> +	0, 193,			/* TPM_TAG_RQU_COMMAND */
> +	0, 0, 0, 34,		/* length */
> +	0, 0, 0, 20,		/* TPM_ORD_Extend */
> +	0, 0, 0, 0		/* PCR index */
> +};
> +
> +/**
> + * tpm_pcr_extend - extend pcr value with hash
> + * @chip_id: 	tpm chip identifier
> + * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
> + * 		Lower 2 bytes: tpm idx # or AN&
> + * @pcr_idx:	pcr idx to extend
> + * @hash: 	hash value used to extend pcr value
> + *
> + * The TPM driver should be built-in, but for whatever reason it
> + * isn't, protect against the chip disappearing, by incrementing
> + * the module usage count.
> + */
> +int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
> +{
> +	u8 data[EXTEND_PCR_SIZE];
> +	int rc;
> +	__be32 index;
> +	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +	struct tpm_chip *chip;
> +
> +	rcu_read_lock();
> +	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
> +	if (chip == NULL) {
> +		rcu_read_unlock();
> +		return -ENODEV;
> +	}
> +	if (!try_module_get(chip->dev->driver->owner)) {
> +		rcu_read_unlock();
> +		return -ENODEV;
> +	}
> +	rcu_read_unlock();
> +
> +	BUILD_BUG_ON(sizeof(pcrextend) > EXTEND_PCR_SIZE);
> +	memcpy(data, pcrextend, sizeof(pcrextend));
> +	index = cpu_to_be32(pcr_idx);
> +	memcpy(data + 10, &index, 4);

This bit of code looks duplicated too.  I really wish these 10's and
14's weren't magic numbers, especially since they're used twice.

> +	memcpy(data + 14, hash, TPM_DIGEST_SIZE);
> +	rc = tpm_transmit(chip, data, sizeof(data));
> +	if (rc > 0)
> +		rc = get_unaligned_be32((__be32 *) (data + 6));
> +
> +	module_put(chip->dev->driver->owner);
> +	return rc;
> +}

Looking at this, I can't help but think a couple of nicely laid out
structs with a union or two could make this all look nicer.  For
instance, is the return code from the tpm_transmit() function always
returned in the 6th byte?

It looks to me like there is a TPM_RET_CODE_IDX in
drivers/char/tpm/tpm.c.  Why on earth isn't that being used?  That also
makes me question all these other magic numbers.

Why not just integrate that rc tinkering into tpm_transmit(), or a
variant of it.  There appear to be at least three or four other users
that could benefit from such a function.  If you decide to mess with it
further than just exporting it, please break that out into a separate
patch, btw.

> +enum tpm_chip_num {
> +	TPM_ANY_NUM = 0xFFFF,
> +};

Why bother even checking this sucker if there's only one value?

> +#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> +
> +extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf);
> +extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash);
> +#endif
> +#endif

The " || defined(CONFIG_TCG_TPM_MODULE)" doesn't do anything.
CONFIG_TCG_TPM is still true even when CONFIG_TCG_TPM_MODULE.

I also think so many authors on the header is a bit excessive.  5
authors for 2 enums and 2 function declarations. :)

-- Dave

