Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZDONbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZDONbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZDONbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:31:36 -0400
Received: from khc.piap.pl ([195.187.100.11]:50404 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZDONbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:31:36 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix RTC-CMOS message, against 2.6.30-rc2
References: <m3vdpnvvzt.fsf@intrepid.localdomain>
	<m3r60bvvrg.fsf@intrepid.localdomain>
	<200904041102.07751.david-b@pacbell.net>
	<m3bprcusdw.fsf@intrepid.localdomain>
	<20090409131556.07c8eed9.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 15 Apr 2009 15:31:29 +0200
In-Reply-To: <20090409131556.07c8eed9.akpm@linux-foundation.org> (Andrew Morton's message of "Thu\, 9 Apr 2009 13\:15\:56 -0700")
Message-ID: <m3zleirqku.fsf_-_@intrepid.localdomain>
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

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b6d35f5..23e10b6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -797,17 +797,15 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
-			dev_name(&cmos_rtc.rtc->dev),
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
+		dev_name(&cmos_rtc.rtc->dev),
+		!is_valid_irq(rtc_irq) ? "no alarms" :
+			cmos_rtc.mon_alrm ? "alarms up to one year" :
+			cmos_rtc.day_alrm ? "alarms up to one month" :
+			"alarms up to one day",
+		cmos_rtc.century ? ", y3k" : "",
+		nvram.size,
+		is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
 

-- 
Krzysztof Halasa
