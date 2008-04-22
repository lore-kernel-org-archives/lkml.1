Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYDVJxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYDVJxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbYDVJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:53:06 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:56954 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755549AbYDVJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:53:04 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1208857983!11707822!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] provide a dummy implementation of the clk API
Date: Tue, 22 Apr 2008 11:52:56 +0200
Message-ID: <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <20080422094708.GB27126@digi.com>
 <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Apr 2008 09:52:58.0089 (UTC) FILETIME=[A4EC4D90:01C8A45E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15864.006
X-TM-AS-Result: No--0.160000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this implementation clk_get and clk_enable always succeed.  The
counterparts clk_put and clk_disable only do some minor error checking.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 lib/Kconfig    |    6 ++++++
 lib/Makefile   |    2 ++
 lib/dummyclk.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 lib/dummyclk.c

Hello,

this patch isn't really UIO related, but as my platform driver uses the
clk API and that's not implemented on X86 here comes a dummy
implementation.

This patch was already sent but up to now I got no feedback for it.

Best regards
Uwe

diff --git a/lib/Kconfig b/lib/Kconfig
index 2d53dc0..098830d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -144,4 +144,10 @@ config CHECK_SIGNATURE
 config HAVE_LMB
 	boolean
 
+config DUMMY_CLK
+	def_bool y if X86
+	help
+	  This provides a dummy implementation for the API defined in
+	  linux/clk.h for platforms that don't implement it theirselves.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index bf8000f..e355c69 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -70,6 +70,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
 
+obj-$(CONFIG_DUMMY_CLK) += dummyclk.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/dummyclk.c b/lib/dummyclk.c
new file mode 100644
index 0000000..bf364df
--- /dev/null
+++ b/lib/dummyclk.c
@@ -0,0 +1,54 @@
+/*
+ * lib/dummyclk.c
+ *
+ * Copyright (C) 2008 by Digi International Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+
+struct clk {
+	unsigned int enablecnt;
+};
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+
+	if (ret)
+		return ret;
+	else
+		return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	WARN_ON(clk->enablecnt);
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_enable(struct clk *clk)
+{
+	++clk->enablecnt;
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	BUG_ON(!clk->enablecnt);
+	--clk->enablecnt;
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	BUG_ON(!clk->enablecnt);
+	return 0;
+}
+EXPORT_SYMBOL(clk_get_rate);
-- 
1.5.5

