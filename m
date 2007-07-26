Return-Path: <linux-kernel-owner+w=401wt.eu-S936107AbXGZQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107AbXGZQow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935730AbXGZQoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:44:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935706AbXGZQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:44:19 -0400
Date: Thu, 26 Jul 2007 09:43:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC nx6325
 (x86_64)
In-Reply-To: <200707261440.50649.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
References: <200707261440.50649.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
>
> On my Turion64-based HPC nx6325 with the 2.6.23-rc1 x86_64 kernel doing
> 
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> causes the system to crash in a spectacular fashion (call traces going
> continuously on the console, no reaction to anything except for the power
> button).  For this reason, suspend and hibernation don't work as well.

Yeah, I really shouldn't have applied that patch. I didn't notice that it 
not only cleaned up the direct memcpy's, it also re-introduced the damn 
broken code that we fixed once already.

Dammit, that read-only debug support IS NOT WORTH THIS CRAP.

I absolutely *detest* it when "debugging features" end up being the thing 
that causes crashes. I think it shows a total lack of taste and 
understanding, and I'm totally tired of it. This has happened too many 
times.

Andi: please don't send this patch *ever* again. If a patch that is 
supposed to help debugging just causes problems, that patch should be 
thrown away FOREVER.

Andrew - on that same note: please throw away the dwarf traceback crap 
from your tree that Andi is still apparently pushing. Exact same issue. 

Debugging "helper" code that has historically only caused problems. We 
could equally well just enable frame pointers for debugging and add the 
trivial code to follow that instead, and it would work (the way it has 
worked on x86 basically forever).

Rafael, does reverting just this part (and leaving the "text_poke()" 
cleanups) work for you?

			Linus

---
 arch/i386/kernel/alternative.c |   10 ----------
 arch/i386/mm/init.c            |   14 +++++++++++---
 arch/x86_64/mm/init.c          |   10 ++++++++++
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index c3750c2..c0d0a89 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -432,20 +432,10 @@ void __init alternative_instructions(void)
  */
 void __kprobes text_poke(void *oaddr, unsigned char *opcode, int len)
 {
-        u8 *addr = oaddr;
-	if (!pte_write(*lookup_address((unsigned long)addr))) {
-		struct page *p[2] = { virt_to_page(addr), virt_to_page(addr+PAGE_SIZE) };
-		addr = vmap(p, 2, VM_MAP, PAGE_KERNEL);
-		if (!addr)
-			return;
-		addr += ((unsigned long)oaddr) % PAGE_SIZE;
-	}
 	memcpy(addr, opcode, len);
 	sync_core();
 	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
 	   case. */
 	if (cpu_has_clflush)
 		asm("clflush (%0) " :: "r" (oaddr) : "memory");
-	if (addr != oaddr)
-		vunmap(addr);
 }
diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index 1b1a1e6..4c4809f 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -800,9 +800,17 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-	change_page_attr(virt_to_page(start),
-	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-	printk("Write protecting the kernel text: %luk\n", size >> 10);
+#ifndef CONFIG_KPROBES
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() <= 1)
+#endif
+	{
+		change_page_attr(virt_to_page(start),
+		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+		printk("Write protecting the kernel text: %luk\n", size >> 10);
+	}
+#endif
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 38f5d63..458893b 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -600,6 +600,16 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() > 1)
+		start = (unsigned long)_etext;
+#endif
+
+#ifdef CONFIG_KPROBES
+	start = (unsigned long)__start_rodata;
+#endif
+	
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;
