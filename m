Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYFGBRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYFGBRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbYFGBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:18 -0400
Received: from sous-sol.org ([216.99.217.87]:42436 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760256AbYFGBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:09 -0400
Message-Id: <20080607010618.448461135@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 30/50] x86: prevent PGE flush from interruption/preemption
Content-Disposition: inline; filename=x86-prevent-pge-flush-from-interruption-preemption.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ingo Molnar <mingo@elte.hu>

upstream commit: b1979a5fda7869a790f4fd83fb06c78498d26ba1

CR4 manipulation is not protected against interrupts and preemption,
but KVM uses smp_function_call to manipulate the X86_CR4_VMXE bit
either from the CPU hotplug code or from the kvm_init call.

We need to protect the CR4 manipulation from both interrupts and
preemption.

Original bug report: http://lkml.org/lkml/2008/5/7/48
Bugzilla entry: http://bugzilla.kernel.org/show_bug.cgi?id=10642

This is not a regression from 2.6.25, it's a long standing and hard to
trigger bug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/asm-x86/tlbflush.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -22,12 +22,23 @@ static inline void __native_flush_tlb(vo
 
 static inline void __native_flush_tlb_global(void)
 {
-	unsigned long cr4 = read_cr4();
+	unsigned long flags;
+	unsigned long cr4;
 
+	/*
+	 * Read-modify-write to CR4 - protect it from preemption and
+	 * from interrupts. (Use the raw variant because this code can
+	 * be called from deep inside debugging code.)
+	 */
+	raw_local_irq_save(flags);
+
+	cr4 = read_cr4();
 	/* clear PGE */
 	write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
 	write_cr4(cr4);
+
+	raw_local_irq_restore(flags);
 }
 
 static inline void __native_flush_tlb_single(unsigned long addr)

-- 
