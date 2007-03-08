Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXCHRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXCHRN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXCHRN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:13:56 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37703 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbXCHRNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:13:54 -0500
Date: Thu, 8 Mar 2007 09:14:11 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 6/6] integrity: TPM internal kernel interface
Message-ID: <20070308171411.GM6602@sequoia.sous-sol.org>
References: <1173369868.5981.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173369868.5981.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Other than the nits below, this looks like the right idea.

* Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> Index: linux-2.6.21-rc3-mm2/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/drivers/char/tpm/tpm.c
> +++ linux-2.6.21-rc3-mm2/drivers/char/tpm/tpm.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (C) 2004 IBM Corporation
> + * Copyright (C) 2004,2007 IBM Corporation
>   *
>   * Authors:
>   * Leendert van Doorn <leendert@watson.ibm.com>
> @@ -25,6 +25,12 @@
>  
>  #include <linux/poll.h>
>  #include <linux/spinlock.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/crypto.h>
> +#include <linux/fs.h>
> +#include <asm/scatterlist.h>
>  #include "tpm.h"
>  
>  enum tpm_const {
> @@ -47,6 +53,8 @@ enum tpm_duration {
>  static LIST_HEAD(tpm_chip_list);
>  static DEFINE_SPINLOCK(driver_lock);
>  static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
> +#define TPM_CHIP_NUM_MASK       0x0000ffff
> +#define TPM_CHIP_TYPE_SHIFT     16
>  
>  /*
>   * Array with one entry per ordinal defining the maximum amount
> @@ -363,7 +371,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_durat
>  /*
>   * Internal kernel interface to transmit TPM commands
>   */
> -static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> +ssize_t tpm_transmit(struct tpm_chip *chip, char *buf,
>  			    size_t bufsiz)
>  {
>  	ssize_t rc;
> @@ -422,6 +430,7 @@ out:
>  	up(&chip->tpm_mutex);
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(tpm_transmit);
>  
>  #define TPM_DIGEST_SIZE 20
>  #define TPM_ERROR_SIZE 10
> @@ -665,6 +674,7 @@ ssize_t tpm_show_temp_deactivated(struct
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
>  
> +#define READ_PCR_RESULT_SIZE 30

Is this the same value that's used as a magic number in places
like tpm_gen_interrupt and tpm_show_pcrs?  Be nice to convert
that as well to eliminate some magic (my quick review of TPM
specs came up empty, so I could be off the mark).

>  static const u8 pcrread[] = {
>  	0, 193,			/* TPM_TAG_RQU_COMMAND */
>  	0, 0, 0, 14,		/* length */
> @@ -713,6 +723,93 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_pcrs);
>  
> +static struct tpm_chip* tpm_chip_lookup(int chip_num, int chip_typ)
> +{
> +        struct tpm_chip *pos;
> +
> +        spin_lock(&driver_lock);
> +        list_for_each_entry(pos, &tpm_chip_list, list)
> +                if ((chip_num == TPM_ANY_NUM ||
> +                        pos->dev_num == chip_num ) &&
> +                        (chip_typ == TPM_ANY_TYPE)){
> +                        spin_unlock(&driver_lock);
> +                        return pos;
> +                }
> +
> +        spin_unlock(&driver_lock);

I guess this is OK, since TPM chips aren't hotpluggable, but
typically this type of interface would refcount the device
it finds before returning it to caller.

> +        return NULL;
> +}
> +
> +/*
> + * Return 0 on success.  On error pass along error code.
> + * chip_id Upper 2 bytes equal ANY, HW_ONLY or SW_ONLY
> + * Lower 2 bytes equal tpm idx # or AN&
> + * res_buf must fit a TPM_PCR (20 bytes) or NULL if you don't care
> + */

Proper kerneldoc for exported functions please.

> +int tpm_pcr_read( u32 chip_id, int pcr_idx, u8* res_buf, int res_buf_size )
> +{
> +        u8 data[READ_PCR_RESULT_SIZE];
> +        int rc;
> +        __be32 index;
> +        int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +        struct tpm_chip* chip;
> +
> +        if ( res_buf && res_buf_size < TPM_DIGEST_SIZE )
> +                return -ENOSPC;

CodingStyle [extra spaces around '(' and ')'],  if (foo)...
Tabs not spaces.

> +
> +        if ( (chip = tpm_chip_lookup( chip_num,
> +                                chip_id >> TPM_CHIP_TYPE_SHIFT ) ) == NULL )

	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
	if (!chip)

> +                return -ENODEV;
> +
> +        memcpy(data, pcrread, sizeof(pcrread));
> +        index = cpu_to_be32(pcr_idx);
> +        memcpy(data + 10, &index, 4);
> +        if ((rc = tpm_transmit(chip, data, sizeof(data))) > 0 )
> +                rc = be32_to_cpu(*((u32*)(data+6)));
> +

Shouldn't this be a helper? (there's other pcr reads going on internally)
And similar CodingStyle comment...

> +        if ( rc == 0 && res_buf )
> +                memcpy(res_buf, data+10, TPM_DIGEST_SIZE);
> +
> +        return rc;
> +
> +}
> +EXPORT_SYMBOL_GPL(tpm_pcr_read);
> +
> +#define EXTEND_PCR_SIZE 34
> +static const u8 pcrextend[] = {
> +        0, 193,                 /* TPM_TAG_RQU_COMMAND */
> +        0, 0, 0, 34,            /* length */
> +        0, 0, 0, 20,            /* TPM_ORD_Extend */
> +        0, 0, 0, 0              /* PCR index */
> +};
> +
> +/*
> + * Return 0 on success.  On error pass along error code.
> + * chip_id Upper 2 bytes equal ANY, HW_ONLY or SW_ONLY
> + * Lower 2 bytes equal tpm idx # or ANY
> + */
> +int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8* hash)
> +{
> +        u8 data[EXTEND_PCR_SIZE];
> +        int rc;
> +        __be32 index;
> +        int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +        struct tpm_chip* chip;
> +
> +        if ( (chip = tpm_chip_lookup( chip_num,
> +                        chip_id >> TPM_CHIP_TYPE_SHIFT )) == NULL )
> +                return -ENODEV;
> +
> +        memcpy(data, pcrextend, sizeof(pcrextend));
> +        index = cpu_to_be32(pcr_idx);
> +        memcpy(data + 10, &index, 4);
> +        memcpy( data + 14, hash, TPM_DIGEST_SIZE );
> +        if ((rc = tpm_transmit(chip, data, sizeof(data))) > 0 )
> +                rc = be32_to_cpu(*((u32*)(data+6)));
> +        return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm_pcr_extend);
> +
>  #define  READ_PUBEK_RESULT_SIZE 314
>  static const u8 readpubek[] = {
>  	0, 193,			/* TPM_TAG_RQU_COMMAND */
> @@ -944,13 +1041,13 @@ int tpm_release(struct inode *inode, str
>  
>  	spin_lock(&driver_lock);
>  	file->private_data = NULL;
> +	spin_unlock(&driver_lock);
>  	chip->num_opens--;
>  	del_singleshot_timer_sync(&chip->user_read_timer);
>  	flush_scheduled_work();
>  	atomic_set(&chip->data_pending, 0);
>  	put_device(chip->dev);
>  	kfree(chip->data_buffer);
> -	spin_unlock(&driver_lock);

Can you explain this, it looks unrelated to the other changes?

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_release);
> Index: linux-2.6.21-rc3-mm2/drivers/char/tpm/tpm.h
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/drivers/char/tpm/tpm.h
> +++ linux-2.6.21-rc3-mm2/drivers/char/tpm/tpm.h
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (C) 2004 IBM Corporation
> + * Copyright (C) 2004, 2007 IBM Corporation
>   *
>   * Authors:
>   * Leendert van Doorn <leendert@watson.ibm.com>
> @@ -25,6 +25,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/tpm.h>
>  
>  enum tpm_timeout {
>  	TPM_TIMEOUT = 5,	/* msecs */
> Index: linux-2.6.21-rc3-mm2/include/linux/tpm.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3-mm2/include/linux/tpm.h
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright (C) 2004,2007 IBM Corporation
> + *
> + * Authors:
> + * Leendert van Doorn <leendert@watson.ibm.com>
> + * Dave Safford <safford@watson.ibm.com>
> + * Reiner Sailer <sailer@watson.ibm.com>
> + * Kylene Hall <kjhall@us.ibm.com>
> + *
> + * Maintained by: <tpmdd_devel@lists.sourceforge.net>
> + *
> + * Device driver for TCG/TCPA TPM (trusted platform module).
> + * Specifications at www.trustedcomputinggroup.org
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + */
> +#ifndef __LINUX_TPM_H__
> +#define __LINUX_TPM_H__
> +
> +#define CONFIG_TCG_TPM 1

eh?  This should have a different name or be proper Kconfig variable.

> +#define PCI_DEVICE_ID_AMD_8111_LPC    0x7468
> +
> +/*
> + * Chip type is one of these values in the upper two bytes of chip_id
> + */
> +enum tpm_chip_type {
> +	TPM_HW_TYPE = 0x0,
> +	TPM_SW_TYPE = 0x1,
> +	TPM_ANY_TYPE = 0xFFFF,
> +};
> +
> +/*
> + * Chip num is this value or a valid tpm idx in lower two bytes of chip_id
> + */
> +enum tpm_chip_num {
> +	TPM_ANY_NUM = 0xFFFF,
> +};
> +
> +
> +#ifdef CONFIG_TCG_TPM

And clearly this isn't needed the way it's currently written ;-)
(although I suspect you want some Kconfig bits, and this would stay)

> +extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8* res_buf, int res_buf_size);
> +extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8* hash);
> +#else
> +static inline int tpm_pcr_read(u32 chip_id, int pcr_idx, u8* res_buf,
> +				int res_buf_size)
> +{
> +	return -1;

This is not the right return value.  I'd guess -ENODEV or similar.

> +}
> +
> +static inline int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8* hash)
> +{
> +	return -1;

ditto

> +}
> +#endif
> +#endif

thanks,
-chris
