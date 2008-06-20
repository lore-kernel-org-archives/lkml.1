Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYFTDdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYFTDdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 23:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYFTDde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 23:33:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55191
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbYFTDdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 23:33:33 -0400
Date: Thu, 19 Jun 2008 20:33:32 -0700 (PDT)
Message-Id: <20080619.203332.129759828.davem@davemloft.net>
To: bunk@kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SPARC64_PAGE_SIZE_4MB build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080525185821.GJ1791@cs181133002.pp.htv.fi>
References: <20080525185821.GJ1791@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 25 May 2008 21:58:21 +0300

> During a compile test I ran into the following build error caused with 
> CONFIG_SPARC64_PAGE_SIZE_4MB:

Adrian, thanks again for this report.

Since I know this stuff doesn't work anyways, and has several other
problems (see commit message for details) I think I'll solve this like
so:

sparc64: Remove 4MB and 512K base page size options.

Adrian Bunk reported that enabling 4MB page size breaks the build.
The problem is that MAX_ORDER combined with the page shift exceeds the
SECTION_SIZE_BITS we use in asm-sparc64/sparsemem.h

There are several ways I suppose we could work around this.  For one
we could define a CONFIG_FORCE_MAX_ZONEORDER to decrease MAX_ORDER in
these higher page size cases.

But I also know that these page size cases are broken wrt. TLB miss
handling especially on pre-hypervisor systems, and there isn't an easy
way to fix that.

These options were meant to be fun experimental hacks anyways, and
only 8K and 64K make any sense to support.

So remove 512K and 4M base page size support.  Of course, we still
support these page sizes for huge pages.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/Kconfig          |   11 +----------
 arch/sparc64/lib/copy_page.S  |    6 +++---
 arch/sparc64/mm/tsb.c         |    6 ------
 include/asm-sparc64/mmu.h     |    4 ----
 include/asm-sparc64/page.h    |    4 ----
 include/asm-sparc64/pgtable.h |    6 ------
 6 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index eb36f3b..066fb07 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -91,19 +91,11 @@ config SPARC64_PAGE_SIZE_8KB
 	  8KB and 64KB work quite well, since SPARC ELF sections
 	  provide for up to 64KB alignment.
 
-	  Therefore, 512KB and 4MB are for expert hackers only.
-
 	  If you don't know what to do, choose 8KB.
 
 config SPARC64_PAGE_SIZE_64KB
 	bool "64KB"
 
-config SPARC64_PAGE_SIZE_512KB
-	bool "512KB"
-
-config SPARC64_PAGE_SIZE_4MB
-	bool "4MB"
-
 endchoice
 
 config SECCOMP
@@ -223,11 +215,10 @@ config HUGETLB_PAGE_SIZE_4MB
 	bool "4MB"
 
 config HUGETLB_PAGE_SIZE_512K
-	depends on !SPARC64_PAGE_SIZE_4MB && !SPARC64_PAGE_SIZE_512KB
 	bool "512K"
 
 config HUGETLB_PAGE_SIZE_64K
-	depends on !SPARC64_PAGE_SIZE_4MB && !SPARC64_PAGE_SIZE_512KB && !SPARC64_PAGE_SIZE_64KB
+	depends on !SPARC64_PAGE_SIZE_64KB
 	bool "64K"
 
 endchoice
diff --git a/arch/sparc64/lib/copy_page.S b/arch/sparc64/lib/copy_page.S
index 3746066..b243d3b 100644
--- a/arch/sparc64/lib/copy_page.S
+++ b/arch/sparc64/lib/copy_page.S
@@ -25,9 +25,9 @@
 
 #define	DCACHE_SIZE	(PAGE_SIZE * 2)
 
-#if (PAGE_SHIFT == 13) || (PAGE_SHIFT == 19)
+#if (PAGE_SHIFT == 13)
 #define PAGE_SIZE_REM	0x80
-#elif (PAGE_SHIFT == 16) || (PAGE_SHIFT == 22)
+#elif (PAGE_SHIFT == 16)
 #define PAGE_SIZE_REM	0x100
 #else
 #error Wrong PAGE_SHIFT specified
@@ -198,7 +198,7 @@ cheetah_copy_page_insn:
 	cmp		%o2, PAGE_SIZE_REM
 	bne,pt		%xcc, 1b
 	 add		%o0, 0x40, %o0
-#if (PAGE_SHIFT == 16) || (PAGE_SHIFT == 22)
+#if (PAGE_SHIFT == 16)
 	TOUCH(f0, f2, f4, f6, f8, f10, f12, f14)
 	ldda		[%o1] ASI_BLK_P, %f32
 	stda		%f48, [%o0] %asi
diff --git a/arch/sparc64/mm/tsb.c b/arch/sparc64/mm/tsb.c
index fe70c8a..3547937 100644
--- a/arch/sparc64/mm/tsb.c
+++ b/arch/sparc64/mm/tsb.c
@@ -96,12 +96,6 @@ void flush_tsb_user(struct mmu_gather *mp)
 #elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
 #define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_64K
 #define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_64K
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_512KB)
-#define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_512K
-#define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_512K
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_4MB)
-#define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_4MB
-#define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_4MB
 #else
 #error Broken base page size setting...
 #endif
diff --git a/include/asm-sparc64/mmu.h b/include/asm-sparc64/mmu.h
index 8abc58f..9067dc5 100644
--- a/include/asm-sparc64/mmu.h
+++ b/include/asm-sparc64/mmu.h
@@ -34,10 +34,6 @@
 #define CTX_PGSZ_BASE	CTX_PGSZ_8KB
 #elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
 #define CTX_PGSZ_BASE	CTX_PGSZ_64KB
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_512KB)
-#define CTX_PGSZ_BASE	CTX_PGSZ_512KB
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_4MB)
-#define CTX_PGSZ_BASE	CTX_PGSZ_4MB
 #else
 #error No page size specified in kernel configuration
 #endif
diff --git a/include/asm-sparc64/page.h b/include/asm-sparc64/page.h
index 93f0881..a8a2bba 100644
--- a/include/asm-sparc64/page.h
+++ b/include/asm-sparc64/page.h
@@ -7,10 +7,6 @@
 #define PAGE_SHIFT   13
 #elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
 #define PAGE_SHIFT   16
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_512KB)
-#define PAGE_SHIFT   19
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_4MB)
-#define PAGE_SHIFT   22
 #else
 #error No page size specified in kernel configuration
 #endif
diff --git a/include/asm-sparc64/pgtable.h b/include/asm-sparc64/pgtable.h
index b870177..51f640f 100644
--- a/include/asm-sparc64/pgtable.h
+++ b/include/asm-sparc64/pgtable.h
@@ -161,12 +161,6 @@
 #elif PAGE_SHIFT == 16
 #define _PAGE_SZBITS_4U	_PAGE_SZ64K_4U
 #define _PAGE_SZBITS_4V	_PAGE_SZ64K_4V
-#elif PAGE_SHIFT == 19
-#define _PAGE_SZBITS_4U	_PAGE_SZ512K_4U
-#define _PAGE_SZBITS_4V	_PAGE_SZ512K_4V
-#elif PAGE_SHIFT == 22
-#define _PAGE_SZBITS_4U	_PAGE_SZ4MB_4U
-#define _PAGE_SZBITS_4V	_PAGE_SZ4MB_4V
 #else
 #error Wrong PAGE_SHIFT specified
 #endif
-- 
1.5.6

