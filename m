Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0BBBCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:02:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:51465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0BBBCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:02:35 -0500
Date: Tue, 2 Feb 2010 01:01:34 GMT
From: tip-bot for Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, andi@firstfloor.org, akpm@linux-foundation.org,
       tglx@linutronix.de, fengguang.wu@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, yinghai@kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, fengguang.wu@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20100122033004.470767217@intel.com>
References: <20100122033004.470767217@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use the generic page_is_ram()
Message-ID: <tip-13ca0fcaa33f6b1984c4111b6ec5df42689fea6f@git.kernel.org>
Git-Commit-ID: 13ca0fcaa33f6b1984c4111b6ec5df42689fea6f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 01:01:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13ca0fcaa33f6b1984c4111b6ec5df42689fea6f
Gitweb:     http://git.kernel.org/tip/13ca0fcaa33f6b1984c4111b6ec5df42689fea6f
Author:     Wu Fengguang <fengguang.wu@intel.com>
AuthorDate: Fri, 22 Jan 2010 11:21:05 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Feb 2010 16:58:17 -0800

x86: Use the generic page_is_ram()

The generic resource based page_is_ram() works better with memory
hotplug/hotremove. So switch the x86 e820map based code to it.

CC: Andi Kleen <andi@firstfloor.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20100122033004.470767217@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/mm/ioremap.c             |   21 ---------------------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 642fe34..a667f24 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -40,7 +40,6 @@
 
 #ifndef __ASSEMBLY__
 
-extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 30e068d..1bf9e08 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -24,27 +24,6 @@
 
 #include "physaddr.h"
 
-int page_is_ram(unsigned long pagenr)
-{
-	resource_size_t addr, end;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		/*
-		 * Not usable memory:
-		 */
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		addr = (e820.map[i].addr + PAGE_SIZE-1) >> PAGE_SHIFT;
-		end = (e820.map[i].addr + e820.map[i].size) >> PAGE_SHIFT;
-
-
-		if ((pagenr >= addr) && (pagenr < end))
-			return 1;
-	}
-	return 0;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
