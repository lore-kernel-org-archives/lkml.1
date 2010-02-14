Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0BNUr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:47:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:45517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0BNUrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:47:55 -0500
Message-ID: <4B786110.9020806@kernel.org>
Date: Sun, 14 Feb 2010 12:46:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-28-git-send-email-yinghai@kernel.org> <20100215011615.e3d35121.sfr@canb.auug.org.au>
In-Reply-To: <20100215011615.e3d35121.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 06:16 AM, Stephen Rothwell wrote:
> Hi,
> 
> On Wed, 10 Feb 2010 01:20:31 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> from arch/x86 to kernel/
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/include/asm/e820.h      |    2 +-
>>  arch/x86/include/asm/early_res.h |   21 --
>>  arch/x86/kernel/Makefile         |    2 +-
>>  arch/x86/kernel/e820.c           |    1 -
>>  arch/x86/kernel/early_res.c      |  523 --------------------------------------
>>  include/linux/early_res.h        |   21 ++
>>  kernel/Makefile                  |    2 +-
>>  kernel/early_res.c               |  522 +++++++++++++++++++++++++++++++++++++
>>  8 files changed, 546 insertions(+), 548 deletions(-)
>>  delete mode 100644 arch/x86/include/asm/early_res.h
>>  delete mode 100644 arch/x86/kernel/early_res.c
>>  create mode 100644 include/linux/early_res.h
>>  create mode 100644 kernel/early_res.c
> 
> From a powerpc pseries_defconfig build (and other configs) of tip/master
> (9d4a5dc3080c811f36bf8175f2de1f9a6f84b176 "Merge branch 'perf/urgent'"):
> 
> kernel/early_res.c:209: error: 'max_pfn_mapped' undeclared (first use in this function)
> 
> max_pfn_mapped is only defined for x86.
> 


please check

Subject: [PATCH -v2] x86: fix cross-arch compiling

Ingo found:
lots of cross-arch build failures in latest -tip:

/home/mingo/tip/kernel/early_res.c: In function '__check_and_double_early_res':
/home/mingo/tip/kernel/early_res.c:209: error: 'max_pfn_mapped' undeclared (first use in this function)
/home/mingo/tip/kernel/early_res.c:209: error: (Each undeclared identifier is reported only once
/home/mingo/tip/kernel/early_res.c:209: error: for each function it appears in.)
make[2]: *** [kernel/early_res.o] Error 1

max_pfn_mapped only defined in x86...

so add get_max_mapped function...

-v2: use that in get_free_all_memory_range() too

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c    |    9 +++++++++
 include/linux/early_res.h |    1 +
 kernel/early_res.c        |   13 ++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -752,6 +752,15 @@ u64 __init find_fw_memmap_area(u64 start
 {
 	return find_e820_area(start, end, size, align);
 }
+
+u64 __init get_max_mapped(void)
+{
+	u64 end = max_pfn_mapped;
+
+	end <<= PAGE_SHIFT;
+
+	return end;
+}
 /*
  * Find next free range after *start
  */
Index: linux-2.6/include/linux/early_res.h
===================================================================
--- linux-2.6.orig/include/linux/early_res.h
+++ linux-2.6/include/linux/early_res.h
@@ -13,6 +13,7 @@ u64 find_early_area(u64 ei_start, u64 ei
 u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 			 u64 *sizep, u64 align);
 u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
+u64 get_max_mapped(void);
 #include <linux/range.h>
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -184,6 +184,13 @@ u64 __init __weak find_fw_memmap_area(u6
 	return -1ULL;
 }
 
+u64 __init __weak get_max_mapped(void)
+{
+	panic("should have get_max_mapped defined with arch");
+
+	return -1ULL;
+}
+
 static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
 {
 	u64 start, end, size, mem;
@@ -206,7 +213,7 @@ static void __init __check_and_double_ea
 					 sizeof(struct early_res));
 	if (mem == -1ULL) {
 		start = ex_end;
-		end = max_pfn_mapped << PAGE_SHIFT;
+		end = get_max_mapped();
 		if (start + size < end)
 			mem = find_fw_memmap_area(start, end, size,
 						 sizeof(struct early_res));
@@ -342,11 +349,11 @@ int __init get_free_all_memory_range(str
 	count *= 2;
 
 	size = sizeof(struct range) * count;
+	end = get_max_mapped();
 #ifdef MAX_DMA32_PFN
-	if (max_pfn_mapped > MAX_DMA32_PFN)
+	if (end > (MAX_DMA32_PFN << PAGE_SHIFT))
 		start = MAX_DMA32_PFN << PAGE_SHIFT;
 #endif
-	end = max_pfn_mapped << PAGE_SHIFT;
 	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
 	if (mem == -1ULL)
 		panic("can not find more space for range free");
