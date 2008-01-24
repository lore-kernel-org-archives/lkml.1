Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYAXUkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYAXUkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbYAXUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53097 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbYAXUew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:52 -0500
Message-Id: <20080124203338.601681619@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 15/26] Immediate Values - Kconfig menu in EMBEDDED
Content-Disposition: inline; filename=immediate-values-kconfig-embedded.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
---
 init/Kconfig |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6-lttng.mm/init/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/init/Kconfig	2008-01-24 14:18:34.000000000 -0500
+++ linux-2.6-lttng.mm/init/Kconfig	2008-01-24 14:29:28.000000000 -0500
@@ -472,6 +472,20 @@ config CC_OPTIMIZE_FOR_SIZE
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
@@ -716,6 +730,16 @@ config MARKERS
 
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
 
 config SLABINFO

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
