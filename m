Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZH1N0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZH1N0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZH1N0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:26:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36501 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZH1N0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:26:34 -0400
Message-ID: <4A97DBD2.903@gentoo.org>
Date: Fri, 28 Aug 2009 08:29:54 -0500
From: "Jory A. Pratt" <anarchy@gentoo.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090822 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix Makefile to ensure proper options get passed from gcc
Content-Type: multipart/mixed;
 boundary="------------060500080203080301000803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060500080203080301000803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

if -D__KERNEL__ is not passed via KBUILD_CFLAGS the compiler can have 
options passed by default that will unset
other options such as -ffreestanding or -fno-toplevel-reorder if the 
compiler is passing -fPIE.

refer to fix-fpie-from-being-used.diff

Another option that was suggested from another user was to pass 
-D__KERNEL__ via Kbuild.include, patch is also attached.
either patch would work, There is no risk of breakage, benefit is for 
those who use a hardened toolchain.

fix-cc-options-check.patch

I believe we should pass the option via KBUILD_CFLAGS as to not confuse 
the fact that we are not building CPP code, but rather C code.

Also correct me if I am wrong but last I knew only part of kernel that 
was cpp was qconfig.

-Jory

--------------060500080203080301000803
Content-Type: text/plain;
 name="fix-fpie-from-being-used.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-fpie-from-being-used.diff"

signed off by: Jory A. Pratt <anarchy@gentoo.org>

When -fPIE is pass to cc1 it can't use -ffreestanding or -fno-toplevel-reorder.
This will cause issues in video-vga.c when compiled leaving a user with no video
modes avaliable when booting system.
Many thanks to Vinky for tracking down bug.

--- Makefile~	2009-08-27 21:38:59.809945943 -0500
+++ Makefile	2009-08-27 21:40:04.204922755 -0500
@@ -348,7 +348,8 @@
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
-		   -fno-delete-null-pointer-checks
+		   -fno-delete-null-pointer-checks \
+		   -D__KERNEL__
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)

--------------060500080203080301000803
Content-Type: text/plain;
 name="fix-cc-options-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-cc-options-check.patch"

2009-08-28		Magnus Granberg		<zorry@ume.nu>
		
		#282201
		* scripts/Kbuild.incude		add $(KBUILD_CPPFLAGS)

--- scripts/Kbuild.include.zorry	2009-08-28 01:50:41.000000000 +0000
+++ scripts/Kbuild.include	2009-08-28 01:50:31.000000000 +0000
@@ -105,12 +105,12 @@
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign


--------------060500080203080301000803--
