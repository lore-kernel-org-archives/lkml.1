Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYKSIlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYKSIlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYKSIlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:41:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:22871 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYKSIlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:x-mutt-fcc:user-agent;
        b=n2vk9dQbR44Oebm8zHs4U+gUGThMi684Cx4kWHwcPIkn25jzXIDLDLuKbBAbHTC0VM
         1sqErRKqnJoANkD0oWDLRQEdW8F7IRyL8XYEDkdLa5q+lQLIURkixQqvFkf+l6AvCOw2
         HAUyPZpzRJcIIWVDE1NEMgFJq6w4K/4oJWRWE=
Date: Wed, 19 Nov 2008 08:41:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Miller <davem@davemloft.net>, Ferenc Wagner <wferi@niif.hu>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] softirq: Fix warnings triggered by netconsole
Message-ID: <20081119084125.GB6699@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6zwwy5c.fsf@tac.ki.iif.hu>
X-Mutt-Fcc: =outbox
X-Mutt-Fcc: =outbox
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider netconsole case as special in local_bh_enable()/_disable().
This patch skips in_irq() and irqs_disabled() warnings for NETPOLL
configs when it's safe wrt. do_softirq().

Reported-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---
[apply on top of my first softirq patch in this thread]

diff -Nurp a/kernel/softirq.c b/kernel/softirq.c
--- a/kernel/softirq.c	2008-11-19 07:33:23.000000000 +0000
+++ b/kernel/softirq.c	2008-11-19 07:26:28.000000000 +0000
@@ -76,7 +76,12 @@ static void __local_bh_disable(unsigned 
 {
 	unsigned long flags;
 
+#ifdef CONFIG_NETPOLL
+	if (!softirq_count())
+		WARN_ON_ONCE(in_irq());
+#else
 	WARN_ON_ONCE(in_irq());
+#endif
 
 	raw_local_irq_save(flags);
 	add_preempt_count(SOFTIRQ_OFFSET);
@@ -138,7 +143,16 @@ static inline void _local_bh_enable_ip(u
 #ifdef CONFIG_TRACE_IRQFLAGS
 	unsigned long flags;
 #endif
+#ifdef CONFIG_NETPOLL
+	/*
+	 * Special-case - netconsole runs network code with all interrupts
+	 * disabled. Warn only if it can be really dangerous:
+	 */
+	if (softirq_count() == SOFTIRQ_OFFSET)
+		WARN_ON_ONCE(in_irq() || irqs_disabled());
+#else
 	WARN_ON_ONCE(in_irq() || irqs_disabled());
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_save(flags);
 #endif
