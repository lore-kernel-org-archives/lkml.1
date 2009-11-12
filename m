Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZKLX0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZKLX0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZKLX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:26:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:52489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbZKLX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:26:05 -0500
Message-ID: <4AFC98CF.5030408@kernel.org>
Date: Thu, 12 Nov 2009 15:22:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers twice
References: <20091112204852.GB5728@lenovo>
In-Reply-To: <20091112204852.GB5728@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Please review, I didn't manage to test (emulate actually since I don't
> have such a hardware) it yet (going to do so this weekend).
> 
> Meanwhile I would like to heard comments, complains and etc...
> Perhaps I miss something obvious so don't hesitate to poke me.
> 
> 	-- Cyrill
> ---
> x86,io-apic: Do not map IO-APIC direct registers twice
> 
> In case if IO-APIC address is not 4K aligned (which is pretty
> established by MPS-1.4) we may not fixmap they twice and
> should eliminate resourse overlap in this case.
> 
> An example of a such configureation is
> 
> 	http://marc.info/?l=linux-kernel&m=118114792006520
> 
> | Quoting the message
> |
> | IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> | IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
> | IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
> | IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
> | IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119
> 
> Some io-apics are 4K aligned while others are -- 1K. We may have
> the situation when next IO-APIC address (1K aligned) is following
> previous 4K one. So instead of allocating new fixmap we may use already
> done one.
> 
> To implement it ioapic_fixmap_shared is introduced which check if
> new IO-APIC base address lays inside already mapped page.
> 
> Also insert_resourse will not fail anymore on 1K aligned io-apics.

looks that we don't need that ...
not io_apic_base already have that + &. left problems are
1. display.
2. insert resource problem.

YH

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 90e8bc5..6a9379b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4140,11 +4140,13 @@ fake_ioapic_page:
 		set_fixmap_nocache(idx, ioapic_phys);
 		apic_printk(APIC_VERBOSE,
 			    "mapped IOAPIC to %08lx (%08lx)\n",
-			    __fix_to_virt(idx), ioapic_phys);
+			    __fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+			    ioapic_phys);
 		idx++;
 
+		/* spec says size is 1024 */
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
+		ioapic_res->end = ioapic_phys + (1<<10) - 1;
 		ioapic_res++;
 	}
 }
