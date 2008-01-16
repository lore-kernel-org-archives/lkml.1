Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYAPUdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYAPUdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYAPUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:33:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:14809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYAPUd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:33:29 -0500
X-ExtLoop1: 1
Date: Wed, 16 Jan 2008 12:33:28 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080116203328.GA17869@linux-os.sc.intel.com>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116185748.GA11244@alberich.amd.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 07:57:48PM +0100, Andreas Herrmann wrote:
> Hi,
> 
> I just want to report that the PAT support in x86/mm causes crashes
> on two of my test machines. On both boxes the SATA detection does
> not work when the PAT support is patched into the kernel.
> 
> Symptoms are as follows -- best described by a diff between the
> two boot.logs:
> 
> # diff boot-failing.log boot-working.log
> 
> -Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version ...
> +Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version ...
> ...
>  early_iounmap(ffffffff82a0b000, 00001000)
> -early_ioremap(000000000000c000, 00001000) => -000002103394304
> -early_iounmap(ffffffff82a0c000, 00001000)
This does not look to be the problem here. We just mapped some new low
address due to possibly a different code path. But, seems to have worked fine.

>  early_iounmap(ffffffff82808000, 00001000)
> ...
> -ACPI: PCI interrupt for device 0000:00:12.0 disabled
> -sata_sil: probe of 0000:00:12.0 failed with error -12
> +scsi0 : sata_sil
> +scsi1 : sata_sil
> +ata1: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc0403080 irq 22
> ...
> -AC'97 space ioremap problem
> -ACPI: PCI interrupt for device 0000:00:14.5 disabled
> -ATI IXP AC97 controller: probe of 0000:00:14.5 failed with error -5

This ioremap failing seems to be the real problem. This can be due to
new tracking of ioremaps introduced by PAT patches. We do not allow
conflicting ioremaps to same region. Probably that is happening
in both Sound and sata initialization which results in driver init failing.

Can you please try the debug patch below over latest x86/mm and boot kernel with
debug boot option and send us the dmesg from the failure. That will give us
better info about ioremaps.

Thanks,
Venki


Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-16 03:38:32.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-16 05:16:28.000000000 -0800
@@ -150,6 +150,8 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
+	printk(KERN_DEBUG "ioremap_nocache: addr %lx, size %lx\n",
+	       phys_addr, size);
 	return __ioremap(phys_addr, size, _PAGE_UC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
Index: linux-2.6.git/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_64.h	2008-01-16 03:38:32.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_64.h	2008-01-16 05:16:57.000000000 -0800
@@ -154,6 +154,8 @@
 
 static inline void __iomem * ioremap (unsigned long offset, unsigned long size)
 {
+	printk(KERN_DEBUG "ioremap: addr %lx, size %lx\n",
+	       offset, size);
 	return __ioremap(offset, size, 0);
 }
 
