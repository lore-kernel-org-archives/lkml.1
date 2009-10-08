Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZJHBAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZJHBAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbZJHBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:00:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37261 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZJHBAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:00:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACD3978.5080601@jp.fujitsu.com>
Date: Thu, 08 Oct 2009 09:59:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
References: <20091006173311.GA15751@auslistsprd01.us.dell.com>
In-Reply-To: <20091006173311.GA15751@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

Matt Domsch wrote:
> For review and comment.
> 
> Today, the PCIe Advanced Error Reporting (AER) driver attaches itself
> to every PCIe root port for which BIOS reports it should, via ACPI
> _OSC.
> 
> However, _OSC alone is insufficient for newer BIOSes.  Part of ACPI
> 4.0 is the new Platform Environment Control Interface (PECI), which is
> a way for OS and BIOS to handshake over which errors for which
> components each will handle.  One table in ACPI 4.0 is the Hardware
> Error Source Table (HEST), where BIOS can define that errors for
> certain PCIe devices (or all devices), should be handled by BIOS
> ("Firmware First mode"), rather than be handled by the OS.
> 
> Dell PowerEdge 11G server BIOS defines Firmware First mode in HEST, so
> that it may manage such errors, log them to the System Event Log, and
> possibly take other actions.  The aer driver should honor this, and
> not attach itself to devices noted as such.
> 
> 
> Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
> 

Thank you for providing this patch.
This is a good step in the right direction, to support newer platform.

> ---
>  drivers/pci/pcie/aer/aerdrv.h      |    4 +-
>  drivers/pci/pcie/aer/aerdrv_acpi.c |  106 +++++++++++++++++++++++++++++++++++-
>  drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
>  include/acpi/actbl1.h              |    8 ++-
>  4 files changed, 112 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
> index bbd7428..2e00a22 100644
> --- a/drivers/pci/pcie/aer/aerdrv.h
> +++ b/drivers/pci/pcie/aer/aerdrv.h
> @@ -128,9 +128,9 @@ extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
>  extern irqreturn_t aer_irq(int irq, void *context);
>  
>  #ifdef CONFIG_ACPI
> -extern int aer_osc_setup(struct pcie_device *pciedev);
> +extern int aer_osc_setup(struct pcie_device *pciedev, int forceload);
>  #else
> -static inline int aer_osc_setup(struct pcie_device *pciedev)
> +static inline int aer_osc_setup(struct pcie_device *pciedev, int forceload)
>  {
>  	return 0;
>  }
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index 8edb2f3..10bd83c 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -18,20 +18,112 @@
>  #include <linux/delay.h>
>  #include "aerdrv.h"
>  
> +static unsigned long parse_aer_hest_xpf_machine_check(struct acpi_hest_xpf_machine_check *p)
> +{
> +	return sizeof(*p) +
> +		(sizeof(struct acpi_hest_xpf_error_bank) * p->num_hardware_banks);
> +}
> +
> +static unsigned long parse_aer_hest_xpf_corrected_machine_check(struct acpi_table_hest_xpf_corrected *p)
> +{
> +	return sizeof(*p) +
> +		(sizeof(struct acpi_hest_xpf_error_bank) * p->num_hardware_banks);
> +}
> +
> +static unsigned long parse_aer_hest_xpf_nmi(struct acpi_hest_xpf_nmi *p)
> +{
> +	return sizeof(*p);
> +}
> +
> +static unsigned long parse_hest_generic(struct acpi_hest_generic *p)
> +{
> +	return sizeof(*p);
> +}
> +
> +static unsigned long parse_hest_aer(void *hdr, int type, struct pcie_device *pciedev, int *firmware_first)
> +{
> +	struct acpi_hest_aer_common *p = hdr + sizeof(struct acpi_hest_header);
> +	unsigned long rc=0;
> +	switch (type) {
> +	case ACPI_HEST_TYPE_AER_ROOT_PORT:
> +		rc = sizeof(struct acpi_hest_aer_root);
> +		break;
> +	case ACPI_HEST_TYPE_AER_ENDPOINT:
> +		rc = sizeof(struct acpi_hest_aer);
> +		break;
> +	case ACPI_HEST_TYPE_AER_BRIDGE:
> +		rc = sizeof(struct acpi_hest_aer_bridge);
> +		break;
> +	}
> +
> +	if (p->flags & ACPI_HEST_AER_FIRMWARE_FIRST &&
> +	    (p->flags & ACPI_HEST_AER_GLOBAL ||
> +	     (p->bus      == pciedev->port->bus->number &&
> +	      p->device   == PCI_SLOT(pciedev->port->devfn) &&
> +	      p->function == PCI_FUNC(pciedev->port->devfn))))
> +		*firmware_first = 1;
> +	return rc;
> +}
> +

HEST is neither pcie specific nor pci specific.
As you know it can include error source structure for machine check,
NMI etc.

It will be nice if we can have shareable codes for HEST in proper place,
such as drivers/acpi/_foo_.c (_foo_.c would be hest.c, error.c, apei.c etc.)
...  It likely means we will have a function acpi_table_parse_hest() which
is a kin of acpi_table_parse_madt/srat().

> +static int aer_hest_firmware_first(struct acpi_table_header *stdheader, struct pcie_device *pciedev)
> +{
> +	struct acpi_table_hest *hest = (struct acpi_table_hest *)stdheader;
> +	void *p = (void *)hest + sizeof(*hest); /* defined by the ACPI 4.0 spec */
> +	struct acpi_hest_header *hdr = p;
> +
> +	int i;
> +	int firmware_first = 0;
> +
> +	for (i=0, hdr=p; p < (((void *)hest) + hest->header.length) && i < hest->error_source_count; i++) {
> +		switch (hdr->type) {
> +		case ACPI_HEST_TYPE_XPF_MACHINE_CHECK:
> +			p += parse_aer_hest_xpf_machine_check(p);
> +			break;
> +		case ACPI_HEST_TYPE_XPF_CORRECTED_MACHINE_CHECK:
> +			p += parse_aer_hest_xpf_corrected_machine_check(p);
> +			break;
> +		case ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT:
> +			p += parse_aer_hest_xpf_nmi(p);
> +			break;
> +		/* These three should never appear */
> +		case ACPI_HEST_TYPE_XPF_UNUSED:
> +		case ACPI_HEST_TYPE_IPF_CORRECTED_MACHINE_CHECK:
> +		case ACPI_HEST_TYPE_IPF_CORRECTED_PLATFORM_ERROR:
> +			break;
> +		case ACPI_HEST_TYPE_AER_ROOT_PORT:
> +		case ACPI_HEST_TYPE_AER_ENDPOINT:
> +		case ACPI_HEST_TYPE_AER_BRIDGE:
> +			p += parse_hest_aer(p, hdr->type, pciedev, &firmware_first);
> +			break;
> +		case ACPI_HEST_TYPE_GENERIC_HARDWARE_ERROR_SOURCE:
> +			p += parse_hest_generic(p);
> +			break;
> +		/* These should never appear either */
> +		case ACPI_HEST_TYPE_RESERVED:
> +		default:
> +			break;
> +		}
> +	}
> +	return firmware_first;
> +}
> +

You could have better code here if there were acpi_table_parse_hest().

>  /**
>   * aer_osc_setup - run ACPI _OSC method
>   * @pciedev: pcie_device which AER is being enabled on
>   *
>   * @return: Zero on success. Nonzero otherwise.
>   *
> - * Invoked when PCIE bus loads AER service driver. To avoid conflict with
> - * BIOS AER support requires BIOS to yield AER control to OS native driver.
> + * Invoked when PCIE bus loads AER service driver. To avoid conflict
> + * with BIOS AER support requires BIOS to yield AER control to OS
> + * native driver.  If HEST is found, and BIOS requires FIRMWARE FIRST
> + * mode, expect the BIOS to continue managing AER.
>   **/
> -int aer_osc_setup(struct pcie_device *pciedev)
> +int aer_osc_setup(struct pcie_device *pciedev, int forceload)
>  {
>  	acpi_status status = AE_NOT_FOUND;
>  	struct pci_dev *pdev = pciedev->port;
>  	acpi_handle handle = NULL;
> +	struct acpi_table_header *hest = NULL;
>  
>  	if (acpi_pci_disabled)
>  		return -1;
> @@ -51,5 +143,13 @@ int aer_osc_setup(struct pcie_device *pciedev)
>  		return -1;
>  	}
>  
> +	status = acpi_get_table(ACPI_SIG_HEST, 1, &hest);
> +	if (ACPI_SUCCESS(status)) {
> +		if (aer_hest_firmware_first(hest, pciedev) && !forceload) {
> +			dev_printk(KERN_DEBUG, &pciedev->device,
> +				   "PCIe device errors handled by platform firmware\n");
> +			return -1;
> +		}
> +	}
>  	return 0;
>  }

Should we check HEST before taking control of AER via _OSC?

Is the forceload only used to suppress the DEBUG level printk message?

I suppose the better procedure is:

[pseudo code:]
{
  if (HEST_indicates_AER_is_firmwarefirst) {
      printk "AER is firmware first";
      goto NG;
  }
  if (OSC_failed) {
      printk "OSC failed";
      goto NG;
  }
  return 0;
NG:
  if (forceload) {
      printk "But force loading aerdrv";
      return 0;
  }
  return -1;
}

> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 3d88727..cbd959b 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -860,7 +860,7 @@ void aer_delete_rootport(struct aer_rpc *rpc)
>   */
>  int aer_init(struct pcie_device *dev)
>  {
> -	if (aer_osc_setup(dev) && !forceload)
> +	if (aer_osc_setup(dev, forceload) && !forceload)
>  		return -ENXIO;
>  
>  	return AER_SUCCESS;
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 59ade07..5919d4c 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -558,8 +558,8 @@ struct acpi_hest_header {
>  enum acpi_hest_types {
>  	ACPI_HEST_TYPE_XPF_MACHINE_CHECK = 0,
>  	ACPI_HEST_TYPE_XPF_CORRECTED_MACHINE_CHECK = 1,
> -	ACPI_HEST_TYPE_XPF_UNUSED = 2,
> -	ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT = 3,
> +	ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT = 2,
> +	ACPI_HEST_TYPE_XPF_UNUSED = 3,
>  	ACPI_HEST_TYPE_IPF_CORRECTED_MACHINE_CHECK = 4,
>  	ACPI_HEST_TYPE_IPF_CORRECTED_PLATFORM_ERROR = 5,
>  	ACPI_HEST_TYPE_AER_ROOT_PORT = 6,
> @@ -630,6 +630,10 @@ struct acpi_hest_aer_common {
>  	u32 advanced_error_capabilities;
>  };
>  
> +/* Flags */
> +#define ACPI_HEST_AER_FIRMWARE_FIRST (1)
> +#define ACPI_HEST_AER_GLOBAL         (1<<1)
> +
>  /* Hardware Error Notification */
>  
>  struct acpi_hest_notify {
> -- 1.6.2.5 

It seems that these changes in include/acpi/actbl1.h are
already included in pci.git/linux-next (by fix from ACPICA).

Could you revise & rebase this patch on newer tree?


Thanks,
H.Seto

