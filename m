Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYH1S41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYH1S41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYH1S4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:56:18 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:36757 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752913AbYH1S4S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:56:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MtOBo872AbV+Tup8D9dFJDBOADpla1npQ78MqKFLdkIQm409/MQfN0Ph3uyp6gKUSKQIHBo3XMYr6Lf6ajCEqnFVJ/TjtUEVnWsLJOFif/uTUVQOm8p8w9RwKQINfQIvdOLo/oLB/nNoCd9LGaInrwMXnKsQcdZSQ48JdiceTLA=  ;
X-YMail-OSG: 6b33zfYVM1l0S2z2TvYcxna_8E1jkVaZ6gZfPS5VU8NCxoWTItN27kEXdUfUPXht81ji8egNvhRCrJKfVX9T7gVN3Imu6YIImnY3OvHAp55dgPfH5l9km.KKPJyaXGs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc4] rtc-cmos: wakes again from S5
Date: Thu, 28 Aug 2008 11:29:35 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Becker <Stefan.Becker@nokia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808281129.35611.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From : Rafael J. Wysocki <rjw@sisk.pl>

Update rtc-cmos shutdown handling to leave RTC alarms active,
resolving http://bugzilla.kernel.org/show_bug.cgi?id=11411 on
several boards.  There are still some systems where the ACPI event
handling doesn't cooperate.  (Possibly related to bugid 11312,
reporting the spontaneous disabling of RTC events.)

Bug 11411 reported that changes to work around some ACPI event
issues broke wake-from-S5 handling, as used for DVR applications.
(They like to power off, then wake later to record programs.)

[ yakui.zhao@intel.com: add shutdown for PNP devices ] 
[ dbrownell@users.sourceforge.net: update comments ]

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/rtc-cmos.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- g26.orig/drivers/rtc/rtc-cmos.c	2008-08-23 14:27:19.000000000 -0700
+++ g26/drivers/rtc/rtc-cmos.c	2008-08-26 15:24:19.000000000 -0700
@@ -894,7 +894,6 @@ static void __exit cmos_do_remove(struct
 static int cmos_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	int		do_wake = device_may_wakeup(dev);
 	unsigned char	tmp;
 
 	/* only the alarm might be a wakeup event source */
@@ -903,7 +902,7 @@ static int cmos_suspend(struct device *d
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 		unsigned char	mask;
 
-		if (do_wake)
+		if (device_may_wakeup(dev))
 			mask = RTC_IRQMASK & ~RTC_AIE;
 		else
 			mask = RTC_IRQMASK;
@@ -933,6 +932,17 @@ static int cmos_suspend(struct device *d
 	return 0;
 }
 
+/* We want RTC alarms to wake us from e.g. ACPI G2/S5 "soft off", even
+ * after a detour through G3 "mechanical off", although the ACPI spec
+ * says wakeup should only work from G1/S4 "hibernate".  To most users,
+ * distinctions between S4 and S5 are pointless.  So when the hardware
+ * allows, don't draw that distinction.
+ */
+static inline int cmos_poweroff(struct device *dev)
+{
+	return cmos_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -983,6 +993,12 @@ static int cmos_resume(struct device *de
 #else
 #define	cmos_suspend	NULL
 #define	cmos_resume	NULL
+
+static inline int cmos_poweroff(struct device *dev)
+{
+	return -ENOSYS;
+}
+
 #endif
 
 /*----------------------------------------------------------------*/
@@ -1002,10 +1018,6 @@ static int cmos_resume(struct device *de
 static int __devinit
 cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	/* REVISIT paranoia argues for a shutdown notifier, since PNP
-	 * drivers can't provide shutdown() methods to disable IRQs.
-	 * Or better yet, fix PNP to allow those methods...
-	 */
 	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
@@ -1041,6 +1053,13 @@ static int cmos_pnp_resume(struct pnp_de
 #define	cmos_pnp_resume		NULL
 #endif
 
+static void cmos_pnp_shutdown(struct device *pdev)
+{
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
+		return;
+
+	cmos_do_shutdown();
+}
 
 static const struct pnp_device_id rtc_ids[] = {
 	{ .id = "PNP0b00", },
@@ -1060,6 +1079,10 @@ static struct pnp_driver cmos_pnp_driver
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.suspend	= cmos_pnp_suspend,
 	.resume		= cmos_pnp_resume,
+	.driver		= {
+		.name	  = (char *)driver_name,
+		.shutdown = cmos_pnp_shutdown,
+	}
 };
 
 #endif	/* CONFIG_PNP */
@@ -1085,6 +1108,9 @@ static int __exit cmos_platform_remove(s
 
 static void cmos_platform_shutdown(struct platform_device *pdev)
 {
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pdev->dev))
+		return;
+
 	cmos_do_shutdown();
 }
 
