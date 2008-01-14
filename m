Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYANRFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYANRFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYANRFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:05:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9054 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYANRFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:05:05 -0500
X-SBRS: None
X-MesageID: 37657464
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,283,1196658000"; 
   d="scan'208";a="37657464"
Message-ID: <478B9606.6020008@citrix.com>
Date: Mon, 14 Jan 2008 09:04:06 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com> <20080114154817.GA14000@elte.hu> <478B96A5.76E4.0078.0@novell.com>
In-Reply-To: <478B96A5.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Ingo Molnar <mingo@elte.hu> 14.01.08 16:48 >>>
>>>>         
>> * Jan Beulich <jbeulich@novell.com> wrote:
>>
>>     
>>> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory 
>>> (Xen requires GDT *and* LDT to be page-aligned). Using the page 
>>> allocator interface also removes the (albeit small) slab allocator 
>>> overhead. The same change being done for 64-bits for consistency.
>>>
>>> Further, the Xen hypercall interface expects the LDT address to be 
>>> virtual, not machine.
>>>       
>> coul dyou try this against x86.git as well? We already unified ldt.c as 
>> part of the paravirt patches.
>>     
>
> Sure, but it may take me a little while.

I've got the unified version here. 

Subject: xen: adjust/fix LDT handling for Xen

From: "Jan Beulich" <jbeulich@novell.com>

Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory
(Xen requires GDT *and* LDT to be page-aligned). Using the page
allocator interface also removes the (albeit small) slab allocator
overhead. The same change being done for 64-bits for consistency.

Further, the Xen hypercall interface expects the LDT address to be
virtual, not machine.

[ Adjusted to unified ldt.c - Jeremy ]

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/ldt.c    |    7 +++----
 arch/x86/xen/enlighten.c |    9 +--------
 2 files changed, 4 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
-#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -40,7 +39,7 @@ static int alloc_ldt(mm_context_t *pc, i
 	if (mincount * LDT_ENTRY_SIZE > PAGE_SIZE)
 		newldt = vmalloc(mincount * LDT_ENTRY_SIZE);
 	else
-		newldt = kmalloc(mincount * LDT_ENTRY_SIZE, GFP_KERNEL);
+		newldt = (void *)__get_free_page(GFP_KERNEL);
 
 	if (!newldt)
 		return -ENOMEM;
@@ -78,7 +77,7 @@ static int alloc_ldt(mm_context_t *pc, i
 		if (oldsize * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(oldldt);
 		else
-			kfree(oldldt);
+			put_page(virt_to_page(oldldt));
 	}
 	return 0;
 }
@@ -129,7 +128,7 @@ void destroy_context(struct mm_struct *m
 		if (mm->context.size * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(mm->context.ldt);
 		else
-			kfree(mm->context.ldt);
+			put_page(virt_to_page(mm->context.ldt));
 		mm->context.size = 0;
 	}
 }
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -275,19 +275,12 @@ static unsigned long xen_store_tr(void)
 
 static void xen_set_ldt(const void *addr, unsigned entries)
 {
-	unsigned long linear_addr = (unsigned long)addr;
 	struct mmuext_op *op;
 	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
 
 	op = mcs.args;
 	op->cmd = MMUEXT_SET_LDT;
-	if (linear_addr) {
-		/* ldt my be vmalloced, use arbitrary_virt_to_machine */
-		xmaddr_t maddr;
-		maddr = arbitrary_virt_to_machine((unsigned long)addr);
-		linear_addr = (unsigned long)maddr.maddr;
-	}
-	op->arg1.linear_addr = linear_addr;
+	op->arg1.linear_addr = (unsigned long)addr;
 	op->arg2.nr_ents = entries;
 
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);

