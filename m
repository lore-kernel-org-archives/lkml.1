Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYJTMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYJTMNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYJTMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:13:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbYJTMNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:13:15 -0400
From: Ivan Vecera <ivecera@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, nhorman@redhat.com,
       jmarchan@redhat.com, Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH] x86: call machine_shutdown and stop all CPUs in native_machine_halt
Date: Mon, 20 Oct 2008 14:13:07 +0200
Message-Id: <1224504787-11403-1-git-send-email-ivecera@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function machine_halt (resp. native_machine_halt) is empty for x86
architectures. When command 'halt -f' is invoked, the message
"System halted." is displayed but this is not really true because
all CPUs are still running.
There are also similar inconsistencies for other arches (some uses
power-off for halt or forever-loop with IRQs enabled/disabled).
IMO there should be used the same approach for all architectures
OR what does the message "System halted" really mean?

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f4c93f1..15ad949 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -465,6 +465,14 @@ static void native_machine_restart(char *__unused)
 
 static void native_machine_halt(void)
 {
+	/* stop other cpus and apics */
+	machine_shutdown();
+
+	/* stop this cpu */
+	local_irq_disable();
+	if (hlt_works(smp_processor_id()))
+		for (;;) halt();
+	for (;;);
 }
 
 static void native_machine_power_off(void)
-- 
1.5.6.3

