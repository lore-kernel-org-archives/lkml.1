Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbZDBQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbZDBQxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbZDBQw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:52:27 -0400
Received: from khc.piap.pl ([195.187.100.11]:48601 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764267AbZDBQw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:52:26 -0400
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix RTC-CMOS message
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 02 Apr 2009 18:52:22 +0200
Message-ID: <m3vdpnvvzt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With no IRQ available/defined, RTC-CMOS driver prints something like:
	rtc0: alarms up to one no, y3k, 114 bytes nvram
                              ^^^^
I guess the following is a bit easier to understand:
	rtc0: no alarms, y3k, 114 bytes nvram

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -794,17 +794,15 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
-			cmos_rtc.rtc->dev.bus_id,
-			is_valid_irq(rtc_irq)
-				?  (cmos_rtc.mon_alrm
-					? "year"
-					: (cmos_rtc.day_alrm
-						? "month" : "day"))
-				: "no",
-			cmos_rtc.century ? ", y3k" : "",
-			nvram.size,
-			is_hpet_enabled() ? ", hpet irqs" : "");
+	pr_info("%s: %s%s, %zd bytes nvram%s\n",
+		cmos_rtc.rtc->dev.bus_id,
+		!is_valid_irq(rtc_irq) ? "no alarms" :
+		cmos_rtc.mon_alrm ? "alarms up to one year" :
+		cmos_rtc.day_alrm ? "alarms up to one month" :
+		"alarms up to one day",
+		cmos_rtc.century ? ", y3k" : "",
+		nvram.size,
+		is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
 
-- 
Krzysztof Halasa
