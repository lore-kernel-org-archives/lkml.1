Return-Path: <linux-kernel-owner+w=401wt.eu-S1031433AbXEDRoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031433AbXEDRoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031435AbXEDRon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:44:43 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51065 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031433AbXEDRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:44:42 -0400
Date: Fri, 4 May 2007 13:39:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: caker@linode.com, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/3] UML - An idle system should have zero load average
Message-ID: <20070504173958.GA7948@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ever-vigilant users of linode.com noticed that an idle 2.6 UML has
a persistent load average of ~.4.

It turns out that because the UML timer handler processed softirqs
before actually delivering the tick, the tick was counted in the
context of the idle thread about half the time.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/time.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/time.c	2007-05-04 12:40:52.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/time.c	2007-05-04 13:13:39.000000000 -0400
@@ -177,6 +177,8 @@ int do_settimeofday(struct timespec *tv)
 
 void timer_handler(int sig, union uml_pt_regs *regs)
 {
+	if(current_thread->cpu == 0)
+		timer_irq(regs);
 	local_irq_disable();
 	irq_enter();
 	update_process_times(CHOOSE_MODE(
@@ -184,6 +186,4 @@ void timer_handler(int sig, union uml_pt
 			     (regs)->skas.is_user));
 	irq_exit();
 	local_irq_enable();
-	if(current_thread->cpu == 0)
-		timer_irq(regs);
 }
