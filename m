Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYIFShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYIFShn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYIFShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:37:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYIFShe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:37:34 -0400
Date: Sat, 6 Sep 2008 20:37:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pawel MOLL <pawel.moll@st.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
Message-ID: <20080906183718.GF21872@elte.hu>
References: <1219313656.31630.89.camel@bri1004.bri.st.com> <1219416584.31630.639.camel@bri1004.bri.st.com> <20080823160859.GE27974@elte.hu> <1219531395.21386.200.camel@pasglop> <1219745676.16078.219.camel@bri1004.bri.st.com> <1219795619.13162.166.camel@pasglop> <1220260331.3299.1118.camel@bri1004.bri.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220260331.3299.1118.camel@bri1004.bri.st.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pawel MOLL <pawel.moll@st.com> wrote:

> This patch clarifies usage of irq_chip->startup() callback:
> 
> 1. The "if (startup) startup(); else enabled();" code in setup_irq()
>    is unnecessary, as startup() falls back to enabled() via
>    default callbacks, set by irq_chip_set_defaults().
> 
> 2. When using set_irq_chained_handler() the startup() was never called,
>    which is not good at all... Fixed. And again - when startup() is not
>    defined the call will fall back to enable() than to unmask() via
>    default callbacks.
> 
> Signed-off-by: Pawel Moll <pawel.moll@st.com>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

applied the commit below to tip/genirq - thanks Pawel.

	Ingo

------------->
>From 7e6e178ab1548c8d894a77593e757acf4510b8ba Mon Sep 17 00:00:00 2001
From: Pawel MOLL <pawel.moll@st.com>
Date: Mon, 1 Sep 2008 10:12:11 +0100
Subject: [PATCH] genirq: irq_chip->startup() usage in setup_irq and set_irq_chained handler

This patch clarifies usage of irq_chip->startup() callback:

1. The "if (startup) startup(); else enabled();" code in setup_irq()
   is unnecessary, as startup() falls back to enabled() via
   default callbacks, set by irq_chip_set_defaults().

2. When using set_irq_chained_handler() the startup() was never called,
   which is not good at all... Fixed. And again - when startup() is not
   defined the call will fall back to enable() than to unmask() via
   default callbacks.

Signed-off-by: Pawel Moll <pawel.moll@st.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |    2 +-
 kernel/irq/manage.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 964964b..240c64d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -587,7 +587,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->unmask(irq);
+		desc->chip->startup(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ae1b684..9aa3e7b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -397,10 +397,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
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
