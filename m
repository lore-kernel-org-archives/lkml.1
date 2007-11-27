Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXK0NBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXK0NBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXK0NBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:01:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXK0NBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:01:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, "acurrid@nvidia.com" <acurrid@nvidia.com>,
       "pchen@nvidia.com" <pchen@nvidia.com>,
       "prakash@punnoor.de" <prakash@punnoor.de>,
       "mchan@broadcom.com" <mchan@broadcom.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quirk: Enable MSI Mapping on HT1000
References: <20071127134014.7a8ac56d@bull.net>
Date: Tue, 27 Nov 2007 05:59:04 -0700
In-Reply-To: <20071127134014.7a8ac56d@bull.net> (=?iso-8859-1?Q?S=E9bastie?=
 =?iso-8859-1?Q?n_Dugu=E9's?= message of
	"Tue, 27 Nov 2007 13:40:14 +0100")
Message-ID: <m1bq9flu93.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sébastien Dugué <sebastien.dugue@bull.net> writes:

> From: Sebastien Dugue <sebastien.dugue@bull.net>
>
>   Add a quirk to enable the MSI mapping capability on HyperTransport
> bridges.
>
>   Wire Broadcom's HT1000 to use the quirk.
>
>   This patch applies cleanly on 2.6.24-rc3-mm1 and was tested on 2.6.24-rc3
> (sorry, but 2.6.24-rc3-mm1 would not boot on my box).
>
>   I also have been running 2.6.21-rt10 with that patch for quite some
> time now.
>
>   Sebastien.

Looks like a sane starting point, and if we know the chipset can
do it preferable to disabling msi on that chipset.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andy Currid <acurrid@nvidia.com>
> Cc: Peer Chen <pchen@nvidia.com>
> Cc: Prakash Punnoor <prakash@punnoor.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michael Chan <mchan@broadcom.com>
>
> ---
>  drivers/pci/quirks.c |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> Index: linux-2.6.24-rc3-mm1/drivers/pci/quirks.c
> ===================================================================
> --- linux-2.6.24-rc3-mm1.orig/drivers/pci/quirks.c
> +++ linux-2.6.24-rc3-mm1/drivers/pci/quirks.c
> @@ -1681,6 +1681,33 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
>  			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
>  			quirk_msi_ht_cap);
>  
> +
> +/*
> + *  Force enable MSI mapping capability on HT bridges
> + */
> +static void __devinit quirk_msi_ht_cap_enable(struct pci_dev *dev)
> +{
> +	int pos, ttl = 48;
> +
> +	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
> +	while (pos && ttl--) {
> +		u8 flags;
> +
> + if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
> + printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
> +			       pci_name(dev));
> +
> +			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
> +					      flags | HT_MSI_FLAGS_ENABLE);
> +		}
> +		pos = pci_find_next_ht_capability(dev, pos,
> +						  HT_CAPTYPE_MSI_MAPPING);
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
> +			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
> +			 quirk_msi_ht_cap_enable);
> +
>  /* The nVidia CK804 chipset may have 2 HT MSI mappings.
>   * MSI are supported if the MSI capability set in any of these mappings.
>   */
