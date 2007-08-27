Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXH1RX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXH1RX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbXH1RXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:23:01 -0400
Received: from ozlabs.org ([203.10.76.45]:57084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXH1RXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:23:00 -0400
Subject: [PATCH] Fix lguest page-pinning logic ("lguest: bad stack page
	0xc057a000")
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lguest <lguest@ozlabs.org>
In-Reply-To: <20070825211405.GA18217@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug>  <20070825211405.GA18217@slug>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 02:09:59 +1000
Message-Id: <1188230999.5531.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the stack pointer is 0xc057a000, then the first stack page is at
0xc0579000 (the stack pointer is decremented before use).  Not
calculating this correctly caused guests with CONFIG_DEBUG_PAGEALLOC=y
to be killed with a "bad stack page" message: the initial kernel stack
was just preceeding the .smp_locks section which
CONFIG_DEBUG_PAGEALLOC marks read-only when freeing.

Thanks to Frederik Deweerdt for the bug report!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r cb71c5b0bbb5 drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c	Sun Aug 26 10:31:53 2007 +1000
+++ b/drivers/lguest/interrupts_and_traps.c	Sun Aug 26 10:34:44 2007 +1000
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


