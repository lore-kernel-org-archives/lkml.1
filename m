Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbYFQV6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbYFQV6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYFQV5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:57:55 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbYFQV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:57:54 -0400
Subject: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 23:57:14 +0200
Message-Id: <1213739834.3803.137.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning has started to trigger with mac80211 because it can, under
some circumstances, use spin_lock_bh() protected sections within
irq-disabled sections. Is that a bug?

Interestingly, the warning was never noticed until somebody ran the code
on UP/NO-PREEMPT because local_bh_enable_ip() does not contain such a
warning. Also, because softirq disabling is refcounted (via the preempt
counter), it ought to be safe to nest it and even use within
irqs-disabled sections, as far as I can tell.

Also, if you're going to treat IRQs being enabled as a bug, there's no
point in disabling them right afterwards, is there?

If you're going to reject this patch, I'll post one that adds the
warning to local_bh_enable_ip() to allow detecting this for everybody
and not just those poor people running UP/NO-PREEMPT :)

(and why doesn't local_bh_enable just call local_bh_enable_ip anyway? or
both "call" a common static inline?)
---
 kernel/softirq.c |    3 ---
 1 file changed, 3 deletions(-)

--- everything.orig/kernel/softirq.c	2008-06-17 23:48:25.000000000 +0200
+++ everything/kernel/softirq.c	2008-06-17 23:48:56.000000000 +0200
@@ -137,10 +137,7 @@ void local_bh_enable(void)
 	unsigned long flags;
 
 	WARN_ON_ONCE(in_irq());
-#endif
-	WARN_ON_ONCE(irqs_disabled());
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_save(flags);
 #endif
 	/*


