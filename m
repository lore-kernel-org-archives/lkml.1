Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbXFRGJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbXFRGJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXFRGJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:09:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47639 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbXFRGJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:09:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
Date: Mon, 18 Jun 2007 02:09:36 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180209.36762.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the macros in msr.h already use __asm__ and __volatile__, this patch
brings the rest into line.  This is needed since these get exported into
userspace (need to use strict __asm__ vs asm when gcc compiles with GNU
extensions turned off).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-x86_64/msr.h b/include/asm-x86_64/msr.h
index d5c55b8..ed15d2b 100644
--- a/include/asm-x86_64/msr.h
+++ b/include/asm-x86_64/msr.h
@@ -33,7 +33,7 @@
 
 /* wrmsr with exception handling */
 #define wrmsr_safe(msr,a,b) ({ int ret__;			\
-	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
+	__asm__ __volatile__("2: wrmsr ; xorl %0,%0\n"			\
 		     "1:\n\t"					\
 		     ".section .fixup,\"ax\"\n\t"		\
 		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
@@ -50,7 +50,7 @@
 
 #define rdmsr_safe(msr,a,b) \
 	({ int ret__;						\
-	  asm volatile ("1:       rdmsr\n"			\
+	  __asm__ __volatile__ ("1:       rdmsr\n"			\
                       "2:\n"					\
                       ".section .fixup,\"ax\"\n"		\
                       "3:       movl %4,%0\n"			\
@@ -70,17 +70,17 @@
      __asm__ __volatile__ ("rdtsc" : "=a" (low) : : "edx")
 
 #define rdtscp(low,high,aux) \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
+     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
 
 #define rdtscll(val) do { \
      unsigned int __a,__d; \
-     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
+     __asm__ __volatile__("rdtsc" : "=a" (__a), "=d" (__d)); \
      (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
 } while(0)
 
 #define rdtscpll(val, aux) do { \
      unsigned long __a, __d; \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
+     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
      (val) = (__d << 32) | __a; \
 } while (0)
 
