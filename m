Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZAMXlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZAMXlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbZAMXkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:40:10 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:42470 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbZAMXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=ZZNUp8brVsWygBAM+W/ptQnf0qiQaglNZoZRcuJP/qx4mRTgXd5K+3o1Y9NU6a1aET
         YFAhdayaz/9VD6I35hjhb28ExxmB8J2gJ57FFddWysjcQK2uux5F8rRA8ITLRw1U77G4
         OhIut2dShJE49eSIz2DH1l4QTJnlh1Dh4A9QI=
From: Nelson <arhuaco@freaks-unidos.net>
Subject: [PATCH 3/5] Add median filter
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, andy@openmoko.com
Date: Tue, 13 Jan 2009 18:39:55 -0500
Message-ID: <20090113233955.26361.77565.stgit@fugue.noexisteestedominiotanlargo.biz>
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

We sort incoming raw samples into an array of MEDIAN_SIZE length,
discarding the oldest sample each time once we are full. We then
return the sum of the middle three samples for X and Y. Check the
comments for a full description of what this patch implements.

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
---

 drivers/input/touchscreen/Kconfig            |    8 +
 drivers/input/touchscreen/Makefile           |    1 
 drivers/input/touchscreen/ts_filter_median.c |  215 ++++++++++++++++++++++++++
 include/linux/ts_filter_median.h             |   36 ++++
 4 files changed, 260 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/ts_filter_median.c
 create mode 100644 include/linux/ts_filter_median.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 09f55dd..5c84858 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -29,6 +29,14 @@ config TOUCHSCREEN_FILTER_GROUP
 	  Say Y here if you want to use the Group touchscreen filter, it
 	  avoids using atypical samples.
 
+config TOUCHSCREEN_FILTER_MEDIAN
+	bool "Median Average Touchscreen Filter"
+	depends on INPUT_TOUCHSCREEN && TOUCHSCREEN_FILTER
+	default Y
+	help
+	  Say Y here if you want to use the Median touchscreen filter, it's
+	  highly effective if you data is noisy with occasional excursions.
+
 endif
 
 config TOUCHSCREEN_ADS7846
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 9ccb21a..e67c334 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -33,3 +33,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_GROUP)	+= ts_filter_group.o
+obj-$(CONFIG_TOUCHSCREEN_FILTER_MEDIAN)	+= ts_filter_median.o
diff --git a/drivers/input/touchscreen/ts_filter_median.c b/drivers/input/touchscreen/ts_filter_median.c
new file mode 100644
index 0000000..883ab06
--- /dev/null
+++ b/drivers/input/touchscreen/ts_filter_median.c
@@ -0,0 +1,215 @@
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
+ * Median averaging stuff.  We sort incoming raw samples into an array of
+ * MEDIAN_SIZE length, discarding the oldest sample each time once we are full.
+ * We then return the sum of the middle three samples for X and Y.  It means
+ * the final result must be divided by (3 * scaling factor) to correct for
+ * avoiding the repeated /3.
+ *
+ * This strongly rejects brief excursions away from a central point that is
+ * sticky in time compared to the excursion duration.
+ *
+ * Thanks to Dale Schumacher (who wrote some example code) and Carl-Daniel
+ * Halifinger who pointed out this would be a good method.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/ts_filter_median.h>
+
+static void ts_filter_median_insert(int *p, int sample, int count)
+{
+	int n;
+
+	/* search through what we got so far to find where to put sample */
+	for (n = 0; n < count; n++)
+		 /* we met somebody bigger than us? */
+		if (sample < p[n]) {
+			/* starting from the end, push bigger guys down one */
+			for (count--; count >= n; count--)
+				p[count + 1] = p[count];
+			p[n] = sample; /* and put us in place of first bigger */
+			return;
+		}
+
+	p[count] = sample; /* nobody was bigger than us, add us on the end */
+}
+
+static void ts_filter_median_del(int *p, int value, int count)
+{
+	int index;
+
+	for (index = 0; index < count; index++)
+		if (p[index] == value) {
+			for (; index < count; index++)
+				p[index] = p[index + 1];
+			return;
+		}
+}
+
+
+static void ts_filter_median_clear_internal(struct ts_filter *tsf)
+{
+	struct ts_filter_median *tsfm = (struct ts_filter_median *)tsf;
+
+	tsfm->pos = 0;
+	tsfm->valid = 0;
+
+}
+static void ts_filter_median_clear(struct ts_filter *tsf)
+{
+	ts_filter_median_clear_internal(tsf);
+
+	if (tsf->next) /* chain */
+		(tsf->next->api->clear)(tsf->next);
+}
+
+static struct ts_filter *ts_filter_median_create(struct platform_device *pdev,
+						 void *conf, int count_coords)
+{
+	int *p;
+	int n;
+	struct ts_filter_median *tsfm = kzalloc(sizeof(struct ts_filter_median),
+								    GFP_KERNEL);
+
+	if (!tsfm)
+		return NULL;
+
+	tsfm->config = (struct ts_filter_median_configuration *)conf;
+	BUG_ON((count_coords < 1) || (count_coords > MAX_TS_FILTER_COORDS));
+	tsfm->tsf.count_coords = count_coords;
+
+	tsfm->config->midpoint = (tsfm->config->extent >> 1) + 1;
+
+	p = kmalloc(2 * count_coords * sizeof(int) * (tsfm->config->extent + 1),
+								    GFP_KERNEL);
+	if (!p) {
+		kfree(tsfm);
+		return NULL;
+	}
+
+	for (n = 0; n < count_coords; n++) {
+		tsfm->sort[n] = p;
+		p += tsfm->config->extent + 1;
+		tsfm->fifo[n] = p;
+		p += tsfm->config->extent + 1;
+	}
+
+	ts_filter_median_clear_internal(&tsfm->tsf);
+
+	printk(KERN_INFO"  Created Median ts filter len %d depth %d dec %d\n",
+	       tsfm->config->extent, count_coords,
+	       tsfm->config->decimation_threshold);
+
+	return &tsfm->tsf;
+}
+
+static void ts_filter_median_destroy(struct platform_device *pdev,
+				     struct ts_filter *tsf)
+{
+	struct ts_filter_median *tsfm = (struct ts_filter_median *)tsf;
+
+	kfree(tsfm->sort[0]); /* first guy has pointer from kmalloc */
+	kfree(tsf);
+}
+
+static void ts_filter_median_scale(struct ts_filter *tsf, int *coords)
+{
+	int n;
+
+	for (n = 0; n < tsf->count_coords; n++)
+		coords[n] = (coords[n] + 2) / 3;
+
+	if (tsf->next) /* chain */
+		(tsf->next->api->scale)(tsf->next, coords);
+}
+
+/* give us the raw sample data coords, and if we return 1 then you can
+ * get a filtered coordinate from coords: if we return 0 you didn't
+ * fill all the filters with samples yet.
+ */
+
+static int ts_filter_median_process(struct ts_filter *tsf, int *coords)
+{
+	struct ts_filter_median *tsfm = (struct ts_filter_median *)tsf;
+	int n;
+	int movement = 1;
+
+	for (n = 0; n < tsf->count_coords; n++) {
+		/* grab copy in insertion order to remove when oldest */
+		tsfm->fifo[n][tsfm->pos] = coords[n];
+		/* insert these samples in sorted order in the median arrays */
+		ts_filter_median_insert(tsfm->sort[n], coords[n], tsfm->valid);
+	}
+	/* move us on in the fifo */
+	if (++tsfm->pos == (tsfm->config->extent + 1))
+		tsfm->pos = 0;
+
+	/* we have finished a median sampling? */
+	if (++tsfm->valid != tsfm->config->extent)
+		return 0; /* no valid sample to use */
+
+	/* discard the oldest sample in median sorted array */
+	tsfm->valid--;
+
+	/* sum the middle 3 in the median sorted arrays.  We don't divide back
+	 * down which increases the sum resolution by a factor of 3 until the
+	 * scale API is called
+	 */
+	for (n = 0; n < tsfm->tsf.count_coords; n++)
+		/* perform the deletion of the oldest sample */
+		ts_filter_median_del(tsfm->sort[n], tsfm->fifo[n][tsfm->pos],
+								   tsfm->valid);
+
+	tsfm->decimation_count--;
+	if (tsfm->decimation_count >= 0)
+		return 0;
+
+	for (n = 0; n < tsfm->tsf.count_coords; n++) {
+		/* give the coordinate result from summing median 3 */
+		coords[n] = tsfm->sort[n][tsfm->config->midpoint - 1] +
+			    tsfm->sort[n][tsfm->config->midpoint] +
+			    tsfm->sort[n][tsfm->config->midpoint + 1]
+			;
+
+		movement += abs(tsfm->last_issued[n] - coords[n]);
+	}
+
+	if (movement > tsfm->config->decimation_threshold) /* fast */
+		tsfm->decimation_count = tsfm->config->decimation_above;
+	else
+		tsfm->decimation_count = tsfm->config->decimation_below;
+
+	memcpy(&tsfm->last_issued[0], coords,
+	       tsfm->tsf.count_coords * sizeof(int));
+
+	if (tsf->next) /* chain */
+		return (tsf->next->api->process)(tsf->next, coords);
+
+	return 1;
+}
+
+struct ts_filter_api ts_filter_median_api = {
+	.create = ts_filter_median_create,
+	.destroy = ts_filter_median_destroy,
+	.clear = ts_filter_median_clear,
+	.process = ts_filter_median_process,
+	.scale = ts_filter_median_scale,
+};
diff --git a/include/linux/ts_filter_median.h b/include/linux/ts_filter_median.h
new file mode 100644
index 0000000..d816428
--- /dev/null
+++ b/include/linux/ts_filter_median.h
@@ -0,0 +1,36 @@
+#ifndef __TS_FILTER_MEDIAN_H__
+#define __TS_FILTER_MEDIAN_H__
+
+#include <linux/ts_filter.h>
+
+/*
+ * touchscreen filter
+ *
+ * median
+ *
+ * (c) 2008 Andy Green <andy@openmoko.com>
+ */
+
+struct ts_filter_median_configuration {
+	int extent;
+	int midpoint;
+	int decimation_threshold;
+	int decimation_above;
+	int decimation_below;
+};
+
+struct ts_filter_median {
+	struct ts_filter tsf;
+	struct ts_filter_median_configuration *config;
+
+	int decimation_count;
+	int last_issued[MAX_TS_FILTER_COORDS];
+	int valid; /* how many samples in the sort buffer are valid */
+	int *sort[MAX_TS_FILTER_COORDS]; /* samples taken for median */
+	int *fifo[MAX_TS_FILTER_COORDS]; /* samples taken for median */
+	int pos; /* where we are in the fifo sample memory */
+};
+
+extern struct ts_filter_api ts_filter_median_api;
+
+#endif

