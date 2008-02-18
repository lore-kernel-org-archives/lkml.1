Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYBRK0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYBRK0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYBRK0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:26:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYBRK0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:26:45 -0500
Message-ID: <47B95CF9.60005@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 18:24:57 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/5] signal(x86_64): add a signal stack overflow check
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar check has been added to x86_32(i386) in commit
id 83bd01024b1fdfc41d9b758e5669e80fca72df66.
So we add this check to x86_64 and improve it a liitle bit in that
we need to check for stack overflow only when the signal is on stack.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---
--- linux-2.6.25-rc2.orig/arch/x86/kernel/signal_64.c	2008-02-16 04:57:20.000000000 +0800
+++ linux-2.6.25-rc2/arch/x86/kernel/signal_64.c	2008-02-18 18:06:48.000000000 +0800
@@ -205,8 +205,19 @@ get_stack(struct k_sigaction *ka, struct
 
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
+			if (!likely(on_sig_stack(sp - size)))
+				return (void __user *) -1L;
+		}
 	}
 
 	return (void __user *)round_down(sp - size, 16);


