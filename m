Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYAFM3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYAFM3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAFM2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:28:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:49370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYAFM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=S5R8UwJyOYYWvKMA4Uku0NPawx6MvCTaGeRG3Y7i/ptw6n4qL8/6OyKFugSylbdPu7MRE+cNCDb6UGi85M1qzged0NLWONejrKSW9KGT3DagSniXbpNnIyfxvI68Q/VYq/g2Z/oOwrjAU8R516z2UKMRsoHa05UaifoNQhyNmqg=
Date: Sun, 6 Jan 2008 15:28:39 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: [PATCH 2/3] pda_power: add suspend/resume support
Message-ID: <20080106122839.GA13275@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume/wakeup support for pda_power.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index d98622f..d1ebfa0 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -239,12 +239,44 @@ static int pda_power_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	if (device_may_wakeup(&pdev->dev)) {
+		if (ac_irq)
+			enable_irq_wake(ac_irq->start);
+		if (usb_irq)
+			enable_irq_wake(usb_irq->start);
+	}
+
+	return 0;
+}
+
+static int pda_power_resume(struct platform_device *pdev)
+{
+	if (device_may_wakeup(&pdev->dev)) {
+		if (usb_irq)
+			disable_irq_wake(usb_irq->start);
+		if (ac_irq)
+			disable_irq_wake(ac_irq->start);
+	}
+
+	return 0;
+}
+#else
+#define pda_power_suspend	NULL
+#define pda_power_resume	NULL
+#endif
+
+
 static struct platform_driver pda_power_pdrv = {
 	.driver = {
 		.name = "pda-power",
 	},
 	.probe = pda_power_probe,
 	.remove = pda_power_remove,
+	.suspend = pda_power_suspend,
+	.resume = pda_power_resume,
 };
 
 static int __init pda_power_init(void)
-- 
With best wishes
Dmitry

