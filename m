Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZAHDCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZAHDCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZAHDCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:02:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45876 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZAHDC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:02:29 -0500
Message-ID: <49656CB9.9070806@jp.fujitsu.com>
Date: Thu, 08 Jan 2009 12:02:17 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <200901042355.55724.rjw@sisk.pl>
In-Reply-To: <200901042355.55724.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If MSI-X interrupt mode is used by the PCI Express port driver, too
> many vectors are allocated and it is not ensured that the right
> vectors will be used for various services.  Namely, the PCI Express
> specification states that both PCI Express native PME and PCI Express
> hotplug will always use the same MSI or MSI-X message for signalling
> interrupts, which implies that the same vector will be used by both
> of them.  Also, the VC service does not use interrupts at all.
> Moreover, is not clear which of the vectors allocated by
> pci_enable_msix() will be used for PME and hotplug and which of them
> will be used for AER if all of these services are configured.
> 
> For these reasons, rework the allocation of interrupts for PCI
> Express ports so that at most two vectors are allocated and ensure
> that the right vector will be used for the right purpose.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pcie/portdrv.h      |    1 
>  drivers/pci/pcie/portdrv_core.c |  155 +++++++++++++++++++++++++++++-----------
>  2 files changed, 117 insertions(+), 39 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pcie/portdrv.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv.h
> +++ linux-2.6/drivers/pci/pcie/portdrv.h
> @@ -25,6 +25,7 @@
>  #define PCIE_CAPABILITIES_REG		0x2
>  #define PCIE_SLOT_CAPABILITIES_REG	0x14
>  #define PCIE_PORT_DEVICE_MAXSERVICES	4
> +#define PORT_MSI_VECTOR_MASK		0x1f
>  
>  #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
>  
> Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_core.c
> @@ -30,55 +30,120 @@ static void release_pcie_device(struct d
>  }
>  
>  /**
> + * fix_up_vectors - ensure the right ordering of MSI-X interrupt vectors
> + * @dev: PCI Express port that is going to use the vectors
> + * @vectors: Array of interrupt vectors to check (2 entries)
> + *
> + * Return value:
> + * 0 on success, error code if the values read from config registers are not as
> + * expected
> + *
> + * If this function is called, we are going to use two interrupt vectors which
> + * may be different, but we have to make sure they are in the right order such
> + * that the vector to be used for PME and hotplug signalling is the first one.
> + *
> + * NOTE: The assumption here is that MSI message offset (with respect to the
> + * base Message Data) equal to N corresponds to index N in the array of vectors
> + * returned by pci_enable_msix().
> + */

I've posted the similar patch recently, which doesn't have this
assumption. Please take a look.

http://marc.info/?l=linux-pci&m=122992792507715&w=2

NOTE: I've confirmed MSI and INTx still work with my patch, but it
is not tested on the machine with MSI-X capable port, since I don't
have such environment.

Thanks,
Kenji Kaneshige

