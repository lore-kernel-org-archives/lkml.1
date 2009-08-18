Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZHRTcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZHRTcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZHRTcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:32:41 -0400
Received: from www.tglx.de ([62.245.132.106]:43294 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZHRTck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:32:40 -0400
Date: Tue, 18 Aug 2009 21:31:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0908182127180.3361@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

I zapped the yesterdays patch as it triggered the hung_task detector
when no hard interrupt came in. So I moved the wakeup to the end of
setup_irq for now. I still need to figure out why the hung_task
detector triggers on that despite claiming otherwise in its comments.

Verified today that the branch contains really what I want you to pull :)

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Wake up irq thread after action has been installed


 kernel/irq/manage.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d222515..0ec9ed8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -607,7 +607,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
-		wake_up_process(t);
 	}
 
 	/*
@@ -690,6 +689,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
+	new->irq = irq;
 	*old_ptr = new;
 
 	/* Reset broken irq detection when installing new handler */
@@ -707,7 +707,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	spin_unlock_irqrestore(&desc->lock, flags);
 
-	new->irq = irq;
+	/*
+	 * Strictly no need to wake it up, but hung_task complains
+	 * when no hard interrupt wakes the thread up.
+	 */
+	if (new->thread)
+		wake_up_process(new->thread);
+
 	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
