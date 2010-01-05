Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256Ab0AEFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0AEFbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255Ab0AEFbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:31:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:37821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0AEFbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:31:12 -0500
Date: Tue, 5 Jan 2010 05:30:33 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B4284C6.9030107@kernel.org>
References: <4B4284C6.9030107@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Reclaim IDT vectors 0x20-0x2f
Message-ID: <tip-99d113b17e8ca5a8b68a9d3f7691e2f552dd6a06@git.kernel.org>
Git-Commit-ID: 99d113b17e8ca5a8b68a9d3f7691e2f552dd6a06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99d113b17e8ca5a8b68a9d3f7691e2f552dd6a06
Gitweb:     http://git.kernel.org/tip/99d113b17e8ca5a8b68a9d3f7691e2f552dd6a06
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 4 Jan 2010 16:16:06 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Jan 2010 21:12:52 -0800

x86, apic: Reclaim IDT vectors 0x20-0x2f

Reclaim 16 IDT vectors and make them available for general allocation.

Reclaim vectors 0x20-0x2f by reallocating the IRQ_MOVE_CLEANUP_VECTOR
to vector 0x1f.  This is in the range of vector numbers that is
officially reserved for the CPU (for exceptions), however, the use of
the APIC to generate any vector 0x10 or above is documented, and the
CPU internally can receive any vector number (the legacy BIOS uses INT
0x08-0x0f for interrupts, as messed up as that is.)

Since IRQ_MOVE_CLEANUP_VECTOR has to be alone in the lowest-numbered
priority level (block of 16), this effectively enables us to reclaim
an otherwise-unusable APIC priority level and put it to use.

Since this is a transient kernel-only allocation we can change it at
any time, and if/when there is an exception at vector 0x1f this
assignment needs to be changed as part of OS enabling that new feature.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B4284C6.9030107@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/irq_vectors.h |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3ab43df..dbc81ac 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -30,26 +30,38 @@
 /*
  * IDT vectors usable for external interrupt sources start
  * at 0x20:
+ * hpa said we can start from 0x1f.
+ *   0x1f is documented as reserved.  However, the ability for the APIC
+ *   to generate vectors starting at 0x10 is documented, as is the
+ *   ability for the CPU to receive any vector number as an interrupt.
+ *   0x1f is used for IRQ_MOVE_CLEANUP_VECTOR since that vector needs
+ *   an entire privilege level (16 vectors) all by itself at a higher
+ *   priority than any actual device vector.  Thus, by placing it in the
+ *   otherwise-unusable 0x10 privilege level, we avoid wasting a full
+ *   16-vector block.
  */
-#define FIRST_EXTERNAL_VECTOR		0x20
+#define FIRST_EXTERNAL_VECTOR		0x1f
 
+#define IA32_SYSCALL_VECTOR		0x80
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
-# define IA32_SYSCALL_VECTOR		0x80
-#else
-# define IA32_SYSCALL_VECTOR		0x80
 #endif
 
 /*
- * Reserve the lowest usable priority level 0x20 - 0x2f for triggering
+ * Reserve the lowest usable priority level 0x10 - 0x1f for triggering
  * cleanup after irq migration.
+ * this overlaps with the reserved range for cpu exceptions so this
+ * will need to be changed to 0x20 - 0x2f if the last cpu exception is
+ * ever allocated.
  */
+
 #define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
 /*
- * Vectors 0x30-0x3f are used for ISA interrupts.
+ * Vectors 0x20-0x2f are used for ISA interrupts.
+ *   round up to the next 16-vector boundary
  */
-#define IRQ0_VECTOR			(FIRST_EXTERNAL_VECTOR + 0x10)
+#define IRQ0_VECTOR			((FIRST_EXTERNAL_VECTOR + 16) & ~15)
 
 #define IRQ1_VECTOR			(IRQ0_VECTOR +  1)
 #define IRQ2_VECTOR			(IRQ0_VECTOR +  2)
@@ -122,7 +134,7 @@
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
- * start at 0x31(0x41) to spread out vectors evenly between priority
+ * start at 0x31 to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 2)
