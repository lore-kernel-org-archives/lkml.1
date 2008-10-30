Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYJ3Rpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYJ3Rpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYJ3Rpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:45:36 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:47604 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYJ3Rpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:45:35 -0400
Subject: rtc: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 18:45:32 +0100
Message-Id: <1225388732.21973.30.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: rtc: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 4dfdf01..280226d 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -48,9 +48,7 @@ static int rtc_suspend(struct device *dev, pm_message_t mesg)
 	struct rtc_time		tm;
 	struct timespec		ts = current_kernel_time();
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
@@ -71,20 +69,18 @@ static int rtc_resume(struct device *dev)
 	time_t			newtime;
 	struct timespec		time;
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strncmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
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
 
@@ -156,7 +152,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	init_waitqueue_head(&rtc->irq_queue);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
-	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
+	dev_set_name(&rtc->dev, "rtc%d", id);
 
 	rtc_dev_prepare(rtc);
 
@@ -169,7 +165,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc_proc_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, rtc->dev.bus_id);
+			rtc->name, dev_name(&rtc->dev));
 
 	return rtc;
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 7af60b9..fa08067 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -335,7 +335,7 @@ static int __rtc_match(struct device *dev, void *data)
 {
 	char *name = (char *)data;
 
-	if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0)
+	if (strcmp(dev_name(dev), name) == 0)
 		return 1;
 	return 0;
 }
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5549231..5d3be30 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -729,7 +729,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
-	rename_region(ports, cmos_rtc.rtc->dev.bus_id);
+	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
 
@@ -777,7 +777,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_DISABLED, cmos_rtc.rtc->dev.bus_id,
+				IRQF_DISABLED, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
@@ -795,7 +795,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	}
 
 	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
 					? "year"
@@ -885,7 +885,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
 	}
 
 	pr_debug("%s: suspend%s, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -941,7 +941,7 @@ static int cmos_resume(struct device *dev)
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			tmp);
 
 	return 0;


