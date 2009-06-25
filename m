Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZFYUqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZFYUqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZFYUp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:45:58 -0400
Received: from mail-pz0-f189.google.com ([209.85.222.189]:57033 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFYUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=u+3RvRrVv3isWUBvHBIj/exMAH67wUQkZY771Gr3CUv+A+yx0VTtWUy3CHhIqByIDT
         RsbIF9nYLt8zxdKYWa3We2RV4Jc5r2NaoP0ZSz3PsesChRHWER4apmOarMHQ4de15ebs
         3Fzov/R4y+NFk2iMx2OEG2DvZKwTa4Bz1piYU=
Subject: [PATCH] PCAP RTC driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PBFClipvosyOMbWXR+c9"
Date: Thu, 25 Jun 2009 17:45:49 -0300
Message-Id: <1245962749.10360.42.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PBFClipvosyOMbWXR+c9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

RTC driver for PCAP2 PMIC.

This patch was sent some time ago and acked by Alessandro, but we had to
change some stuff on the core driver and consequently on this driver
too, so I'm submitting it again for review (sorry).

Signed-off-by: guiming zhuo <gmzhuo@gmail.com>
Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/rtc/Kconfig    |    7 ++
 drivers/rtc/Makefile   |    1 +
 drivers/rtc/rtc-pcap.c |  222 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 230 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 81adbdb..a8e8846 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -759,4 +759,11 @@ config RTC_DRV_PS3
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ps3.
=20
+config RTC_DRV_PCAP
+	tristate "PCAP RTC"
+	depends on EZX_PCAP
+	help
+	  If you say Y here you will get support for the RTC found on
+	  the PCAP2 ASIC used on some Motorola phones.
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 3c0f2b2..450fede 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_RTC_DRV_MAX6900)	+=3D rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+=3D rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MV)	+=3D rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+=3D rtc-omap.o
+obj-$(CONFIG_RTC_DRV_PCAP)	+=3D rtc-pcap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+=3D rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+=3D rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PL030)	+=3D rtc-pl030.o
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
new file mode 100644
index 0000000..d8eca0d
--- /dev/null
+++ b/drivers/rtc/rtc-pcap.c
@@ -0,0 +1,222 @@
+/*
+ *  pcap rtc code for Motorola EZX phones
+ *
+ *  Copyright (c) 2008 guiming zhuo <gmzhuo@gmail.com>
+ *  Copyright (c) 2009 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ *  Based on Motorola's rtc.c Copyright (c) 2003-2005 Motorola
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mfd/ezx-pcap.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+struct pcap_rtc {
+	struct pcap_chip *pcap;
+	struct rtc_device *rtc;
+};
+
+static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
+{
+	struct pcap_rtc *pcap_rtc =3D _pcap_rtc;
+	unsigned long rtc_events =3D 0;
+
+	if (irq =3D=3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
+		rtc_events |=3D RTC_IRQF | RTC_UF;
+	else if (irq =3D=3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
+		rtc_events |=3D RTC_IRQF | RTC_AF;
+
+	rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
+	return IRQ_HANDLED;
+}
+
+static int pcap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm=
)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+	struct rtc_time *tm =3D &alrm->time;
+	unsigned long secs;
+	u32 tmp;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tmp);
+	secs =3D tmp & PCAP_RTC_TOD_MASK;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &tmp);
+	secs +=3D (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+
+	rtc_time_to_tm(secs, tm);
+
+	return 0;
+}
+
+static int pcap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+	struct rtc_time *tm =3D &alrm->time;
+	unsigned long secs;
+	u32 tmp;
+
+	rtc_tm_to_time(tm, &secs);
+
+	tmp =3D secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tmp);
+
+	tmp =3D secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, tmp);
+
+	return 0;
+}
+
+static int pcap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+	unsigned long secs;
+	u32 tmp;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TOD, &tmp);
+	secs =3D tmp & PCAP_RTC_TOD_MASK;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &tmp);
+	secs +=3D (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+
+	rtc_time_to_tm(secs, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int pcap_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+	u32 tmp;
+
+	tmp =3D secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tmp);
+
+	tmp =3D secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, tmp);
+
+	return 0;
+}
+
+static inline int pcap_rtc_irq_enable(struct device *dev, int pirq,
+							unsigned int en)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+
+	if (en)
+		enable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
+	else
+		disable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
+
+	return 0;
+}
+
+static int pcap_rtc_alarm_irq_enable(struct device *dev, unsigned int en)
+{
+	return pcap_rtc_irq_enable(dev, PCAP_IRQ_TODA, en);
+}
+
+static int pcap_rtc_update_irq_enable(struct device *dev, unsigned int en)
+{
+	return pcap_rtc_irq_enable(dev, PCAP_IRQ_1HZ, en);
+}
+
+static const struct rtc_class_ops pcap_rtc_ops =3D {
+	.read_time =3D pcap_rtc_read_time,
+	.read_alarm =3D pcap_rtc_read_alarm,
+	.set_alarm =3D pcap_rtc_set_alarm,
+	.set_mmss =3D pcap_rtc_set_mmss,
+	.alarm_irq_enable =3D pcap_rtc_alarm_irq_enable,
+	.update_irq_enable =3D pcap_rtc_update_irq_enable,
+};
+
+static int __devinit pcap_rtc_probe(struct platform_device *pdev)
+{
+	struct pcap_rtc *pcap_rtc;
+	int timer_irq, alarm_irq;
+	int err =3D -ENOMEM;
+
+	pcap_rtc =3D kmalloc(sizeof(struct pcap_rtc), GFP_KERNEL);
+	if (!pcap_rtc)
+		return err;
+
+	pcap_rtc->pcap =3D platform_get_drvdata(pdev);
+
+	pcap_rtc->rtc =3D rtc_device_register("pcap", &pdev->dev,
+				  &pcap_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pcap_rtc->rtc)) {
+		err =3D PTR_ERR(pcap_rtc->rtc);
+		goto fail_rtc;
+	}
+
+	platform_set_drvdata(pdev, pcap_rtc);
+
+	timer_irq =3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
+	alarm_irq =3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
+
+	err =3D request_irq(timer_irq, pcap_rtc_irq, 0, "RTC Timer", pcap_rtc);
+	if (err)
+		goto fail_timer;
+
+	err =3D request_irq(alarm_irq, pcap_rtc_irq, 0, "RTC Alarm", pcap_rtc);
+	if (err)
+		goto fail_alarm;
+
+	return 0;
+fail_alarm:
+	free_irq(timer_irq, pcap_rtc);
+fail_timer:
+	rtc_device_unregister(pcap_rtc->rtc);
+fail_rtc:
+	kfree(pcap_rtc);
+	return err;
+}
+
+static int __devexit pcap_rtc_remove(struct platform_device *pdev)
+{
+	struct pcap_rtc *pcap_rtc =3D platform_get_drvdata(pdev);
+
+	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ), pcap_rtc);
+	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA), pcap_rtc);
+	rtc_device_unregister(pcap_rtc->rtc);
+	kfree(pcap_rtc);
+
+	return 0;
+}
+
+static struct platform_driver pcap_rtc_driver =3D {
+	.remove =3D __devexit_p(pcap_rtc_remove),
+	.driver =3D {
+		.name  =3D "pcap-rtc",
+		.owner =3D THIS_MODULE,
+	},
+};
+
+static int __init rtc_pcap_init(void)
+{
+	return platform_driver_probe(&pcap_rtc_driver, pcap_rtc_probe);
+}
+
+static void __exit rtc_pcap_exit(void)
+{
+	platform_driver_unregister(&pcap_rtc_driver);
+}
+
+module_init(rtc_pcap_init);
+module_exit(rtc_pcap_exit);
+
+MODULE_DESCRIPTION("Motorola pcap rtc driver");
+MODULE_AUTHOR("guiming zhuo <gmzhuo@gmail.com>");
+MODULE_LICENSE("GPL");
--=20
tg: (3ef3153..) ezx/pcap_rtc (depends on: ezx/local/pcap)

--=20
Daniel Ribeiro

--=-PBFClipvosyOMbWXR+c9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpD4f0ACgkQw3OYl0G0liT5LwCfTthYZACyS27XUVQI+GATgKbu
AZgAnRLIq+hsycU+BxAZK8JMyl3Farh2
=B+Bp
-----END PGP SIGNATURE-----

--=-PBFClipvosyOMbWXR+c9--

