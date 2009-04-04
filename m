Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZDDTcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZDDTcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZDDTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:32:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:45038 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZDDTcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:32:32 -0400
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix RTC-CMOS message, now with SOB
References: <m3vdpnvvzt.fsf@intrepid.localdomain>
	<m3r60bvvrg.fsf@intrepid.localdomain>
	<200904041102.07751.david-b@pacbell.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 04 Apr 2009 21:32:27 +0200
In-Reply-To: <200904041102.07751.david-b@pacbell.net> (David Brownell's message of "Sat\, 4 Apr 2009 11\:02\:07 -0700")
Message-ID: <m3bprcusdw.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

>> +               !is_valid_irq(rtc_irq) ? "no alarms" :
>> +               cmos_rtc.mon_alrm ? "alarms up to one year" :
>> +               cmos_rtc.day_alrm ? "alarms up to one month" :
>> +               "alarms up to one day",
>
> Could you reformat that so it looks more like the compound-IF
> statement it really is?  That is, display the nesting structure.

You mean something like

>> +               !is_valid_irq(rtc_irq) ? "no alarms" :
>> +                       cmos_rtc.mon_alrm ? "alarms up to one year" :
>> +                       cmos_rtc.day_alrm ? "alarms up to one month" :
>> +                       "alarms up to one day",

Not this certainly?

>> +               !is_valid_irq(rtc_irq) ? "no alarms" :
>> +                       cmos_rtc.mon_alrm ? "alarms up to one year" :
>> +                               cmos_rtc.day_alrm ? "alarms up to one month" :
>> +                                       "alarms up to one day",

> And not use negative logic for that first test.

I think it's worse WRT readability:

+		is_valid_irq(rtc_irq) ?
+		        (cmos_rtc.mon_alrm ? "alarms up to one year" :
+		                cmos_rtc.day_alrm ? "alarms up to one month" :
+		                        "alarms up to one day") :
+		        "no alarms";

Feel free to use the following or your own version as long as the
resulting message is correct.
Thanks.

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
+			cmos_rtc.mon_alrm ? "alarms up to one year" :
+			cmos_rtc.day_alrm ? "alarms up to one month" :
+			"alarms up to one day",
+		cmos_rtc.century ? ", y3k" : "",
+		nvram.size,
+		is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
 
-- 
Krzysztof Halasa
