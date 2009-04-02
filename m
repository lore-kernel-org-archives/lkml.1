Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbZDBQ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbZDBQ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZDBQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:57:30 -0400
Received: from khc.piap.pl ([195.187.100.11]:51297 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192AbZDBQ52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:57:28 -0400
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix RTC-CMOS message, now with SOB
References: <m3vdpnvvzt.fsf@intrepid.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 02 Apr 2009 18:57:23 +0200
In-Reply-To: <m3vdpnvvzt.fsf@intrepid.localdomain> (Krzysztof Halasa's message of "Thu\, 02 Apr 2009 18\:52\:22 +0200")
Message-ID: <m3r60bvvrg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With no IRQ available/defined, RTC-CMOS driver prints something like:
	rtc0: alarms up to one no, y3k, 114 bytes nvram
                              ^^^^
I guess the following is a bit easier to understand:
	rtc0: no alarms, y3k, 114 bytes nvram

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

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
