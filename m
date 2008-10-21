Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYJUOOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYJUOOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYJUOOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:14:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYJUOOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:14:39 -0400
Date: Tue, 21 Oct 2008 16:14:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] irq fixes
Message-ID: <20081021141427.GA20066@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Chris Friesen (1):
      genirq: fix set_irq_type() when recording trigger type

Dean Nelson (1):
      genirq: NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()

Ingo Molnar (1):
      genirq: fix off by one and coding style


 arch/x86/kernel/irq.c |    4 ++--
 include/linux/irqnr.h |    6 +++---
 kernel/irq/chip.c     |    3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index ccf6c50..d1d4dc5 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -36,7 +36,7 @@ void ack_bad_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_X86_32
-# define irq_stats(x)		(&per_cpu(irq_stat,x))
+# define irq_stats(x)		(&per_cpu(irq_stat, x))
 #else
 # define irq_stats(x)		cpu_pda(x)
 #endif
@@ -113,7 +113,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	if (i == 0) {
 		seq_printf(p, "           ");
 		for_each_online_cpu(j)
-			seq_printf(p, "CPU%-8d",j);
+			seq_printf(p, "CPU%-8d", j);
 		seq_putc(p, '\n');
 	}
 
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 3171ddc..452c280 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -13,9 +13,9 @@ extern int nr_irqs;
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
 
-# define for_each_irq_desc_reverse(irq, desc)			\
-	for (irq = nr_irqs -1, desc = irq_desc + (nr_irqs -1 );	\
-	     irq > 0; irq--, desc--)
+# define for_each_irq_desc_reverse(irq, desc)				\
+	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);	\
+	     irq >= 0; irq--, desc--)
 #endif
 
 #define for_each_irq_nr(irq)			\
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 4895fde..10b5092 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -76,6 +76,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->name = NULL;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
@@ -127,7 +128,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 		return 0;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, flags);
+	ret = __irq_set_trigger(desc, irq, type);
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
