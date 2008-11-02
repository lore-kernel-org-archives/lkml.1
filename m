Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYKBCru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYKBCru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYKBCrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:47:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:21011 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYKBCrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:47:41 -0400
Subject: Re: rtc: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       akpm@linux-foundation.org
In-Reply-To: <20081030184837.776f57bd@i1501.lan.towertech.it>
References: <1225388732.21973.30.camel@nga.site>
	 <20081030184837.776f57bd@i1501.lan.towertech.it>
Content-Type: text/plain; charset=utf-8
Date: Sun, 02 Nov 2008 03:47:41 +0100
Message-Id: <1225594061.2142.11.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 18:48 +0100, Alessandro Zummo wrote:
> On Thu, 30 Oct 2008 18:45:32 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: rtc: struct device - replace bus_id with dev_name(), dev_set_name()
> > 
> > CC: Alessandro Zummo <a.zummo@towertech.it>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> 
> 
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Updated patch, fix one wrong conversion from strncmp() to strcmp()

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: rtc: struct device - replace bus_id with dev_name(), dev_set_name()

Acked-By: Alessandro Zummo <a.zummo@towertech.it>
﻿Acked-By: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/rtc/class.c     |   16 ++++++----------
 drivers/rtc/interface.c |    2 +-
 drivers/rtc/rtc-cmos.c  |   10 +++++-----
 3 files changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -48,9 +48,7 @@ static int rtc_suspend(struct device *de
 	struct rtc_time		tm;
 	struct timespec		ts = current_kernel_time();
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
@@ -71,20 +69,18 @@ static int rtc_resume(struct device *dev
 	time_t			newtime;
 	struct timespec		time;
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
 	if (rtc_valid_tm(&tm) != 0) {
-		pr_debug("%s:  bogus resume time\n", rtc->dev.bus_id);
+		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
 	rtc_tm_to_time(&tm, &newtime);
 	if (newtime <= oldtime) {
 		if (newtime < oldtime)
-			pr_debug("%s:  time travel!\n", rtc->dev.bus_id);
+			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
 
@@ -156,7 +152,7 @@ struct rtc_device *rtc_device_register(c
 	init_waitqueue_head(&rtc->irq_queue);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
-	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
+	dev_set_name(&rtc->dev, "rtc%d", id);
 
 	rtc_dev_prepare(rtc);
 
@@ -169,7 +165,7 @@ struct rtc_device *rtc_device_register(c
 	rtc_proc_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, rtc->dev.bus_id);
+			rtc->name, dev_name(&rtc->dev));
 
 	return rtc;
 
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -335,7 +335,7 @@ static int __rtc_match(struct device *de
 {
 	char *name = (char *)data;
 
-	if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0)
+	if (strcmp(dev_name(dev), name) == 0)
 		return 1;
 	return 0;
 }
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -729,7 +729,7 @@ cmos_do_probe(struct device *dev, struct
 
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
-	rename_region(ports, cmos_rtc.rtc->dev.bus_id);
+	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
 
@@ -777,7 +777,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_DISABLED, cmos_rtc.rtc->dev.bus_id,
+				IRQF_DISABLED, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
@@ -795,7 +795,7 @@ cmos_do_probe(struct device *dev, struct
 	}
 
 	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
 					? "year"
@@ -885,7 +885,7 @@ static int cmos_suspend(struct device *d
 	}
 
 	pr_debug("%s: suspend%s, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -941,7 +941,7 @@ static int cmos_resume(struct device *de
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			tmp);
 
 	return 0;


