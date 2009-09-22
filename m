Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZIVSPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZIVSPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZIVSPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:15:30 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:60174 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZIVSP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:15:29 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: rtc_cmos oops in cmos_rtc_ioctl
Date: Tue, 22 Sep 2009 15:15:26 -0300
User-Agent: KMail/1.12.1 (Linux/2.6.31-desktop-2mnb; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       rtc-linux@googlegroups.com
References: <200909211553.38409.herton@mandriva.com.br> <20090922124041.62abee25@i1501.lan.towertech.it>
In-Reply-To: <20090922124041.62abee25@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909221515.26777.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter 22 Set 2009, às 07:40:41, Alessandro Zummo escreveu:
> On Mon, 21 Sep 2009 15:53:38 -0300
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > The problem here is the rtc char device being created early and acessible before
> > rtc_cmos does dev_set_drvdata(dev, &cmos_rtc), so dev_get_drvdata in
> > cmos_rtc_ioctl can return null, like in this example where hwclock is run right
> > after char device creation that triggers the udev rule:
> > ACTION=="add", SUBSYSTEM=="rtc", RUN+="/sbin/hwclock --hctosys --rtc=/dev/%k"
> > And makes the oops possible, in this case hwclock looks to open and close the
> > device fast enough.
> 
>  right. the best option would be to use the new irq api that was
>  introduced after the creation of rtc_cmos (and thus remove the whole
>  ioctl routine).
> 
>  [...]

Something like this?:

>From a94365843ab40a1904c4bc244af4e551f2f2aca9 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Tue, 22 Sep 2009 13:46:00 -0300
Subject: [PATCH] rtc-cmos: convert RTC_AIE/RTC_UIE to rtc irq API

Drop ioctl function that handles RTC_AIE/RTC_UIE, and use instead the
rtc subsystem API (alarm_irq_enable/update_irq_enable callbacks).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/rtc/rtc-cmos.c |   75 ++++++++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f7a4701..a472242 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -420,49 +420,43 @@ static int cmos_irq_set_state(struct device *dev, int enabled)
 	return 0;
 }
 
-#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
-
-static int
-cmos_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned long	flags;
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-	case RTC_UIE_OFF:
-	case RTC_UIE_ON:
-		if (!is_valid_irq(cmos->irq))
-			return -EINVAL;
-		break;
-	/* PIE ON/OFF is handled by cmos_irq_set_state() */
-	default:
-		return -ENOIOCTLCMD;
-	}
+	if (!is_valid_irq(cmos->irq))
+		return -EINVAL;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm off */
-		cmos_irq_disable(cmos, RTC_AIE);
-		break;
-	case RTC_AIE_ON:	/* alarm on */
+
+	if (enabled)
 		cmos_irq_enable(cmos, RTC_AIE);
-		break;
-	case RTC_UIE_OFF:	/* update off */
-		cmos_irq_disable(cmos, RTC_UIE);
-		break;
-	case RTC_UIE_ON:	/* update on */
-		cmos_irq_enable(cmos, RTC_UIE);
-		break;
-	}
+	else
+		cmos_irq_disable(cmos, RTC_AIE);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
 
-#else
-#define	cmos_rtc_ioctl	NULL
-#endif
+static int cmos_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+	unsigned long	flags;
+
+	if (!is_valid_irq(cmos->irq))
+		return -EINVAL;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+
+	if (enabled)
+		cmos_irq_enable(cmos, RTC_UIE);
+	else
+		cmos_irq_disable(cmos, RTC_UIE);
+
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return 0;
+}
 
 #if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
 
@@ -503,14 +497,15 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
 #endif
 
 static const struct rtc_class_ops cmos_rtc_ops = {
-	.ioctl		= cmos_rtc_ioctl,
-	.read_time	= cmos_read_time,
-	.set_time	= cmos_set_time,
-	.read_alarm	= cmos_read_alarm,
-	.set_alarm	= cmos_set_alarm,
-	.proc		= cmos_procfs,
-	.irq_set_freq	= cmos_irq_set_freq,
-	.irq_set_state	= cmos_irq_set_state,
+	.read_time		= cmos_read_time,
+	.set_time		= cmos_set_time,
+	.read_alarm		= cmos_read_alarm,
+	.set_alarm		= cmos_set_alarm,
+	.proc			= cmos_procfs,
+	.irq_set_freq		= cmos_irq_set_freq,
+	.irq_set_state		= cmos_irq_set_state,
+	.alarm_irq_enable	= cmos_alarm_irq_enable,
+	.update_irq_enable	= cmos_update_irq_enable,
 };
 
 /*----------------------------------------------------------------*/
-- 
1.6.4.4

Still, couldn't an oops still trigger with this with dev_set_drvdata after
rtc_device_register? Lets say, a small test program like this:
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/rtc.h>

int main(int argc, char **argv)
{
        int fd;
        struct rtc_time rtc_tm;

        fd = open("/dev/rtc0", O_RDONLY);
        ioctl(fd, RTC_AIE_ON, &rtc_tm);
        ioctl(fd, RTC_UIE_ON, &rtc_tm);
        close(fd);
}
Compiled and run with similar udev rule. It's very unlikely, and I couldn't
get an oops anymore unless I moved dev_set_drvdata down in cmos_do_probe in
my test machine, but should be a possibility?

> 
> > But I saw another issue: looks it could be possible that as cmos_rtc_ioctl
> > (ioctl) can be run before rtc_device_register returns, the following call chain
> > could happen in current code:
> > cmos_rtc_ioctl->cmos_irq_{en,dis}able->cmos_checkintr->rtc_update_irq
> > rtc_update_irq uses cmos->rtc, which is set only at return of
> > rtc_device_register, and here we may have another problem... is it
> > possible?
> 
>  this shouldn't happen, irqs are enabled only after everything
>  has been setup to handle them.
> 

--
[]'s
Herton
