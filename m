Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYDTTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYDTTow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbYDTTon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:44:43 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:61898 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854AbYDTTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:44:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAO44C0hMROPA/2dsb2JhbACBUKc4
Date: Sun, 20 Apr 2008 15:44:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Check for breakpoint in text_poke to eliminate bug_on
Message-ID: <20080420194440.GA15319@Krystal>
References: <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal> <20080420000657.20ba6b4b@daedalus.pq.iki.fi> <20080420005208.12ad32fd@daedalus.pq.iki.fi> <20080419215826.GC2831@Krystal> <20080420014206.5cd61d4a@daedalus.pq.iki.fi> <20080420000509.GA7496@Krystal> <20080420101408.518b21b4@daedalus.pq.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080420101408.518b21b4@daedalus.pq.iki.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:43:14 up 51 days, 15:54,  4 users,  load average: 0.50, 0.61,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you test this new version ? The check was buggy when it fell on a
code boundary : the addr - 1 wan't always a valid address.



Check for breakpoint in text_poke to eliminate bug_on

It's ok to modify an instruction non-atomically (multiple memory accesses to a
large and/or non aligned instruction) *if and only if* we have inserted a
breakpoint at the beginning of the instruction.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-04-20 15:40:30.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-04-20 15:42:08.000000000 -0400
@@ -15,6 +15,7 @@
 #include <asm/cacheflush.h>
 
 #define MAX_PATCH_LEN (255-1)
+#define BREAKPOINT_INSTRUCTION	0xcc
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -505,6 +506,11 @@ void *text_poke_early(void *addr, const 
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * It's ok to modify an instruction non-atomically (multiple memory accesses to
+ * a large and/or non aligned instruction) *if and only if* we have inserted a
+ * breakpoint at the beginning of the instruction and we are modifying the rest
+ * of the instruction.
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
@@ -512,11 +518,9 @@ void *__kprobes text_poke(void *addr, co
 	char *vaddr;
 	int nr_pages = 2;
 	struct page *pages[2];
+	int i;
 
-	BUG_ON(len > sizeof(long));
-	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
-		- ((long)addr & ~(sizeof(long) - 1)));
-	if (is_vmalloc_addr(addr)) {
+	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
 	} else {
@@ -535,5 +539,7 @@ void *__kprobes text_poke(void *addr, co
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	for (i = 0; i < len; i++)
+		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	return addr;
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
