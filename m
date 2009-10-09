Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZJIF4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZJIF4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZJIF4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:56:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:38657 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbZJIF4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:56:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="501360550"
Subject: Re: Fwd: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
From: Huang Ying <ying.huang@intel.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <851fc09e0910082221q7f832c22xfc0d01ab72a97c3f@mail.gmail.com>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com>
	 <851fc09e0910082221q7f832c22xfc0d01ab72a97c3f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 13:55:27 +0800
Message-Id: <1255067727.5228.111.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt,

Thanks for your work.

Matt Domsch wrote: 
> For review and comment.
> 
> Today, the PCIe Advanced Error Reporting (AER) driver attaches itself
> to every PCIe root port for which BIOS reports it should, via ACPI
> _OSC.
> 
> However, _OSC alone is insufficient for newer BIOSes.  Part of ACPI
> 4.0 is the new Platform Environment Control Interface (PECI), which is

I can not find Platform Environment Control Interface in ACPI 4.0. There
is something about that here:
http://en.wikipedia.org/wiki/Platform_Environment_Control_Interface. But
it seems have nothing to do with OS/BIOS interface.

Can you tell me where can I find more about PECI? Or you mean APEI (ACPI
Platform Error Interfaces)?

We are working on APEI supporting now too, mainly on the general part.
We will release the code after it passes our internal testing.

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
> --
> Matt Domsch
> Technology Strategist, Dell Office of the CTO
> linux.dell.com & www.dell.com/linux
> 
> 
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
> @@ -128,9 +128,9 @@ extern void aer_print_error(struct pci_dev *dev,
> struct aer_err_info *info);
>  extern irqreturn_t aer_irq(int irq, void *context);
> 
>  #ifdef CONFIG_ACPI
> -extern int aer_osc_setup(struct pcie_device *pciedev);
> +extern int aer_osc_setup(struct pcie_device *pciedev, int forceload);
>  #else
> -static inline int aer_osc_setup(struct pcie_device *pciedev)
> +static inline int aer_osc_setup(struct pcie_device *pciedev, int forceload)
>  {
>        return 0;
>  }
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c
> b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index 8edb2f3..10bd83c 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -18,20 +18,112 @@
>  #include <linux/delay.h>
>  #include "aerdrv.h"
> 
> +static unsigned long parse_aer_hest_xpf_machine_check(struct
> acpi_hest_xpf_machine_check *p)
> +{
> +       return sizeof(*p) +
> +               (sizeof(struct acpi_hest_xpf_error_bank) *
> p->num_hardware_banks);
> +}
> +
> +static unsigned long
> parse_aer_hest_xpf_corrected_machine_check(struct
> acpi_table_hest_xpf_corrected *p)
> +{
> +       return sizeof(*p) +
> +               (sizeof(struct acpi_hest_xpf_error_bank) *
> p->num_hardware_banks);
> +}
> +
> +static unsigned long parse_aer_hest_xpf_nmi(struct acpi_hest_xpf_nmi *p)
> +{
> +       return sizeof(*p);
> +}
> +
> +static unsigned long parse_hest_generic(struct acpi_hest_generic *p)
> +{
> +       return sizeof(*p);
> +}
> +
> +static unsigned long parse_hest_aer(void *hdr, int type, struct
> pcie_device *pciedev, int *firmware_first)
> +{
> +       struct acpi_hest_aer_common *p = hdr + sizeof(struct acpi_hest_header);
> +       unsigned long rc=0;
> +       switch (type) {
> +       case ACPI_HEST_TYPE_AER_ROOT_PORT:
> +               rc = sizeof(struct acpi_hest_aer_root);
> +               break;
> +       case ACPI_HEST_TYPE_AER_ENDPOINT:
> +               rc = sizeof(struct acpi_hest_aer);
> +               break;
> +       case ACPI_HEST_TYPE_AER_BRIDGE:
> +               rc = sizeof(struct acpi_hest_aer_bridge);
> +               break;
> +       }
> +
> +       if (p->flags & ACPI_HEST_AER_FIRMWARE_FIRST &&
> +           (p->flags & ACPI_HEST_AER_GLOBAL ||
> +            (p->bus      == pciedev->port->bus->number &&
> +             p->device   == PCI_SLOT(pciedev->port->devfn) &&
> +             p->function == PCI_FUNC(pciedev->port->devfn))))
> +               *firmware_first = 1;
> +       return rc;
> +}
> +
> +static int aer_hest_firmware_first(struct acpi_table_header
> *stdheader, struct pcie_device *pciedev)
> +{
> +       struct acpi_table_hest *hest = (struct acpi_table_hest *)stdheader;
> +       void *p = (void *)hest + sizeof(*hest); /* defined by the ACPI
> 4.0 spec */
> +       struct acpi_hest_header *hdr = p;
> +
> +       int i;
> +       int firmware_first = 0;
> +
> +       for (i=0, hdr=p; p < (((void *)hest) + hest->header.length) &&
> i < hest->error_source_count; i++) {
> +               switch (hdr->type) {
> +               case ACPI_HEST_TYPE_XPF_MACHINE_CHECK:
> +                       p += parse_aer_hest_xpf_machine_check(p);
> +                       break;
> +               case ACPI_HEST_TYPE_XPF_CORRECTED_MACHINE_CHECK:
> +                       p += parse_aer_hest_xpf_corrected_machine_check(p);
> +                       break;
> +               case ACPI_HEST_TYPE_XPF_NON_MASKABLE_INTERRUPT:
> +                       p += parse_aer_hest_xpf_nmi(p);
> +                       break;
> +               /* These three should never appear */
> +               case ACPI_HEST_TYPE_XPF_UNUSED:
> +               case ACPI_HEST_TYPE_IPF_CORRECTED_MACHINE_CHECK:
> +               case ACPI_HEST_TYPE_IPF_CORRECTED_PLATFORM_ERROR:
> +                       break;
> +               case ACPI_HEST_TYPE_AER_ROOT_PORT:
> +               case ACPI_HEST_TYPE_AER_ENDPOINT:
> +               case ACPI_HEST_TYPE_AER_BRIDGE:
> +                       p += parse_hest_aer(p, hdr->type, pciedev,
> &firmware_first);
> +                       break;
> +               case ACPI_HEST_TYPE_GENERIC_HARDWARE_ERROR_SOURCE:
> +                       p += parse_hest_generic(p);
> +                       break;
> +               /* These should never appear either */
> +               case ACPI_HEST_TYPE_RESERVED:
> +               default:
> +                       break;
> +               }
> +       }
> +       return firmware_first;
> +}

As H.Seto said, HEST table parsing code should go the general APEI
supporting code. We have some HEST table parsing code, hope that can be
used by your code too.

Best Regards,
Huang Ying


