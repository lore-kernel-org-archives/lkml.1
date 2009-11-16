Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZKPPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZKPPOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZKPPOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:14:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:18463 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZKPPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ow3j8G59UZmtqfBBCOrIYTlm3wP0xKdyLhUC+L0276GvBxpBlzGMFmagFTWagfv4Jk
         HFNvDdEDy/kRS88YAi9/H9bjTpiNosgto8dp0H87uhaFYFOMHUs+N69El5PVcaEjMQne
         oMU3j9jU7vwHFeleCoPBIwm0nSEVennyCtKJY=
Date: Mon, 16 Nov 2009 18:14:26 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, x86team <x86@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,io-apic: IO-APIC MMIO should not fail on resourse
	insertion
Message-ID: <20091116151426.GC5653@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---

Yinghai, I've added your Ack assuming yours "Good to me" is it.

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
