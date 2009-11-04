Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbZKDVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbZKDVzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbZKDVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:55:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35457 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbZKDVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:55:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pRnsC2ocr0/8OB6prr8AplIoo8ZeLc5bQ9Cz07LmkhLLb4KR6NOuLzWVot1LPd9Ajr
         HVL48ZYigElWDSZpIeRITjWkkZrzMpQ1Mh8s0NHkfA6j/U/wIB++UdmPAjHlNwnEnwjx
         RMF3WDWwcBqRvuaSmUh1SsjTI4alHeGuO4Y4A=
From: Paul Fertser <fercerpav@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       Werner Almesberger <werner@openmoko.org>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 3/3] rtc: pcf50633: manage RTC alarm "pending" flag
Date: Thu,  5 Nov 2009 00:55:17 +0300
Message-Id: <1257371717-547-4-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257371717-547-3-git-send-email-fercerpav@gmail.com>
References: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
 <1257371717-547-2-git-send-email-fercerpav@gmail.com>
 <1257371717-547-3-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Werner Almesberger <werner@openmoko.org>

This patch adds setting and clearing of the "pending" flag of the
RTC alarm. The semantics follow the UEFI specification 2.2 available
at http://www.uefi.org/specs/, i.e., the "pending" flag is cleared
by disabling the alarm, but not by any other condition (such as the
passing of time, a successful wakeup, or setting of a new alarm.)

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/rtc/rtc-pcf50633.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index 33a10c4..8669815 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -58,6 +58,7 @@ struct pcf50633_time {
 struct pcf50633_rtc {
 	int alarm_enabled;
 	int second_enabled;
+	int alarm_pending;
 
 	struct pcf50633 *pcf;
 	struct rtc_device *rtc_dev;
@@ -209,6 +210,7 @@ static int pcf50633_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	rtc = dev_get_drvdata(dev);
 
 	alrm->enabled = rtc->alarm_enabled;
+	alrm->pending = rtc->alarm_pending;
 
 	ret = pcf50633_read_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
@@ -244,6 +246,8 @@ static int pcf50633_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	/* Returns 0 on success */
 	ret = pcf50633_write_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
+	if (!alrm->enabled)
+		rtc->alarm_pending = 0;
 
 	if (!alarm_masked || alrm->enabled)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
@@ -268,6 +272,7 @@ static void pcf50633_rtc_irq(int irq, void *data)
 	switch (irq) {
 	case PCF50633_IRQ_ALARM:
 		rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
+		rtc->alarm_pending = 1;
 		break;
 	case PCF50633_IRQ_SECOND:
 		rtc_update_irq(rtc->rtc_dev, 1, RTC_UF | RTC_IRQF);
-- 
1.6.0.6

