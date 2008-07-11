Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYGKIkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYGKIkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYGKIkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:40:08 -0400
Received: from mail-va3.bigfish.com ([216.32.180.111]:19716 "EHLO
	mail32-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752841AbYGKIkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:40:06 -0400
X-BigFish: VPS-14(z1039oz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K3U2QI-01-QGH-01
Date: Fri, 11 Jul 2008 10:39:46 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [x86, patch] turn x86 VISWS into a generic architecture
Message-ID: <20080711083946.GU7963@erda.amd.com>
References: <20080710170712.GA14583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710170712.GA14583@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 08:39:47.0849 (UTC) FILETIME=[AD2ED790:01C8E331]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.08 19:07:12, Ingo Molnar wrote:

[...]

> diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> index 99d9f09..e515e8d 100644
> --- a/arch/x86/pci/Makefile
> +++ b/arch/x86/pci/Makefile
> @@ -9,9 +9,7 @@ pci-y				:= fixup.o
>  pci-$(CONFIG_ACPI)		+= acpi.o
>  pci-y				+= legacy.o irq.o
>  
> -# Careful: VISWS overrule the pci-y above. The colons are
> -# therefor correct. This needs a proper fix by distangling the code.
> -pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
> +pci-$(CONFIG_X86_VISWS)		+= visws.o

Ingo, if we turn this into generic code, we have to remove the
subsys_initcall for this too. Otherwise subsystem initialization is
running twice, in legacy.c and in visws.c.

>  
>  pci-$(CONFIG_X86_NUMAQ)		+= numa.o
>  
> diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
> index 16e5206..1a7bed4 100644
> --- a/arch/x86/pci/visws.c
> +++ b/arch/x86/pci/visws.c
> @@ -8,18 +8,19 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  
> -#include "cobalt.h"
> -#include "lithium.h"
> +#include <asm/setup.h>
> +#include <asm/visws/cobalt.h>
> +#include <asm/visws/lithium.h>
>  
>  #include "pci.h"
>  
>  static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
>  static void pci_visws_disable_irq(struct pci_dev *dev) { }
>  
> -int (*pcibios_enable_irq)(struct pci_dev *dev) = &pci_visws_enable_irq;
> -void (*pcibios_disable_irq)(struct pci_dev *dev) = &pci_visws_disable_irq;
> +/* int (*pcibios_enable_irq)(struct pci_dev *dev) = &pci_visws_enable_irq; */
> +/* void (*pcibios_disable_irq)(struct pci_dev *dev) = &pci_visws_disable_irq; */
>  
> -void __init pcibios_penalize_isa_irq(int irq, int active) {}
> +/* void __init pcibios_penalize_isa_irq(int irq, int active) {} */
>  
>  
>  unsigned int pci_bus0, pci_bus1;
> @@ -107,7 +108,15 @@ static int __init pci_visws_init(void)
>  
>  static __init int pci_subsys_init(void)
>  {
> +	if (!is_visws_box())
> +		return -1;
> +
> +	pcibios_enable_irq = &pci_visws_enable_irq;
> +	pcibios_disable_irq = &pci_visws_disable_irq;
> +
>  	pci_visws_init();
>  	pcibios_init();
> +
> +	return 0;
>  }
>  subsys_initcall(pci_subsys_init);

This code should be moved to pci_subsys_init() of legacy.c.

[...]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

