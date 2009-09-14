Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbZINUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbZINUXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZINUX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:23:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54005 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbZINUIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 08/72] Blackfin: allow high priority domains to preempt schedule_tail()
Date: Mon, 14 Sep 2009 16:07:12 -0400
Message-Id: <1252958896-25150-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

ret_from_fork is always entered with hw interrupts off, which prevents
real-time domains to preempt the Linux kernel during part of the
initial context switch to the new task, which could in turn raise the
worst-case latency figures.

To avoid this, stall the root domain stage in the interrupt pipeline
to keep the scheduling tail code free from Linux-handled IRQs, then
enable hardware interrupts again.

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/entry.S |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/entry.S b/arch/blackfin/kernel/entry.S
index a9cfba9..3f8769b 100644
--- a/arch/blackfin/kernel/entry.S
+++ b/arch/blackfin/kernel/entry.S
@@ -43,8 +43,28 @@
 
 ENTRY(_ret_from_fork)
 #ifdef CONFIG_IPIPE
-	[--sp] = reti; 		/* IRQs on. */
-	SP += 4;
+	/*
+	 * Hw IRQs are off on entry, and we don't want the scheduling tail
+	 * code to starve high priority domains from interrupts while it
+	 * runs. Therefore we first stall the root stage to have the
+	 * virtual interrupt state reflect IMASK.
+	 */
+	p0.l = ___ipipe_root_status;
+	p0.h = ___ipipe_root_status;
+	r4 = [p0];
+	bitset(r4, 0);
+	[p0] = r4;
+	/*
+	 * Then we may enable hw IRQs, allowing preemption from high
+	 * priority domains. schedule_tail() will do local_irq_enable()
+	 * since Blackfin does not define __ARCH_WANT_UNLOCKED_CTXSW, so
+	 * there is no need to unstall the root domain by ourselves
+	 * afterwards.
+	 */
+	p0.l = _bfin_irq_flags;
+	p0.h = _bfin_irq_flags;
+	r4 = [p0];
+	sti r4;
 #endif /* CONFIG_IPIPE */
 	SP += -12;
 	call _schedule_tail;
-- 
1.6.4.2

