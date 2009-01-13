Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbZAMXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbZAMXkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbZAMXjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:39:53 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:54036 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020AbZAMXjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=dyRlBgF/OHJ2r9IvtLmDfEToC+INwMmPOIUya6ZoKNO2LxVG9VIwYTR/K/aFSAJgI4
         rRMipThk5HBqJ0o/ipWn6twUUF0K1M39dkQoMs/dgAjHNRpFK7u+gDoS4RgpI4YeF27c
         l8amCk2n+DJylvJkcI038tTKSfIlG4lo3PF9M=
From: Nelson <arhuaco@freaks-unidos.net>
Subject: [PATCH 1/5] Add touchscreen filter API
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, andy@openmoko.com
Date: Tue, 13 Jan 2009 18:39:39 -0500
Message-ID: <20090113233939.26361.18138.stgit@fugue.noexisteestedominiotanlargo.biz>
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

Generic filters are not useful by themselves. They define an API that
actual filters have to implement.

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
---

 drivers/input/touchscreen/Kconfig     |    8 ++++
 drivers/input/touchscreen/Makefile    |    1 +
 drivers/input/touchscreen/ts_filter.c |   64 +++++++++++++++++++++++++++++++++
 include/linux/ts_filter.h             |   56 +++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/ts_filter.c
 create mode 100644 include/linux/ts_filter.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3d1ab8f..aed3eb0 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -11,6 +11,14 @@ menuconfig INPUT_TOUCHSCREEN
 
 if INPUT_TOUCHSCREEN
 
+menuconfig TOUCHSCREEN_FILTER
+	boolean "Touchscreen Filtering"
+	depends on INPUT_TOUCHSCREEN
+	help
+	  Select this to include kernel touchscreen filter support.  The filters
+	  can be combined in any order in your machine init and the parameters
+	  for them can also be set there.
+
 config TOUCHSCREEN_ADS7846
 	tristate "ADS7846/TSC2046 and ADS7843 based touchscreens"
 	depends on SPI_MASTER
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 15cf290..74ab26f 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -31,3 +31,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
+obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
diff --git a/drivers/input/touchscreen/ts_filter.c b/drivers/input/touchscreen/ts_filter.c
new file mode 100644
index 0000000..1508388
--- /dev/null
+++ b/drivers/input/touchscreen/ts_filter.c
@@ -0,0 +1,64 @@
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/ts_filter.h>
+
+int ts_filter_create_chain(struct platform_device *pdev,
+			   struct ts_filter_api **api, void **config,
+			   struct ts_filter **list, int count_coords)
+{
+	int count = 0;
+	struct ts_filter *last = NULL;
+
+	if (!api)
+		return 0;
+
+	while (*api && count < MAX_TS_FILTER_CHAIN) {
+		*list = ((*api)->create)(pdev, *config++, count_coords);
+		if (!*list) {
+			printk(KERN_ERR "Filter %d failed init\n", count);
+			return count;
+		}
+		(*list)->api = *api++;
+		if (last)
+			last->next = *list;
+		last = *list;
+		list++;
+		count++;
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(ts_filter_create_chain);
+
+void ts_filter_destroy_chain(struct platform_device *pdev,
+			     struct ts_filter **list)
+{
+	struct ts_filter **first;
+	int count = 0;
+
+	first = list;
+	while (*list && count++ < MAX_TS_FILTER_CHAIN) {
+		((*list)->api->destroy)(pdev, *list);
+		list++;
+	}
+	*first = NULL;
+}
+EXPORT_SYMBOL_GPL(ts_filter_destroy_chain);
diff --git a/include/linux/ts_filter.h b/include/linux/ts_filter.h
new file mode 100644
index 0000000..1671044
--- /dev/null
+++ b/include/linux/ts_filter.h
@@ -0,0 +1,56 @@
+#ifndef __TS_FILTER_H__
+#define __TS_FILTER_H__
+
+/*
+ * touchscreen filter
+ *
+ * (c) 2008 Andy Green <andy@openmoko.com>
+ */
+
+#include <linux/platform_device.h>
+
+#define MAX_TS_FILTER_CHAIN		4  /* max filters you can chain up */
+#define MAX_TS_FILTER_COORDS		3  /* X, Y and Z (pressure) */
+
+struct ts_filter;
+
+/* operations that a filter can perform
+ */
+struct ts_filter_api {
+	struct ts_filter * (*create)(struct platform_device *pdev, void *config,
+				     int count_coords);
+	void (*destroy)(struct platform_device *pdev, struct ts_filter *filter);
+	void (*clear)(struct ts_filter *filter);
+	int (*process)(struct ts_filter *filter, int *coords);
+	void (*scale)(struct ts_filter *filter, int *coords);
+};
+
+/* this is the common part of all filters, the result
+ * we use this type as an otherwise opaque handle on to
+ * the actual filter.  Therefore you need one of these
+ * at the start of your actual filter struct
+ */
+
+struct ts_filter {
+	struct ts_filter *next; /* next in chain */
+	struct ts_filter_api *api; /* operations to use for this object */
+	int count_coords;
+	int coords[MAX_TS_FILTER_COORDS];
+};
+
+/*
+ * helper to create a filter chain from array of API pointers and
+ * array of config ints... leaves pointers to created filters in list
+ * array and fills in ->next pointers to create the chain
+ */
+
+extern int ts_filter_create_chain(struct platform_device *pdev,
+				  struct ts_filter_api **api, void **config,
+				  struct ts_filter **list, int count_coords);
+
+/* helper to destroy a whole chain from the list of filter pointers */
+
+extern void ts_filter_destroy_chain(struct platform_device *pdev,
+				    struct ts_filter **list);
+
+#endif

