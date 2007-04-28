Return-Path: <linux-kernel-owner+w=401wt.eu-S1031842AbXD1Rzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031842AbXD1Rzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163311AbXD1RxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163315AbXD1Rwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [28/35] x86: Drop cc-options call for all options supported in gcc 3.2+
Message-Id: <20070428175253.CB22E151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel only supports gcc 3.2+ now so it doesn't make sense
anymore to explicitely check for options this compiler version
already has.

This actually fixes a bug. The -mprefered-stack-boundary check
never worked because gcc rightly complains

  CC      arch/i386/kernel/asm-offsets.s
cc1: -mpreferred-stack-boundary=2 is not between 4 and 12

We just never saw the error because of cc-options.
I changed it to 4 to actually work.

Tested by compiling i386 and x86-64 defconfig with gcc 3.2.

Should speed up the build time a tiny bit and improve
stack usage on i386 slightly.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Makefile           |    2 +-
 arch/i386/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -491,7 +491,7 @@ endif
 include $(srctree)/arch/$(ARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
-CFLAGS		+= -fno-omit-frame-pointer $(call cc-option,-fno-optimize-sibling-calls,)
+CFLAGS		+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
 CFLAGS		+= -fomit-frame-pointer
 endif
Index: linux/arch/i386/Makefile
===================================================================
--- linux.orig/arch/i386/Makefile
+++ linux/arch/i386/Makefile
@@ -34,7 +34,7 @@ CHECKFLAGS	+= -D__i386__
 CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
 
 # prevent gcc from keeping the stack 16 byte aligned
-CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
+CFLAGS += -mpreferred-stack-boundary=4
 
 # CPU-specific tuning. Anything which can be shared with UML should go here.
 include $(srctree)/arch/i386/Makefile.cpu
