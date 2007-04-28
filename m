Return-Path: <linux-kernel-owner+w=401wt.eu-S1163324AbXD1Rxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163324AbXD1Rxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163304AbXD1Rxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:38 -0400
Received: from ns.suse.de ([195.135.220.2]:34468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163328AbXD1RxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:53:12 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Lasse Collin <lasse.collin@tukaani.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [31/35] i386: Fix usage of -mtune when X86_GENERIC=y or CONFIG_MCORE2=y
Message-Id: <20070428175257.09774151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Lasse Collin <lasse.collin@tukaani.org>
Hi!

I sent this simple patch to lkml about two weeks ago and also cc'ed 
to Linus, but seems that the patch got ignored. I decided to write to 
you, because you have modified the relevant file most recently.

Below is a copy of the mail that is also available at 
<http://lkml.org/lkml/2007/2/28/230>.

Signed-off-by: Andi Kleen <ak@suse.de>

---

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

---
 arch/i386/Makefile.cpu |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/i386/Makefile.cpu
===================================================================
--- linux.orig/arch/i386/Makefile.cpu
+++ linux/arch/i386/Makefile.cpu
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
@@ -33,7 +33,7 @@ cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)		+= -march=i686
-cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call cc-option,-mtune=core2,$(call cc-option,-mtune=generic,-mtune=i686))
+cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
 
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
@@ -43,5 +43,5 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pen
 
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
-cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic)
+cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
