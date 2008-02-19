Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbYBSC1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbYBSC1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYBSC0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:26:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbYBSC0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:26:54 -0500
Message-ID: <47BA3E05.8020805@cn.fujitsu.com>
Date: Tue, 19 Feb 2008 10:25:09 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: tony.luck@intel.com
CC: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 4/5] signal(ia64): add a signal stack overflow check
References: <47B95D4F.8030003@cn.fujitsu.com>
In-Reply-To: <47B95D4F.8030003@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar check has been added to x86_32(i386) in commit
id 83bd01024b1fdfc41d9b758e5669e80fca72df66.
So we add this check to ia64 and improve it a liitle bit in that
we need to check for stack overflow only when the signal is on stack.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---

The previous patch has a comment mistake. Now I correct it.

---
--- linux-2.6.25-rc2.orig/arch/ia64/kernel/signal.c	2008-02-16 04:57:20.000000000 +0800
+++ linux-2.6.25-rc2/arch/ia64/kernel/signal.c	2008-02-19 09:57:05.000000000 +0800
@@ -342,15 +342,33 @@ setup_frame (int sig, struct k_sigaction
 
 	new_sp = scr->pt.r12;
 	tramp_addr = (unsigned long) __kernel_sigtramp;
-	if ((ka->sa.sa_flags & SA_ONSTACK) && sas_ss_flags(new_sp) == 0) {
-		new_sp = current->sas_ss_sp + current->sas_ss_size;
-		/*
-		 * We need to check for the register stack being on the signal stack
-		 * separately, because it's switched separately (memory stack is switched
-		 * in the kernel, register stack is switched in the signal trampoline).
-		 */
-		if (!rbs_on_sig_stack(scr->pt.ar_bspstore))
-			new_rbs = (current->sas_ss_sp + sizeof(long) - 1) & ~(sizeof(long) - 1);
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		int onstack = sas_ss_flags(new_sp);
+
+		if (onstack == 0) {
+			new_sp = current->sas_ss_sp + current->sas_ss_size;
+			/*
+			 * We need to check for the register stack being on the
+			 * signal stack separately, because it's switched
+			 * separately (memory stack is switched in the kernel,
+			 * register stack is switched in the signal trampoline).
+			 */
+			if (!rbs_on_sig_stack(scr->pt.ar_bspstore))
+				new_rbs = ALIGN(current->sas_ss_sp,
+						sizeof(long));
+		} else if (onstack == SS_ONSTACK) {
+			unsigned long check_sp;
+
+			/*
+			 * If we are on the alternate signal stack and would
+			 * overflow it, don't. Return an always-bogus address
+			 * instead so we will die with SIGSEGV.
+			 */
+			check_sp = (new_sp - sizeof(*frame)) & -STACK_ALIGN;
+			if (!likely(on_sig_stack(check_sp)))
+				return force_sigsegv_info(sig, (void __user *)
+							  check_sp);
+		}
 	}
 	frame = (void __user *) ((new_sp - sizeof(*frame)) & -STACK_ALIGN);
 


