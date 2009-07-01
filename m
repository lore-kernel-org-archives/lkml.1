Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGAGxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGAGxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZGAGx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:53:26 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42522 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZGAGxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:53:25 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: sameo@linux.intel.com
Cc: drwyrm@gmail.com, laforge@openezx.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] MFD: ezx-pcap, fix lock imbalance
Date: Wed,  1 Jul 2009 08:53:07 +0200
Message-Id: <1246431187-23684-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an omitted unlock in pcap_adc_irq ISR on one fail path. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/mfd/ezx-pcap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 671a7ef..c1de4af 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -238,8 +238,10 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
 	mutex_lock(&pcap->adc_mutex);
 	req = pcap->adc_queue[pcap->adc_head];
 
-	if (WARN(!req, KERN_WARNING "adc irq without pending request\n"))
+	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
+		mutex_unlock(&pcap->adc_mutex);
 		return IRQ_HANDLED;
+	}
 
 	/* read requested channels results */
 	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
-- 
1.6.3.2

