Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZLBKoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZLBKoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZLBKoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:44:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:44907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZLBKoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:44:12 -0500
Date: Wed, 2 Dec 2009 10:43:31 GMT
From: "tip-bot for Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, macro@linux-mips.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091201233334.975416130@sbs-t61.sc.intel.com>
References: <20091201233334.975416130@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, io-apic: Move the effort of clearing remoteIRR explicitly before migrating the irq
Message-ID: <tip-ca64c47cecd0321b2e0dcbd7aaff44b68ce20654@git.kernel.org>
Git-Commit-ID: ca64c47cecd0321b2e0dcbd7aaff44b68ce20654
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca64c47cecd0321b2e0dcbd7aaff44b68ce20654
Gitweb:     http://git.kernel.org/tip/ca64c47cecd0321b2e0dcbd7aaff44b68ce20654
Author:     Maciej W. Rozycki <macro@linux-mips.org>
AuthorDate: Tue, 1 Dec 2009 15:31:15 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:11:00 +0100

x86, io-apic: Move the effort of clearing remoteIRR explicitly before migrating the irq

When the level-triggered interrupt is seen as an edge interrupt,
we try to clear the remoteIRR explicitly (using either an
io-apic eoi register when present or through the idea of
changing trigger mode of the io-apic RTE to edge and then back
to level). But this explicit try also needs to happen before we
try to migrate the irq. Otherwise irq migration attempt will
fail anyhow, as it postpones the irq migration to a later
attempt when it sees the remoteIRR in the io-apic RTE still set.

Signed-off-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: ebiederm@xmission.com
Cc: garyhade@us.ibm.com
LKML-Reference: <20091201233334.975416130@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 085e60e..b377b97 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2583,6 +2583,20 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	/* Tail end of version 0x11 I/O APIC bug workaround */
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+
+		if (use_eoi_reg)
+			eoi_ioapic_irq(desc);
+		else {
+			spin_lock(&ioapic_lock);
+			__mask_and_edge_IO_APIC_irq(cfg);
+			__unmask_and_level_IO_APIC_irq(cfg);
+			spin_unlock(&ioapic_lock);
+		}
+	}
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2616,20 +2630,6 @@ static void ack_apic_level(unsigned int irq)
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq_desc(desc);
 	}
-
-	/* Tail end of version 0x11 I/O APIC bug workaround */
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-
-		if (use_eoi_reg)
-			eoi_ioapic_irq(desc);
-		else {
-			spin_lock(&ioapic_lock);
-			__mask_and_edge_IO_APIC_irq(cfg);
-			__unmask_and_level_IO_APIC_irq(cfg);
-			spin_unlock(&ioapic_lock);
-		}
-	}
 }
 
 #ifdef CONFIG_INTR_REMAP
