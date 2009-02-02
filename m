Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZBBXAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZBBXAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBBXA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:00:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZBBXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:00:27 -0500
Message-ID: <49877B04.10405@zytor.com>
Date: Mon, 02 Feb 2009 15:00:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: x86@kernel.org
Subject: x86 patch: embedded platform tests wanted
Content-Type: multipart/mixed;
 boundary="------------020408010608030504000804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020408010608030504000804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I have just committed the attached patch to the -tip tree.  I'm hoping 
it will improve the boot on certain embedded x86 platforms.  In 
particular, it should remove the need for CONFIG_X86_ELAN, which would 
be a good thing.

If you have access to any embedded platforms without KBC, and especially 
Elan, I would really appreciate it if you could test this out and report 
if it works.

	-hpa

--------------020408010608030504000804
Content-Type: text/x-patch;
 name="0001-x86-setup-a20-early-timeout-for-a-nonexistent-keyb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-setup-a20-early-timeout-for-a-nonexistent-keyb.patc";
 filename*1="h"

>From 3bd323a1da42525317e2ce6c93b97b5ba653bc9d Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Mon, 2 Feb 2009 14:52:00 -0800
Subject: [PATCH] x86 setup: a20: early timeout for a nonexistent keyboard controller

When probing the keyboard controller to enable A20, if we get FF back
(which is *possible* as a valid status word, but is extremely
unlikely) then bail after much fewer iterations than we otherwise
would, and abort the attempt to access the KBC.

This hopefully should make it work a lot better for embedded platforms
which don't have a KBC and where the BIOS doesn't implement
INT 15h AX=2401h (and doesn't boot with A20 already enabled.)

If this works, it will be the one remaining use of CONFIG_X86_ELAN as
anything other than a processor type optimization option.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/a20.c |   75 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 4063d63..fba8e9c 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -15,16 +16,23 @@
 #include "boot.h"
 
 #define MAX_8042_LOOPS	100000
+#define MAX_8042_FF	32
 
 static int empty_8042(void)
 {
 	u8 status;
 	int loops = MAX_8042_LOOPS;
+	int ffs   = MAX_8042_FF;
 
 	while (loops--) {
 		io_delay();
 
 		status = inb(0x64);
+		if (status == 0xff) {
+			/* FF is a plausible, but very unlikely status */
+			if (!--ffs)
+				return -1; /* Assume no KBC present */
+		}
 		if (status & 1) {
 			/* Read and discard input data */
 			io_delay();
@@ -118,44 +126,43 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-#if defined(CONFIG_X86_ELAN)
-	/* Elan croaks if we try to touch the KBC */
-	enable_a20_fast();
-	while (!a20_test_long())
-		;
-	return 0;
-#elif defined(CONFIG_X86_VOYAGER)
+#ifdef CONFIG_X86_VOYAGER
 	/* On Voyager, a20_test() is unsafe? */
 	enable_a20_kbc();
 	return 0;
 #else
        int loops = A20_ENABLE_LOOPS;
-	while (loops--) {
-		/* First, check to see if A20 is already enabled
-		   (legacy free, etc.) */
-		if (a20_test_short())
-			return 0;
-
-		/* Next, try the BIOS (INT 0x15, AX=0x2401) */
-		enable_a20_bios();
-		if (a20_test_short())
-			return 0;
-
-		/* Try enabling A20 through the keyboard controller */
-		empty_8042();
-		if (a20_test_short())
-			return 0; /* BIOS worked, but with delayed reaction */
-
-		enable_a20_kbc();
-		if (a20_test_long())
-			return 0;
-
-		/* Finally, try enabling the "fast A20 gate" */
-		enable_a20_fast();
-		if (a20_test_long())
-			return 0;
-	}
-
-	return -1;
+       int kbc_err;
+
+       while (loops--) {
+	       /* First, check to see if A20 is already enabled
+		  (legacy free, etc.) */
+	       if (a20_test_short())
+		       return 0;
+	       
+	       /* Next, try the BIOS (INT 0x15, AX=0x2401) */
+	       enable_a20_bios();
+	       if (a20_test_short())
+		       return 0;
+	       
+	       /* Try enabling A20 through the keyboard controller */
+	       kbc_err = empty_8042();
+
+	       if (a20_test_short())
+		       return 0; /* BIOS worked, but with delayed reaction */
+	
+	       if (!kbc_err) {
+		       enable_a20_kbc();
+		       if (a20_test_long())
+			       return 0;
+	       }
+	       
+	       /* Finally, try enabling the "fast A20 gate" */
+	       enable_a20_fast();
+	       if (a20_test_long())
+		       return 0;
+       }
+       
+       return -1;
 #endif
 }
-- 
1.6.0.6


--------------020408010608030504000804--
