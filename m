Return-Path: <linux-kernel-owner+w=401wt.eu-S932175Ab0A0UE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0A0UE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383Ab0A0UEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:04:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab0A0UEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:04:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com
Cc: aris@redhat.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Date: Wed, 27 Jan 2010 15:03:40 -0500
Message-Id: <1264622622-5778-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
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
index 3339917..3b98dd3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -400,6 +400,11 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
+
+	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+	        			                == NOTIFY_STOP)
+	                return;
+
 #ifdef CONFIG_X86_LOCAL_APIC
 		/*
 		 * Ok, so this is none of the documented NMI sources,
-- 
1.6.5.2

