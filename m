Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZCDDSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZCDDSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZCDDSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:18:12 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:46638 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750760AbZCDDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:18:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vF6odWGz762RSJWDdUQfA7AukA9+yvHlxp+sBmfWNDcMX0lvS7htOe20pqCDiQsE4kiWwpbP9X23Ug52S3VYTZBVwRDglCgznMH/Rg93d3nvEusX7fLqcdzQCDnoZ4UkZa1S/QxZleY/bPB3QEMCPH3jw4BjhP2w2QVYk/rqLYw=  ;
X-YMail-OSG: 8q9JALUVM1m8JFUQxxIMZ719KY2wV3SR3qasdkfl4SocAdBAq4OEYxxyRbN3WHMw0uRDbh2wj8j1fiZzM5q8CUqiYplPFOKqcmDlWEfaphdFOERXamqWe96L_4UG_btgOuRejIhCbU82ftWNX3sOwYJtiRhNK8XmMDPz_XIX9rg6Ym8scCXaABGnKogqob3V6799b9T87BXATJPaLBPfa31pT.5XWyEwcbpMXg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Date: Tue, 3 Mar 2009 19:18:06 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <20090302224040.5e7ab0b2@mjolnir.ossman.eu> <200903021400.50201.david-b@pacbell.net>
In-Reply-To: <200903021400.50201.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903031918.07443.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Glue between MMC and regulator stacks ... compiles, and
mmc_regulator_get_ocrmask() passed sanity testing.

These calls are intended to be used by MMC host adapters
using at least one regulator per host.  Examples include
slots with regulators supporting multiple voltages and
ones using multiple voltage rails (e.g. DAT4..DAT7 using a
separate supply, or a split rail chip like certain SDIO
WLAN or eMMC solutions).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Changes from previous version:  automagically available if the
regulator calls are available; callers now pass in host->ios.vdd.
mmc_regulator_set_ocr() still untested.

 drivers/mmc/core/core.c  |   86 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    5 ++
 2 files changed, 91 insertions(+)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -21,6 +21,7 @@
 #include <linux/leds.h>
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
+#include <linux/regulator/consumer.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -523,6 +524,91 @@ u32 mmc_vddrange_to_ocrmask(int vdd_min,
 }
 EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
 
+#ifdef CONFIG_REGULATOR
+
+/**
+ * mmc_regulator_get_ocrmask - return mask of supported voltages
+ * @host: mmc host whose supply will be consulted
+ * @supply: regulator to use
+ *
+ * This returns either a negative errno, or a mask of voltages that
+ * can be provided to MMC/SD/SDIO devices using the specified voltage
+ * regulator.  This would normally be called before registering the
+ * MMC host adapter.
+ */
+int mmc_regulator_get_ocrmask(struct mmc_host *host, struct regulator *supply)
+{
+	int			result = 0;
+	int			count;
+	int			i;
+
+	count = regulator_count_voltages(supply);
+	if (count < 0)
+		return count;
+
+	for (i = 0; i < count; i++) {
+		int		vdd_uV;
+		int		vdd_mV;
+
+		vdd_uV = regulator_list_voltage(supply, i);
+		if (vdd_uV <= 0)
+			continue;
+
+		vdd_mV = vdd_uV / 1000;
+		result |= mmc_vddrange_to_ocrmask(vdd_mV, vdd_mV);
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
+
+/**
+ * mmc_regulator_set_ocr - set regulator to match host->ios voltage
+ * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
+ * @supply: regulator to use
+ *
+ * Returns zero on success, else negative errno.
+ *
+ * MMC host drivers may use this to enable or disable a regulator using
+ * a particular supply voltage.  This would normally be called from the
+ * set_ios() method.
+ */
+int mmc_regulator_set_ocr(unsigned short vdd_bit, struct regulator *supply)
+{
+	int			result = 0;
+	int			min_mV, max_mV;
+	int			enabled;
+
+	enabled = regulator_is_enabled(supply);
+	if (enabled < 0)
+		return enabled;
+
+	if (vdd_bit) {
+		int		tmp;
+
+		tmp = vdd_bit - ilog2(MMC_VDD_165_195);
+		if (tmp == 0) {
+			min_mV = 1650;
+			max_mV = 1950;
+		} else {
+			min_mV = 2000 + tmp * 100;
+			max_mV = min_mV + 100;
+		}
+
+		result = regulator_set_voltage(supply,
+				min_mV * 1000, max_mV * 1000);
+		if (result == 0 && !enabled)
+			result = regulator_enable(supply);
+	} else if (enabled) {
+		result = regulator_disable(supply);
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(mmc_regulator_set_ocr);
+
+#endif
+
 /*
  * Mask off any voltages we don't support and select
  * the lowest voltage
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -192,5 +192,10 @@ static inline void mmc_signal_sdio_irq(s
 	wake_up_process(host->sdio_irq_thread);
 }
 
+struct regulator;
+
+int mmc_regulator_get_ocrmask(struct mmc_host *host, struct regulator *supply);
+int mmc_regulator_set_ocr(unsigned short vdd_bit, struct regulator *supply);
+
 #endif
 
