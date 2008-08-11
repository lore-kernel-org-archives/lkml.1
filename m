Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYHKTjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYHKTjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYHKTjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:39:39 -0400
Received: from gw.goop.org ([64.81.55.164]:58118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYHKTjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:39:39 -0400
Message-ID: <48A09550.60502@goop.org>
Date: Mon, 11 Aug 2008 12:38:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] make PFN_PHYS explicitly return phys_addr_t
References: <489B6B40.5050705@goop.org>	<20080807145648.ab3dfa90.akpm@linux-foundation.org>	<489B72C3.30603@goop.org>	<20080807162741.8dfcd336.akpm@linux-foundation.org>	<489B8908.2010007@goop.org> <20080807170617.79ca3ce7.akpm@linux-foundation.org>
In-Reply-To: <20080807170617.79ca3ce7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PFN_PHYS, as its name suggests, turns a pfn into a physical address.
However, it is a macro which just operates on its argument without
modifying its type.  pfns are typed unsigned long, but an unsigned
long may not be long enough to hold a physical address (32-bit systems
with more than 32 bits of physcial address).

Make sure we cast to phys_addr_t to return a complete result.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/m32r/mm/discontig.c   |    2 +-
 include/asm-x86/xen/page.h |    4 ++--
 include/linux/pfn.h        |    6 +++++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -r 6b03eb6361dd arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c	Mon Aug 11 11:19:24 2008 -0700
+++ b/arch/m32r/mm/discontig.c	Mon Aug 11 11:20:07 2008 -0700
@@ -112,9 +112,9 @@
 				initrd_start, INITRD_SIZE);
 		} else {
 			printk("initrd extends beyond end of memory "
-				"(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+				"(0x%08lx > 0x%08llx)\ndisabling initrd\n",
 				INITRD_START + INITRD_SIZE,
-				PFN_PHYS(max_low_pfn));
+			        (unsigned long long)PFN_PHYS(max_low_pfn));
 
 			initrd_start = 0;
 		}
diff -r 6b03eb6361dd include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h	Mon Aug 11 11:19:24 2008 -0700
+++ b/include/asm-x86/xen/page.h	Mon Aug 11 11:20:07 2008 -0700
@@ -76,13 +76,13 @@
 static inline xmaddr_t phys_to_machine(xpaddr_t phys)
 {
 	unsigned offset = phys.paddr & ~PAGE_MASK;
-	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+	return XMADDR(PFN_PHYS(pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
 }
 
 static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 {
 	unsigned offset = machine.maddr & ~PAGE_MASK;
-	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+	return XPADDR(PFN_PHYS(mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
 }
 
 /*
diff -r 6b03eb6361dd include/linux/pfn.h
--- a/include/linux/pfn.h	Mon Aug 11 11:19:24 2008 -0700
+++ b/include/linux/pfn.h	Mon Aug 11 11:20:07 2008 -0700
@@ -1,9 +1,13 @@
 #ifndef _LINUX_PFN_H_
 #define _LINUX_PFN_H_
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif
 
 #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
-#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
+#define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
 
 #endif


