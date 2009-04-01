Return-Path: <linux-kernel-owner+w=401wt.eu-S1764529AbZDAQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764529AbZDAQl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZDAQlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:41:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbZDAQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:41:14 -0400
Date: Wed, 1 Apr 2009 09:40:13 -0700
Message-Id: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 setup BIOS workarounds
In-Reply-To: <20090327171441.GD4363@logo.rdu.rpath.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These three patches work around one identified and two hypothetical
BIOS problems with the E820 memory probe.

The identified problem is one specific box which clobbers %esi; the
other two patches protect %edi and %ebp, and implements handling for
the backwards-incompatible(!) E820 handling in ACPI 3.


The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/setup

H. Peter Anvin (2):
      x86, setup: preemptively save/restore edi and ebp around INT 15 E820
      x86, setup: ACPI 3, BIOS workaround for E820-probing code

Michael K. Johnson (1):
      x86, setup: mark %esi as clobbered in E820 BIOS call

 arch/x86/boot/memory.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 8c3c25f..d5d2360 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -16,24 +17,32 @@
 
 #define SMAP	0x534d4150	/* ASCII "SMAP" */
 
+struct e820_ext_entry {
+	struct e820entry std;
+	u32 ext_flags;
+} __attribute__((packed));
+
 static int detect_memory_e820(void)
 {
 	int count = 0;
 	u32 next = 0;
-	u32 size, id;
+	u32 size, id, edi;
 	u8 err;
 	struct e820entry *desc = boot_params.e820_map;
+	static struct e820_ext_entry buf; /* static so it is zeroed */
 
 	do {
-		size = sizeof(struct e820entry);
+		size = sizeof buf;
 
-		/* Important: %edx is clobbered by some BIOSes,
-		   so it must be either used for the error output
-		   or explicitly marked clobbered. */
-		asm("int $0x15; setc %0"
+		/* Important: %edx and %esi are clobbered by some BIOSes,
+		   so they must be either used for the error output
+		   or explicitly marked clobbered.  Given that, assume there
+		   is something out there clobbering %ebp and %edi, too. */
+		asm("pushl %%ebp; int $0x15; popl %%ebp; setc %0"
 		    : "=d" (err), "+b" (next), "=a" (id), "+c" (size),
-		      "=m" (*desc)
-		    : "D" (desc), "d" (SMAP), "a" (0xe820));
+		      "=D" (edi), "+m" (buf)
+		    : "D" (&buf), "d" (SMAP), "a" (0xe820)
+		    : "esi");
 
 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on
@@ -51,8 +60,14 @@ static int detect_memory_e820(void)
 			break;
 		}
 
+		/* ACPI 3.0 added the extended flags support.  If bit 0
+		   in the extended flags is zero, we're supposed to simply
+		   ignore the entry -- a backwards incompatible change! */
+		if (size > 20 && !(buf.ext_flags & 1))
+			continue;
+
+		*desc++ = buf.std;
 		count++;
-		desc++;
 	} while (next && count < ARRAY_SIZE(boot_params.e820_map));
 
 	return boot_params.e820_entries = count;
