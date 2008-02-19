Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYBSCYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYBSCYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYBSCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:23:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63499 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbYBSCX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:23:56 -0500
Message-ID: <47BA3D53.6010307@cn.fujitsu.com>
Date: Tue, 19 Feb 2008 10:22:11 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] signal(x86_64): add a signal stack overflow check
References: <47B95CF9.60005@cn.fujitsu.com>
In-Reply-To: <47B95CF9.60005@cn.fujitsu.com>
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

The previous patch has a comment mistake. Now I correct it.

---
--- linux-2.6.25-rc2.orig/arch/x86/kernel/signal_64.c	2008-02-16 04:57:20.000000000 +0800
+++ linux-2.6.25-rc2/arch/x86/kernel/signal_64.c	2008-02-19 09:56:20.000000000 +0800
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
+			 * overflow it, don't. Return an always-bogus address
+			 * instead so we will die with SIGSEGV.
+			 */
+			if (!likely(on_sig_stack(sp - size)))
+				return (void __user *) -1L;
+		}
 	}
 
 	return (void __user *)round_down(sp - size, 16);


