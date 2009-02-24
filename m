Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZBXHZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZBXHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZBXHZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:25:16 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:45949 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751803AbZBXHZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:25:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Qca07+bwdfltfKoIAVdD+Lku3E4I5X9lQ397z2WSFgYiSSLZktZDoNBI1izueNqRmzHgkUL/w5WcSWV+84jO9Mi07esq16LOFPazxh/qOSp+4RMTAWqxoJopltAj1YUWSNqAyY619RCNkwwQ2GLIhqLpBf/zPi0ulzUxZ9jTy8M=  ;
X-YMail-OSG: GdoAzxoVM1kUTEz0jfAZrUXML8Scy.Uyy0LOBTP179J4IXdQDnPvyLjoHsdOKaySuM.ey0Jz0Uyf.yqe2TTQQaRSQVxelrQIx4S0pfp8_Sf1Fc4H6YhyfchEZqTlYKYKMeWBox_dlh4XYx01V87iNph9lcIJSW4mSR0y0slEOrZl0IAxrUcqcawm73EQ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 23 Feb 2009 23:25:10 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <200902081037.06645.david-b@pacbell.net> <20090224005536.GC3601@sirena.org.uk> <200902231822.27422.david-b@pacbell.net>
In-Reply-To: <200902231822.27422.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902232325.10447.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, David Brownell wrote:
> > There's also fun and games to be had with accuracy once you 
> > start looking too closely at the discrete voltages.
> 
> Yes; the patch I sent is explicitly making those available.
> 
> But I ignored issues like "+/- 3% accurate output" for LDOs
> (or switchers) ... if anyone really needs to address them,
> patches will be needed.  For now I only care that a 3.1 Volt
> output can match both MMC_VDD_30_31 and MMC_VDD_31_32! ;)

And -- for kicks -- here's one notion of what it might look
like to have the MMC stack support the regulator framework.

- Dave


=================
Prototype glue between MMC and regulator stacks ... compiles,
and mmc_regulator_get_ocrmask() passed sanity testing.

NOTES:

 - The MMC core does't call mmc_regulator_set_ocr() because hosts
   may need to do that in conjunction with updating I/O voltage.

   Case in point, MMC1 on omap_hsmmc ... where the host driver
   must update MMC1_HCTL.SDVS and PBIAS registers in addition to
   the regulator, supporting 1.8V or 3.0V voltage ranges.  (MMC2
   and MMC3 use external level shifting for Vdd != 1.8V.)

   Likewise, using eMMC "managed NAND" solutions, powerup includes
   not both Vcc ("vdd" to Linux, e.g. 3.0V) and an I/O interface
   rail VccQ (e.g. 1.8V).  The JEDEC spec for eMMC requires VccQ
   powerup after Vcc, and powerdown before it.

 - The "vdd" supply name isn't fixed, since platforms may need
   to use more than one I/O supply.

   Case in point, MMC1 on omap_hsmmc (again) ... where a second
   supply is needed to kick in 8-bit I/O using DAT4..DAT7 signals.
   That would not be handled quite like VccQ, since it's only
   used for 8-bit I/O widths (MMCplus cards, some eMMC, etc).
 
---
 drivers/mmc/core/Kconfig |    8 +++
 drivers/mmc/core/core.c  |   98 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    3 +
 3 files changed, 109 insertions(+)

--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -14,3 +14,11 @@ config MMC_UNSAFE_RESUME
 	  This option is usually just for embedded systems which use
 	  a MMC/SD card for rootfs. Most people should say N here.
 
+config MMC_REGULATOR
+	bool
+	depends on REGULATOR
+	default y
+	help
+	  Select this to provide some helper utilities to access the
+	  "vdd" (card) voltage supply associated with an MMC/SD slot.
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
@@ -523,6 +524,103 @@ u32 mmc_vddrange_to_ocrmask(int vdd_min,
 }
 EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
 
+#ifdef CONFIG_MMC_REGULATOR
+
+/**
+ * mmc_regulator_get_ocrmask - return mask of supported voltages
+ * @host: mmc host whose supply will be consulted
+ * @supply: supply voltage to use; "vdd" if NULL
+ *
+ * This returns either a negative errno, or a mask of voltages
+ * that can be provided to MMC/SD/SDIO devices using the specified
+ * host's "vdd" supply.
+ */
+int mmc_regulator_get_ocrmask(struct mmc_host *host, const char *supply)
+{
+	int			result = 0;
+	struct regulator	*reg;
+	int			count;
+	int			i;
+
+	reg = regulator_get(host->parent, supply ? : "vdd");
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+	count = regulator_count_voltages(reg);
+	if (count < 0) {
+		result = count;
+		goto done;
+	}
+
+	for (i = 0; i < count; i++) {
+		int		vdd_uV;
+		int		vdd_mV;
+
+		vdd_uV = regulator_list_voltage(reg, i);
+		if (vdd_uV <= 0)
+			continue;
+
+		vdd_mV = vdd_uV / 1000;
+		result |= mmc_vddrange_to_ocrmask(vdd_mV, vdd_mV);
+	}
+
+done:
+	regulator_put(reg);
+	return result;
+}
+EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
+
+/**
+ * mmc_regulator_set_ocr - set regulator to match host->ios voltage
+ * @host: mmc host whose supply voltage will be changed
+ * @supply: supply voltage to use; "vdd" if NULL
+ *
+ * MMC host drivers may use this to enable or disable a regulator
+ * using a particular supply voltage.  This would normally be
+ * called from the set_ios() method, possibly as part of updating
+ * digital interfaces to support that voltage.
+ */
+int mmc_regulator_set_ocr(struct mmc_host *host, const char *supply)
+{
+	int			result = 0;
+	struct regulator	*reg;
+	int			min_mV, max_mV;
+	int			enabled;
+
+	reg = regulator_get(host->parent, supply ? : "vdd");
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+	enabled = regulator_is_enabled(reg);
+	if (WARN(enabled < 0, "%s: regulator_is_enabled --> %d\n",
+			mmc_hostname(host), enabled))
+		enabled = !host->ios.vdd;
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
+		result = regulator_set_voltage(reg, min_mV * 1000, max_mV * 1000);
+		if (result == 0 && !enabled)
+			result = regulator_enable(reg);
+	} else if (enabled) {
+		result = regulator_disable(reg);
+	}
+
+	regulator_put(reg);
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
@@ -192,5 +192,8 @@ static inline void mmc_signal_sdio_irq(s
 	wake_up_process(host->sdio_irq_thread);
 }
 
+int mmc_regulator_get_ocrmask(struct mmc_host *host, const char *supply);
+int mmc_regulator_set_ocr(struct mmc_host *host, const char *supply);
+
 #endif
 
