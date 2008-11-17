Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYKQNgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYKQNgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYKQNgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:36:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:19718 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKQNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=q4rJu+DlKolXTfUrdgxBfzMQbDrGwQzl4lLLVa5kV5ThKPN2CCsyYXBNjNgw9/RzuP
         CS213Atx5Pm6OaplKM0IxrKqj6++Ug6lxyrhkeee6+XLp7EAcfh/c4Q5Lo28Ev8MmhKG
         npqk9eVCaibzCk85yZzPe1uZig/gO8F+jBV8c=
Date: Mon, 17 Nov 2008 13:35:48 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Miller <davem@davemloft.net>, Ferenc Wagner <wferi@niif.hu>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] softirq: Use local_irq_save() in local_bh_enable()
Message-ID: <20081117133548.GC6345@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6zwwy5c.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This report: http://marc.info/?l=linux-netdev&m=122599341430090&w=2
shows local_bh_enable() is used in the wrong context (irqs disabled).
It happens when a usual network receive path is called by netconsole,
which simply turns off irqs around this all. Probably this is wrong,
but it worked like this long time, and it's not trivial to fix this.

Anyway, a commit 0f476b6d91a1395bda6464e653ce66ea9bea7167 "softirq:
remove irqs_disabled warning from local_bh_enable" can break things
after changing from local_irq_save() to local_irq_disable(). Before
this commit there was only a warning, now a lockup is possible, so
it could be treated as a regression. This patch reverts the change
in irqs.

Reported-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 kernel/softirq.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..756c928 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -135,9 +135,12 @@ EXPORT_SYMBOL(_local_bh_enable);
 
 static inline void _local_bh_enable_ip(unsigned long ip)
 {
+#ifdef CONFIG_TRACE_IRQFLAGS
+	unsigned long flags;
+#endif
 	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_disable();
+	local_irq_save(flags);
 #endif
 	/*
 	 * Are softirqs going to be turned on now:
@@ -155,7 +158,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_enable();
+	local_irq_restore(flags);
 #endif
 	preempt_check_resched();
 }
