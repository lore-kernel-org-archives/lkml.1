Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZA2V7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZA2V7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZA2V7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:59:35 -0500
Received: from 076-076-148-181.pdx.net ([76.76.148.181]:46220 "EHLO
	inaky-mobl3" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752790AbZA2V7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:59:34 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: wimax@linuxwimax.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH] wimax: fix build issue when debugfs is disabled
Date: Thu, 29 Jan 2009 13:59:29 -0800
Message-Id: <1233266369-16834-1-git-send-email-inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <200901291346.16906.inaky@linux.intel.com>
References: <200901291346.16906.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Toralf Förster and Randy Dunlap.

- http://linuxwimax.org/pipermail/wimax/2009-January/000460.html

- http://lkml.org/lkml/2009/1/29/279

The definitions needed for the wimax stack and i2400m driver debug
infrastructure was, by mistake, compiled depending on CONFIG_DEBUG_FS
(by them being placed in the debugfs.c files); thus the build broke in
2.6.29-rc3 when debugging was enabled (CONFIG_WIMAX_DEBUG) and
DEBUG_FS was disabled.

These definitions are always needed if debug is enabled at compile
time (independently of DEBUG_FS being or not enabled), so moving them
to a file that is always compiled fixes the issue.

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 drivers/net/wimax/i2400m/debugfs.c |   14 --------------
 drivers/net/wimax/i2400m/driver.c  |   16 ++++++++++++++++
 net/wimax/debugfs.c                |   11 -----------
 net/wimax/stack.c                  |   13 +++++++++++++
 4 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 6266329..9b81af3 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -234,20 +234,6 @@ struct dentry *debugfs_create_i2400m_reset(
 				   &fops_i2400m_reset);
 }
 
-/*
- * Debug levels control; see debug.h
- */
-struct d_level D_LEVEL[] = {
-	D_SUBMODULE_DEFINE(control),
-	D_SUBMODULE_DEFINE(driver),
-	D_SUBMODULE_DEFINE(debugfs),
-	D_SUBMODULE_DEFINE(fw),
-	D_SUBMODULE_DEFINE(netdev),
-	D_SUBMODULE_DEFINE(rfkill),
-	D_SUBMODULE_DEFINE(rx),
-	D_SUBMODULE_DEFINE(tx),
-};
-size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
 
 #define __debugfs_register(prefix, name, parent)			\
 do {									\
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 5f98047..e80a0b6 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -707,6 +707,22 @@ void i2400m_release(struct i2400m *i2400m)
 EXPORT_SYMBOL_GPL(i2400m_release);
 
 
+/*
+ * Debug levels control; see debug.h
+ */
+struct d_level D_LEVEL[] = {
+	D_SUBMODULE_DEFINE(control),
+	D_SUBMODULE_DEFINE(driver),
+	D_SUBMODULE_DEFINE(debugfs),
+	D_SUBMODULE_DEFINE(fw),
+	D_SUBMODULE_DEFINE(netdev),
+	D_SUBMODULE_DEFINE(rfkill),
+	D_SUBMODULE_DEFINE(rx),
+	D_SUBMODULE_DEFINE(tx),
+};
+size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
+
+
 static
 int __init i2400m_driver_init(void)
 {
diff --git a/net/wimax/debugfs.c b/net/wimax/debugfs.c
index 87cf443..94d216a 100644
--- a/net/wimax/debugfs.c
+++ b/net/wimax/debugfs.c
@@ -28,17 +28,6 @@
 #include "debug-levels.h"
 
 
-/* Debug framework control of debug levels */
-struct d_level D_LEVEL[] = {
-	D_SUBMODULE_DEFINE(debugfs),
-	D_SUBMODULE_DEFINE(id_table),
-	D_SUBMODULE_DEFINE(op_msg),
-	D_SUBMODULE_DEFINE(op_reset),
-	D_SUBMODULE_DEFINE(op_rfkill),
-	D_SUBMODULE_DEFINE(stack),
-};
-size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
-
 #define __debugfs_register(prefix, name, parent)			\
 do {									\
 	result = d_level_register_debugfs(prefix, name, parent);	\
diff --git a/net/wimax/stack.c b/net/wimax/stack.c
index d4da92f..3869c03 100644
--- a/net/wimax/stack.c
+++ b/net/wimax/stack.c
@@ -516,6 +516,19 @@ void wimax_dev_rm(struct wimax_dev *wimax_dev)
 }
 EXPORT_SYMBOL_GPL(wimax_dev_rm);
 
+
+/* Debug framework control of debug levels */
+struct d_level D_LEVEL[] = {
+	D_SUBMODULE_DEFINE(debugfs),
+	D_SUBMODULE_DEFINE(id_table),
+	D_SUBMODULE_DEFINE(op_msg),
+	D_SUBMODULE_DEFINE(op_reset),
+	D_SUBMODULE_DEFINE(op_rfkill),
+	D_SUBMODULE_DEFINE(stack),
+};
+size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
+
+
 struct genl_family wimax_gnl_family = {
 	.id = GENL_ID_GENERATE,
 	.name = "WiMAX",
-- 
1.5.6.5

