Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZLBKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZLBKo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZLBKo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:44:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:44925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZLBKoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:44:25 -0500
Date: Wed, 2 Dec 2009 10:43:57 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       macro@linux-mips.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, macro@linux-mips.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091201233335.143970505@sbs-t61.sc.intel.com>
References: <20091201233335.143970505@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Document another case when level irq is seen as an edge
Message-ID: <tip-1c83995b6c7c6bb795bce80f75fbffb15f78db2d@git.kernel.org>
Git-Commit-ID: 1c83995b6c7c6bb795bce80f75fbffb15f78db2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c83995b6c7c6bb795bce80f75fbffb15f78db2d
Gitweb:     http://git.kernel.org/tip/1c83995b6c7c6bb795bce80f75fbffb15f78db2d
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 1 Dec 2009 15:31:17 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:11:01 +0100

x86, ioapic: Document another case when level irq is seen as an edge

In the case when cpu goes offline, fixup_irqs() will forward any
unhandled interrupt on the offlined cpu to the new cpu
destination that is handling the corresponding interrupt. This
interrupt forwarding is done via IPI's. Hence, in this case also
level-triggered io-apic interrupt will be seen as an edge
interrupt in the cpu's APIC IRR.

Document this scenario in the code which handles this case by doing
an explicit EOI to the io-apic to clear remote IRR of the io-apic RTE.

Requested-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: ebiederm@xmission.com
Cc: garyhade@us.ibm.com
LKML-Reference: <20091201233335.143970505@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 78960a3..c0b4468 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2586,6 +2586,19 @@ static void ack_apic_level(unsigned int irq)
 	 * level-triggered interrupt.  We mask the source for the time of the
 	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
 	 * The idea is from Manfred Spraul.  --macro
+	 *
+	 * Also in the case when cpu goes offline, fixup_irqs() will forward
+	 * any unhandled interrupt on the offlined cpu to the new cpu
+	 * destination that is handling the corresponding interrupt. This
+	 * interrupt forwarding is done via IPI's. Hence, in this case also
+	 * level-triggered io-apic interrupt will be seen as an edge
+	 * interrupt in the IRR. And we can't rely on the cpu's EOI
+	 * to be broadcasted to the IO-APIC's which will clear the remoteIRR
+	 * corresponding to the level-triggered interrupt. Hence on IO-APIC's
+	 * supporting EOI register, we do an explicit EOI to clear the
+	 * remote IRR and on IO-APIC's which don't have an EOI register,
+	 * we use the above logic (mask+edge followed by unmask+level) from
+	 * Manfred Spraul to clear the remote IRR.
 	 */
 	cfg = desc->chip_data;
 	i = cfg->vector;
@@ -2597,7 +2610,13 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
-	/* Tail end of version 0x11 I/O APIC bug workaround */
+	/*
+	 * Tail end of clearing remote IRR bit (either by delivering the EOI
+	 * message via io-apic EOI register write or simulating it using
+	 * mask+edge followed by unnask+level logic) manually when the
+	 * level triggered interrupt is seen as the edge triggered interrupt
+	 * at the cpu.
+	 */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 
