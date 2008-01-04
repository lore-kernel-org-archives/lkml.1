Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYADAph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYADAph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYADApQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:45:16 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:59501 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYADApN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZP3mJXytRIKRA+72KCDnCzx/86zqDDXNV64IGili/yY+LL/JG2MXB3MeMFs5i9V2QTDtyHTwMnKmVxE8zIbziGucZB5J8zcOko4TB1ucGDqi97g4lRE0XN1pQbfB8279fwrHA9oNtJmUb92peTPLWQAs7aqSuCzyHXCcfi3y8uY=
Date: Fri, 4 Jan 2008 03:32:43 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: [PATCH 2/2] pda_power: implement polling
Message-ID: <20080104003243.GB12308@zarina>
References: <20080104002907.GA767@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080104002907.GA767@zarina>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Untested, just to show the idea.

 drivers/power/pda_power.c |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pda_power.h |    1 +
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 153e3b1..8e9aec3 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -32,6 +32,8 @@ static struct pda_power_pdata *pdata;
 static struct resource *ac_irq, *usb_irq;
 static struct timer_list charger_timer;
 static struct timer_list supply_timer;
+static struct timer_list polling_timer;
+static int polling;
 
 enum {
 	PDA_PSY_OFFLINE = 0,
@@ -166,6 +168,28 @@ static irqreturn_t power_changed_isr(int irq, void *power_supply)
 	return IRQ_HANDLED;
 }
 
+static void polling_timer_func(unsigned long unused)
+{
+	int changed = 0;
+
+	dev_vdbg(dev, "polling...\n");
+
+	update_status();
+
+	if (!ac_irq && new_ac_status != ac_status) {
+		ac_status = PDA_PSY_TO_CHANGE;
+		changed = 1;
+	}
+
+	if (!usb_irq && new_usb_status != usb_status) {
+		usb_status = PDA_PSY_TO_CHANGE;
+		changed = 1;
+	}
+
+	if (changed)
+		psy_changed();
+}
+
 static int pda_power_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -190,6 +214,9 @@ static int pda_power_probe(struct platform_device *pdev)
 	if (!pdata->wait_for_charger)
 		pdata->wait_for_charger = 500;
 
+	if (!pdata->polling_interval)
+		pdata->polling_interval = 2000;
+
 	setup_timer(&charger_timer, charger_timer_func, 0);
 	setup_timer(&supply_timer, supply_timer_func, 0);
 
@@ -219,6 +246,8 @@ static int pda_power_probe(struct platform_device *pdev)
 				dev_err(dev, "request ac irq failed\n");
 				goto ac_irq_failed;
 			}
+		} else {
+			polling = 1;
 		}
 	}
 
@@ -238,9 +267,18 @@ static int pda_power_probe(struct platform_device *pdev)
 				dev_err(dev, "request usb irq failed\n");
 				goto usb_irq_failed;
 			}
+		} else {
+			polling = 1;
 		}
 	}
 
+	if (polling) {
+		dev_dbg(dev, "will poll for status\n");
+		setup_timer(&polling_timer, polling_timer_func, 0);
+		mod_timer(&polling_timer,
+			  jiffies + msecs_to_jiffies(pdata->polling_interval));
+	}
+
 	return 0;
 
 usb_irq_failed:
@@ -264,6 +302,8 @@ static int pda_power_remove(struct platform_device *pdev)
 	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_psy_ac);
 
+	if (polling)
+		del_timer_sync(&polling_timer);
 	del_timer_sync(&charger_timer);
 	del_timer_sync(&supply_timer);
 
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
index 1375f15..225beb1 100644
--- a/include/linux/pda_power.h
+++ b/include/linux/pda_power.h
@@ -26,6 +26,7 @@ struct pda_power_pdata {
 
 	unsigned int wait_for_status; /* msecs, default is 500 */
 	unsigned int wait_for_charger; /* msecs, default is 500 */
+	unsigned int polling_interval; /* msecs, default is 2000 */
 };
 
 #endif /* __PDA_POWER_H__ */
-- 
1.5.2.4
