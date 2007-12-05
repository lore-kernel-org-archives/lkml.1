Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbXLEFYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbXLEFYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 00:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLEFYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 00:24:04 -0500
Received: from [222.73.24.84] ([222.73.24.84]:54847 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLEFYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 00:24:03 -0500
Message-ID: <4756359F.5000008@cn.fujitsu.com>
Date: Wed, 05 Dec 2007 13:22:39 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <474CF7D5.6010702@cn.fujitsu.com>	<474D05AE.60905@cn.fujitsu.com>	<20071204130218.GE31590@elte.hu> <20071204215251.60C6326F8D9@magilla.localdomain>
In-Reply-To: <20071204215251.60C6326F8D9@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Roland McGrath wrote::
>>> Thank you for your detailed explanation and patch. I tested your 
>>> patch, unfortunately it can not stop all kinds of overflow.
>> [...]
>>> So, the patch I posted is still needed 
>> thanks, i've picked up your fix for x86.git, for 2.6.25 merging.
> 
> I just explained that not all overflows would be caught and that doing so
> would violate the semantics of e.g. longjmp.  I don't see how the patch
> you've included now doesn't still have all those problems.  I think it's wrong.
> 

I am sorry, i don't understand how this is related to the semantics of e.g. longjmp.
But, i am sure my patch solves all overflows. Ingo's patch can't catch the overflow 
which is caught by "int i[1000];" in the handler function.

Do you have more idea for me? Thanks.

Regards
Shi Weihua

By the way, I think Ingo's patch can be improved. 

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>

---
--- linux-2.6.24-rc4-git1.orig/arch/x86/kernel/signal_32.c	2007-12-04 12:26:10.000000000 +0800
+++ linux-2.6.24-rc4-git1/arch/x86/kernel/signal_32.c	2007-12-05 11:13:56.000000000 +0800
@@ -297,8 +297,17 @@ get_sigframe(struct k_sigaction *ka, str
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(esp) == 0)
+		int onstack = sas_ss_flags(esp);
+		if (onstack == 0)
 			esp = current->sas_ss_sp + current->sas_ss_size;
+		else if(onstack == SS_ONSTACK){
+			/*
+			 * If we are on the alternate signal stack and would overflow it, don't.
+			 * Return an always-bogus address instead so we will die with SIGSEGV.
+			 */
+			if (!likely(on_sig_stack(esp - frame_size)))
+				return (void __user *) -1L;
+		}
 	}
 
 	/* This is the legacy signal stack switching. */


