Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYBOEsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYBOEsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 23:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBOEsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 23:48:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:41613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYBOEsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 23:48:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="340269526"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080214161218.GA28152@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 12:48:06 +0800
Message-Id: <1203050886.30010.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 04:47:05.0737 (UTC) FILETIME=[D0645F90:01C86F8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 17:12 +0100, Ingo Molnar wrote: 
> this is indeed a bug (we change the attributes for a larger area than 
> needed), but your fix is unclean. Find below a cleaner solution.
> 
> Ying, if you agree with this fix could you please test and ACK it before 
> we push it to Linus? (this fix is also in the latest x86.git#mm)

I think the patch following may be better, because it is possible that
the EFI_PAGE_SHIFT and PAGE_SHIFT are different.

Best Regards,
Huang Ying

-------------------------> 
The EFI-runtime mapping code changed a larger memory area than it
should have, due to a pages/bytes parameter mixup.

noticed by Andi Kleen.

This patch has been tested on Intel x86 platform with EFI 32/64.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -386,12 +386,13 @@ static void __init runtime_code_page_mke
 
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+		unsigned long num_pages;
 
+		md = p;
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
-
-		set_memory_x(md->virt_addr, md->num_pages << EFI_PAGE_SHIFT);
+		num_pages = (md->num_pages << EFI_PAGE_SHIFT) >> PAGE_SHIFT;
+		set_memory_x(md->virt_addr, num_pages);
 	}
 }
 
@@ -434,7 +435,7 @@ void __init efi_enter_virtual_mode(void)
 		}
 
 		if (!(md->attribute & EFI_MEMORY_WB))
-			set_memory_uc(md->virt_addr, size);
+			set_memory_uc(md->virt_addr, size >> PAGE_SHIFT);
 
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {

