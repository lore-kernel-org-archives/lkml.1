Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYHLIWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYHLIWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYHLIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:22:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35222
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbYHLIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:21:59 -0400
Date: Tue, 12 Aug 2008 01:22:01 -0700 (PDT)
Message-Id: <20080812.012201.164876122.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080811.233013.49328708.davem@davemloft.net>
References: <20080620.215139.218732028.davem@davemloft.net>
	<Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
	<20080811.233013.49328708.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 11 Aug 2008 23:30:13 -0700 (PDT)

> The problem is that CONFIG_STACK_DEBUG doesn't understand
> the IRQ stacks at all.
> 
> I'll see if I can tweak it to handle this.

This patch, on top of my original IRQSTACKS patch for
sparc64, seems to get things working for me.

diff --git a/arch/sparc64/lib/mcount.S b/arch/sparc64/lib/mcount.S
index 9e4534b..24e6a3c 100644
--- a/arch/sparc64/lib/mcount.S
+++ b/arch/sparc64/lib/mcount.S
@@ -45,11 +45,47 @@ _mcount:
 	sub		%g3, STACK_BIAS, %g3
 	cmp		%sp, %g3
 	bg,pt		%xcc, 1f
-	 sethi		%hi(panicstring), %g3
+	 nop
+#ifdef CONFIG_IRQSTACKS
+	lduh		[%g6 + TI_CPU], %g1
+	sethi		%hi(hardirq_stack), %g3
+	or		%g3, %lo(hardirq_stack), %g3
+	sllx		%g1, 3, %g1
+	ldx		[%g3 + %g1], %g7
+	sub		%g7, STACK_BIAS, %g7
+	cmp		%sp, %g7
+	bleu,pt		%xcc, 2f
+	 sethi		%hi(THREAD_SIZE), %g3
+	add		%g7, %g3, %g7
+	cmp		%sp, %g7
+	blu,pn		%xcc, 1f
+2:	 sethi		%hi(softirq_stack), %g3
+	or		%g3, %lo(softirq_stack), %g3
+	ldx		[%g3 + %g1], %g7
+	cmp		%sp, %g7
+	bleu,pt		%xcc, 2f
+	 sethi		%hi(THREAD_SIZE), %g3
+	add		%g7, %g3, %g7
+	cmp		%sp, %g7
+	blu,pn		%xcc, 1f
+	 nop
+#endif
+	/* If we are already on panic stack, don't hop onto it
+	 * again, we are already trying to output the stack overflow
+	 * message.
+	 */
 	sethi		%hi(ovstack), %g7		! cant move to panic stack fast enough
 	 or		%g7, %lo(ovstack), %g7
-	add		%g7, OVSTACKSIZE, %g7
+	add		%g7, OVSTACKSIZE, %g3
+	sub		%g3, STACK_BIAS - 192, %g3
 	sub		%g7, STACK_BIAS, %g7
+	cmp		%sp, %g7
+	blu,pn		%xcc, 2f
+	 cmp		%sp, %g3
+	bleu,pn		%xcc, 1f
+	 nop
+2:	mov		%g3, %sp
+	sethi		%hi(panicstring), %g3
 	mov		%g7, %sp
 	call		prom_printf
 	 or		%g3, %lo(panicstring), %o0
