Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYEWNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYEWNOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYEWNNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:13:17 -0400
Received: from gw.goop.org ([64.81.55.164]:33952 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbYEWNNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] xen: use new sched_op
X-Mercurial-Node: 5957906ead278257c1d111da6bd8f3bcb38343cb
Message-Id: <5957906ead278257c1d1.1211548255@localhost>
In-Reply-To: <patchbomb.1211548253@localhost>
Date: Fri, 23 May 2008 14:10:55 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new sched_op hypercall, mainly because xenner doesn't support
the old one.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c        |    6 ++++--
 include/asm-x86/xen/hypercall.h |    4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -254,7 +254,7 @@
 static void xen_safe_halt(void)
 {
 	/* Blocking includes an implicit local_irq_enable(). */
-	if (HYPERVISOR_sched_op(SCHEDOP_block, 0) != 0)
+	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
 		BUG();
 }
 
@@ -1139,11 +1139,13 @@
 
 static void xen_reboot(int reason)
 {
+	struct sched_shutdown r = { .reason = reason };
+
 #ifdef CONFIG_SMP
 	smp_send_stop();
 #endif
 
-	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, reason))
+	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
 		BUG();
 }
 
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -176,9 +176,9 @@
 }
 
 static inline int
-HYPERVISOR_sched_op(int cmd, unsigned long arg)
+HYPERVISOR_sched_op(int cmd, void *arg)
 {
-	return _hypercall2(int, sched_op, cmd, arg);
+	return _hypercall2(int, sched_op_new, cmd, arg);
 }
 
 static inline long


