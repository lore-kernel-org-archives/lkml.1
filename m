Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZKMTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZKMTWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbZKMTWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:22:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:11871 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbZKMTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dsarmUiNFOI8BFXBBuj94wRNUUJv5hy9GtjZs+Vq8fup1EVaAsuNzVUwm62IqI8AVp
         inbQ2us7/wTFt8VyDfb/nAaKPKfDJAhipXLNlovebm8EdtE1ZpGWyeRthezdSq4iJFTE
         FNcbR1p1o8kvsRzu3MlRDklkmu3Qesp2sRxIQ=
Date: Fri, 13 Nov 2009 22:22:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers
	twice
Message-ID: <20091113192242.GD5695@lenovo>
References: <20091112204852.GB5728@lenovo> <4AFC98CF.5030408@kernel.org> <20091113175057.GA5695@lenovo> <4AFDABE3.2050006@kernel.org> <20091113190955.GC5695@lenovo> <4AFDB0AC.10302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFDB0AC.10302@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:17:00AM -0800, Yinghai Lu wrote:
> >> Cyrill Gorcunov wrote:
> >>> On Thu, Nov 12, 2009 at 03:22:55PM -0800, Yinghai Lu wrote:
> >> 2. print out ...?
> > 
> > Print out what? Not sure I understand you right. Perhaps you mean
> > to check insert_resourse results?
...
> 
>   		apic_printk(APIC_VERBOSE,
>  			    "mapped IOAPIC to %08lx (%08lx)\n",
> -			    __fix_to_virt(idx), ioapic_phys);
> +			    __fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
> 
> YH
> 

Updated version below, thanks Yinghai! Looks good?

	-- Cyrill
---
x86,io-apic: IO-APIC MMIO should not fail on resourse insertion

If IO-APIC base address is 1K aligned we should not fail
on resourse insertion procedure. For this sake we define
IO_APIC_SLOT_SIZE constant which should cover all IO-APIC
direct accessible registers.

An example of a such configuration is there

	http://marc.info/?l=linux-kernel&m=118114792006520

| Quoting the message
|
| IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
| IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
| IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
| IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
| IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119

Reported-by: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apicdef.h |    7 +++++++
 arch/x86/kernel/apic/io_apic.c |   11 +++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apicdef.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6.git/arch/x86/include/asm/apicdef.h
@@ -11,6 +11,13 @@
 #define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
 #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
+/*
+ * We assume that it will be more then enough
+ * in feasible feauture to cover all direct
+ * accessible IO-APIC registers
+ */
+#define IO_APIC_SLOT_SIZE		1024
+
 #define	APIC_ID		0x20
 
 #define	APIC_LVR	0x30
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -4133,18 +4133,17 @@ void __init ioapic_init_mappings(void)
 #ifdef CONFIG_X86_32
 fake_ioapic_page:
 #endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %08lx (%08lx)\n",
-			    __fix_to_virt(idx), ioapic_phys);
+		apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
+			__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+			ioapic_phys);
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
+		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
 }
