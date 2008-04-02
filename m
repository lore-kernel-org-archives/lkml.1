Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYDBRgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYDBRgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYDBRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:36:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60919 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753652AbYDBRgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:36:06 -0400
Date: Wed, 2 Apr 2008 10:33:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
In-Reply-To: <20080401230322.331c50f4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
 <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Andrew Morton wrote:

> On Wed, 02 Apr 2008 09:40:22 +0400 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
> > Hi Andrew,
> > 
> > MIPS build fails with the following:
> > 
> > $ make ARCH=mips CROSS_COMPILE=mips-unknown-linux-gnu-
> > ...
> > [skipped]
> > ...
> >   CC      arch/mips/mips-boards/generic/init.o
> > In file included from include/asm/cacheflush.h:13,
> >                  from arch/mips/mips-boards/generic/init.c:30:
> > include/linux/mm.h:411:63: "NR_PAGEFLAGS" is not defined
> > include/linux/mm.h:459:62: "NR_PAGEFLAGS" is not defined
> > make[1]: *** [arch/mips/mips-boards/generic/init.o] Error 1
> > make: *** [arch/mips/mips-boards/generic] Error 2
> 
> ahh, yup, known problem, sorry.  We are slowly working on a fix.

This the fix that I posted a couple of days ago after Andrew noted the 
problem:




From: Christoph Lameter <clameter@sgi.com>
Subject: Allow override of definition for asm constant

MIPS has a different way of defining asm constants which causes troubles
for bounds.h generation (see also the Kbuild script).

Add a new per arch CONFIG variable

	CONFIG_ASM_SYMBOL_PREFIX

which can be set to define an alternate header for asm constant definitions.
Use this for MIPS to make bounds determination work right.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/mips/Kconfig |    7 +++++++
 kernel/bounds.c   |   11 ++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc5-mm1/arch/mips/Kconfig
===================================================================
--- linux-2.6.25-rc5-mm1.orig/arch/mips/Kconfig	2008-03-31 13:14:26.888383587 -0700
+++ linux-2.6.25-rc5-mm1/arch/mips/Kconfig	2008-03-31 13:14:28.028403612 -0700
@@ -2019,6 +2019,13 @@ config I8253
 config ZONE_DMA32
 	bool
 
+#
+# Used to override gas symbol setup in kernel/bounds.c.
+#
+config ASM_SYMBOL_PREFIX
+	string
+	default "@@@#define "
+
 source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
Index: linux-2.6.25-rc5-mm1/kernel/bounds.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/kernel/bounds.c	2008-03-31 13:14:26.904383870 -0700
+++ linux-2.6.25-rc5-mm1/kernel/bounds.c	2008-03-31 13:14:28.028403612 -0700
@@ -9,8 +9,17 @@
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 
+#ifdef CONFIG_ASM_SYMBOL_PREFIX
+#define PREFIX CONFIG_ASM_SYMBOL_PREFIX
+#else
+/*
+ * Standard gas way of defining an asm symbol
+ */
+#define PREFIX "->"
+#endif
+
 #define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+	asm volatile("\n" PREFIX #sym " %0 " : : "i" (val))
 
 #define BLANK() asm volatile("\n->" : :)
 
