Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbZHWCbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbZHWCbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 22:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933435AbZHWCbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 22:31:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:62291 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434AbZHWCbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 22:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IINutzx2Nbte+LaypPb97FHUOA8SZkUuxoiE2kGGFBNa/xrCUjEUq+1qDWnQzScEKo
         boiOE9niUpXw7e2TulGDHRAFDns71HRuw+BID9gbY41QeZF5KOrAejo5b+1X7z+qOWI9
         atZRdyB3coMbltH2BJXc27FjAt4Cp2uRY98uo=
Message-ID: <4A90AADE.20307@gmail.com>
Date: Sun, 23 Aug 2009 10:35:10 +0800
From: Xiao Guangrong <ericxiao.gr@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org
Subject: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Some fixed_addresses items are only used when system boot, after
boot, they are free but no way to use, like early ioremap area.
They are wasted for us, we can reuse them after system boot.

In this patch, we put them in permanent kmap's area and expand
vmalloc's address range. In boot time, reserve them in
permanent_kmaps_init() to avoid multiple used, after system boot,
we unreserved them then user can use it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/fixmap.h           |    2 ++
 arch/x86/include/asm/pgtable_32_types.h |    4 ++--
 arch/x86/mm/init_32.c                   |    8 ++++++++
 include/linux/highmem.h                 |    2 ++
 mm/highmem.c                            |   26 ++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7b2d71d..604f135 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -142,6 +142,8 @@ extern void reserve_top_address(unsigned long reserve);
 #define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
 #define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
+#define FIXMAP_REUSE		(__end_of_fixed_addresses - 	\
+				 __end_of_permanent_fixed_addresses)
 
 extern int fixmaps_set;
 
diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index 5e67c15..328b8af 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -37,8 +37,8 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #define LAST_PKMAP 1024
 #endif
 
-#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
-		    & PMD_MASK)
+#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP -	\
+		    FIXMAP_REUSE + 1)) & PMD_MASK)
 
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..595e485 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -410,8 +410,16 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pmd = pmd_offset(pud, vaddr);
 	pte = pte_offset_kernel(pmd, vaddr);
 	pkmap_page_table = pte;
+	kmaps_reserve(LAST_PKMAP-FIXMAP_REUSE, LAST_PKMAP-1);
 }
 
+static int __init permanent_kmaps_unreserve(void)
+{
+	kmaps_unreserve(LAST_PKMAP-FIXMAP_REUSE, LAST_PKMAP-1);
+	return 0;
+}
+late_initcall(permanent_kmaps_unreserve);
+
 static void __init add_one_highpage_init(struct page *page, int pfn)
 {
 	ClearPageReserved(page);
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 211ff44..984c4c9 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -41,6 +41,8 @@ unsigned int nr_free_highpages(void);
 extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
+void kmaps_reserve(int start, int end);
+void kmaps_unreserve(int start, int end);
 
 #else /* CONFIG_HIGHMEM */
 
diff --git a/mm/highmem.c b/mm/highmem.c
index 25878cc..a481fa7 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -85,6 +85,32 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+void kmaps_reserve(int start, int end)
+{
+	int i;
+
+	lock_kmap();
+	for (i = start; i <= end; i++) {
+		BUG_ON(pkmap_count[i]);
+		pkmap_count[i] = -1;
+	}
+	unlock_kmap();
+}
+
+void kmaps_unreserve(int start, int end)
+{
+	int i;
+
+	lock_kmap();
+	for (i = start; i <= end; i++) {
+		BUG_ON(pkmap_count[i] != -1);
+		pkmap_count[i] = 0;
+	}
+
+	flush_tlb_kernel_range(PKMAP_ADDR(start), PKMAP_ADDR(end));
+	unlock_kmap();
+}
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
-- 
1.6.0.4


