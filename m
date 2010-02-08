Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0BHIxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:53:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:59559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0BHIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:53:11 -0500
Date: Mon, 8 Feb 2010 08:51:42 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1265424425-31562-2-git-send-email-dzickus@redhat.com>
References: <1265424425-31562-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] x86: Move notify_die from nmi.c to traps.c
Message-ID: <tip-e40b17208b6805be50ffe891878662b6076206b9@git.kernel.org>
Git-Commit-ID: e40b17208b6805be50ffe891878662b6076206b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Feb 2010 08:51:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e40b17208b6805be50ffe891878662b6076206b9
Gitweb:     http://git.kernel.org/tip/e40b17208b6805be50ffe891878662b6076206b9
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 5 Feb 2010 21:47:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Feb 2010 08:29:02 +0100

x86: Move notify_die from nmi.c to traps.c

In order to handle a new nmi_watchdog approach, I need to move
the notify_die() routine out of nmi_watchdog_tick() and into
default_do_nmi(). This lets me easily swap out the old
nmi_watchdog with the new one with just a config change.

The change probably makes sense from a high level perspective
because the nmi_watchdog shouldn't be handling notify_die
routines anyway.  However, this move does change the semantics a
little bit.  Instead of checking on every nmi interrupt if the
cpus are stuck, only check them on the nmi_watchdog interrupts.

 v2: Move notify_die call into #idef block

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
Cc: peterz@infradead.org
LKML-Reference: <1265424425-31562-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 1168e44..51ef893 100644
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
