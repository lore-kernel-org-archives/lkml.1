Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507Ab0AEFbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0AEFbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440Ab0AEFbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:31:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0AEFbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:31:15 -0500
Date: Tue, 5 Jan 2010 05:30:48 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <4B426550.6000209@kernel.org>
References: <4B426550.6000209@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Don't waste a vector to improve vector spread
Message-ID: <tip-ea94396629a3e0cb9a3a9c75335b1de255b30426@git.kernel.org>
Git-Commit-ID: ea94396629a3e0cb9a3a9c75335b1de255b30426
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea94396629a3e0cb9a3a9c75335b1de255b30426
Gitweb:     http://git.kernel.org/tip/ea94396629a3e0cb9a3a9c75335b1de255b30426
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 4 Jan 2010 21:14:41 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Jan 2010 21:28:24 -0800

x86, apic: Don't waste a vector to improve vector spread

We want to use a vector-assignment sequence that avoids stumbling onto
0x80 earlier in the sequence, in order to improve the spread of
vectors across priority levels on machines with a small number of
interrupt sources.  Right now, this is done by simply making the first
vector (0x31 or 0x41) completely unusable.  This is unnecessary; all
we need is to start assignment at a +1 offset, we don't actually need
to prohibit the usage of this vector once we have wrapped around.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4B426550.6000209@kernel.org>
---
 arch/x86/include/asm/irq_vectors.h |    9 +++++----
 arch/x86/kernel/apic/io_apic.c     |    3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index dbc81ac..585a428 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -133,11 +133,12 @@
 #define MCE_SELF_VECTOR			0xeb
 
 /*
- * First APIC vector available to drivers: (vectors 0x30-0xee) we
- * start at 0x31 to spread out vectors evenly between priority
- * levels. (0x80 is the syscall vector)
+ * First APIC vector available to drivers: (vectors 0x30-0xee).  We
+ * start allocating at 0x31 to spread out vectors evenly between
+ * priority levels. (0x80 is the syscall vector)
  */
-#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 2)
+#define FIRST_DEVICE_VECTOR		(IRQ15_VECTOR + 1)
+#define VECTOR_OFFSET_START		1
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d9cd1f1..e9ba090 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1162,7 +1162,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
+	static int current_offset = VECTOR_OFFSET_START % 8;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
