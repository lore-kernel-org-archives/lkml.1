Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYHYG2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYHYG2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYHYG2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:28:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbYHYG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:28:03 -0400
Date: Mon, 25 Aug 2008 08:27:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Witbrodt <dawitbro@sbcglobal.net>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080825062746.GA26445@elte.hu>
References: <914225.91320.qm@web82104.mail.mud.yahoo.com> <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86: check hpet with BAR v2
> 
> insert some resources to resource tree forcily, so could avoid kernel update the
> resources in pci device.
> 
> should check in device too.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/pci/i386.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/i386.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/i386.c
> +++ linux-2.6/arch/x86/pci/i386.c
> @@ -33,6 +33,7 @@
>  #include <linux/bootmem.h>
>  
>  #include <asm/pat.h>
> +#include <asm/hpet.h>
>  
>  #include "pci.h"
>  
> @@ -77,6 +78,30 @@ pcibios_align_resource(void *data, struc
>  }
>  EXPORT_SYMBOL(pcibios_align_resource);
>  
> +static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
> +{
> +	unsigned long base;
> +	unsigned long size;
> +
> +	base = res->start;
> +	size = (res->start == 0 && res->end == res->start) ? 0 :
> +		 (res->end - res->start + 1);
> +
> +	if (!base || !size)
> +		return 0;
> +
> +#ifdef CONFIG_HPET_TIMER
> +	/* for hpet */
> +	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
> +		dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
> +				 base, base + size - 1);
> +		return 1;
> +	}
> +#endif

i think the warning should be more prominent and should also generate a 
stack trace for the kerneloops client to pick up. A WARN() printout 
would be perfect here.

Also, we should do subsequent commits as well enumerating all the other 
'magic' non-PCI-enumerated bus memory resources that matter on a PC 
platform: lapic address and io-apic address(es). Perhaps even the ACPI 
NVS and ACPI data areas that are enumerated in e820.

(the lapic address will likely never be present in a PCI device - but 
maybe the IO-APIC address can be present in theory - so lets protect 
it.)

Another suggestion: perhaps this all should be done as a new, "sticky" 
resource type flag [defined in include/linux/ioport.h and implemented in 
kernel/resource.c], which would be inserted by the hpet driver, and 
which would be listened to by pcibios_allocate_resources() 
automatically. If the resource manager later on finds a generic-looking, 
unclaimed PCI device whose BAR matches on it, then the new semantics 
would mean that the device's BAR will not be touched.

This approach would be even more generic and would allow a robust 
insertion of maybe-PCI addresses into the resource tree.

	Ingo
