Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYIKIc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYIKIc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYIKIbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:31:51 -0400
Received: from gw.goop.org ([64.81.55.164]:33264 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbYIKIbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:31:50 -0400
Message-ID: <48C8D774.9010705@goop.org>
Date: Thu, 11 Sep 2008 01:31:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] make PFN_PHYS explicitly return phys_addr_t
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
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
 arch/m32r/mm/discontig.c   |    4 ++--
 include/asm-x86/xen/page.h |    4 ++--
 include/linux/pfn.h        |    6 +++++-
 3 files changed, 9 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
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
===================================================================
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
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
===================================================================
--- a/include/linux/pfn.h
+++ b/include/linux/pfn.h
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


