Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZKXBNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZKXBNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZKXBNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:13:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:59109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbZKXBNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:13:21 -0500
Date: Tue, 24 Nov 2009 01:13:00 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: is_untracked_pat_range() takes a normal semiclosed range
Message-ID: <tip-8a27138924f64d2f30c1022f909f74480046bc3f@git.kernel.org>
Git-Commit-ID: 8a27138924f64d2f30c1022f909f74480046bc3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a27138924f64d2f30c1022f909f74480046bc3f
Gitweb:     http://git.kernel.org/tip/8a27138924f64d2f30c1022f909f74480046bc3f
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 23 Nov 2009 14:49:20 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Nov 2009 17:09:59 -0800

x86, mm: is_untracked_pat_range() takes a normal semiclosed range

is_untracked_pat_range() -- like its components, is_ISA_range() and
is_GRU_range(), takes a normal semiclosed interval (>=, <) whereas the
PAT code called it as if it took a closed range (>=, <=).  Fix.

Although this is a bug, I believe it is non-manifest, simply because
none of the callers will call this with non-page-aligned addresses.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20091119202341.GA4420@sgi.com>
---
 arch/x86/include/asm/pgtable.h |    2 +-
 arch/x86/mm/pat.c              |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1de2094..a34c785 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -274,7 +274,7 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 	/*
 	 * PAT type is always WB for untracked ranges, so no need to check.
 	 */
-	if (x86_platform.is_untracked_pat_range(paddr, paddr + size - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + size))
 		return 1;
 
 	/*
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 38a66ef..b5bc08c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -394,7 +394,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (x86_platform.is_untracked_pat_range(start, end - 1)) {
+	if (x86_platform.is_untracked_pat_range(start, end)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -505,7 +505,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (x86_platform.is_untracked_pat_range(start, end - 1))
+	if (x86_platform.is_untracked_pat_range(start, end))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
@@ -588,7 +588,7 @@ static unsigned long lookup_memtype(u64 paddr)
 	int rettype = _PAGE_CACHE_WB;
 	struct memtype *entry;
 
-	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
 		return rettype;
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
