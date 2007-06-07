Return-Path: <linux-kernel-owner+w=401wt.eu-S936465AbXFGDf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465AbXFGDf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbXFGDfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:35:18 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:52120 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbXFGDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:35:17 -0400
Subject: [PATCH] enable interrupts in user path of page fault.
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 23:34:04 -0400
Message-Id: <1181187244.18444.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minor fix, but what is currently there is essentially wrong.
In do_page_fault, if the faulting address from user code happens to be
in kernel address space (int *p = (int*)-1; p = 0xbed;)  then the
do_page_fault handler will jump over the local_irq_enable with the

  goto bad_area_nosemaphore;

But the first line there sees this is user code and goes through the
process of sending a signal to send SIGSEGV to the user task. This whole
time interrupts are disabled and the task can not be preempted by a
higher priority task.

This patch always enables interrupts in the user path of the
bad_area_nosemaphore.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 29d7d61..1ecb3e4 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -458,6 +458,11 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & 4) {
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
 		/* 
 		 * Valid to do another page fault here because this one came 
 		 * from user space.
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index bfb62a1..635e58d 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -476,6 +476,12 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & PF_USER) {
+
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
 		if (is_prefetch(regs, address, error_code))
 			return;
 


