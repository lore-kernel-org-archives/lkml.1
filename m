Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZCQTnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZCQTnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCQTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:42:57 -0400
Received: from gw.goop.org ([64.81.55.164]:51031 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZCQTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:42:57 -0400
Message-ID: <49BFFD3C.3020908@goop.org>
Date: Tue, 17 Mar 2009 12:42:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com> <49BEBD98.3090905@goop.org> <49BEC143.6030104@zytor.com> <49BEC53F.20200@goop.org> <49BED431.5070201@zytor.com> <49BF0A51.5000909@kernel.org> <49BF2054.9020009@zytor.com> <49BF301C.6010708@goop.org> <49BFCA05.7000508@zytor.com>
In-Reply-To: <49BFCA05.7000508@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> H. Peter Anvin wrote:
>>     
>>> Yinghai Lu wrote:
>>>  
>>>       
>>>>> You could also write:
>>>>>
>>>>> PAGE_TABLE_SIZE((-PAGE_OFFSET & 0xffffffff) >> PAGE_SHIFT) <<
>>>>> PAGE_SHIFT
>>>>>
>>>>> (the & 0xffffffff is necessary, or you'll get a signed shift.)
>>>>>       
>>>>>           
>>>> max kernel address space range?
>>>>
>>>>     
>>>>         
>>> Yes, either ((1 << 32)-PAGE_OFFSET) or (-PAGE_OFFSET & 0xffffffff)
>>> should work for that.
>>>   
>>>       
>> The former seems more obvious.
>>     
>
> Hi,
>
> Are you refreshing the patchset?
>   

Here's an updated patch:

>From a7029ec1dbff1f32d75c03d45b3bb3497fb3032c Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Mon, 16 Mar 2009 12:07:54 -0700
Subject: [PATCH] x86-32: make sure we map enough to fit linear map pagetables

head_32.S needs to map the kernel itself, and enough space so
that mm/init.c can allocate space from the e820 allocator
for the linear map of low memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index c79741c..83e4192 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -38,8 +38,8 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
+ * This is how much memory in addition to the memory covered up to
+ * and including _end we need mapped initially.
  * We need:
  *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
  *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
@@ -52,19 +52,28 @@
  * KERNEL_IMAGE_SIZE should be greater than pa(_end)
  * and small than max_low_pfn, otherwise will waste some page table entries
  */
-LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
 #if PTRS_PER_PMD > 1
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
+#define PAGE_TABLE_SIZE(pages) (((pages) / PTRS_PER_PMD) + PTRS_PER_PGD)
 #else
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
+#define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
 #endif
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
-RESERVE_BRK(pagetables, INIT_MAP_SIZE)
+/* Enough space to fit pagetables for the low memory linear map */
+MAPPING_BEYOND_END = (PAGE_TABLE_SIZE(((1 << 32) - __PAGE_OFFSET) / PAGE_SIZE) * PAGE_SIZE)
 
 /*
+ * Worst-case size of the kernel mapping we need to make:
+ * the worst-case size of the kernel itself, plus the extra we need
+ * to map for the linear map.
+ */
+KERNEL_PAGES = (KERNEL_IMAGE_SIZE + MAPPING_BEYOND_END)>>PAGE_SHIFT
+
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE(KERNEL_PAGES) + ALLOCATOR_SLOP) * PAGE_SIZE_asm
+RESERVE_BRK(pagetables, INIT_MAP_SIZE)
+	
+/*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
  * CS and DS must be 4 GB flat segments, but we don't depend on
@@ -197,9 +206,9 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to the end.
+	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
 	 */
-	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
+	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
@@ -229,9 +238,9 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to end
+	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
 	 */
-	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
+	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 	addl $__PAGE_OFFSET, %edi


