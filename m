Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbXKBPme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbXKBPme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbXKBPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:41:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60102 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758494AbXKBPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:41:31 -0400
Date: Fri, 2 Nov 2007 11:40:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/6] UML - get_wchan fixes
Message-ID: <20071102154015.GA10288@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This can be merged with uml-implement-get_wchan.patch ]

The previous get_wchan patch needed some more work.  Joe Perches
suggested the use of bool where I was using a counter.  It also turned
out not to work so well on x86_64, so I changed the algorithm a bit.
Instead of skipping one frame and looking for the next non-sched
symbol, it now looks for at least one scheduler frame, then returns
the first symbol seen above that.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/process.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-10-31 13:16:40.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/process.c	2007-10-31 13:17:00.000000000 -0400
@@ -462,7 +462,8 @@ unsigned long arch_align_stack(unsigned 
 
 unsigned long get_wchan(struct task_struct *p)
 {
-	unsigned long stack_page, sp, ip, count = 0;
+	unsigned long stack_page, sp, ip;
+	bool seen_sched = 0;
 
 	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
 		return 0;
@@ -482,14 +483,11 @@ unsigned long get_wchan(struct task_stru
 
 	while (sp < stack_page + THREAD_SIZE) {
 		ip = *((unsigned long *) sp);
-		if (kernel_text_address(ip) && !in_sched_functions(ip)) {
-			/*
-			 * Skip one valid IP, which will be the low-level UML
-			 * context switcher.
-			 */
-			if (count++ == 1)
-				return ip;
-		}
+		if (in_sched_functions(ip))
+			/* Ignore everything until we're above the scheduler */
+			seen_sched = 1;
+		else if (kernel_text_address(ip) && seen_sched)
+			return ip;
 
 		sp += sizeof(unsigned long);
 	}
