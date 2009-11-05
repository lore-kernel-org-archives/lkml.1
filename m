Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZKETLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZKETLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbZKETLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:11:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbZKETLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:11:34 -0500
Date: Thu, 5 Nov 2009 12:11:38 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Message-ID: <20091105191138.GN10555@parisc-linux.org>
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <20091104110321.5e58e112@jbarnes-piketon> <200911041628.17905.bjorn.helgaas@hp.com> <4AF240E7.8050200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF240E7.8050200@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 12:05:11PM +0900, Kenji Kaneshige wrote:
> There are a lot of codes that searches PCI express capability offset
> in the PCI configuration space using pci_find_capability(). Caching it
> in the struct pci_dev will reduce unncecessary search. This patch adds
> an additional 'pcie_cap' fields into struct pci_dev, which is
> initialized at pci device scan time (in set_pcie_port_type()).

I think adding this should imply the removal of ->is_pcie.  pcie_cap == 0
means !is_pcie.

> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/probe.c |    1 +
>  include/linux/pci.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> Index: 20090825/drivers/pci/probe.c
> ===================================================================
> --- 20090825.orig/drivers/pci/probe.c
> +++ 20090825/drivers/pci/probe.c
> @@ -693,6 +693,7 @@ static void set_pcie_port_type(struct pc
>  	if (!pos)
>  		return;
>  	pdev->is_pcie = 1;
> +	pdev->pcie_cap = pos;
>  	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
>  	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
>  }
> Index: 20090825/include/linux/pci.h
> ===================================================================
> --- 20090825.orig/include/linux/pci.h
> +++ 20090825/include/linux/pci.h
> @@ -218,6 +218,7 @@ struct pci_dev {
>  	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
>  	u8		revision;	/* PCI revision, low byte of class word */
>  	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
> +	u8		pcie_cap;	/* PCI-E capability offset */
>  	u8		pcie_type;	/* PCI-E device/port type */
>  	u8		rom_base_reg;	/* which config register controls the ROM */
>  	u8		pin;  		/* which interrupt pin this device uses */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
