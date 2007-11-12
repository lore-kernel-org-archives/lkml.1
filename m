Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXKLWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXKLWJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXKLWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:09:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:53077 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbXKLWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=ZWBhUB/bjTyoQqbZP6w2/29X4jh1ktROsEl6ktlp9k5HcACq1p+XxG1KJ1v6TCaRNko0ZoymAskOXQSZbGj/zJnFcTGkFdfbGDu9nZUQSzuPtA5PADT01nEpOMyXeu8FEIGA+OQD6tCZSEAZCXH9dgrYHyjy/S0lTz1BfOblpi4=
Message-ID: <4738CF15.10707@gmail.com>
Date: Tue, 13 Nov 2007 01:09:25 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Replace the goto-based loop by a do-while statement
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

It looks like using the goto statement in constructs like

restart:
	// DO SOMETHING
if (condition)
	goto restart;

should be frowned upon and the loop

do {
	// DO SOMETHING
} while (condition);

is more appropriate in such situation.

However, in the __do_softirq() routine located in `kernel/softirq.c' the goto construct was chosen in favor of the do-while loop.

The patch included below replaces the goto-based loop by the do-while statement.

If the goto is really necessary here, I would be very grateful if someone could explain why.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
--
diff --git a/kernel/softirq.c b/kernel/softirq.c
index bd89bc4..b0d0431 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -219,28 +219,28 @@ asmlinkage void __do_softirq(void)
 	trace_softirq_enter();
 
 	cpu = smp_processor_id();
-restart:
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
 
-	local_irq_enable();
+	do {
+		/* Reset the pending bitmask before enabling irqs */
+		set_softirq_pending(0);
 
-	h = softirq_vec;
+		local_irq_enable();
 
-	do {
-		if (pending & 1) {
-			h->action(h);
-			rcu_bh_qsctr_inc(cpu);
-		}
-		h++;
-		pending >>= 1;
-	} while (pending);
+		h = softirq_vec;
 
-	local_irq_disable();
+		do {
+			if (pending & 1) {
+				h->action(h);
+				rcu_bh_qsctr_inc(cpu);
+			}
+			h++;
+			pending >>= 1;
+		} while (pending);
 
-	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+		local_irq_disable();
+
+		pending = local_softirq_pending();
+	} while (pending && --max_restart);
 
 	if (pending)
 		wakeup_softirqd();
