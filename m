Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYJ3T4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYJ3T4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYJ3T4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:56:34 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:3506 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752386AbYJ3T4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:56:34 -0400
Date: Thu, 30 Oct 2008 22:56:32 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/3] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081030195632.GB13640@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function sets the OCR mask bits according to provided voltage
ranges. Will be used by the mmc_spi OpenFirmware bindings.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/core/core.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/core.h |    3 ++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..d4afae8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/leds.h>
 #include <linux/scatterlist.h>
+#include <linux/log2.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -444,6 +445,60 @@ void mmc_set_bus_width(struct mmc_host *host, unsigned int width)
 	mmc_set_ios(host);
 }
 
+static int mmc_vdd_to_ocrbit(int vdd)
+{
+	int bit;
+	const int max_bit = ilog2(MMC_VDD_35_36);
+
+	if (vdd < 1650 || vdd > 3600)
+		return -EINVAL;
+
+	if (vdd >= 1650 && vdd <= 1950)
+		return ilog2(MMC_VDD_165_195);
+
+	/* base 2000 mV, step 100 mV, bit's base 8 */
+	bit = (vdd - 2000) / 100 + 8;
+	if (bit > max_bit)
+		return max_bit;
+	return bit;
+}
+
+/**
+ * mmc_vddrange_to_ocrmask - Convert a voltage range to the OCR mask
+ * @vdd_min:	minimum voltage value (mV)
+ * @vdd_max:	maximum voltage value (mV)
+ * @mask:	pointer to the mask
+ *
+ * This function sets the OCR mask bits according to the provided @vdd_min
+ * and @vdd_max values.
+ *
+ * NOTE: You _must_ set the mask value to 0 before calling this function the
+ *       first time. This is done so that you can call this function several
+ *       times to set OCR mask for discontinuous voltage ranges.
+ *
+ * The function returns 0 on success and a negative errno value when
+ * a conversion is not possible.
+ */
+int mmc_vddrange_to_ocrmask(int vdd_min, int vdd_max, unsigned int *mask)
+{
+	if (vdd_max < vdd_min)
+		return -EINVAL;
+
+	vdd_max = mmc_vdd_to_ocrbit(vdd_max);
+	if (vdd_max < 0)
+		return -EINVAL;
+
+	vdd_min = mmc_vdd_to_ocrbit(vdd_min);
+	if (vdd_min < 0)
+		return -EINVAL;
+
+	/* fill the mask, from max bit to min bit */
+	while (vdd_max >= vdd_min)
+		*mask |= 1 << vdd_max--;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
+
 /*
  * Mask off any voltages we don't support and select
  * the lowest voltage
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 143cebf..3b139b0 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -151,4 +151,7 @@ static inline void mmc_claim_host(struct mmc_host *host)
 	__mmc_claim_host(host, NULL);
 }
 
+extern int mmc_vddrange_to_ocrmask(int vdd_min, int vdd_max,
+				   unsigned int *mask);
+
 #endif
-- 
1.5.6.3

