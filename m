Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbXKPUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbXKPUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbXKPUF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:05:59 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46734 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934753AbXKPUF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:05:57 -0500
Message-Id: <20071116200512.860130438@polymtl.ca>
References: <20071116200238.740495156@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:02:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [rfc-patch 2/9] Immediate Values - Kconfig menu in EMBEDDED
Content-Disposition: inline; filename=immediate-values-kconfig-embedded.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:05:14 +0000
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

Changelog:
- Change ARCH_SUPPORTS_IMMEDIATE for ARCH_HAS_IMMEDIATE

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
---
 init/Kconfig |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-11-15 22:18:42.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2007-11-15 22:19:24.000000000 -0500
@@ -428,6 +428,20 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config IMMEDIATE
+	default y if !DISABLE_IMMEDIATE
+	depends on HAVE_IMMEDIATE
+	bool
+	help
+	  Immediate values are used as read-mostly variables that are rarely
+	  updated. They use code patching to modify the values inscribed in the
+	  instruction stream. It provides a way to save precious cache lines
+	  that would otherwise have to be used by these variables. They can be
+	  disabled through the EMBEDDED menu.
+
+config HAVE_IMMEDIATE
+	def_bool n
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -663,6 +677,16 @@ config MARKERS
 
 source "arch/Kconfig"
 
+config DISABLE_IMMEDIATE
+	default y if EMBEDDED
+	bool "Disable immediate values" if EMBEDDED
+	depends on HAVE_IMMEDIATE
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
