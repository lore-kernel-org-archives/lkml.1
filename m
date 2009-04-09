Return-Path: <linux-kernel-owner+w=401wt.eu-S937215AbZDIXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937215AbZDIXNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZDIXNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:13:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:54248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216AbZDIXNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:13:22 -0400
Date: Thu, 9 Apr 2009 23:13:00 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the core boot code
Message-ID: <tip-df7699c56421c0476704f24a43409ac8c505f3d2@git.kernel.org>
Git-Commit-ID: df7699c56421c0476704f24a43409ac8c505f3d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:13:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df7699c56421c0476704f24a43409ac8c505f3d2
Gitweb:     http://git.kernel.org/tip/df7699c56421c0476704f24a43409ac8c505f3d2
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:13:46 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:11 -0700

x86, setup: "glove box" BIOS interrupts in the core boot code

Impact: BIOS proofing

"Glove box" off BIOS interrupts in the core boot code.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


---
 arch/x86/boot/a20.c    |    9 +++--
 arch/x86/boot/main.c   |   39 ++++++++++++----------
 arch/x86/boot/memory.c |   81 +++++++++++++++++++++++------------------------
 arch/x86/boot/tty.c    |   52 ++++++++++++++++--------------
 4 files changed, 95 insertions(+), 86 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 7c19ce8..64a31a6 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -2,7 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
- *   Copyright 2009 Intel Corporation
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -90,8 +90,11 @@ static int a20_test_long(void)
 
 static void enable_a20_bios(void)
 {
-	asm volatile("pushfl; int $0x15; popfl"
-		     : : "a" ((u16)0x2401));
+	struct biosregs ireg;
+
+	initregs(&ireg);
+	ireg.ax = 0x2401;
+	intcall(0x15, &ireg, NULL);
 }
 
 static void enable_a20_kbc(void)
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 58f0415..140172b 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -61,11 +62,10 @@ static void copy_boot_params(void)
  */
 static void keyboard_set_repeat(void)
 {
-	u16 ax = 0x0305;
-	u16 bx = 0;
-	asm volatile("int $0x16"
-		     : "+a" (ax), "+b" (bx)
-		     : : "ecx", "edx", "esi", "edi");
+	struct biosregs ireg;
+	initregs(&ireg);
+	ireg.ax = 0x0305;
+	intcall(0x16, &ireg, NULL);
 }
 
 /*
@@ -73,18 +73,22 @@ static void keyboard_set_repeat(void)
  */
 static void query_ist(void)
 {
+	struct biosregs ireg, oreg;
+
 	/* Some older BIOSes apparently crash on this call, so filter
 	   it from machines too old to have SpeedStep at all. */
 	if (cpu.level < 6)
 		return;
 
-	asm("int $0x15"
-	    : "=a" (boot_params.ist_info.signature),
-	      "=b" (boot_params.ist_info.command),
-	      "=c" (boot_params.ist_info.event),
-	      "=d" (boot_params.ist_info.perf_level)
-	    : "a" (0x0000e980),	 /* IST Support */
-	      "d" (0x47534943)); /* Request value */
+	initregs(&ireg);
+	ireg.ax  = 0xe980;	 /* IST Support */
+	ireg.edx = 0x47534943;	 /* Request value */
+	intcall(0x15, &ireg, &oreg);
+
+	boot_params.ist_info.signature  = oreg.eax;
+	boot_params.ist_info.command    = oreg.ebx;
+	boot_params.ist_info.event      = oreg.ecx;
+	boot_params.ist_info.perf_level = oreg.edx;
 }
 
 /*
@@ -93,13 +97,12 @@ static void query_ist(void)
 static void set_bios_mode(void)
 {
 #ifdef CONFIG_X86_64
-	u32 eax, ebx;
+	struct biosregs ireg;
 
-	eax = 0xec00;
-	ebx = 2;
-	asm volatile("int $0x15"
-		     : "+a" (eax), "+b" (ebx)
-		     : : "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ax = 0xec00;
+	ireg.bx = 2;
+	intcall(0x15, &ireg, NULL);
 #endif
 }
 
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 5054c2d..d989de8 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -25,12 +25,16 @@ struct e820_ext_entry {
 static int detect_memory_e820(void)
 {
 	int count = 0;
-	u32 next = 0;
-	u32 size, id, edi;
-	u8 err;
+	struct biosregs ireg, oreg;
 	struct e820entry *desc = boot_params.e820_map;
 	static struct e820_ext_entry buf; /* static so it is zeroed */
 
+	initregs(&ireg);
+	ireg.ax  = 0xe820;
+	ireg.cx  = sizeof buf;
+	ireg.edx = SMAP;
+	ireg.di  = (size_t)&buf;
+
 	/*
 	 * Set this here so that if the BIOS doesn't change this field
 	 * but still doesn't change %ecx, we're still okay...
@@ -38,22 +42,13 @@ static int detect_memory_e820(void)
 	buf.ext_flags = 1;
 
 	do {
-		size = sizeof buf;
-
-		/* Important: %edx and %esi are clobbered by some BIOSes,
-		   so they must be either used for the error output
-		   or explicitly marked clobbered.  Given that, assume there
-		   is something out there clobbering %ebp and %edi, too. */
-		asm("pushl %%ebp; int $0x15; popl %%ebp; setc %0"
-		    : "=d" (err), "+b" (next), "=a" (id), "+c" (size),
-		      "=D" (edi), "+m" (buf)
-		    : "D" (&buf), "d" (SMAP), "a" (0xe820)
-		    : "esi");
+		intcall(0x15, &ireg, &oreg);
+		ireg.ebx = oreg.ebx; /* for next iteration... */
 
 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on
 		   the final, failing, probe. */
-		if (err)
+		if (oreg.eflags & X86_EFLAGS_CF)
 			break;
 
 		/* Some BIOSes stop returning SMAP in the middle of
@@ -61,7 +56,7 @@ static int detect_memory_e820(void)
 		   screwed up the map at that point, we might have a
 		   partial map, the full map, or complete garbage, so
 		   just return failure. */
-		if (id != SMAP) {
+		if (oreg.eax != SMAP) {
 			count = 0;
 			break;
 		}
@@ -69,58 +64,62 @@ static int detect_memory_e820(void)
 		/* ACPI 3.0 added the extended flags support.  If bit 0
 		   in the extended flags is zero, we're supposed to simply
 		   ignore the entry -- a backwards incompatible change! */
-		if (size > 20 && !(buf.ext_flags & 1))
+		if (oreg.cx > 20 && !(buf.ext_flags & 1))
 			continue;
 
 		*desc++ = buf.std;
 		count++;
-	} while (next && count < ARRAY_SIZE(boot_params.e820_map));
+	} while (ireg.ebx && count < ARRAY_SIZE(boot_params.e820_map));
 
 	return boot_params.e820_entries = count;
 }
 
 static int detect_memory_e801(void)
 {
-	u16 ax, bx, cx, dx;
-	u8 err;
+	struct biosregs ireg, oreg;
 
-	bx = cx = dx = 0;
-	ax = 0xe801;
-	asm("stc; int $0x15; setc %0"
-	    : "=m" (err), "+a" (ax), "+b" (bx), "+c" (cx), "+d" (dx));
+	initregs(&ireg);
+	ireg.ax = 0xe801;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err)
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;
 
 	/* Do we really need to do this? */
-	if (cx || dx) {
-		ax = cx;
-		bx = dx;
+	if (oreg.cx || oreg.dx) {
+		oreg.ax = oreg.cx;
+		oreg.bx = oreg.dx;
 	}
 
-	if (ax > 15*1024)
+	if (oreg.ax > 15*1024) {
 		return -1;	/* Bogus! */
-
-	/* This ignores memory above 16MB if we have a memory hole
-	   there.  If someone actually finds a machine with a memory
-	   hole at 16MB and no support for 0E820h they should probably
-	   generate a fake e820 map. */
-	boot_params.alt_mem_k = (ax == 15*1024) ? (dx << 6)+ax : ax;
+	} else if (oreg.ax == 15*1024) {
+		boot_params.alt_mem_k = (oreg.dx << 6) + oreg.ax;
+	} else {
+		/*
+		 * This ignores memory above 16MB if we have a memory
+		 * hole there.  If someone actually finds a machine
+		 * with a memory hole at 16MB and no support for
+		 * 0E820h they should probably generate a fake e820
+		 * map.
+		 */
+		boot_params.alt_mem_k = oreg.ax;
+	}
 
 	return 0;
 }
 
 static int detect_memory_88(void)
 {
-	u16 ax;
-	u8 err;
+	struct biosregs ireg, oreg;
 
-	ax = 0x8800;
-	asm("stc; int $0x15; setc %0" : "=bcdm" (err), "+a" (ax));
+	initregs(&ireg);
+	ireg.ah = 0x88;
+	intcall(0x15, &ireg, &oreg);
 
-	boot_params.screen_info.ext_mem_k = ax;
+	boot_params.screen_info.ext_mem_k = oreg.ax;
 
-	return -err;
+	return -(oreg.eflags & X86_EFLAGS_CF); /* 0 or -1 */
 }
 
 int detect_memory(void)
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 7e8e8b2..01ec69c 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -22,24 +23,23 @@
 
 void __attribute__((section(".inittext"))) putchar(int ch)
 {
-	unsigned char c = ch;
+	struct biosregs ireg;
 
-	if (c == '\n')
+	if (ch == '\n')
 		putchar('\r');	/* \n -> \r\n */
 
-	/* int $0x10 is known to have bugs involving touching registers
-	   it shouldn't.  Be extra conservative... */
-	asm volatile("pushal; pushw %%ds; int $0x10; popw %%ds; popal"
-		     : : "b" (0x0007), "c" (0x0001), "a" (0x0e00|ch));
+	initregs(&ireg);
+	ireg.bx = 0x0007;
+	ireg.cx = 0x0001;
+	ireg.ah = 0x0e;
+	ireg.al = ch;
+	intcall(0x10, &ireg, NULL);
 }
 
 void __attribute__((section(".inittext"))) puts(const char *str)
 {
-	int n = 0;
-	while (*str) {
+	while (*str)
 		putchar(*str++);
-		n++;
-	}
 }
 
 /*
@@ -49,14 +49,13 @@ void __attribute__((section(".inittext"))) puts(const char *str)
 
 static u8 gettime(void)
 {
-	u16 ax = 0x0200;
-	u16 cx, dx;
+	struct biosregs ireg, oreg;
 
-	asm volatile("int $0x1a"
-		     : "+a" (ax), "=c" (cx), "=d" (dx)
-		     : : "ebx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x02;
+	intcall(0x1a, &ireg, &oreg);
 
-	return dx >> 8;
+	return oreg.dh;
 }
 
 /*
@@ -64,19 +63,24 @@ static u8 gettime(void)
  */
 int getchar(void)
 {
-	u16 ax = 0;
-	asm volatile("int $0x16" : "+a" (ax));
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+	/* ireg.ah = 0x00; */
+	intcall(0x16, &ireg, &oreg);
 
-	return ax & 0xff;
+	return oreg.al;
 }
 
 static int kbd_pending(void)
 {
-	u8 pending;
-	asm volatile("int $0x16; setnz %0"
-		     : "=qm" (pending)
-		     : "a" (0x0100));
-	return pending;
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+	ireg.ah = 0x01;
+	intcall(0x16, &ireg, &oreg);
+
+	return !(oreg.eflags & X86_EFLAGS_ZF);
 }
 
 void kbd_flush(void)
