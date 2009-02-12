Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbZBLMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbZBLMwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbZBLMuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbZBLMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/9] x86: CMCI: Use polled banks bitmap in machine check poller
Message-Id: <20090212124934.532233E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define a per cpu bitmap that contains the banks polled by the machine
check poller. This is needed for the CMCI code in the next patches
to be able to disable polling on specific banks.

The bank by default contains all banks, so there is no behaviour
change. Only future code will remove some banks from the polling
set.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h              |    5 ++++-
 arch/x86/kernel/cpu/mcheck/mce_64.c     |   16 ++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    3 ++-
 3 files changed, 18 insertions(+), 6 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:17.000000000 +0100
@@ -119,11 +119,14 @@
 
 extern void do_machine_check(struct pt_regs *, long);
 
+typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
+DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
+
 enum mcp_flags {
 	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
 	MCP_UC = (1 << 1),		/* log uncorrected errors */
 };
-extern void machine_check_poll(enum mcp_flags flags);
+extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 extern int mce_notify_user(void);
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:17.000000000 +0100
@@ -62,6 +62,11 @@
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 
+/* MCA banks polled by the period polling timer for corrected events */
+DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
+	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
+};
+
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
 {
@@ -191,7 +196,7 @@
  *
  * This is executed in standard interrupt context.
  */
-void machine_check_poll(enum mcp_flags flags)
+void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int i;
@@ -200,7 +205,7 @@
 
 	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 	for (i = 0; i < banks; i++) {
-		if (!bank[i])
+		if (!bank[i] || !test_bit(i, *b))
 			continue;
 
 		m.misc = 0;
@@ -458,7 +463,8 @@
 	WARN_ON(smp_processor_id() != data);
 
 	if (mce_available(&current_cpu_data))
-		machine_check_poll(MCP_TIMESTAMP);
+		machine_check_poll(MCP_TIMESTAMP,
+				&__get_cpu_var(mce_poll_banks));
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -567,11 +573,13 @@
 {
 	u64 cap;
 	int i;
+	mce_banks_t all_banks;
 
 	/*
 	 * Log the machine checks left over from the previous reset.
 	 */
-	machine_check_poll(MCP_UC);
+	bitmap_fill(all_banks, MAX_NR_BANKS);
+	machine_check_poll(MCP_UC, &all_banks);
 
 	set_in_cr4(X86_CR4_MCE);
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 11:30:51.000000000 +0100
@@ -231,7 +231,8 @@
 
 			/* Log the machine check that caused the threshold
 			   event. */
-			machine_check_poll(MCP_TIMESTAMP);
+			machine_check_poll(MCP_TIMESTAMP,
+					&__get_cpu_var(mce_poll_banks));
 
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
