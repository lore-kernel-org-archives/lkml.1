Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbXG2O5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbXG2O5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763666AbXG2O4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:56:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47749 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763150AbXG2O4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:56:45 -0400
Date: Sun, 29 Jul 2007 16:56:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: remove -maccumulate-outgoing-args
Message-ID: <20070729145622.GC16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to the comment "newer gccs do it by default", newer gcc 
versions default to -maccumulate-outgoing-args only with 
CONFIG_CC_OPTIMIZE_FOR_SIZE=n, and then only with some CPU settings.

Measured with an i386 defconfig, gcc 4.2.1 and kernel 2.6.23-rc1
("orig" is the plain kernel, "changed is with -maccumulate-outgoing-args 
removed):

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
comment, adding it to the cflags when the user enabled the unwinder 
should be a better option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/i386/Makefile.old	2007-07-24 22:29:56.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/Makefile	2007-07-24 22:30:16.000000000 +0200
@@ -42,10 +42,6 @@
 # temporary until string.h is fixed
 cflags-y += -ffreestanding
 
-# this works around some issues with generating unwind tables in older gccs
-# newer gccs do it by default
-cflags-y += -maccumulate-outgoing-args
-
 # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
 # a lot more stack due to the lack of sharing of stacklots:
 CFLAGS				+= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
