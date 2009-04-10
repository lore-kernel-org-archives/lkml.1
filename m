Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZDJMeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZDJMeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbZDJMeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:34:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZDJMeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:34:06 -0400
Date: Fri, 10 Apr 2009 12:33:35 GMT
From: Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239355037-22856-1-git-send-email-weidong.han@intel.com>
References: <1239355037-22856-1-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/pat] x86, intr-remap: fix eoi for interrupt remapping without x2apic
Message-ID: <tip-746cddd37d48a166f170165a0df4bd50fde1ea60@git.kernel.org>
Git-Commit-ID: 746cddd37d48a166f170165a0df4bd50fde1ea60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:33:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  746cddd37d48a166f170165a0df4bd50fde1ea60
Gitweb:     http://git.kernel.org/tip/746cddd37d48a166f170165a0df4bd50fde1ea60
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 10 Apr 2009 17:17:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:12:17 +0200

x86, intr-remap: fix eoi for interrupt remapping without x2apic

To simplify level irq migration in the presence of interrupt-remapping,
Suresh used a virtual vector (io-apic pin number) to eliminate io-apic
RTE modification. Level triggered interrupt will appear as an edge to
the local apic cpu but still as level to the IO-APIC. So in addition to
do the local apic EOI, it still needs to do IO-APIC directed EOI to clear
the remote IRR bit in the IO-APIC RTE. Pls refer to Suresh's patch for
more details (commit 0280f7c416c652a2fd95d166f52b199ae61122c0).

Now interrupt remapping is decoupled from x2apic, it also needs to do the
directed EOI for apic. Otherwise, apic interrupts won't work correctly.

Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Weidong Han <weidong.han@intel.com>
Cc: suresh.b.siddha@intel.com
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
LKML-Reference: <1239355037-22856-1-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..a2789e4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2524,7 +2524,6 @@ static void irq_complete_move(struct irq_desc **descp)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-#ifdef CONFIG_X86_X2APIC
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -2558,6 +2557,7 @@ eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+#ifdef CONFIG_X86_X2APIC
 static void ack_x2apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2634,6 +2634,9 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	if (irq_remapped(irq))
+		eoi_ioapic_irq(desc);
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
