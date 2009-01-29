Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZA2Vqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZA2Vqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZA2VqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:46:25 -0500
Received: from mga06.intel.com ([134.134.136.21]:12316 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752288AbZA2VqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:46:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,346,1231142400"; 
   d="scan'208";a="382481064"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PATCH] Re: mmotm 2009-01-29-02-29 uploaded (wimax)
Date: Thu, 29 Jan 2009 13:46:16 -0800
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       David Miller <davem@davemloft.net>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981EC35.1030306@oracle.com>
In-Reply-To: <4981EC35.1030306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901291346.16906.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

On Thursday 29 January 2009, Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-29-02-29 has been uploaded to
> >
> >    http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> >    git://git.zen-sources.org/zen/mmotm.git
>
> Build fails with:
>
> ERROR: "d_level_wimax" [net/wimax/wimax.ko] undefined!
> ERROR: "d_level_size_wimax" [net/wimax/wimax.ko] undefined!

Fixed, tested and pushed to 
git://git.kernel.org/pub/scm/linux/kernel/git/inaky/wimax.git

Thanks

---
>From 968f75d77e857fb6ac69b785533a611d21986f3d Mon Sep 17 00:00:00 2001
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Thu, 29 Jan 2009 13:29:05 -0800
Subject: [PATCH] wimax: fix build issue when debugfs is disabled
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/net/wimax/i2400m/debugfs.c 
b/drivers/net/wimax/i2400m/debugfs.c
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
diff --git a/drivers/net/wimax/i2400m/driver.c 
b/drivers/net/wimax/i2400m/driver.c
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
