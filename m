Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbXFGBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbXFGBnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXFGBnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:43:39 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63240 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbXFGBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:43:38 -0400
Subject: [PATCH RT] enable interrupts in do_page_fault for users (take 2 -
	add i386 fix too)
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1180740062.21781.53.camel@localhost.localdomain>
References: <1180740062.21781.53.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 21:42:27 -0400
Message-Id: <1181180547.18444.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Can you replace my previous patch with this one. This one includes the
fix for i386.

-- Steve

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
 
Index: linux-2.6.21-rt9/arch/i386/mm/fault.c
===================================================================
--- linux-2.6.21-rt9.orig/arch/i386/mm/fault.c
+++ linux-2.6.21-rt9/arch/i386/mm/fault.c
@@ -459,6 +459,10 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & 4) {
+
+		/* it's possible to have interrupts off here */
+		local_irq_enable();
+
 		/* 
 		 * Valid to do another page fault here because this one came 
 		 * from user space.


