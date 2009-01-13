Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZAMXlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZAMXlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbZAMXkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:40:19 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:26100 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558AbZAMXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=olR4eTnopDoCztlmF72tsCd9mVk5X+VLZIDzfRRRUl7Fy2kw4SZ2RR7d9/wYFe/yHz
         xixRoP7dlAC9+nrs9cqjmCjK+4/614rM5YsHbeDOyoZO21MJ8mpQnj2eC4tODGosIrZo
         qhUAV0oX3TQb4/cOkxfi7tbycaxZWmhXkAX9I=
From: Nelson <arhuaco@freaks-unidos.net>
Subject: [PATCH 4/5] Add mean filter
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, andy@openmoko.com
Date: Tue, 13 Jan 2009 18:40:03 -0500
Message-ID: <20090113234003.26361.93732.stgit@fugue.noexisteestedominiotanlargo.biz>
In-Reply-To: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Castillo <arhuaco@freaks-unidos.net>

This filter works well if the input data is already good quality,
reducing sample jitter when the stylus is still, or moving
very slowly, without introducing abrupt transitions or reducing
ability to follow larger movements. Check the comments for a
better description of what this filter does.

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
---

 drivers/input/touchscreen/Kconfig          |    8 +
 drivers/input/touchscreen/Makefile         |    1 
 drivers/input/touchscreen/ts_filter_mean.c |  172 ++++++++++++++++++++++++++++
 include/linux/ts_filter_mean.h             |   34 ++++++
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/ts_filter_mean.c
 create mode 100644 include/linux/ts_filter_mean.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 5c84858..3f725d4 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -37,6 +37,14 @@ config TOUCHSCREEN_FILTER_MEDIAN
 	  Say Y here if you want to use the Median touchscreen filter, it's
 	  highly effective if you data is noisy with occasional excursions.
 
+config TOUCHSCREEN_FILTER_MEAN
+	bool "Mean Average Touchscreen Filter"
+	depends on INPUT_TOUCHSCREEN && TOUCHSCREEN_FILTER
+	default Y
+	help
+	  Say Y here if you want to use the Mean touchscreen filter, it
+	  can further improve decent quality data by removing jitter
+
 endif
 
 config TOUCHSCREEN_ADS7846
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index e67c334..84651c2 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_GROUP)	+= ts_filter_group.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_MEDIAN)	+= ts_filter_median.o
+obj-$(CONFIG_TOUCHSCREEN_FILTER_MEAN)	+= ts_filter_mean.o
diff --git a/drivers/input/touchscreen/ts_filter_mean.c b/drivers/input/touchscreen/ts_filter_mean.c
new file mode 100644
index 0000000..34ac123
--- /dev/null
+++ b/drivers/input/touchscreen/ts_filter_mean.c
@@ -0,0 +1,172 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Copyright (c) 2008 Andy Green <andy@openmoko.com>
+ *
+ *
+ * Mean has no effect if the samples are changing by more that the
+ * threshold set by averaging_threshold in the configuration.
+ *
+ * However while samples come in that don't go outside this threshold from
+ * the last reported sample, Mean replaces the samples with a simple mean
+ * of a configurable number of samples (set by bits_filter_length in config,
+ * which is 2^n, so 5 there makes 32 sample averaging).
+ *
+ * Mean works well if the input data is already good quality, reducing + / - 1
+ * sample jitter when the stylus is still, or moving very slowly, without
+ * introducing abrupt transitions or reducing ability to follow larger
+ * movements.  If you set the threshold higher than the dynamic range of the
+ * coordinates, you can just use it as a simple mean average.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/ts_filter_mean.h>
+
+static void ts_filter_mean_clear_internal(struct ts_filter *tsf)
+{
+	struct ts_filter_mean *tsfs = (struct ts_filter_mean *)tsf;
+	int n;
+
+	for (n = 0; n < tsfs->tsf.count_coords; n++) {
+		tsfs->fhead[n] = 0;
+		tsfs->ftail[n] = 0;
+		tsfs->lowpass[n] = 0;
+	}
+}
+
+static void ts_filter_mean_clear(struct ts_filter *tsf)
+{
+	ts_filter_mean_clear_internal(tsf);
+
+	if (tsf->next) /* chain */
+		(tsf->next->api->clear)(tsf->next);
+}
+
+static struct ts_filter *ts_filter_mean_create(struct platform_device *pdev,
+					       void *config, int count_coords)
+{
+	int *p;
+	int n;
+	struct ts_filter_mean *tsfs = kzalloc(
+				  sizeof(struct ts_filter_mean), GFP_KERNEL);
+
+	if (!tsfs)
+		return NULL;
+
+	BUG_ON((count_coords < 1) || (count_coords > MAX_TS_FILTER_COORDS));
+	tsfs->tsf.count_coords = count_coords;
+
+	tsfs->config = (struct ts_filter_mean_configuration *)config;
+
+	tsfs->config->extent = 1 << tsfs->config->bits_filter_length;
+	BUG_ON((tsfs->config->extent > 256) || (!tsfs->config->extent));
+
+	p = kmalloc(tsfs->config->extent * sizeof(int) * count_coords,
+								    GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	for (n = 0; n < count_coords; n++) {
+		tsfs->fifo[n] = p;
+		p += tsfs->config->extent;
+	}
+
+	if (!tsfs->config->averaging_threshold)
+		tsfs->config->averaging_threshold = 0xffff; /* always active */
+
+	ts_filter_mean_clear_internal(&tsfs->tsf);
+
+	printk(KERN_INFO"  Created Mean ts filter len %d depth %d thresh %d\n",
+	       tsfs->config->extent, count_coords,
+	       tsfs->config->averaging_threshold);
+
+	return &tsfs->tsf;
+}
+
+static void ts_filter_mean_destroy(struct platform_device *pdev,
+				   struct ts_filter *tsf)
+{
+	struct ts_filter_mean *tsfs = (struct ts_filter_mean *)tsf;
+
+	kfree(tsfs->fifo[0]); /* first guy has pointer from kmalloc */
+	kfree(tsf);
+}
+
+static void ts_filter_mean_scale(struct ts_filter *tsf, int *coords)
+{
+	if (tsf->next) /* chain */
+		(tsf->next->api->scale)(tsf->next, coords);
+}
+
+/* give us the raw sample data in x and y, and if we return 1 then you can
+ * get a filtered coordinate from tsm->x and tsm->y: if we return 0 you didn't
+ * fill the filter with samples yet.
+ */
+
+static int ts_filter_mean_process(struct ts_filter *tsf, int *coords)
+{
+	struct ts_filter_mean *tsfs = (struct ts_filter_mean *)tsf;
+	int n;
+	int len;
+
+	for (n = 0; n < tsf->count_coords; n++) {
+
+		/* has he moved far enough away that we should abandon current
+		 * low pass filtering state?
+		 */
+		if ((coords[n] < (tsfs->reported[n] -
+					  tsfs->config->averaging_threshold)) ||
+		    (coords[n] > (tsfs->reported[n] +
+					  tsfs->config->averaging_threshold))) {
+			tsfs->fhead[n] = 0;
+			tsfs->ftail[n] = 0;
+			tsfs->lowpass[n] = 0;
+		}
+
+		/* capture this sample into fifo and sum */
+		tsfs->fifo[n][tsfs->fhead[n]++] = coords[n];
+		if (tsfs->fhead[n] == tsfs->config->extent)
+			tsfs->fhead[n] = 0;
+		tsfs->lowpass[n] += coords[n];
+
+		/* adjust the sum into an average and use that*/
+		len = (tsfs->fhead[n] - tsfs->ftail[n]) &
+						     (tsfs->config->extent - 1);
+		coords[n] = (tsfs->lowpass[n] + (len >> 1)) / len;
+		tsfs->reported[n] = coords[n];
+
+		/* remove oldest sample if we are full */
+		if (len == (tsfs->config->extent - 1)) {
+			tsfs->lowpass[n] -= tsfs->fifo[n][tsfs->ftail[n]++];
+			if (tsfs->ftail[n] == tsfs->config->extent)
+				tsfs->ftail[n] = 0;
+		}
+	}
+
+	if (tsf->next) /* chain */
+		return (tsf->next->api->process)(tsf->next, coords);
+
+	return 1;
+}
+
+struct ts_filter_api ts_filter_mean_api = {
+	.create = ts_filter_mean_create,
+	.destroy = ts_filter_mean_destroy,
+	.clear = ts_filter_mean_clear,
+	.process = ts_filter_mean_process,
+	.scale = ts_filter_mean_scale,
+};
diff --git a/include/linux/ts_filter_mean.h b/include/linux/ts_filter_mean.h
new file mode 100644
index 0000000..46ff01a
--- /dev/null
+++ b/include/linux/ts_filter_mean.h
@@ -0,0 +1,34 @@
+#ifndef __TS_FILTER_MEAN_H__
+#define __TS_FILTER_MEAN_H__
+
+#include <linux/ts_filter.h>
+
+/*
+ * touchscreen filter
+ *
+ * mean
+ *
+ * (c) 2008 Andy Green <andy@openmoko.com>
+ */
+
+struct ts_filter_mean_configuration {
+	int bits_filter_length;
+	int averaging_threshold;
+
+	int extent;
+};
+
+struct ts_filter_mean {
+	struct ts_filter tsf;
+	struct ts_filter_mean_configuration *config;
+
+	int reported[MAX_TS_FILTER_COORDS];
+	int lowpass[MAX_TS_FILTER_COORDS];
+	int *fifo[MAX_TS_FILTER_COORDS];
+	int fhead[MAX_TS_FILTER_COORDS];
+	int ftail[MAX_TS_FILTER_COORDS];
+};
+
+extern struct ts_filter_api ts_filter_mean_api;
+
+#endif

