Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXJYIG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXJYIG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXJYIGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:06:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50375 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXJYIGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:06:14 -0400
To: LKML <linux-kernel@vger.kernel.org>
Message-Id: <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
In-Reply-To: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH] Permit silencing of __deprecated warnings.
Date: Thu, 25 Oct 2007 04:06:13 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __deprecated marker is quite useful in highlighting the remnants of
old APIs that want removing.

However, it is quite normal for one or more years to pass, before the
(usually ancient, bitrotten) code in question is either updated or
deleted.

Thus, like __must_check, add a Kconfig option that permits the silencing
of this compiler warning.

This change mimics the ifdef-ery and Kconfig defaults of MUST_CHECK as
closely as possible.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 include/linux/compiler.h |    6 ++++++
 lib/Kconfig.debug        |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c811c8b..c68b67b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -101,6 +101,12 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #undef __must_check
 #define __must_check
 #endif
+#ifndef CONFIG_ENABLE_WARN_DEPRECATED
+#undef __deprecated
+#undef __deprecated_for_modules
+#define __deprecated
+#define __deprecated_for_modules
+#endif
 
 /*
  * Allow us to avoid 'defined but not used' warnings on functions and data,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1faa508..1e5f207 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -9,6 +9,14 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config ENABLE_WARN_DEPRECATED
+	bool "Enable __deprecated logic"
+	default y
+	help
+	  Enable the __deprecated logic in the kernel build.
+	  Disable this to suppress the "warning: 'foo' is deprecated
+	  (declared at kernel/power/somefile.c:1234)" messages.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y
-- 
1.5.2.4

