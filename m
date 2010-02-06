Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab0BFCr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 21:47:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0BFCr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 21:47:27 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3 v2] [x86] move notify_die from nmi.c to traps.c
Date: Fri,  5 Feb 2010 21:47:03 -0500
Message-Id: <1265424425-31562-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
References: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to handle a new nmi_watchdog approach, I need to move the notify_die()
routine out of nmi_watchdog_tick() and into default_do_nmi().  This lets me easily
swap out the old nmi_watchdog with the new one with just a config change.

The change probably makes sense from a high level perspective because the
nmi_watchdog shouldn't be handling notify_die routines anyway.  However, this
move does change the semantics a little bit.  Instead of checking on every nmi
interrupt if the cpus are stuck, only check them on the nmi_watchdog interrupts.

v2: move notify_die call into #idef block

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/nmi.c |    7 -------
 arch/x86/kernel/traps.c    |    5 +++++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 0159a69..5d47682 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -400,13 +400,6 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	int cpu = smp_processor_id();
 	int rc = 0;
 
-	/* check for other users first */
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			== NOTIFY_STOP) {
-		rc = 1;
-		touched = 1;
-	}
-
 	sum = get_timer_irqs(cpu);
 
 	if (__get_cpu_var(nmi_touch)) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..3be4687 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -400,7 +400,12 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
+
 #ifdef CONFIG_X86_LOCAL_APIC
+	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+	        			                == NOTIFY_STOP)
+	                return;
+
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
-- 
1.6.6.83.gc9a2

