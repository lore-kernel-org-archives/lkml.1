Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYGAXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYGAXf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbYGAXfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:35:16 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:4332 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYGAXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:35:15 -0400
Date: Wed, 2 Jul 2008 01:32:28 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: traps_xx: modify default_do_nmi
Message-ID: <20080701233227.GF29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 02 Jul 2008 01:35:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - local caching of smp_processor_id()

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   12 ++++++++----
 arch/x86/kernel/traps_64.c |    3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 68e800f..14fe3cd 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -790,12 +790,16 @@ void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	do_exit(SIGSEGV);
 }
 
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+static notrace __kprobes void
+default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
+	int cpu;
+
+	cpu = smp_processor_id();
 
-	/* Only the BSP gets external NMIs from the system: */
-	if (!smp_processor_id())
+	/* Only the BSP gets external NMIs from the system. */
+	if (!cpu)
 		reason = get_nmi_reason();
 
 	if (!(reason & 0xc0)) {
@@ -809,7 +813,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, smp_processor_id()))
+		if (!do_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 677b4e5..2f8d87d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -832,7 +832,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 
 /* Runs on IST stack. This code must keep interrupts off all the time.
    Nested NMIs are prevented by the CPU. */
-asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
+asmlinkage notrace __kprobes void
+default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
-- 
1.5.4.3

