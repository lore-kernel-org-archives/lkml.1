Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbXB1UXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbXB1UXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXB1UXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:23:30 -0500
Received: from tossu.ebaana.net ([62.121.33.10]:4206 "EHLO tossu.ebaana.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbXB1UXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:23:30 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 15:23:29 EST
From: Lasse Collin <lasse.collin@tukaani.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] i386: Fix usage of -mtune when X86_GENERIC=y or CONFIG_MCORE2=y
Date: Wed, 28 Feb 2007 22:17:21 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282217.21910.lasse.collin@tukaani.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes to arch/i386/Makefile.cpu:

1) When X86_GENERIC=y is set, use -mtune=i686 if $(CC) doesn't
   support -mtune=generic. GCC 4.1.2 and earlier don't support
   -mtune=generic. When building a generic kernel for a distro
   that runs on i586 and better, it is nice to use
   -march=i586 -mtune=i686 instead of plain -march=i586.

2) Use $(call tune) instead of hardcoded -mtune when CONFIG_MCORE2=y.
   This makes it possible to have CONFIG_MCORE2=y when using GCC 3.3,
   which uses -mcpu instead of -mtune. Also dropped fallback to
   -mtune=generic and -mtune=i686, because -march=i686 already
   implies -mtune=i686.

The patch is against 2.6.20, but Makefile.cpu hasn't changed recently.

--- linux-2.6.20/arch/i386/Makefile.cpu.orig	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.20/arch/i386/Makefile.cpu	2007-02-28 21:22:47.000000000 +0200
@@ -4,9 +4,9 @@
 #-mtune exists since gcc 3.4
 HAS_MTUNE	:= $(call cc-option-yn, -mtune=i386)
 ifeq ($(HAS_MTUNE),y)
-tune		= $(call cc-option,-mtune=$(1),)
+tune		= $(call cc-option,-mtune=$(1),$(2))
 else
-tune		= $(call cc-option,-mcpu=$(1),)
+tune		= $(call cc-option,-mcpu=$(1),$(2))
 endif
 
 align := $(cc-option-align)
@@ -32,7 +32,7 @@
 cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
-cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call cc-option,-mtune=core2,$(call cc-option,-mtune=generic,-mtune=i686))
+cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
 
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
@@ -42,5 +42,5 @@
 
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
-cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic)
+cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
