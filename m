Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbYARV7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbYARV7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbYARV7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:59:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbYARV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:59:31 -0500
Date: Fri, 18 Jan 2008 13:58:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, jeff@garzik.org,
       greg@kroah.com, hancockr@shaw.ca, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: MMCONF enable MCFG early
Message-Id: <20080118135830.7a04a806.akpm@linux-foundation.org>
In-Reply-To: <200801161409.02591.yinghai.lu@sun.com>
References: <200801161405.17889.yinghai.lu@sun.com>
	<200801161406.38946.yinghai.lu@sun.com>
	<200801161409.02591.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 14:09:02 -0800
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86: MMCONF enable MCFG early
> 
> patch
> 	x86: validate against ACPI motherboard resources
> 
> changed the mmconf init sequence, and init MMCONF late in acpi_init.
> 
> here change it back to old sequence
> 1. check hostbridge in early
> 2. check MCFG with e820 in early
> 3. if all fail, will check MCFg with acpi _CRS in acpi_init
> 
> So we can make MCONF working again when acpi=off is set if hostbridge support that.
> 
> ...
>
> +		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
>  		       "segment %hu buses %u - %u\n",
>  		       i, (unsigned long)cfg->address, cfg->pci_segment,
>  		       (unsigned int)cfg->start_bus_number,
>  		       (unsigned int)cfg->end_bus_number);
> +
> +		if (!early)
>  		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
>  			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
>  			       "in ACPI motherboard resources\n",
>  			       cfg->address);
> -		} else {
> +			valid = 1;
> +		}

grumble.  Please don't mess up the kernel source like that.

> -void __init pci_mmcfg_late_init(void)
> +void __init __pci_mmcfg_init(int type, int early)
>  {
> -	int known_bridge = 0;
> -
>  	/* MMCONFIG disabled */
>  	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
>  		return;
>  
>  	/* MMCONFIG already enabled */
> +	if (!early)
>  	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
>  		return;
>  

and that.  Do it properly.

--- a/arch/x86/pci/mmconfig-shared.c~x86-mmconf-enable-mcfg-early-cleanup
+++ a/arch/x86/pci/mmconfig-shared.c
@@ -308,8 +308,8 @@ static void __init pci_mmcfg_reject_brok
 		       (unsigned int)cfg->start_bus_number,
 		       (unsigned int)cfg->end_bus_number);
 
-		if (!early)
-		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
+		if (!early &&
+		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
 			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
 			       "in ACPI motherboard resources\n",
 			       cfg->address);
@@ -357,8 +357,7 @@ void __init __pci_mmcfg_init(int type, i
 		return;
 
 	/* MMCONFIG already enabled */
-	if (!early)
-	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
+	if (!early && !(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
 		return;
 
 	/* for late to exit */
_

