Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYBRKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYBRKYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYBRKYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:24:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYBRKYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:24:36 -0500
Message-ID: <47B95C4D.6080000@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 18:22:05 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow check
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check for stack overflow only when the signal is on stack.
So we can improve the patch "http://lkml.org/lkml/2007/11/27/101" as following. 

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---
--- linux-2.6.25-rc2.orig/arch/x86/kernel/signal_32.c	2008-02-16 04:57:20.000000000 +0800
+++ linux-2.6.25-rc2/arch/x86/kernel/signal_32.c	2008-02-18 18:06:39.000000000 +0800
@@ -299,17 +299,21 @@ get_sigframe(struct k_sigaction *ka, str
 	/* Default to using normal stack */
 	sp = regs->sp;
 
-	/*
-	 * If we are on the alternate signal stack and would overflow it, don't.
-	 * Return an always-bogus address instead so we will die with SIGSEGV.
-	 */
-	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
-		return (void __user *) -1L;
-
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
+		int onstack = sas_ss_flags(sp);
+
+		if (onstack == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
+		else if (onstack == SS_ONSTACK) {
+			/*
+			 * If we are on the alternate signal stack and would
+			 * overflow it, don't return an always-bogus address
+			 * instead so we will die with SIGSEGV.
+			 */
+			if (!likely(on_sig_stack(sp - frame_size)))
+				return (void __user *) -1L;
+		}
 	}
 
 	/* This is the legacy signal stack switching. */

