Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYAFNq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYAFNq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYAFNqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:46:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:38712 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYAFNqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:46:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dQ9nKMwoKC/G4galtT8akDAputLOUe5qFT17NbBLOvwvE3tOrCXxLDkJutGQsdmaOwwJ6uKzaDkrLsgqyGFdvCGmZ1D//FCfVtkxtdIPl5xdmaa17X1I9bkJe/C4V5AvpS392bjz9EH5BBPmx8iMbbkx/K2BtHGwvn4TWCFxSV8=
Subject: [PATCH] DS1WM: decouple host IRQ and INTR active state settings.
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 14:46:14 +0100
Message-Id: <1199627174.28826.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
high) from IRQ settings. There are devices that have IAS=0 but still need
the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/w1/masters/ds1wm.c |    9 +++++----
 include/linux/ds1wm.h      |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 5747997..688e435 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -361,11 +361,12 @@ static int ds1wm_probe(struct platform_device *pdev)
 		goto err1;
 	}
 	ds1wm_data->irq = res->start;
-	ds1wm_data->active_high = (res->flags & IORESOURCE_IRQ_HIGHEDGE) ?
-		1 : 0;
+	ds1wm_data->active_high = plat->active_high;
 
-	set_irq_type(ds1wm_data->irq, ds1wm_data->active_high ?
-			IRQ_TYPE_EDGE_RISING : IRQ_TYPE_EDGE_FALLING);
+	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
+	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
 	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
 			  "ds1wm", ds1wm_data);
diff --git a/include/linux/ds1wm.h b/include/linux/ds1wm.h
index 31f6e3c..d3c65e4 100644
--- a/include/linux/ds1wm.h
+++ b/include/linux/ds1wm.h
@@ -6,6 +6,7 @@ struct ds1wm_platform_data {
 			     * e.g. on h5xxx and h2200 this is 2
 			     * (registers aligned to 4-byte boundaries),
 			     * while on hx4700 this is 1 */
+	int active_high;
 	void (*enable)(struct platform_device *pdev);
 	void (*disable)(struct platform_device *pdev);
 };
-- 
1.5.3.7


