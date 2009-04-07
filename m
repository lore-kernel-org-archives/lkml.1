Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZDGPIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZDGPIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZDGPHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48807 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZDGPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
In-Reply-To: <20090407506.675031434@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [2/4] x86: MCE: Fix boot logging logic
Message-Id: <20090407150655.254A01D046F@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:06:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bugfix

The earlier patch to change the poller to a separate function subtly
broke the boot logging logic. This could lead to machine checks 
getting logged at boot even when disabled or defaulting to off
on some systems. Fix that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_64.c |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:57.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:15.000000000 +0200
@@ -137,6 +137,7 @@
 enum mcp_flags {
 	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
 	MCP_UC = (1 << 1),		/* log uncorrected errors */
+	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
 };
 extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
@@ -239,9 +239,10 @@
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-
-		mce_log(&m);
-		add_taint(TAINT_MACHINE_CHECK);
+		if (!(flags & MCP_DONTLOG)) {
+			mce_log(&m);
+			add_taint(TAINT_MACHINE_CHECK);
+		}
 
 		/*
 		 * Clear state for this bank.
@@ -585,7 +586,7 @@
 	 * Log the machine checks left over from the previous reset.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
-	machine_check_poll(MCP_UC, &all_banks);
+	machine_check_poll(MCP_UC|(!mce_bootlog ? MCP_DONTLOG : 0), &all_banks);
 
 	set_in_cr4(X86_CR4_MCE);
 
