Return-Path: <linux-kernel-owner+w=401wt.eu-S1765320AbXIUU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765320AbXIUU5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763470AbXIUUpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:50093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762758AbXIUUpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:21 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [37/45] i386: remove -maccumulate-outgoing-args
Message-Id: <20070921204520.3196B14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Contrary to the comment "newer gccs do it by default", newer gcc versions
default to -maccumulate-outgoing-args only with CONFIG_CC_OPTIMIZE_FOR_SIZE=n,
and then only with some CPU settings.

Measured with an i386 defconfig, gcc 4.2.1 and kernel 2.6.23-rc1 ("orig" is
the plain kernel, "changed is with -maccumulate-outgoing-args removed):

$ ls -la vmlinux*
-rwxrwxr-x 1 bunk bunk 6269713 2007-07-24 22:19 vmlinux.changed
-rwxrwxr-x 1 bunk bunk 6425361 2007-07-24 22:19 vmlinux.orig
$ size vmlinux.*
   text    data     bss     dec     hex filename
4493465  504108  614400 5611973  55a1c5 vmlinux.changed
4646160  504108  614400 5764668  57f63c vmlinux.orig
$

That's a 2.5% size increase that does for sure hurt small systems.

If the stack unwinder ever comes back and needs this as indicated in the
comment, adding it to the cflags when the user enabled the unwinder should be
a better option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/Makefile |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/i386/Makefile
===================================================================
--- linux.orig/arch/i386/Makefile
+++ linux/arch/i386/Makefile
@@ -46,10 +46,6 @@ cflags-y += -ffreestanding
 # newer gccs do it by default
 cflags-y += -maccumulate-outgoing-args
 
-# this works around some issues with generating unwind tables in older gccs
-# newer gccs do it by default
-cflags-y += -maccumulate-outgoing-args
-
 # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
 # a lot more stack due to the lack of sharing of stacklots:
 CFLAGS				+= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
