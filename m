Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYKTTM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYKTTM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYKTTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:11:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbYKTTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:11:51 -0500
Message-Id: <20081120191149.086287646@goodmis.org>
References: <20081120190948.057007623@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 14:09:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] powerpc: ftrace, do not latency trace idle
Content-Disposition: inline; filename=0001-powerpc-ftrace-do-not-latency-trace-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix for irq off latency tracer

When idle is called, interrupts are disabled, but the idle function
will still wake up on an interrupt. The problem is that the interrupt
disabled latency tracer will take this call to idle as a latency.

This patch disables the latency tracing when going into idle.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/idle.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 31982d0..88d9c1d 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -69,10 +69,15 @@ void cpu_idle(void)
 				smp_mb();
 				local_irq_disable();
 
+				/* Don't trace irqs off for idle */
+				stop_critical_timings();
+
 				/* check again after disabling irqs */
 				if (!need_resched() && !cpu_should_die())
 					ppc_md.power_save();
 
+				start_critical_timings();
+
 				local_irq_enable();
 				set_thread_flag(TIF_POLLING_NRFLAG);
 
-- 
1.5.6.5

-- 
