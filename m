Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbYAQVsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYAQVsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbYAQVl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:25648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326AbYAQVlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:55 -0500
X-ExtLoop1: 1
Date: Thu, 17 Jan 2008 13:41:50 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [-mm Patch] uml: fix a building error
Message-ID: <20080117214150.GA25872@linux-os.sc.intel.com>
References: <20080117105606.ff89e9e9.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com> <20080117211437.GA7573@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117211437.GA7573@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 04:14:37PM -0500, Jeff Dike wrote:
> On Thu, Jan 17, 2008 at 11:38:53AM -0800, Pallipadi, Venkatesh wrote:
> > Apart from unxlate, there is also ioremap_wc which is defined in the
> > same way.
> 
> And while we're on the subject, what's the deal with these, in
> include/asm-x86/io.h?
> 
> #define ioremap_wc ioremap_wc
> #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
> 

If archs want to override the defaults for these two functions, they define
the above and then include asm-generic/iomap.h.

Archs which doesnt want to implement anything in these new funcs just have to
include asm-generic/iomap.h which has the proper stubs.

So, a patch like the below is what is required here for all archs to
include asm-generic iomap.h (without the other patch that
defines null unxlate in asm specific header).

Totally untested.

Thanks,
Venki

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/include/asm-arm/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-arm/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-arm/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -27,6 +27,8 @@
 #include <asm/byteorder.h>
 #include <asm/memory.h>
 
+#include <asm-generic/iomap.h>
+
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
  */
Index: linux-2.6.git/include/asm-avr32/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-avr32/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-avr32/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -10,6 +10,8 @@
 
 #include <asm/arch/io.h>
 
+#include <asm-generic/iomap.h>
+
 /* virt_to_phys will only work when address is in P1 or P2 */
 static __inline__ unsigned long virt_to_phys(volatile void *address)
 {
Index: linux-2.6.git/include/asm-blackfin/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-blackfin/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-blackfin/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -8,6 +8,8 @@
 #endif
 #include <linux/compiler.h>
 
+#include <asm-generic/iomap.h>
+
 /*
  * These are for ISA/PCI shared memory _only_ and should never be used
  * on any other type of memory, including Zorro memory. They are meant to
Index: linux-2.6.git/include/asm-cris/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-cris/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-cris/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -5,6 +5,8 @@
 #include <asm/arch/io.h>
 #include <linux/kernel.h>
 
+#include <asm-generic/iomap.h>
+
 struct cris_io_operations
 {
 	u32 (*read_mem)(void *addr, int size);
Index: linux-2.6.git/include/asm-frv/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-frv/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-frv/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -23,6 +23,8 @@
 #include <asm/mb-regs.h>
 #include <linux/delay.h>
 
+#include <asm-generic/iomap.h>
+
 /*
  * swap functions are sometimes needed to interface little-endian hardware
  */
Index: linux-2.6.git/include/asm-h8300/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-h8300/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-h8300/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -13,6 +13,8 @@
 #error UNKNOWN CPU TYPE
 #endif
 
+#include <asm-generic/iomap.h>
+
 
 /*
  * These are for ISA/PCI shared memory _only_ and should never be used
Index: linux-2.6.git/include/asm-m32r/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-m32r/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-m32r/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -5,6 +5,8 @@
 #include <linux/compiler.h>
 #include <asm/page.h>  /* __va */
 
+#include <asm-generic/iomap.h>
+
 #ifdef __KERNEL__
 
 #define IO_SPACE_LIMIT  0xFFFFFFFF
Index: linux-2.6.git/include/asm-m68knommu/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-m68knommu/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-m68knommu/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -1,6 +1,8 @@
 #ifndef _M68KNOMMU_IO_H
 #define _M68KNOMMU_IO_H
 
+#include <asm-generic/iomap.h>
+
 #ifdef __KERNEL__
 
 
Index: linux-2.6.git/include/asm-ppc/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-ppc/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-ppc/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -10,6 +10,8 @@
 #include <asm/synch.h>
 #include <asm/mmu.h>
 
+#include <asm-generic/iomap.h>
+
 #define SIO_CONFIG_RA	0x398
 #define SIO_CONFIG_RD	0x399
 
Index: linux-2.6.git/include/asm-s390/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-s390/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-s390/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -15,6 +15,8 @@
 
 #include <asm/page.h>
 
+#include <asm-generic/iomap.h>
+
 #define IO_SPACE_LIMIT 0xffffffff
 
 /*
Index: linux-2.6.git/include/asm-sparc/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-sparc/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-sparc/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -11,6 +11,8 @@
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/system.h>
 
+#include <asm-generic/iomap.h>
+
 #define page_to_phys(page)	(((page) - mem_map) << PAGE_SHIFT)
 
 static inline u32 flip_dword (u32 l)
Index: linux-2.6.git/include/asm-sparc64/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-sparc64/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-sparc64/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -9,6 +9,8 @@
 #include <asm/system.h>
 #include <asm/asi.h>
 
+#include <asm-generic/iomap.h>
+
 /* PC crapola... */
 #define __SLOW_DOWN_IO	do { } while (0)
 #define SLOW_DOWN_IO	do { } while (0)
Index: linux-2.6.git/include/asm-um/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-um/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-um/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -3,6 +3,8 @@
 
 #include "asm/page.h"
 
+#include <asm-generic/iomap.h>
+
 #define IO_SPACE_LIMIT 0xdeadbeef /* Sure hope nothing uses this */
 
 static inline int inb(unsigned long i) { return(0); }
Index: linux-2.6.git/include/asm-v850/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-v850/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-v850/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -14,6 +14,8 @@
 #ifndef __V850_IO_H__
 #define __V850_IO_H__
 
+#include <asm-generic/iomap.h>
+
 #define IO_SPACE_LIMIT 0xFFFFFFFF
 
 #define readb(addr) \
Index: linux-2.6.git/include/asm-xtensa/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-xtensa/io.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-xtensa/io.h	2008-01-17 06:39:13.000000000 -0800
@@ -18,6 +18,8 @@
 
 #include <linux/types.h>
 
+#include <asm-generic/iomap.h>
+
 #define XCHAL_KIO_CACHED_VADDR	0xf0000000
 #define XCHAL_KIO_BYPASS_VADDR	0xf8000000
 #define XCHAL_KIO_PADDR		0xf0000000
Index: linux-2.6.git/include/asm-generic/iomap.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/iomap.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-generic/iomap.h	2008-01-17 06:39:39.000000000 -0800
@@ -2,6 +2,7 @@
 #define __GENERIC_IO_H
 
 #include <linux/linkage.h>
+#include <linux/compiler.h>
 #include <asm/byteorder.h>
 
 /*
