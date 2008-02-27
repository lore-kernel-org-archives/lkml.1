Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbYB0VBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbYB0VBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbYB0VAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:11691 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbYB0VAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=BnBYU6aZu2q7Fn05wFyWXLhTWUAKxT5hjn5aa1XquixMg5gmOvMtPW/iDKZ77/VULjixxy6ni9gCacxa9e4Lt6mkTc0Yo//W2XQMnKnabGGR4NmzYVVYO1F+sYhDPXwqbn+IUlXtnWbK6xfVhzUPCeNKDNgGbpg7702U3xn5bNU=
Message-Id: <20080227210002.282887337@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:32 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 01/10] arm: vmlinux.lds.S cleanup - use PERCPU, PAGE_SIZE macroses
Content-Disposition: inline; filename=arm-vmlinux-cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies PAGE_SIZE definition to be able to
include it into vmlinux.lds.S script and use it then

Also PERCPU macros is used instead of explicit section
declaration

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 arch/arm/kernel/vmlinux.lds.S |   21 ++++++++++-----------
 include/asm-arm/page.h        |    4 +++-
 2 files changed, 13 insertions(+), 12 deletions(-)

Index: linux-2.6.git/arch/arm/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/arm/kernel/vmlinux.lds.S	2008-02-10 10:46:36.000000000 +0300
+++ linux-2.6.git/arch/arm/kernel/vmlinux.lds.S	2008-02-27 20:34:47.000000000 +0300
@@ -5,8 +5,9 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/thread_info.h>
+#include <asm/page.h>
 #include <asm/memory.h>
-	
+
 OUTPUT_ARCH(arm)
 ENTRY(stext)
 
@@ -63,15 +64,13 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
-		__per_cpu_start = .;
-			*(.data.percpu)
-			*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
+
+		PERCPU(PAGE_SIZE)
+
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		INIT_DATA
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 #endif
 	}
@@ -128,17 +127,17 @@ SECTIONS
 		*(.data.init_task)
 
 #ifdef CONFIG_XIP_KERNEL
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
 		INIT_DATA
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 #endif
 
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__nosave_begin = .;
 		*(.data.nosave)
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 
 		/*
Index: linux-2.6.git/include/asm-arm/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-arm/page.h	2008-02-09 12:09:28.000000000 +0300
+++ linux-2.6.git/include/asm-arm/page.h	2008-02-27 20:38:59.000000000 +0300
@@ -10,9 +10,11 @@
 #ifndef _ASMARM_PAGE_H
 #define _ASMARM_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT		12
-#define PAGE_SIZE		(1UL << PAGE_SHIFT)
+#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 /* to align the pointer to the (next) page boundary */

-- 
