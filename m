Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYE1HTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYE1HTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYE1HTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:19:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbYE1HTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:19:10 -0400
Date: Wed, 28 May 2008 00:17:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC][Patch 2/5]integrity: TPM internel kernel interface
Message-Id: <20080528001739.54c630f9.akpm@linux-foundation.org>
In-Reply-To: <1211555021.16195.14.camel@new-host>
References: <1211555021.16195.14.camel@new-host>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:03:41 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Resubmitting integrity-tpm-internal-kernel-interface.patch, which
> was previously Signed-off-by Kylene Hall.
> 
> Adds the following support: 
> - make internal kernel interface to transmit TPM commands global
> - adds reading a pcr value
> - adds extending a pcr value
> - adds lookup the tpm_chip for given chip number and type
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Is this effort a once-off, or should you add yourself to ./MAINTAINERS?

> ...
>
> +/*
> + * tpm_chip_lookup - return tpm_chip for given chip number and type
> + */
> +static struct tpm_chip *tpm_chip_lookup(int chip_num, int chip_typ)
> +{
> +	struct tpm_chip *pos;
> +
> +	spin_lock(&driver_lock);
> +	list_for_each_entry(pos, &tpm_chip_list, list)
> +	    if ((chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)

hard tabs for indenting here, please.

> +		&& (chip_typ == TPM_ANY_TYPE)) {
> +		spin_unlock(&driver_lock);
> +		return pos;
> +	}
> +
> +	spin_unlock(&driver_lock);
> +	return NULL;
> +}
> +
> +/**
> + * tpm_pcr_read - read a pcr value
> + * @chip_id: 	tpm chip identifier
> + * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
> + * 		Lower 2 bytes: tpm idx # or AN&
> + * @pcr_idx:	pcr idx to retrieve
> + * @res_buf: 	TPM_PCR value
> + * @res_buf_size: 20 bytes (or NULL if you don't care)
> + */
> +int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf, int res_buf_size)
> +{
> +	u8 data[READ_PCR_RESULT_SIZE];
> +	int rc;
> +	__be32 index;
> +	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +	struct tpm_chip *chip;
> +
> +	if (res_buf && res_buf_size < TPM_DIGEST_SIZE)
> +		return -ENOSPC;
> +
> +	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
> +	if (chip == NULL)
> +		return -ENODEV;
> +
> +	memcpy(data, pcrread, sizeof(pcrread));

For robustness purposes it would be good to have a check that
sizeof(pcrread) does not exceed READ_PCR_RESULT_SIZE.  One way of doing
that would be to add

	if (sizeof(pcrread) > READ_PCR_RESULT_SIZE)
		function_which_does_not_exist();

under the assumption that gcc will not emit the call.  Or a plain old
BUG_ON() in the init code somewhere.

Or, better, implement all of this in a typesafe manner, using the C
type system.  Is that possible?  Things like unions mght be needed...

> +	index = cpu_to_be32(pcr_idx);
> +	memcpy(data + 10, &index, 4);
> +	rc = tpm_transmit(chip, data, sizeof(data));
> +	if (rc > 0)
> +		rc = be32_to_cpu(*((u32 *) (data + 6)));

An unaligned access.  What architectures is this hardware available on?

Harvey might be able to suggest a neater and better way of doing this?
At least a get_unaligned(), I think?

> +
> +	if (rc == 0 && res_buf)
> +		memcpy(res_buf, data + 10, TPM_DIGEST_SIZE);
> +
> +	return rc;
> +
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
> + */
> +int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
> +{
> +	u8 data[EXTEND_PCR_SIZE];
> +	int rc;
> +	__be32 index;
> +	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> +	struct tpm_chip *chip;
> +
> +	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
> +	if (chip == NULL)
> +		return -ENODEV;
> +
> +	memcpy(data, pcrextend, sizeof(pcrextend));
> +	index = cpu_to_be32(pcr_idx);
> +	memcpy(data + 10, &index, 4);
> +	memcpy(data + 14, hash, TPM_DIGEST_SIZE);
> +	rc = tpm_transmit(chip, data, sizeof(data));
> +	if (rc > 0)
> +		rc = be32_to_cpu(*((u32 *) (data + 6)));
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm_pcr_extend);

Dittoes.

>
> ...
>
> +#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> +
> +extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf,
> +			int res_buf_size);
> +extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash);
> +#else
> +static inline int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf,
> +				int res_buf_size)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +#endif

Are the !CONFIG_TCG_TPM stub functions actually needed?  Perhaps all
the code which can call tpm_pcr_read() and tpm_pcr_extend() cannot be
coppiled when CONFIG_TCG_TPM=n due to Kconfig dependencies?
