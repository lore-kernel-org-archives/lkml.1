Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYKZTy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYKZTy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYKZTyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:54:21 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:25341 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbYKZTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:54:20 -0500
Date: Wed, 26 Nov 2008 22:54:17 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081126195417.GA26264@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru> <20081030195632.GB13640@oksana.dev.rtsoft.ru> <20081108215537.12cdf5f6@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20081108215537.12cdf5f6@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function sets the OCR mask bits according to provided voltage
ranges. Will be used by the mmc_spi OpenFirmware bindings.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Hi Pierre,

Sorry for the delay.

On Sat, Nov 08, 2008 at 09:55:37PM +0100, Pierre Ossman wrote:
> On Thu, 30 Oct 2008 22:56:32 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > +/**
> > + * mmc_vddrange_to_ocrmask - Convert a voltage range to the OCR mask
> > + * @vdd_min:	minimum voltage value (mV)
> > + * @vdd_max:	maximum voltage value (mV)
> > + * @mask:	pointer to the mask
> > + *
> 
> Why the pointer? Why not let the caller handle the aggregation? That
> would be a lot safer.

Yeah, makes sense. Now the function returns OCR mask, or 0 on error.

> > +	/* fill the mask, from max bit to min bit */
> > +	while (vdd_max >= vdd_min)
> > +		*mask |= 1 << vdd_max--;
> > +	return 0;
> 
> Many cards get a bit uppity with a single bit set. If possible, try to
> make this function set two bits when the voltage is right on the
> boundary (e.g. 3.3V).

Something like this patch (the boundary cases are documented now)?

p.s. If the patch is OK I'll respin the whole patchset.

 drivers/mmc/core/core.c  |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/core.h |    2 +
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..1673765 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/leds.h>
 #include <linux/scatterlist.h>
+#include <linux/log2.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -444,6 +445,80 @@ void mmc_set_bus_width(struct mmc_host *host, unsigned int width)
 	mmc_set_ios(host);
 }
 
+/**
+ * mmc_vdd_to_ocrbitnum - Convert a voltage to the OCR bit number
+ * @vdd:	voltage (mV)
+ * @low_bits:	prefer low bits in boundary cases
+ *
+ * This function returns the OCR bit number according to the provided @vdd
+ * value. If conversion is not possible a negative errno value returned.
+ *
+ * Depending on the @low_bits flag the function prefers low or high OCR bits
+ * on boundary voltages. For example,
+ * with @low_bits = true, 3300 mV translates to ilog2(MMC_VDD_32_33);
+ * with @low_bits = false, 3300 mV translates to ilog2(MMC_VDD_33_34);
+ *
+ * Any value in the [1951:1999] range translates to the ilog2(MMC_VDD_20_21).
+ */
+static int mmc_vdd_to_ocrbitnum(int vdd, bool low_bits)
+{
+	const int max_bit = ilog2(MMC_VDD_35_36);
+	int bit;
+
+	if (vdd < 1650 || vdd > 3600)
+		return -EINVAL;
+
+	if (vdd >= 1650 && vdd <= 1950)
+		return ilog2(MMC_VDD_165_195);
+
+	if (low_bits)
+		vdd -= 1;
+
+	/* Base 2000 mV, step 100 mV, bit's base 8. */
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
+ *
+ * This function returns the OCR mask bits according to the provided @vdd_min
+ * and @vdd_max values. If conversion is not possible the function returns 0.
+ *
+ * Notes wrt boundary cases:
+ * This function sets the OCR bits for all boundary voltages, for example
+ * [3300:3400] range is translated to MMC_VDD_32_33 | MMC_VDD_33_34 |
+ * MMC_VDD_34_35 mask.
+ */
+u32 mmc_vddrange_to_ocrmask(int vdd_min, int vdd_max)
+{
+	u32 mask = 0;
+
+	if (vdd_max < vdd_min)
+		return 0;
+
+	/* Prefer high bits for the boundary vdd_max values. */
+	vdd_max = mmc_vdd_to_ocrbitnum(vdd_max, false);
+	if (vdd_max < 0)
+		return 0;
+
+	/* Prefer low bits for the boundary vdd_min values. */
+	vdd_min = mmc_vdd_to_ocrbitnum(vdd_min, true);
+	if (vdd_min < 0)
+		return 0;
+
+	/* Fill the mask, from max bit to min bit. */
+	while (vdd_max >= vdd_min)
+		mask |= 1 << vdd_max--;
+
+	return mask;
+}
+EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
+
 /*
  * Mask off any voltages we don't support and select
  * the lowest voltage
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 143cebf..7ac8b50 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -151,4 +151,6 @@ static inline void mmc_claim_host(struct mmc_host *host)
 	__mmc_claim_host(host, NULL);
 }
 
+extern u32 mmc_vddrange_to_ocrmask(int vdd_min, int vdd_max);
+
 #endif
-- 
1.5.6.5

