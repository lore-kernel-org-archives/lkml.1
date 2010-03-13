Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936516Ab0CMBdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:33:20 -0500
Received: from kroah.org ([198.145.64.141]:60609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934845Ab0CMATq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:46 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.015783380@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>
Subject: [patch 021/123] clocksource: Fix up a registration/IRQ race in the sh drivers.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Paul Mundt <lethal@linux-sh.org>

commit da64c2a8dee66ca03f4f3e15d84be7bedf73db3d upstream.

All of the SH clocksource drivers follow the scheme that the IRQ is setup
prior to registering the clockevent. The interrupt handler in the
clockevent cases looks to the event handler function pointer being filled
in by the registration code, permitting us to get in to situations where
asserted IRQs step in to the handler before registration has had a chance
to complete and hitting a NULL pointer deref.

In practice this is not an issue for most platforms, but some of them
with fairly special loaders (or that are chain-loading from another
kernel) may enter in to this situation. This fixes up the oops reported
by Rafael on hp6xx.

Reported-and-tested-by: Rafael Ignacio Zurita <rafaelignacio.zurita@gmail.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/clocksource/sh_cmt.c  |   32 +++++++++++++++++++-------------
 drivers/clocksource/sh_mtu2.c |    6 +++---
 drivers/clocksource/sh_tmu.c  |    6 +++---
 3 files changed, 25 insertions(+), 19 deletions(-)

--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -603,18 +603,13 @@ static int sh_cmt_setup(struct sh_cmt_pr
 	p->irqaction.handler = sh_cmt_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;
-	ret = setup_irq(irq, &p->irqaction);
-	if (ret) {
-		pr_err("sh_cmt: failed to request irq %d\n", irq);
-		goto err1;
-	}
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, cfg->clk);
 	if (IS_ERR(p->clk)) {
 		pr_err("sh_cmt: cannot get clock \"%s\"\n", cfg->clk);
 		ret = PTR_ERR(p->clk);
-		goto err2;
+		goto err1;
 	}
 
 	if (resource_size(res) == 6) {
@@ -627,14 +622,25 @@ static int sh_cmt_setup(struct sh_cmt_pr
 		p->clear_bits = ~0xc000;
 	}
 
-	return sh_cmt_register(p, cfg->name,
-			       cfg->clockevent_rating,
-			       cfg->clocksource_rating);
- err2:
-	remove_irq(irq, &p->irqaction);
- err1:
+	ret = sh_cmt_register(p, cfg->name,
+			      cfg->clockevent_rating,
+			      cfg->clocksource_rating);
+	if (ret) {
+		pr_err("sh_cmt: registration failed\n");
+		goto err1;
+	}
+
+	ret = setup_irq(irq, &p->irqaction);
+	if (ret) {
+		pr_err("sh_cmt: failed to request irq %d\n", irq);
+		goto err1;
+	}
+
+	return 0;
+
+err1:
 	iounmap(p->mapbase);
- err0:
+err0:
 	return ret;
 }
 
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -221,15 +221,15 @@ static void sh_mtu2_register_clockevent(
 	ced->cpumask = cpumask_of(0);
 	ced->set_mode = sh_mtu2_clock_event_mode;
 
+	pr_info("sh_mtu2: %s used for clock events\n", ced->name);
+	clockevents_register_device(ced);
+
 	ret = setup_irq(p->irqaction.irq, &p->irqaction);
 	if (ret) {
 		pr_err("sh_mtu2: failed to request irq %d\n",
 		       p->irqaction.irq);
 		return;
 	}
-
-	pr_info("sh_mtu2: %s used for clock events\n", ced->name);
-	clockevents_register_device(ced);
 }
 
 static int sh_mtu2_register(struct sh_mtu2_priv *p, char *name,
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -323,15 +323,15 @@ static void sh_tmu_register_clockevent(s
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
 
+	pr_info("sh_tmu: %s used for clock events\n", ced->name);
+	clockevents_register_device(ced);
+
 	ret = setup_irq(p->irqaction.irq, &p->irqaction);
 	if (ret) {
 		pr_err("sh_tmu: failed to request irq %d\n",
 		       p->irqaction.irq);
 		return;
 	}
-
-	pr_info("sh_tmu: %s used for clock events\n", ced->name);
-	clockevents_register_device(ced);
 }
 
 static int sh_tmu_register(struct sh_tmu_priv *p, char *name,


