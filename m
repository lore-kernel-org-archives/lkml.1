Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZKMRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZKMRvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZKMRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:51:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49168 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZKMRvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HkKSnh7SqDQHr0oCm5eCtUCf8dclYVyAUtDtjSWGCkJIrSNqzR+iF8G/kty5BMuqjW
         RnINnpJzz/mAyVMlfjcRR8nkozJDB+QB6dZHt8tyHmMqMiPm20WN5vfYXQbYm+cTrLJw
         I59vUqHhYxDV0Oj0BCbxks+2pUGiax/jTuJvg=
Date: Fri, 13 Nov 2009 20:50:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers
	twice
Message-ID: <20091113175057.GA5695@lenovo>
References: <20091112204852.GB5728@lenovo> <4AFC98CF.5030408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC98CF.5030408@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 03:22:55PM -0800, Yinghai Lu wrote:
> Cyrill Gorcunov wrote:
> > Please review, I didn't manage to test (emulate actually since I don't
> > 
...

First of all -- thanks a lot for review Yinghai!

> > Also insert_resourse will not fail anymore on 1K aligned io-apics.
> 
> looks that we don't need that ...
> not io_apic_base already have that + &. left problems are
> 1. display.
> 2. insert resource problem.
> 
> YH
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 90e8bc5..6a9379b 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -4140,11 +4140,13 @@ fake_ioapic_page:
>  		set_fixmap_nocache(idx, ioapic_phys);
>  		apic_printk(APIC_VERBOSE,
>  			    "mapped IOAPIC to %08lx (%08lx)\n",
> -			    __fix_to_virt(idx), ioapic_phys);
> +			    __fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),

Don't understand, why? What is wrong with physical address,
could you elaborate please?

> +			    ioapic_phys);
>  		idx++;
>  
> +		/* spec says size is 1024 */

Hmm, MP says nothing about size of IO-APIC direct registers
cound and as a result -- the size of MMIO. It will (and
is) differ between IO-APIC versions. An example -- IO-APIC EOI register
which 82489DX just dont have at all. At moment (ICH-10) the lenght is 68
bytes so you may note the comment in the former patch that we "hope" such
a size will be enough for quite a long time to cover all direct register
space an IO-APIC provides (though to be precise from this 68 bytes only
index,data,eoi registers specified).

>  		ioapic_res->start = ioapic_phys;
> -		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
> +		ioapic_res->end = ioapic_phys + (1<<10) - 1;
>  		ioapic_res++;
>  	}
>  }
>

I think I've compicated the patch/idea too much indeed :)
Since we have fixmap for all io_apics build time reserved
even if some io-apic is 1K aligned we still may use new
fixmap index. So only issue remains -- resource allocation.
Here is an updated patch. Please review.

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
 arch/x86/kernel/apic/io_apic.c |    5 ++---
 2 files changed, 9 insertions(+), 3 deletions(-)

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
@@ -4133,8 +4133,7 @@ void __init ioapic_init_mappings(void)
 #ifdef CONFIG_X86_32
 fake_ioapic_page:
 #endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
@@ -4144,7 +4143,7 @@ fake_ioapic_page:
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
+		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
 }
