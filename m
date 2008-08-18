Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYHRRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYHRRyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYHRRyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:54:05 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34866 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYHRRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:54:04 -0400
Date: Mon, 18 Aug 2008 11:54:02 -0600
From: Alex Chiang <achiang@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 1/1] PCI: add acpi_find_root_bridge_handle
Message-ID: <20080818175402.GA23155@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jiri Slaby <jirislaby@gmail.com>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	kristen.c.accardi@intel.com,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <20080818143019.GC2537@ldl.fc.hp.com> <1219081651-13233-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219081651-13233-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby <jirislaby@gmail.com>:
> Hi,
> 
> I'm sending an update proposed by Alex. Consider it and drop or merge :).
> --
> 
> Consolidate finding of a root bridge and getting its handle to the
> one inline function. It's cut&pasted on multiple places. Use this
> new inline in those.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: kristen.c.accardi@intel.com
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> ---
>  drivers/pci/hotplug/acpi_pcihp.c   |    5 +----
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    7 +------
>  include/linux/pci-acpi.h           |   10 ++++++++++
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> index bd83197..e17ef54 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -404,10 +404,7 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags)
>  	 * OSHP within the scope of the hotplug controller and its parents,
>  	 * upto the host bridge under which this controller exists.
>  	 */
> -	while (pdev->bus->self)
> -		pdev = pdev->bus->self;
> -	handle = acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
> -			pdev->bus->number);
> +	handle = acpi_find_root_bridge_handle(pdev);
>  	if (handle) {
>  		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
>  		dbg("Trying to get hotplug control for %s\n",
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index 30f581b..6dd7b13 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -36,12 +36,7 @@ int aer_osc_setup(struct pcie_device *pciedev)
>  	if (acpi_pci_disabled)
>  		return -1;
>  

The reason I even knew about aer_osc_setup() was because I found
the while (pdev->bus->self) idiom a bit confusing, so I did a git
grep to see if it was used anywhere else in the kernel. Luckily,
the below comment was there, and I found it helpful.

> -	/* Find root host bridge */

So can we move this coment ^^ into your new inline below?

Thanks!

/ac

> -	while (pdev->bus->self)
> -		pdev = pdev->bus->self;
> -	handle = acpi_get_pci_rootbridge_handle(
> -		pci_domain_nr(pdev->bus), pdev->bus->number);
> -
> +	handle = acpi_find_root_bridge_handle(pdev);
>  	if (handle) {
>  		pcie_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
>  		status = pci_osc_control_set(handle,
> diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
> index 3ba2506..807847a 100644
> --- a/include/linux/pci-acpi.h
> +++ b/include/linux/pci-acpi.h
> @@ -57,6 +57,14 @@ static inline acpi_status pcie_osc_support_set(u32 flags)
>  {
>  	return __pci_osc_support_set(flags, PCI_EXPRESS_ROOT_HID_STRING);
>  }
> +static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
> +{
> +	while (pdev->bus->self)
> +		pdev = pdev->bus->self;
> +
> +	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
> +			pdev->bus->number);
> +}
>  #else
>  #if !defined(AE_ERROR)
>  typedef u32 		acpi_status;
> @@ -66,6 +74,8 @@ static inline acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
>  {return AE_ERROR;}
>  static inline acpi_status pci_osc_support_set(u32 flags) {return AE_ERROR;} 
>  static inline acpi_status pcie_osc_support_set(u32 flags) {return AE_ERROR;}
> +static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
> +{ return NULL; }
>  #endif
>  
>  #endif	/* _PCI_ACPI_H_ */
> -- 
> 1.6.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
