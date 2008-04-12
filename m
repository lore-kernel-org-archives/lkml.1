Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYDLLr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYDLLr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 07:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYDLLrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 07:47:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbYDLLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 07:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=he7ZQs8ZvX8MjbLlRqXqYUGWA9C9m1T3ofQaTTxmIJVTgkh6/4BArDgoUzsgy3ngKaPGL/uWpPJKcOufyqQfHQHolk5pVF/ykBbq9vvFyf6ysIgEpoFZhUrHu31nhDvWxelos70dekjV9han9ojQoqfBDUl6GXg3SZiesKngHjY=
Subject: [PATCH] pda_power: add init and exit function callbacks
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 13:47:45 +0200
Message-Id: <1208000865.9566.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds init/exit function callbacks to pda_power, to
provide a place where the platform code can request/free
GPIOs that it wants to use in the is_ac_online, is_usb_online
and set_charge functions.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/power/pda_power.c |   11 +++++++++++
 include/linux/pda_power.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index c8aa55b..5a0c434 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -209,6 +209,12 @@ static int pda_power_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 
+	if (pdata->init) {
+		ret = pdata->init(dev);
+		if (ret < 0)
+			goto init_failed;
+	}
+
 	update_status();
 	update_charger();
 
@@ -299,6 +305,9 @@ ac_irq_failed:
 		power_supply_unregister(&pda_psy_ac);
 ac_supply_failed:
 wrongid:
+	if (pdata->exit)
+		pdata->exit(dev);
+init_failed:
 	return ret;
 }
 
@@ -318,6 +327,8 @@ static int pda_power_remove(struct platform_device *pdev)
 		power_supply_unregister(&pda_psy_usb);
 	if (pdata->is_ac_online)
 		power_supply_unregister(&pda_psy_ac);
+	if (pdata->exit)
+		pdata->exit(dev);
 
 	return 0;
 }
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
index 225beb1..8ad67bb 100644
--- a/include/linux/pda_power.h
+++ b/include/linux/pda_power.h
@@ -17,9 +17,11 @@
 #define PDA_POWER_CHARGE_USB (1 << 1)
 
 struct pda_power_pdata {
+	int (*init)(struct device *);
 	int (*is_ac_online)(void);
 	int (*is_usb_online)(void);
 	void (*set_charge)(int flags);
+	void (*exit)(struct device *);
 
 	char **supplied_to;
 	size_t num_supplicants;
-- 
1.5.5


