Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYHUKcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYHUKcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbYHUKb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:31:57 -0400
Received: from s200bog18.obsmtp.com ([207.126.150.132]:46417 "EHLO
	s200bog18.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYHUKb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:31:56 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 06:31:55 EDT
Subject: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
From: Pawel MOLL <pawel.moll@st.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Pawe=C5=82?= Moll <pawel.moll@st.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 11:14:15 +0100
Message-Id: <1219313656.31630.89.camel@bri1004.bri.st.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clarifies a usage of irq_chip->startup() callback:

1. The "if (startup) startup(); else enabled();" code in setup_irq()
   is unnecessary, as startup() falls back to enabled() via
   default callbacks, set by irq_chip_set_defaults().

2. When using set_irq_chained_handler() the startup() was never called,
   which is not good at all... Fixed. And again - when startup() is not
   defined the call will fall back to enable() than to unmask() via
   default callbacks.

Signed-off-by: Pawel Moll <pawel.moll@st.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |    2 +-
 kernel/irq/manage.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 7279484..a32c337 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -595,7 +595,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->unmask(irq);
+		desc->chip->startup(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fdccfd5..d0af30c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -369,10 +369,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			if (desc->chip->startup)
-				desc->chip->startup(irq);
-			else
-				desc->chip->enable(irq);
+			desc->chip->startup(irq);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
-- 
1.5.5.1



