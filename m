Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYHRSld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYHRSld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYHRSlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:41:22 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45550 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYHRSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:41:20 -0400
Date: Mon, 18 Aug 2008 12:40:43 -0600
From: Alex Chiang <achiang@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 1/1 #2] PCI: add acpi_find_root_bridge_handle
Message-ID: <20080818184043.GC23155@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jiri Slaby <jirislaby@gmail.com>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	kristen.c.accardi@intel.com,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <20080818175402.GA23155@ldl.fc.hp.com> <1219083774-6833-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219083774-6833-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby <jirislaby@gmail.com>:
> Consolidate finding of a root bridge and getting its handle to the
> one inline function. It's cut&pasted on multiple places. Use this
> new inline in those.
> 
> Updates:
> - added a comment to the acpi_find_root_bridge_handle

Acked-by: Alex Chiang <achiang@hp.com>

Thanks.

/ac

> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: kristen.c.accardi@intel.com
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> ---
>  drivers/pci/hotplug/acpi_pcihp.c   |    5 +----
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    7 +------
>  include/linux/pci-acpi.h           |   11 +++++++++++
>  3 files changed, 13 insertions(+), 10 deletions(-)
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
> -	/* Find root host bridge */
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
> index 3ba2506..8837928 100644
> --- a/include/linux/pci-acpi.h
> +++ b/include/linux/pci-acpi.h
> @@ -57,6 +57,15 @@ static inline acpi_status pcie_osc_support_set(u32 flags)
>  {
>  	return __pci_osc_support_set(flags, PCI_EXPRESS_ROOT_HID_STRING);
>  }
> +static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
> +{
> +	/* Find root host bridge */
> +	while (pdev->bus->self)
> +		pdev = pdev->bus->self;
> +
> +	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pdev->bus),
> +			pdev->bus->number);
> +}
>  #else
>  #if !defined(AE_ERROR)
>  typedef u32 		acpi_status;
> @@ -66,6 +75,8 @@ static inline acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
>  {return AE_ERROR;}
>  static inline acpi_status pci_osc_support_set(u32 flags) {return AE_ERROR;} 
>  static inline acpi_status pcie_osc_support_set(u32 flags) {return AE_ERROR;}
> +static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
> +{ return NULL; }
>  #endif
>  
>  #endif	/* _PCI_ACPI_H_ */
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
