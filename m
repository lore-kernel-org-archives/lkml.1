Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYJBQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYJBQWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYJBQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:22:07 -0400
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:60951 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753897AbYJBQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:22:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=T/NJoYKoBXooaC2WPyqGoQ101APZPg2bZ/HfWpXgWdPFpajlANNjIj9NNXPgopAPNHzLTdQn8IkDLUyjj1bEmdeHUYT8Uf3npP/D12yRFl8cjj8mycHqBnrKHKapCz17;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Subject: Re: [PATCH 2/6 v3] PCI: add new general functions
Date: Thu, 2 Oct 2008 09:21:31 -0700
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
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F2@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F2@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810020921.32335.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2008 1:27 am Zhao, Yu wrote:
> Centralize capability related functions into several new functions and put
> PCI resource definitions into an enum.

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index f99160d..f2feebc 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c

The sysfs changes look fine, they should be submitted separately.

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 259eaff..400d3b3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -356,25 +356,10 @@ pci_find_parent_resource(const struct pci_dev *dev,
> struct resource *res) static void
>  pci_restore_bars(struct pci_dev *dev)
>  {
> -       int i, numres;
> -
> -       switch (dev->hdr_type) {
> -       case PCI_HEADER_TYPE_NORMAL:
> -               numres = 6;
> -               break;
> -       case PCI_HEADER_TYPE_BRIDGE:
> -               numres = 2;
> -               break;
> -       case PCI_HEADER_TYPE_CARDBUS:
> -               numres = 1;
> -               break;
> -       default:
> -               /* Should never get here, but just in case... */
> -               return;
> -       }
> +       int i;
>
> -       for (i = 0; i < numres; i ++)
> -               pci_update_resource(dev, &dev->resource[i], i);
> +       for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
> +               pci_update_resource(dev, i);
>  }

This confused me for a minute until I saw that the new pci_update_resource 
ignores invalid BAR numbers.  Not sure if that's clearer than the current 
code...

> +/**
> + * pci_resource_bar - get position of the BAR associated with a resource
> + * @dev: the PCI device
> + * @resno: the resource number
> + * @type: the BAR type to be filled in
> + *
> + * Returns BAR position in config space, or 0 if the BAR is invalid.
> + */
> +int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type
> *type) +{
> +       if (resno < PCI_ROM_RESOURCE) {
> +               *type = pci_bar_unknown;
> +               return PCI_BASE_ADDRESS_0 + 4 * resno;
> +       } else if (resno == PCI_ROM_RESOURCE) {
> +               *type = pci_bar_rom;
> +               return dev->rom_base_reg;
> +       }
> +
> +       dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
> +       return 0;
> +}

It looks like this will spew an error even under normal circumstances since 
pci_restore_bars gets called at resume time, right?  You could make this into 
a debug message or just get rid of it.  Also now that I look at this, I don't 
think it'll provide equivalent functionality to the old restore_bars code, 
won't a cardbus bridge end up getting pci_update_resource called on invalid 
BARs?

> +static void pci_init_capabilities(struct pci_dev *dev)
> +{
> +       /* MSI/MSI-X list */
> +       pci_msi_init_pci_dev(dev);
> +
> +       /* Power Management */
> +       pci_pm_init(dev);
> +
> +       /* Vital Product Data */
> +       pci_vpd_pci22_init(dev);
> +}
> +

These capabilities changes look good, care to separate them out?

Let's see if we can whittle down this patchset by extracting and applying all 
the various cleanups; that should make the core bits easier to review.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
