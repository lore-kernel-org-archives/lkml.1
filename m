Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYBRRKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYBRRKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYBRRKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:10:25 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:65280 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYBRRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:10:23 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWG2CL-04-7M4-01
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Mon, 18 Feb 2008 18:10:47 +0100
From: "Hans Rosenfeld" <hans.rosenfeld@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix pmd_bad and pud_bad to support huge pages
Message-ID: <20080218171047.GA4091@escobedo.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 18 Feb 2008 17:09:55.0982 (UTC)
 FILETIME=[15914AE0:01C87251]
X-WSS-ID: 6BA7646C2IW12188398-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently stumbled upon a problem in the support for huge pages. If a
program using huge pages does not explicitly unmap them, they remain
mapped (and therefore, are lost) after the program exits.

I observed that the free huge page count in /proc/meminfo decreased when
running my program, and it did not increase after the program exited.
After running the program a few times, no more huge pages could be
allocated.

The reason for this seems to be that the x86 pmd_bad and pud_bad
consider pmd/pud entries having the PSE bit set invalid. I think there
is nothing wrong with this bit being set, it just indicates that the
lowest level of translation has been reached. This bit has to be (and
is) checked after the basic validity of the entry has been checked, like
in this fragment from follow_page() in mm/memory.c:

  if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
          goto no_page_table;

  if (pmd_huge(*pmd)) {
          BUG_ON(flags & FOLL_GET);
          page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
          goto out;
  }

Note that this code currently doesn't work as intended if the pmd refers
to a huge page, the pmd_huge() check can not be reached if the page is
huge.

Extending pmd_bad() (and, for future 1GB page support, pud_bad()) to
allow for the PSE bit being set fixes this. For similar reasons,
allowing the NX bit being set is necessary, too. I have seen huge pages
having the NX bit set in their pmd entry, which would cause the same
problem.




Signed-Off-By: Hans Rosenfeld <hans.rosenfeld@amd.com>

---
 include/asm-x86/pgtable_32.h |    4 +++-
 include/asm-x86/pgtable_64.h |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a842c72..b478efa 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -91,7 +91,9 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define	pmd_bad(x)	((pmd_val(x) \
+			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
+			 != _KERNPG_TABLE)
 
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index bd4740a..02bd4aa 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -153,12 +153,14 @@ static inline unsigned long pgd_bad(pgd_t pgd)
 
 static inline unsigned long pud_bad(pud_t pud)
 {
-	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pud_val(pud) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 static inline unsigned long pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pmd_val(pmd) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 #define pte_none(x)	(!pte_val(x))
-- 
1.5.3.7

-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown


