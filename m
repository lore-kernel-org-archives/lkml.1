Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYDRXXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYDRXXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYDRXW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:22:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53223 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYDRXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:48 -0400
Message-Id: <0fc974582553292880b65973b4095297056eec03.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: cooloney@kernel.org
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/15] [BLACKFIN] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:48 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- time_sched_init() should use standard irq_handler_t

- sys_timer0_int_handler() should not take 'regs' third argument

- remove pointless cast from void*

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/blackfin/kernel/time.c        |    5 ++---
 arch/blackfin/oprofile/timer_int.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 9bdc8f9..715b394 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -39,8 +39,7 @@
 /* This is an NTP setting */
 #define	TICK_SIZE (tick_nsec / 1000)
 
-static void time_sched_init(irqreturn_t(*timer_routine)
-			(int, void *));
+static void time_sched_init(irq_handler_t timer_routine);
 static unsigned long gettimeoffset(void);
 
 static struct irqaction bfin_timer_irq = {
@@ -64,7 +63,7 @@ static struct irqaction bfin_timer_irq = {
 #define TIME_SCALE 1
 
 static void
-time_sched_init(irqreturn_t(*timer_routine) (int, void *))
+time_sched_init(irq_handler_t timer_routine)
 {
 	u32 tcount;
 
diff --git a/arch/blackfin/oprofile/timer_int.c b/arch/blackfin/oprofile/timer_int.c
index 6c6f860..e2c825a 100644
--- a/arch/blackfin/oprofile/timer_int.c
+++ b/arch/blackfin/oprofile/timer_int.c
@@ -40,10 +40,9 @@ static void disable_sys_timer0()
 {
 }
 
-static irqreturn_t sys_timer0_int_handler(int irq, void *dev_id,
-					  struct pt_regs *regs)
+static irqreturn_t sys_timer0_int_handler(int irq, void *dev_id)
 {
-	oprofile_add_sample(regs, 0);
+	oprofile_add_sample(get_irq_regs(), 0);
 	return IRQ_HANDLED;
 }
 
-- 
1.5.4.1

