Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbYGBLlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbYGBLlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbYGBLl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:41:28 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:58502 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYGBLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:41:27 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 07:41:27 EDT
Message-ID: <486B6827.3060205@selhorst.net>
Date: Wed, 02 Jul 2008 13:36:07 +0200
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
To: Marcin Obara <marcin_obara@users.sourceforge.net>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm:increase size of internal TPM response buffers
References: <alpine.DEB.0.99.0806052220040.8295@ip-195-3-221-75.vnet.pl>
In-Reply-To: <alpine.DEB.0.99.0806052220040.8295@ip-195-3-221-75.vnet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.8.0.59; VDF: 7.0.5.34; host: mail)
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Marcel Selhorst <tpm@selhorst.net>

Marcin Obara schrieb:
> This patch increases size of driver internal response buffers.
> Some TPM responses defined in TCG TPM Specification Version 1.2 Revision 103
> have increased size and do not fit previously defined buffers.
> Some TPM responses do not have fixed size, so bigger response buffers
> have to be allocated. 200B buffers should be enough.
> 
> Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
> 
> --- linux/drivers/char/tpm/tpm.c	2008-06-05 22:12:47.000000000 +0200
> +++ linux_tpm/drivers/char/tpm/tpm.c	2008-06-05 22:10:59.000000000 +0200
> @@ -579,91 +579,133 @@ void tpm_continue_selftest(struct tpm_ch
>  }
>  EXPORT_SYMBOL_GPL(tpm_continue_selftest);
>  
> +#define  TPM_INTERNAL_RESULT_SIZE 200
> +
>  ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
>  			char *buf)
>  {
> -	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
> +	u8 *data;
>  	ssize_t rc;
>  
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> -			"attemtping to determine the permanent state");
> -	if (rc)
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> +			"attemtping to determine the permanent enabled state");
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> -	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
> +	}
> +
> +	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
> +
> +	kfree(data);
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_enabled);
>  
>  ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
>  			char *buf)
>  {
> -	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
> +	u8 *data;
>  	ssize_t rc;
>  
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> -			"attemtping to determine the permanent state");
> -	if (rc)
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> +			"attemtping to determine the permanent active state");
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> -	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
> +	}
> +
> +	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
> +
> +	kfree(data);
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_active);
>  
>  ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
>  			char *buf)
>  {
> -	u8 data[sizeof(tpm_cap)];
> +	u8 *data;
>  	ssize_t rc;
>  
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_OWNER;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the owner state");
> -	if (rc)
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> -	return sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
> +	}
> +
> +	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
> +
> +	kfree(data);
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_owned);
>  
>  ssize_t tpm_show_temp_deactivated(struct device * dev,
>  				struct device_attribute * attr, char *buf)
>  {
> -	u8 data[sizeof(tpm_cap)];
> +	u8 *data;
>  	ssize_t rc;
>  
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_VOL;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the temporary state");
> -	if (rc)
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> -	return sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
> +	}
> +
> +	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
> +
> +	kfree(data);
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
>  
> @@ -677,7 +719,7 @@ static const u8 pcrread[] = {
>  ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
>  		      char *buf)
>  {
> -	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)), 30)];
> +	u8 *data;
>  	ssize_t rc;
>  	int i, j, num_pcrs;
>  	__be32 index;
> @@ -687,21 +729,27 @@ ssize_t tpm_show_pcrs(struct device *dev
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_PCR;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the number of PCRS");
> -	if (rc)
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> +	}
>  
>  	num_pcrs = be32_to_cpu(*((__be32 *) (data + 14)));
>  	for (i = 0; i < num_pcrs; i++) {
>  		memcpy(data, pcrread, sizeof(pcrread));
>  		index = cpu_to_be32(i);
>  		memcpy(data + 10, &index, 4);
> -		rc = transmit_cmd(chip, data, sizeof(data),
> +		rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  				"attempting to read a PCR");
>  		if (rc)
>  			goto out;
> @@ -711,6 +759,7 @@ ssize_t tpm_show_pcrs(struct device *dev
>  		str += sprintf(str, "\n");
>  	}
>  out:
> +	kfree(data);
>  	return str - buf;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_pcrs);
> @@ -794,7 +843,7 @@ static const u8 cap_version[] = {
>  ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
>  		      char *buf)
>  {
> -	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
> +	u8 *data;
>  	ssize_t rc;
>  	char *str = buf;
>  
> @@ -802,21 +851,27 @@ ssize_t tpm_show_caps(struct device *dev
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
>  
> -	rc = transmit_cmd(chip, data, sizeof(data),
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the manufacturer");
> -	if (rc)
> +	if (rc) {
> +		kfree(data);
>  		return 0;
> +	}
>  
>  	str += sprintf(str, "Manufacturer: 0x%x\n",
>  		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
>  
>  	memcpy(data, cap_version, sizeof(cap_version));
>  	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
> -	rc = transmit_cmd(chip, data, sizeof(data),
> +	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the 1.1 version");
>  	if (rc)
>  		goto out;
> @@ -827,6 +882,7 @@ ssize_t tpm_show_caps(struct device *dev
>  		       (int) data[17]);
>  
>  out:
> +	kfree(data);
>  	return str - buf;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_caps);
> @@ -834,7 +890,7 @@ EXPORT_SYMBOL_GPL(tpm_show_caps);
>  ssize_t tpm_show_caps_1_2(struct device * dev,
>  			  struct device_attribute * attr, char *buf)
>  {
> -	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
> +	u8 *data;
>  	ssize_t len;
>  	char *str = buf;
>  
> @@ -842,15 +898,20 @@ ssize_t tpm_show_caps_1_2(struct device 
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
>  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
>  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
>  
> -	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
> +	if ((len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE)) <=
>  	    TPM_ERROR_SIZE) {
>  		dev_dbg(chip->dev, "A TPM error (%d) occurred "
>  			"attempting to determine the manufacturer\n",
>  			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
> +		kfree(data);
>  		return 0;
>  	}
>  
> @@ -860,7 +921,7 @@ ssize_t tpm_show_caps_1_2(struct device 
>  	memcpy(data, cap_version, sizeof(cap_version));
>  	data[CAP_VERSION_IDX] = CAP_VERSION_1_2;
>  
> -	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
> +	if ((len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE)) <=
>  	    TPM_ERROR_SIZE) {
>  		dev_err(chip->dev, "A TPM error (%d) occurred "
>  			"attempting to determine the 1.2 version\n",
> @@ -873,6 +934,7 @@ ssize_t tpm_show_caps_1_2(struct device 
>  		       (int) data[19]);
>  
>  out:
> +	kfree(data);
>  	return str - buf;
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
> 
