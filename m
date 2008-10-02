Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYJBQD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYJBQD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYJBQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:03:48 -0400
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:57854 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752558AbYJBQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:03:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id:X-Identified-User;
	b=lZO3xJVs3k9m52rkWxaZ/D1EHPjfawJEKD3GbHAMSMrDIaoHaHsOw2BbrdO1FI9T8RDHMsLWX1Mz3RyIUQT7stRR3M7dAJoC9fdQ240/pLLzLl7e+9rtFEsr/ipAIUj+;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Subject: Re: [PATCH 3/6 v3] PCI: support ARI capability
Date: Thu, 2 Oct 2008 09:03:15 -0700
User-Agent: KMail/1.9.10
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F3@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F3@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810020903.16385.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2008 1:28 am Zhao, Yu wrote:
> Add Alternative Routing-ID Interpretation (ARI) support.
>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Roland Dreier <rdreier@cisco.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>
> ---
>  drivers/pci/pci.c        |   31 +++++++++++++++++++++++++++++++
>  drivers/pci/pci.h        |   12 ++++++++++++
>  drivers/pci/probe.c      |    3 +++
>  include/linux/pci.h      |    1 +
>  include/linux/pci_regs.h |   14 ++++++++++++++
>  5 files changed, 61 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 400d3b3..fe9efc4 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1260,6 +1260,37 @@ void pci_pm_init(struct pci_dev *dev)
>         }
>  }
>
> +/**
> + * pci_ari_init - turn on ARI forwarding if it's supported
> + * @dev: the PCI device
> + */
> +void pci_ari_init(struct pci_dev *dev)
> +{
> +       int pos;
> +       u32 cap;
> +       u16 ctrl;
> +
> +       if (!dev->is_pcie || (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
> +                               dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM))
> +               return;
> +
> +       pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
> +       if (!pos)
> +               return;
> +
> +       pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
> +
> +       if (!(cap & PCI_EXP_DEVCAP2_ARI))
> +               return;
> +
> +       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
> +       ctrl |= PCI_EXP_DEVCTL2_ARI;
> +       pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
> +
> +       dev->ari_enabled = 1;
> +       dev_info(&dev->dev, "ARI forwarding enabled.\n");
> +}
> +

Maybe we should be consistent with the other APIs and call it pci_enable_ari 
(like we do for wake & msi).  Looks pretty good otherwise.

Jesse
