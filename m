Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZAFAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZAFAx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZAFAxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:53:49 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4124 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZAFAxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:53:48 -0500
Subject: Re: [PATCH v2] ASPM: Use msleep instead of cpu_relax during link
 retraining
From: Joe Perches <joe@perches.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, matthew@wil.cx,
       akpm@linux-foundation.org, shaohua.li@intel.com
In-Reply-To: <20090105230716.15081.29984.stgit@bob.kio>
References: <20090105230716.15081.29984.stgit@bob.kio>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 16:54:36 -0800
Message-Id: <1231203276.20557.175.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 16:07 -0700, Andrew Patterson wrote:
> ASPM: Use msleep instead of cpu_relax during link retraining
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 4d8e2c7..e67eaa2 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
[]
> @@ -238,16 +241,19 @@ static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
>  	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
>  
>  	/* Wait for link training end */
> -	/* break out after waiting for 1 second */
> +	/* break out after waiting for timeout */
>  	start_jiffies = jiffies;
> -	while ((jiffies - start_jiffies) < HZ) {
> +	for (;;) {
>  		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
>  		if (!(reg16 & PCI_EXP_LNKSTA_LT))
>  			break;
> -		cpu_relax();
> +		if (time_after(start_jiffies,
> +			       start_jiffies + LINK_RETRAIN_TIMEOUT))
> +			break;
> +		msleep(1);
>  	}

if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))


