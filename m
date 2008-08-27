Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYH0Ofx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYH0Ofx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYH0Ofb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:35:31 -0400
Received: from flusers.ccur.com ([12.192.68.2]:41856 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755086AbYH0Ofb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:35:31 -0400
Date: Wed, 27 Aug 2008 10:35:06 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] make poll_idle behave more like the other idle methods
Message-ID: <20080827143506.GA23166@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make poll_idle() behave more like the other idle methods.

Currently, poll_idle() returns immediately.  The other
idle methods all wait indefinately for some condition
to come true before returning.  poll_idle should emulate
these other methods and also wait for a return condition,
in this case, for need_resched() to become 'true'.

Without this delay the idle loop spends all of its time
in the outer loop that calls poll_idle.  This outer loop,
these days, does real work, some of it under rcu locks.
That work should only be done when idle is entered and
when idle exits, not continuously while idle is spinning.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/arch/x86/kernel/process.c
===================================================================
--- 2.6.27-rc4-git4.orig/arch/x86/kernel/process.c	2008-08-26 17:44:34.000000000 -0400
+++ 2.6.27-rc4-git4/arch/x86/kernel/process.c	2008-08-26 18:22:19.000000000 -0400
@@ -185,7 +185,8 @@
 static void poll_idle(void)
 {
 	local_irq_enable();
-	cpu_relax();
+	while(!need_resched())
+		cpu_relax();
 }
 
 /*
