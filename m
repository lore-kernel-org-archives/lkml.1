Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYE2SUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYE2SUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYE2STu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbYE2STt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] Werror: Provide a configuration option to enable -Werror
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:51 +0100
Message-ID: <20080529181751.5396.57465.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a configuration option to enable -Werror and make it work for x86_64
allyesconfig with __deprecated and __must_check checking disabled.

Note that it _won't_ be turned on for allyesconfig as it is suppressed by
ENABLE_WARN_DEPRECATED or ENABLE_MUST_CHECK being enabled.

Additionally, the advansys driver has its complaint about not being coverted
to the DMA API suppressed if this option is enabled.

Subject to those conditions, x86_64 allyesconfig will build with this option
enabled, if ENABLE_WARN_DEPRECATED and ENABLE_MUST_CHECK are manually disabled
and ENABLE_WERROR enabled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile                |    4 ++++
 drivers/scsi/advansys.c |    2 ++
 lib/Kconfig.debug       |    8 ++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)


diff --git a/Makefile b/Makefile
index 8db70fe..f40d5c1 100644
--- a/Makefile
+++ b/Makefile
@@ -528,6 +528,10 @@ KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
 endif
 
+ifdef CONFIG_ENABLE_WERROR
+KBUILD_CFLAGS	+= -Werror
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8591585..539d22f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -68,7 +68,9 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
+#ifndef CONFIG_ENABLE_WERROR
 #warning this driver is still not properly converted to the DMA API
+#endif
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..3efca43 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -25,6 +25,14 @@ config ENABLE_MUST_CHECK
 	  suppress the "warning: ignoring return value of 'foo', declared with
 	  attribute warn_unused_result" messages.
 
+config ENABLE_WERROR
+	bool "Enable -Werror"
+	default n
+	depends on !ENABLE_WARN_DEPRECATED && !ENABLE_MUST_CHECK
+	help
+	  Enable -Werror on building C files.  This causes all warnings to
+	  abort the compilation, just as errors do.
+
 config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192

