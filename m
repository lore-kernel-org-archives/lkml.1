Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYLJScV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYLJScV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYLJS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:09 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33258 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300AbYLJS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:28:08 -0500
Subject: [PATCH 13/15] kmemleak: Keep the __init functions after initialization
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:28:06 +0000
Message-ID: <20081210182806.30323.62122.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:28:06.0574 (UTC) FILETIME=[0BA6D4E0:01C95AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the CONFIG_DEBUG_KEEP_INIT option which preserves the
.init.* sections after initialization. Memory leaks happening during
this phase can be more easily tracked.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/linux/init.h |    6 ++++++
 lib/Kconfig.debug    |   12 ++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 68cb026..41321ad 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -40,9 +40,15 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
+#ifdef CONFIG_DEBUG_KEEP_INIT
+#define __init
+#define __initdata
+#define __initconst
+#else
 #define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
 #define __initconst	__section(.init.rodata)
+#endif
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1e59827..72cde77 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -313,6 +313,18 @@ config DEBUG_MEMLEAK
 	  In order to access the memleak file, debugfs needs to be
 	  mounted (usually at /sys/kernel/debug).
 
+config DEBUG_KEEP_INIT
+	bool "Do not free the __init code/data"
+	default n
+	depends on DEBUG_MEMLEAK
+	help
+	  This option moves the __init code/data out of the
+	  .init.text/.init.data sections. It is useful for identifying
+	  memory leaks happening during the kernel or modules
+	  initialization.
+
+	  If unsure, say N.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)

