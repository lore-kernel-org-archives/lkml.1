Return-Path: <linux-kernel-owner+w=401wt.eu-S966529AbXG3Csu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529AbXG3Csu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966136AbXG3Cr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41611 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936593AbXG3CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:22 -0400
Message-Id: <20070730024719.782847315@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:38 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=softirq-raise-wakeup-fix.patch
Subject: [PATCH -rt 4/9] ifdef raise_softirq_irqoff wakeup
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

raise_softirq is called every timer interrupt in run_local_timers(),
which causes a thread wakeup to happen every timer interrupt. This
happens in !CONFIG_PREEMPT_SOFTIRQS, which means the wakeup is most
likely not needed. In addition it also fouls calc_load() since it's,
agian, observing at least one thread running on every invocation.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
 
---
 kernel/softirq.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22/kernel/softirq.c
===================================================================
--- linux-2.6.22.orig/kernel/softirq.c
+++ linux-2.6.22/kernel/softirq.c
@@ -508,7 +508,9 @@ inline fastcall void raise_softirq_irqof
 {
 	__do_raise_softirq_irqoff(nr);
 
+#ifdef CONFIG_PREEMPT_SOFTIRQS
 	wakeup_softirqd(nr);
+#endif
 }
 
 EXPORT_SYMBOL(raise_softirq_irqoff);

-- 
