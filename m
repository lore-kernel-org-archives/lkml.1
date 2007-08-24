Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXHXTR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXHXTR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764333AbXHXTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:17:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43525 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763829AbXHXTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:17:38 -0400
Date: Fri, 24 Aug 2007 12:12:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH v2 -mm 7/7] I/OAT: Add DCA services
Message-Id: <20070824121217.3048147c.randy.dunlap@oracle.com>
In-Reply-To: <20070824001527.16997.2238.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
	<20070824001527.16997.2238.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:15:27 -0700 Shannon Nelson wrote:

> Add code to connect to the DCA driver and provide cpu tags for use by
> drivers that would like to use Direct Cache Access hints.
> 
>     [Adrian Bunk]                Several Kconfig cleanup items
>     [Andrew Morten, Chris Leech] fix for using cpu_physical_id() even when
> 			         built for uni-processor
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
> 
>  drivers/dca/Kconfig    |    7 -
>  drivers/dma/Kconfig    |   60 ++++++-----
>  drivers/dma/Makefile   |    2 
>  drivers/dma/ioat.c     |   12 ++
>  drivers/dma/ioat_dca.c |  267 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/ioatdma.h  |    2 
>  6 files changed, 318 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
> new file mode 100644
> index 0000000..03c993a
> --- /dev/null
> +++ b/drivers/dma/ioat_dca.c
> @@ -0,0 +1,267 @@

> +
> +/* either a kernel change is needed, or we need something like this in kernel */
> +#ifndef CONFIG_SMP
> +#include <asm/smp.h>
> +#undef cpu_physical_id
> +#define cpu_physical_id(cpu) (cpuid_ebx(1) >> 24)
> +#endif
> +
> +#include "ioatdma.h"
> +#include "ioatdma_registers.h"
> +
> +/* THIS STUFF NEEDS TO LIVE SOMEWHERE ELSE */
> +#define X86_FEATURE_DCA	(4*32+18) /* Direct Cache Access */
> +/* / THIS STUFF NEEDS TO LIVE SOMEWHERE ELSE */

Yes, feature bits need to be integrated with the other CPU-specific
feature bits.

> +/* pack PCI B/D/F into a u16 */
> +static inline u16 dcaid_from_pcidev(struct pci_dev *pci)
> +{
> +	return (pci->bus->number << 8) | pci->devfn;
> +}

Could any other PCI users use this in include/linux/pci.h ?


> diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
> index 5931e56..d59c90b 100644
> --- a/drivers/dma/ioatdma.h
> +++ b/drivers/dma/ioatdma.h
> @@ -132,9 +132,11 @@ struct ioat_desc_sw {
>  #if defined(CONFIG_INTEL_IOATDMA) || defined(CONFIG_INTEL_IOATDMA_MODULE)
>  struct ioatdma_device *ioat_dma_probe(struct pci_dev *, void __iomem *);
>  void ioat_dma_remove(struct ioatdma_device *device);
> +struct dca_provider *ioat_dca_init(struct pci_dev *, void __iomem *);

Parameter (variable) names in prototypes, please.

>  #else
>  #define ioat_dma_probe(pdev, io)                NULL
>  #define ioat_dma_remove(dev)            do { } while (0)
> +#define ioat_dca_init(pdev, io)			NULL
>  #endif
>  
>  #endif /* IOATDMA_H */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
