Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0CESkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:40:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab0CESkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:40:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, stephen.chen@atheros.com,
       cliff.holden@atheros.com, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2.6.23..2.6.24] Backport r and q constraints fixes
Date: Fri,  5 Mar 2010 13:40:04 -0500
Message-Id: <1267814404-27394-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit: 811a0fff5d6e80e18e06be88e0fb685f3924bf8f

This patch included on 2.6.25 is required to be backported to compile
both the 2.6.23 and 2.6.24 kernels on x86_64 systems with a modern
toolchain. Otherwise you get this pesky assembly error:

arch/i386/boot/boot.h: Assembler messages:
arch/i386/boot/boot.h:112: Error: bad register name `%dil'

	Author: H. Peter Anvin <hpa@zytor.com>
	Date:   Wed Jan 30 13:33:02 2008 +0100

	    x86 setup: fix constraints in segment accessor functions
	    
	    Fix the operand constraints for the segment accessor functions,
	    {rd,wr}{fs,gs}*.  In particular, the 8-bit functions used "r"
	    constraints instead of "q" constraints.
	    
	    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
	    Signed-off-by: Ingo Molnar <mingo@elte.hu>
	    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch is not likely to be applied upstream as 2.6.23.y and 2.6.24.y
are both dead now. Use at least the latest 2.6.27.y as that is the latest
supported kernel. I put this out there though in case someone also is looking
for a solution and does not have an option to upgrade. May the google cache
be with you.

--- arch/i386/boot/boot.h.orig	2010-01-05 17:03:12.000000000 -0800
+++ arch/i386/boot/boot.h	2010-01-06 00:14:04.000000000 -0800
@@ -109,7 +109,7 @@
 static inline u8 rdfs8(addr_t addr)
 {
 	u8 v;
-	asm volatile("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
 	return v;
 }
 static inline u16 rdfs16(addr_t addr)
@@ -127,21 +127,21 @@
 
 static inline void wrfs8(u8 v, addr_t addr)
 {
-	asm volatile("movb %1,%%fs:%0" : "+m" (*(u8 *)addr) : "r" (v));
+	asm volatile("movb %1,%%fs:%0" : "+m" (*(u8 *)addr) : "qi" (v));
 }
 static inline void wrfs16(u16 v, addr_t addr)
 {
-	asm volatile("movw %1,%%fs:%0" : "+m" (*(u16 *)addr) : "r" (v));
+	asm volatile("movw %1,%%fs:%0" : "+m" (*(u16 *)addr) : "ri" (v));
 }
 static inline void wrfs32(u32 v, addr_t addr)
 {
-	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "r" (v));
+	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
 }
 
 static inline u8 rdgs8(addr_t addr)
 {
 	u8 v;
-	asm volatile("movb %%gs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%gs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
 	return v;
 }
 static inline u16 rdgs16(addr_t addr)
@@ -159,15 +159,15 @@
 
 static inline void wrgs8(u8 v, addr_t addr)
 {
-	asm volatile("movb %1,%%gs:%0" : "+m" (*(u8 *)addr) : "r" (v));
+	asm volatile("movb %1,%%gs:%0" : "+m" (*(u8 *)addr) : "qi" (v));
 }
 static inline void wrgs16(u16 v, addr_t addr)
 {
-	asm volatile("movw %1,%%gs:%0" : "+m" (*(u16 *)addr) : "r" (v));
+	asm volatile("movw %1,%%gs:%0" : "+m" (*(u16 *)addr) : "ri" (v));
 }
 static inline void wrgs32(u32 v, addr_t addr)
 {
-	asm volatile("movl %1,%%gs:%0" : "+m" (*(u32 *)addr) : "r" (v));
+	asm volatile("movl %1,%%gs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
 }
 
 /* Note: these only return true/false, not a signed return value! */
