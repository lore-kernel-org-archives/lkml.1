Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXEOVfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXEOVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbXEOVfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:35:33 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:38813 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbXEOVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:35:33 -0400
Date: Tue, 15 May 2007 14:35:31 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oruba <peter.oruba@amd.com>, gregkh@suse.de, cramerj@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       rolandd@cisco.com, halr@voltaire.com, linux-driver@qlogic.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/2] PCI-X/PCI-Express read control interfaces
Message-ID: <20070515213531.GG29996@n7651av69tz181.qlogic.org>
References: <200705151350.28330.peter.oruba@amd.com> <20070515123721.1bfb02a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515123721.1bfb02a3.akpm@linux-foundation.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 May 2007 21:35:01.0909 (UTC) FILETIME=[E4FCE450:01C79738]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Andrew Morton wrote:

> On Tue, 15 May 2007 13:50:27 +0200
> "Peter Oruba" <peter.oruba@amd.com> wrote:
> 
> > This patch set introduces a PCI-X / PCI-Express read byte count control 
> > interface. Instead of letting every driver to directly read/write to PCI 
> > config space for that, an interface is provided. The interface functions then 
> > can be used for quirks since some PCI bridges require that read byte count 
> > values are set by the BIOS and left unchanged by device drivers.
> 
> Some of the patches were wordwrapped, which I fixed.
> 
> The way we would merge a feature like this is
> 
> - get maintainers to review-and-ack the change

This is definetly good cleanup, and I ACK the QLogic changes.

I do though have some questions on call prerequisites given the
driver-changes, most in the form of:

> diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
> linux-2.6.22-rc1.orig/drivers/infiniband/hw/mthca/mthca_main.c 
> linux-2.6.22-rc1/drivers/infiniband/hw/mthca/mthca_main.c
> --- linux-2.6.22-rc1.orig/drivers/infiniband/hw/mthca/mthca_main.c	2007-05-14 
> 11:29:29.358547000 +0200
> +++ linux-2.6.22-rc1/drivers/infiniband/hw/mthca/mthca_main.c	2007-05-15 
> 10:55:24.954074000 +0200
> @@ -137,45 +137,27 @@ static const char mthca_version[] __devi
>  
>  static int mthca_tune_pci(struct mthca_dev *mdev)
>  {
> -	int cap;
> -	u16 val;
> -
>  	if (!tune_pci)
>  		return 0;
>  
>  	/* First try to max out Read Byte Count */
> -	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX);
> -	if (cap) {
> -		if (pci_read_config_word(mdev->pdev, cap + PCI_X_CMD, &val)) {
> -			mthca_err(mdev, "Couldn't read PCI-X command register, "
> -				  "aborting.\n");
> -			return -ENODEV;
> -		}
> -		val = (val & ~PCI_X_CMD_MAX_READ) | (3 << 2);
> -		if (pci_write_config_word(mdev->pdev, cap + PCI_X_CMD, val)) {
> -			mthca_err(mdev, "Couldn't write PCI-X command register, "
> -				  "aborting.\n");
> +	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX)) {
> +		if (pcix_set_mmrbc(mdev->pdev, pcix_get_max_mmrbc(mdev->pdev))) {
> +			mthca_err(mdev, "Couldn't set PCI-X max read count, "
> +				"aborting.\n");
...
> -	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP);
> -	if (cap) {
> -		if (pci_read_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, &val)) {
> -			mthca_err(mdev, "Couldn't read PCI Express device control "
> -				  "register, aborting.\n");
> -			return -ENODEV;
> -		}
> -		val = (val & ~PCI_EXP_DEVCTL_READRQ) | (5 << 12);
> -		if (pci_write_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, val)) {
> -			mthca_err(mdev, "Couldn't write PCI Express device control "
> -				  "register, aborting.\n");
> +	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP)) {
> +		if (pcie_set_readrq(mdev->pdev, 4096)) {
> +			mthca_err(mdev, "Couldn't write PCI Express read request, "
> +				"aborting.\n");


In general, if PCI-[Xe] capability structure exists do set-
mmrbc()/readrq(), yet each of those pre-condition checks are already
present in the pcix_set_mmrbc() and pcie_set_readrq().

At least for the qla2xxx case, the patch could easily distill down from:

	...
	/* PCIe -- adjust Maximum Read Request Size (2048). */
	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
	if (pcie_dctl_reg)
		if (pcie_set_readrq(ha->pdev, 2048))
			DEBUG2(printk("Couldn't write PCI Express read request\n"));

to:

	...
	pcie_set_readrq(ha->pdev, 2048);


Whatever the decision, I can fold this into my next patchset for
qla2xxx and submit.
