Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbXFAXV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbXFAXV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXFAXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:21:50 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:65451 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXFAXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:21:49 -0400
Subject: [PATCH RT] enable interrupts in do_page_fault for users.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 19:21:02 -0400
Message-Id: <1180740062.21781.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

To prevent scheduling while irqs disabled, I added a force to the
do_page_fault to enable interrupts.

The thing is, if the user faults at an address above PAGE_OFFSET. My
stupid program that I attached to my last email did just that:

  unsigned long *p = (void*)-1;

  *p = 0xbed;


where (void*)-1 is an address greater than PAGE_OFFSET.  If I changed
that address to (void*)1, the program still segfaulted, but I didn't get
the warning about scheduling while interrupts disabled. I even put in a
print to show if interrupts are disabled in do_page_fault before calling
force_sig_info, and with (void*)-1 they were, and with (void*)1 they
were not disabled.

This patch forces interrupts to always be enabled when entering the user
fault code. Maybe this should also be applied to mainline?

This solves the one issue with scheduling while irqs disabled.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt9/arch/x86_64/mm/fault.c
===================================================================
--- linux-2.6.21-rt9.orig/arch/x86_64/mm/fault.c
+++ linux-2.6.21-rt9/arch/x86_64/mm/fault.c
@@ -476,6 +476,10 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & PF_USER) {
+
+		/* it's possible to have interrupts off here */
+		local_irq_enable();
+
 		if (is_prefetch(regs, address, error_code))
 			return;
 


