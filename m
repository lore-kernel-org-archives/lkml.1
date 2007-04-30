Return-Path: <linux-kernel-owner+w=401wt.eu-S1423311AbXD3OgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423311AbXD3OgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423310AbXD3Ofj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:35:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423311AbXD3OfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:35:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=uvqWk7b83+1jX5ki02gNIR7rUJQyiZjV0mD4mLdrraFElY2oA19ctv9IGgMTG00WJ
	51aYV1MU8RNJi6TGr0c5Q==
Date: Mon, 30 Apr 2007 07:34:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: [patch] nmi: move do_nmi_callback()
Message-ID: <Pine.LNX.4.64.0704291659130.1822@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Define do_nmi_callback() only after unknown_nmi_panic_callback() so we
don't need to put its prototype in between #ifdef CONFIG_SYSCTL.
Otherwise we have a prototype for a function we never define.

{enable,disable}_lapic_nmi_watchdog() should only be defined in
CONFIG_SYSCTL.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/i386/kernel/nmi.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -73,8 +73,6 @@ struct nmi_watchdog_ctlblk {
 static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
 
 /* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 extern void show_registers(struct pt_regs *regs);
 extern int unknown_nmi_panic;
 
@@ -391,6 +389,8 @@ static int __init setup_nmi_watchdog(char *str)
 
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
+#ifdef CONFIG_SYSCTL
+
 static void disable_lapic_nmi_watchdog(void)
 {
 	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
@@ -419,6 +419,8 @@ static void enable_lapic_nmi_watchdog(void)
 	touch_nmi_watchdog();
 }
 
+#endif
+
 void disable_timer_nmi_watchdog(void)
 {
 	BUG_ON(nmi_watchdog != NMI_IO_APIC);
@@ -1105,15 +1107,6 @@ done:
 	return rc;
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
@@ -1167,6 +1160,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs * regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;
