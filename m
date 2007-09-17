Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbXIQSp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbXIQSp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbXIQSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:43:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50259 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621AbXIQSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:43:47 -0400
Message-Id: <20070917184319.915814997@polymtl.ca>
References: <20070917184224.549435917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 14:42:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 2/7] Immediate Values - Kconfig menu in EMBEDDED
Content-Disposition: inline; filename=immediate-values-kconfig-embedded.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 17 Sep 2007 18:43:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values provide a way to use dynamic code patching to update variables
sitting within the instruction stream. It saves caches lines normally used by
static read mostly variables. Enable it by default, but let users disable it
through the EMBEDDED menu with the "Disable immediate values" submenu entry.

Note: Since I think that I really should let embedded systems developers using
RO memory the option to disable the immediate values, I choose to leave this
menu option there, in the EMBEDDED menu. Also, the "CONFIG_IMMEDIATE" makes
sense because we want to compile out all the immediate code when we decide not
to use optimized immediate values at all (it removes otherwise unused code).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
---
 init/Kconfig |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-09-04 11:53:59.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2007-09-04 12:12:03.000000000 -0400
@@ -407,6 +407,17 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config IMMEDIATE
+	default y if !DISABLE_IMMEDIATE
+	depends on X86_32 || PPC || PPC64
+	bool
+	help
+	  Immediate values are used as read mostly variables that are rarely
+	  updated. They use code patching to modify the values inscribed in the
+	  instruction stream. It provides a way to save precious cache lines
+	  that would otherwise have to be used by these variables. Can be
+	  disabled through the EMBEDDED menu.
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -645,6 +656,16 @@ config PROC_KPAGEMAP
           information on page-level memory usage. Disabling this interface
           will reduce the size of the kernel by around 600 bytes.
 
+config DISABLE_IMMEDIATE
+	default y if EMBEDDED
+	bool "Disable immediate values" if EMBEDDED
+	depends on X86_32 || PPC || PPC64
+	help
+	  Disable code patching based immediate values for embedded systems. It
+	  consumes slightly more memory and requires to modify the instruction
+	  stream each time a variable is updated. Should really be disabled for
+	  embedded systems with read-only text.
+
 endmenu		# General setup
 
 config RT_MUTEXES

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
