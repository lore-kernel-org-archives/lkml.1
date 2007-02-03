Return-Path: <linux-kernel-owner+w=401wt.eu-S1946247AbXBCCgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946247AbXBCCgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946244AbXBCCgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:16 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52707 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946247AbXBCCgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:00 -0500
Message-Id: <20070203023959.413020000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:20 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>, ard@telegraafnet.nl,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Subject: [patch 16/59] start_kernel: test if irqs got enabled early, barf, and disable them again
Content-Disposition: inline; filename=start_kernel-test-if-irq-s-got-enabled-early-barf-and-disable-them-again.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Ard van Breemen <ard@telegraafnet.nl>

The calls made by parse_parms to other initialization code might enable
interrupts again way too early.

Having interrupts on this early can make systems PANIC when they initialize
the IRQ controllers (which happens later in the code).  This patch detects
that irq's are enabled again, barfs about it and disables them again as a
safety net.

[akpm@osdl.org: cleanups]
Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
This is half of the fix for http://bugzilla.kernel.org/show_bug.cgi?id=7505

 init/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.19.2.orig/init/main.c
+++ linux-2.6.19.2/init/main.c
@@ -525,6 +525,11 @@ asmlinkage void __init start_kernel(void
 	parse_args("Booting kernel", command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+	if (!irqs_disabled()) {
+		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
+				"enabled *very* early, fixing it\n");
+		local_irq_disable();
+	}
 	sort_main_extable();
 	trap_init();
 	rcu_init();

--
