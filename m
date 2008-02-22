Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYBVOPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYBVOPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYBVOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:15:14 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:59314 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbYBVOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:15:11 -0500
Date: Fri, 22 Feb 2008 15:15:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [PATCH] Add option to enable -Wframe-larger-than= on gcc 4.4
Message-ID: <20080222141503.GA933@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Feb 2008 14:08:39.0030 (UTC) FILETIME=[6C0D2160:01C8755C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add option to enable -Wframe-larger-than= on gcc 4.4

gcc mainline (upcoming 4.4) added a new -Wframe-larger-than=...
option to warn at build time about too large stack frames. Add a config 
option to enable this warning, since this very useful for the kernel.

I chose (somewhat arbitarily) 2048 as default warning threshold for 64bit 
and 1024 as default for 32bit architectures.  With some research and
fixing all the code for smaller values these defaults should be probably
lowered.

With the default allyesconfigs have some new warnings, but I think
that is all code that should be just fixed.

At some point (when gcc 4.4 is released and widely used) this should 
obsolete make checkstack

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -528,6 +528,10 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
+ifneq (CONFIG_FRAME_WARN,0)
+KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
+endif
+
 # Force gcc to behave correct even for buggy distributions
 KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
 
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -25,6 +25,17 @@ config ENABLE_MUST_CHECK
 	  suppress the "warning: ignoring return value of 'foo', declared with
 	  attribute warn_unused_result" messages.
 
+config FRAME_WARN
+	int "Warn for stack frames larger than (needs gcc 4.4)"
+	range 0 8192
+	default 1024 if !64BIT
+	default 2048 if 64BIT
+	help
+	  Tell gcc to warn at build time for stack frames larger than this.
+	  Setting this too low will cause a lot of warnings.
+	  Setting it to 0 disables the warning.
+	  Requires gcc 4.4
+
 config MAGIC_SYSRQ
 	bool "Magic SysRq key"
 	depends on !UML
