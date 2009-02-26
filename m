Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZBZWk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZBZWk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZBZWkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:40:09 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:37727 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754974AbZBZWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:40:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RH2ifupBGngH/0B6QeGouVmdGjIXUk2ipgmxJZHuixGqyRl03KpybXUhfHST9eFHMUdOAUZneWJg29yMcmkQK5L+XIXJvdYy+VvgW69dwLXH64iUdxCH6/am2KCHHRL+1OsXEWnQaf2bEnnzz75bjLxazRPNZHL7iChmJmpoEBI=  ;
X-YMail-OSG: 4pMANzsVM1mAYTU1YmhUXQmpXwayQIT.GMNstRtku46maWmEu9Tjb352CH0ms_C0KuX1dyXjGxBgtJl7cukhNf_538dxpCUMYDaw9tgFfFA3OS4yLAAajNjhPVe_OqjLjF9u6DibsLTHLGirhffx7C9jQZ2Lsrx9bOBLN2mscRj4Qjm34pCZu8ZMYPYxMFIEjg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Date: Thu, 26 Feb 2009 13:48:30 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <20090226202055.GE8595@sirena.org.uk> <200902261312.42720.david-b@pacbell.net>
In-Reply-To: <200902261312.42720.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261348.30617.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add optional glue between MMC and regulator stacks, using a new
regulator interface to learn what voltages are available.

This is intended to be selected and driven by MMC host adapters.
It only handles reusable parts of the regulator-to-MMC glue; the
adapter drivers will have access to details that affect how this
is used.  Examples include when to use multiple voltage rails or
configure (internal or external) level shifters.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Changes from previous version:  adapter must select this, and
callers now pass in the regulator.  mmc_regulator_set_ocr()
is still not tested, mmc_regulator_get_ocrmask() passed sanity
testing.

Pierre:  Mark may have a need for this soonish.  The omap_hsmmc
code will want it at some point.

 drivers/mmc/core/Kconfig |    7 +++
 drivers/mmc/core/core.c  |   84 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    5 ++
 3 files changed, 96 insertions(+)

--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -14,3 +14,10 @@ config MMC_UNSAFE_RESUME
 	  This option is usually just for embedded systems which use
 	  a MMC/SD card for rootfs. Most people should say N here.
 
+config MMC_REGULATOR
+	bool
+	depends on REGULATOR
+	help
+	  Select this if your MMC host adapter driver wants helper
+	  utilities for accessing power rails.
+
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -21,6 +21,7 @@
 #include <linux/leds.h>
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
+#include <linux/regulator/consumer.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -523,6 +524,89 @@ u32 mmc_vddrange_to_ocrmask(int vdd_min,
 }
 EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
 
+#ifdef CONFIG_MMC_REGULATOR
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
+ * @host: mmc host whose supply voltage will be changed
+ * @supply: regulator to use
+ *
+ * MMC host drivers may use this to enable or disable a regulator using
+ * a particular supply voltage.  This would normally be called from the
+ * set_ios() method.
+ */
+int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply)
+{
+	int			result = 0;
+	int			min_mV, max_mV;
+	int			enabled;
+
+	enabled = regulator_is_enabled(supply);
+	if (enabled < 0)
+		return enabled;
+
+	if (host->ios.vdd) {
+		int		tmp;
+
+		tmp = host->ios.vdd - ilog2(MMC_VDD_165_195);
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
+int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply);
+
 #endif
 
