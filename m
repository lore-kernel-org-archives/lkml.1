Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYCJShi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYCJShi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYCJShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:37:00 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:35095 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbYCJSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:36:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEADMc1UdMQWoK/2dsb2JhbACBWKkcggc
Date: Mon, 10 Mar 2008 14:36:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 Fix test_poke for vmalloced pages
Message-ID: <20080310183653.GA4482@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:35:35 up 10 days, 14:46,  6 users,  load average: 1.74, 1.49,
	1.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shadow vmap for DEBUG_RODATA kernel text modification uses virt_to_page to
get the pages from the pointer address.

However, I think vmalloc_to_page would be required in case the page is used for
modules.

Since only the core kernel text is marked read-only, use kernel_text_address()
to make sure we only shadow map the core kernel text, not modules.

It applies on top of the current x86 git tree.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6-x86/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/alternative.c	2008-03-10 10:34:11.000000000 -0400
+++ linux-2.6-x86/arch/x86/kernel/alternative.c	2008-03-10 10:50:38.000000000 -0400
@@ -511,7 +511,7 @@
 	BUG_ON(len > sizeof(long));
 	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
 		- ((long)addr & ~(sizeof(long) - 1)));
-	{
+	if (kernel_text_address((unsigned long)addr)) {
 		struct page *pages[2] = { virt_to_page(addr),
 			virt_to_page(addr + PAGE_SIZE) };
 		if (!pages[1])
@@ -522,6 +522,13 @@
 		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
 		local_irq_restore(flags);
 		vunmap(vaddr);
+	} else {
+		/*
+		 * modules are in vmalloc'ed memory, always writable.
+		 */
+		local_irq_save(flags);
+		memcpy(addr, opcode, len);
+		local_irq_restore(flags);
 	}
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
