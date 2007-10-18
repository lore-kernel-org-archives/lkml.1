Return-Path: <linux-kernel-owner+w=401wt.eu-S1764553AbXJRVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764553AbXJRVM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXJRVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:12:49 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56134 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbXJRVMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:12:47 -0400
Date: Thu, 18 Oct 2007 23:14:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Rob Landley <rob@landley.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071018211420.GA23397@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin> <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au> <200710111614.39879.rob@landley.net> <Pine.LNX.4.64.0710120849480.11634@anakin> <Pine.LNX.4.64.0710121731110.17887@loopy.telegraphics.com.au> <Pine.LNX.4.64.0710121046020.7335@anakin> <20071012102124.GA18959@uranus.ravnborg.org> <Pine.LNX.4.64.0710152217150.16889@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710152217150.16889@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Anyway, here's a try to make it autodetect m68k-linux-gnu-gcc and
> m68k-linux-gcc. Perhaps it can be generalized in kbuild, to allow
> arch/*/Makefile to set a list of possible cross-compiler prefixes?

Here is my first try.
We only touch CROSS_COMPILE is empty and building for another arch.

I can obviously move crossgcc part of this to core kbuild.
Any better name?

	Sam


diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 4a1bd44..6465bbe 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -13,17 +13,26 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
+# usage:
+# CROSS_COMPILE := $(call crossgcc, foo bar /usr/bin/)
+# CROSS_COMPILE will be assinged the first prefix that point
+# to a gcc in the path
+crossgcc =  $(word 1, $(foreach c,$(1),                               \
+		$(shell set -e;                                       \
+		if (which $(strip $(c))$(CC)) > /dev/null 2>&1 ; then \
+			echo $(c);                                    \
+		fi)))
+
+ifneq ($(SUBARCH),$(ARCH))
+        ifeq ($(CROSS_COMPILE),)
+                CROSS_COMPILE := $(call crossgcc, m68k-linux-gnu-)
+        endif
+endif
 
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
-ifneq ($(COMPILE_ARCH),$(ARCH))
-	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
-endif
 
 ifdef CONFIG_SUN3
 LDFLAGS_vmlinux = -N
