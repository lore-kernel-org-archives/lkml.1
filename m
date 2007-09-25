Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXIYMSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXIYMSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXIYMSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:18:38 -0400
Received: from www.osadl.org ([213.239.205.134]:34132 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269AbXIYMSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:18:37 -0400
Subject: Re: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200709251408.54361.rjw@sisk.pl>
References: <200709251408.54361.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:18:30 +0200
Message-Id: <1190722710.4035.320.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 14:08 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> This patch from Andi:
> 
> x86_64-mm-cpa-einval.patch
> 
> makes the hda_intel audio driver stop working on my HP nx6325.
> 
> The following line appears in dmesg (from 2.6.23-rc7-mm1:
> 
> ALSA /home/rafael/src/mm/linux-2.6.23-rc7-mm1/sound/pci/hda/hda_intel.c:1755: hd
> a-intel: ioremap error
> 
> and the driver doesn't work afterwards.
> 
> Still, I'm not sure if the patch above is wrong or rather it exposes a problem
> in the driver.

The patch is correct. Instead of returning "Success" in the case of a
failure of lookup_address, it now returns -EINVAL, which in turn makes
the ioremap fail.

OTOH, the driver ioremap call looks straight forward. Can you apply the
patch below and provide the resulting debug output please ?

Thanks,

	tglx

Index: linux-2.6.23-rc8-mm/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6.23-rc8-mm.orig/arch/x86_64/mm/pageattr.c	2007-09-25 14:05:41.000000000 +0200
+++ linux-2.6.23-rc8-mm/arch/x86_64/mm/pageattr.c	2007-09-25 14:09:35.000000000 +0200
@@ -156,8 +156,10 @@ __change_page_attr(unsigned long address
 	pgprot_t ref_prot2;
 
 	kpte = lookup_address(address);
-	if (!kpte)
+	if (!kpte) {
+		printk("lookup failed for %lu\n", address);
 		return -EINVAL;
+	}
 
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	BUG_ON(PageCompound(kpte_page));
Index: linux-2.6.23-rc8-mm/sound/pci/hda/hda_intel.c
===================================================================
--- linux-2.6.23-rc8-mm.orig/sound/pci/hda/hda_intel.c	2007-09-25 14:05:43.000000000 +0200
+++ linux-2.6.23-rc8-mm/sound/pci/hda/hda_intel.c	2007-09-25 14:09:28.000000000 +0200
@@ -1752,7 +1752,8 @@ static int __devinit azx_create(struct s
 	chip->addr = pci_resource_start(pci, 0);
 	chip->remap_addr = ioremap_nocache(chip->addr, pci_resource_len(pci,0));
 	if (chip->remap_addr == NULL) {
-		snd_printk(KERN_ERR SFX "ioremap error\n");
+		snd_printk(KERN_ERR SFX "ioremap error: %lu %lu\n",
+			   chip->addr, pci_resource_len(pci, 0));
 		err = -ENXIO;
 		goto errout;
 	}



