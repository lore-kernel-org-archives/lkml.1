Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZKDTDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZKDTDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZKDTDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:03:19 -0500
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:46862 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752863AbZKDTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:03:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LkJwgBHeBF+VCBkPWjb7WtfAsx+nbxTY0io+2uoPGD9iNAKnm9Qi8Q4eFWyHJnHrdLzD141f7FMZ+2AQGdMMvvMATUm565WtEHrju8fw/eCHKHwW/fyL/kurk9Ql6mmH;
Date: Wed, 4 Nov 2009 11:03:21 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: rdh@east.sun.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Message-ID: <20091104110321.5e58e112@jbarnes-piketon>
In-Reply-To: <19184.41676.262206.134000@gargle.gargle.HOWL>
References: <19184.41676.262206.134000@gargle.gargle.HOWL>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc'ing linux-pci@vger.kernel.org too]

On Tue, 3 Nov 2009 16:38:20 -0500
RDH <rdh@east.sun.com> wrote:

> 
> This patch avoids unnecessary PCIe link retraining sequences within
> the PCIe ASPM common clock setup code by issuing a link retrain
> command only if we are actually changing the PCIe clock configuration.
> 
> Signed-off-by: Robert D. Houk <rdh@East.Sun.COM>
> ---
>  aspm.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> --- a/drivers/pci/pcie/aspm.c	2009-10-15 20:41:50.000000000
> -0400 +++ b/drivers/pci/pcie/aspm.c	2009-11-02
> 14:29:35.000000000 -0500 @@ -183,6 +183,7 @@ static void
> pcie_aspm_configure_common_c {
>  	int ppos, cpos, same_clock = 1;
>  	u16 reg16, parent_reg, child_reg[8];
> +	u16 lnkctl_ccc_or, lnkctl_ccc_and;
>  	unsigned long start_jiffies;
>  	struct pci_dev *child, *parent = link->pdev;
>  	struct pci_bus *linkbus = parent->subordinate;
> @@ -205,6 +206,25 @@ static void pcie_aspm_configure_common_c
>  	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
>  		same_clock = 0;
>  
> +	/* Check upstream component for Common Clock Config */
> +	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
> +	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 &
> PCI_EXP_LNKCTL_CCC); +
> +	/* Scan downstream component for CCC, all functions */
> +	list_for_each_entry(child, &linkbus->devices, bus_list) {
> +		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
> +		pci_read_config_word(child, cpos + PCI_EXP_LNKCTL,
> &reg16);
> +		lnkctl_ccc_and &= (reg16 & PCI_EXP_LNKCTL_CCC);
> +		lnkctl_ccc_or |= (reg16 & PCI_EXP_LNKCTL_CCC);
> +	}
> +
> +	/* If we want Common Clock OFF and no device/function has it
> on */
> +	/* or we want Common Clock ON and every device/function has
> it on */
> +	/* then there is no need to retrain PCIe links */
> +	if (((same_clock == 0) && (lnkctl_ccc_or == 0))
> +            || ((same_clock == 1) && (lnkctl_ccc_and ==
> PCI_EXP_LNKCTL_CCC)))
> +		return;		/* Don't retrain link(s) */
> +
>  	/* Configure downstream component, all functions */
>  	list_for_each_entry(child, &linkbus->devices, bus_list) {
>  		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
> 

Seems ok to me, anyone have comments?

-- 
Jesse Barnes, Intel Open Source Technology Center
