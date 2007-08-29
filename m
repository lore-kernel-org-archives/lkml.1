Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXH2Ufr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXH2Ufr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 16:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXH2Ufi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 16:35:38 -0400
Received: from ozlabs.org ([203.10.76.45]:51650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXH2Ufi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 16:35:38 -0400
Subject: [PATCH] Fix lguest page-pinning logic ("lguest: bad stack page
	0xc057a000")
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 06:35:08 +1000
Message-Id: <1188419708.5531.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the stack pointer is 0xc057a000, then the first stack page is at
0xc0579000 (the stack pointer is decremented before use).  Not
calculating this correctly caused guests with CONFIG_DEBUG_PAGEALLOC=y
to be killed with a "bad stack page" message: the initial kernel stack
was just proceeding the .smp_locks section which
CONFIG_DEBUG_PAGEALLOC marks read-only when freeing.

Thanks to Frederik Deweerdt for the bug report!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/interrupts_and_traps.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -270,8 +270,11 @@ void pin_stack_pages(struct lguest *lg)
 	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
 	 * two pages of stack space. */
 	for (i = 0; i < lg->stack_pages; i++)
-		/* The stack grows *upwards*, hence the subtraction */
-		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
+		/* The stack grows *upwards*, so the address we're given is the
+		 * start of the page after the kernel stack.  Subtract one to
+		 * get back onto the first stack page, and keep subtracting to
+		 * get to the rest of the stack pages. */
+		pin_page(lg, lg->esp1 - 1 - i * PAGE_SIZE);
 }
 
 /* Direct traps also mean that we need to know whenever the Guest wants to use


