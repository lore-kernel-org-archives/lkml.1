Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXGLHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXGLHRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXGLHQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:16:58 -0400
Received: from ozlabs.org ([203.10.76.45]:47716 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbXGLHQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:16:57 -0400
Subject: [PATCH] lguest: disable SYSENTER for guests
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@qumranet.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 17:16:35 +1000
Message-Id: <1184224595.6005.772.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SYSENTER instruction jumps to a pre-programmed address at
privilege level 0.  We must not allow execution of guest code at that
privilege level, so disable sysenter when we enter the guest (and
re-enable it on return).  This fixes current case where guest
userspace can crash host.

This save/restore adds 3% to guest context switch times.  (If only
there were some kind of scheduler hook or something which would tell
us when we were being preempted so we could fix this up lazily.  But
what kind of daredevil coder would propose such a thing?)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -338,6 +338,10 @@ int run_guest(struct lguest *lg, unsigne
 		if (lg->ts)
 			set_ts();
 
+		/* Don't let Guest do SYSENTER: we can't handle it. */
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
+
 		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
 
 		/* Save cr2 now if we page-faulted. */
@@ -345,6 +349,9 @@ int run_guest(struct lguest *lg, unsigne
 			cr2 = read_cr2();
 		else if (lg->regs->trapnum == 7)
 			math_state_restore();
+
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 		local_irq_enable();
 
 		switch (lg->regs->trapnum) {


