Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCRVCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCRVCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZCRVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:01:58 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:37308 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbZCRVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:01:57 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 21/57] microblaze_v7: heartbeat file
Date: Wed, 18 Mar 2009 21:30:48 +0100
Message-Id: <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/heartbeat.c |   66 ++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/heartbeat.c

diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
new file mode 100644
index 0000000..390bab7
--- /dev/null
+++ b/arch/microblaze/kernel/heartbeat.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/prom.h>
+
+static unsigned int base_addr;
+
+void heartbeat(void)
+{
+	static unsigned int cnt, period, dist;
+
+	if (base_addr) {
+		if (cnt == 0 || cnt == dist)
+			out_be32(base_addr, 1);
+		else if (cnt == 7 || cnt == dist + 7)
+			out_be32(base_addr, 0);
+
+		if (++cnt > period) {
+			cnt = 0;
+			/*
+			 * The hyperbolic function below modifies the heartbeat
+			 * period length in dependency of the current (5min)
+			 * load. It goes through the points f(0)=126, f(1)=86,
+			 * f(5)=51, f(inf)->30.
+			 */
+			period = ((672 << FSHIFT) / (5 * avenrun[0] +
+						(7 << FSHIFT))) + 30;
+			dist = period / 4;
+		}
+	}
+}
+
+void setup_heartbeat(void)
+{
+	struct device_node *gpio = NULL;
+	int j;
+	char *gpio_list[] = {
+				"xlnx,xps-gpio-1.00.a",
+				"xlnx,opb-gpio-1.00.a",
+				NULL
+			};
+
+	for (j = 0; gpio_list[j] != NULL; j++) {
+		gpio = of_find_compatible_node(NULL, NULL, gpio_list[j]);
+		if (gpio)
+			break;
+	}
+
+	base_addr = *(int *) of_get_property(gpio, "reg", NULL);
+	base_addr = (unsigned long) ioremap(base_addr, PAGE_SIZE);
+	printk(KERN_NOTICE "Heartbeat GPIO at 0x%x\n", base_addr);
+
+	if (*(int *) of_get_property(gpio, "xlnx,is-bidir", NULL))
+		out_be32(base_addr + 4, 0); /* GPIO is configured as output */
+}
-- 
1.5.5.1

