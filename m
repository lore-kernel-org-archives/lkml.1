Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbZINUXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbZINUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbZINUWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:22:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54017 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbZINUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 12/72] Blackfin: document __ipipe_call_irqtail
Date: Mon, 14 Sep 2009 16:07:16 -0400
Message-Id: <1252958896-25150-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/interrupt.S |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index 29fbf67..c754ff7 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -261,6 +261,31 @@ ENTRY(_evt_system_call)
 ENDPROC(_evt_system_call)
 
 #ifdef CONFIG_IPIPE
+/*
+ * __ipipe_call_irqtail: lowers the current priority level to EVT15
+ * before running a user-defined routine, then raises the priority
+ * level to EVT14 to prepare the caller for a normal interrupt
+ * return through RTI.
+ *
+ * We currently use this facility in two occasions:
+ *
+ * - to branch to __ipipe_irq_tail_hook as requested by a high
+ *   priority domain after the pipeline delivered an interrupt,
+ *   e.g. such as Xenomai, in order to start its rescheduling
+ *   procedure, since we may not switch tasks when IRQ levels are
+ *   nested on the Blackfin, so we have to fake an interrupt return
+ *   so that we may reschedule immediately.
+ *
+ * - to branch to sync_root_irqs, in order to play any interrupt
+ *   pending for the root domain (i.e. the Linux kernel). This lowers
+ *   the core priority level enough so that Linux IRQ handlers may
+ *   never delay interrupts handled by high priority domains; we defer
+ *   those handlers until this point instead. This is a substitute
+ *   to using a threaded interrupt model for the Linux kernel.
+ *
+ * r0: address of user-defined routine
+ * context: caller must have preempted EVT15, hw interrupts must be off.
+ */
 ENTRY(___ipipe_call_irqtail)
 	p0 = r0;
 	r0.l = 1f;
-- 
1.6.4.2

