Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYLBW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYLBW7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLBW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:59:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42935 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYLBW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:59:12 -0500
Message-ID: <4935BDB9.90806@garzik.org>
Date: Tue, 02 Dec 2008 17:59:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@br.ibm.com>
Subject: Re: [PATCH 1/6] integrity: TPM internel kernel interface
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
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
[...]
> +#ifndef __LINUX_TPM_H__
> +#define __LINUX_TPM_H__
> +
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
> +#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> +
> +extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf);
> +extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash);
> +#endif
> +#endif


Minor nits:

* this is a bit schizophrenic with regards to defining named constants; 
sometimes enum is used, other times #define is used.  It would be better 
to just use enum, which is what the current code does (see top of 
pre-patched tpm.c)

* you really shouldn't hide PCI_DEVICE_ID_xxx constants in places other 
than pci_ids.h.

* furthermore, is that constant even used?  used in a later patch?  if 
the constant is only used once, e.g. in a pci_device_list list, then 
consider eliminating the constant altogether and directly using the PCI 
device id hexidecimal number in the target location.

	Jeff



