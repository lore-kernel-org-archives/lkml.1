Return-Path: <linux-kernel-owner+w=401wt.eu-S938142AbZDJMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938142AbZDJMhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937770AbZDJMgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:36:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:45713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937270AbZDJMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:36:11 -0400
Date: Fri, 10 Apr 2009 12:34:43 GMT
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212708.939936000@intel.com>
References: <20090409212708.939936000@intel.com>
Subject: [tip:x86/pat] x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()
Message-ID: <tip-b6ff32d9aaeeeecf98f9a852d715569183585312@git.kernel.org>
Git-Commit-ID: b6ff32d9aaeeeecf98f9a852d715569183585312
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:34:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6ff32d9aaeeeecf98f9a852d715569183585312
Gitweb:     http://git.kernel.org/tip/b6ff32d9aaeeeecf98f9a852d715569183585312
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:48 +0200

x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()

Fix pat_x_mtrr_type() to use UC_MINUS when the mtrr type return UC. This
is to be  consistent with ioremap() and ioremap_nocache() which uses
UC_MINUS.

Consolidate the code such that reserve_memtype() also uses
pat_x_mtrr_type() when the caller doesn't specify any special attribute
(non WB attribute).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20090409212708.939936000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |    3 ++-
 arch/x86/mm/pat.c     |   35 +++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 329387e..d4c4b2c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -375,7 +375,8 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
 	 * - Inherit from confliting mappings otherwise
 	 */
-	err = reserve_memtype(phys_addr, phys_addr + size, -1, &flags);
+	err = reserve_memtype(phys_addr, phys_addr + size,
+				_PAGE_CACHE_WB, &flags);
 	if (err < 0)
 		return NULL;
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..8d3de95 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-			return _PAGE_CACHE_UC;
-		if (mtrr_type == MTRR_TYPE_WRCOMB)
-			return _PAGE_CACHE_WC;
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_UC_MINUS;
+
+		return _PAGE_CACHE_WB;
 	}
 
 	return req_type;
@@ -352,23 +352,13 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return 0;
 	}
 
-	if (req_type == -1) {
-		/*
-		 * Call mtrr_lookup to get the type hint. This is an
-		 * optimization for /dev/mem mmap'ers into WB memory (BIOS
-		 * tools and ACPI tools). Use WB request for WB memory and use
-		 * UC_MINUS otherwise.
-		 */
-		u8 mtrr_type = mtrr_type_lookup(start, end);
-
-		if (mtrr_type == MTRR_TYPE_WRBACK)
-			actual_type = _PAGE_CACHE_WB;
-		else
-			actual_type = _PAGE_CACHE_UC_MINUS;
-	} else {
-		actual_type = pat_x_mtrr_type(start, end,
-					      req_type & _PAGE_CACHE_MASK);
-	}
+	/*
+	 * Call mtrr_lookup to get the type hint. This is an
+	 * optimization for /dev/mem mmap'ers into WB memory (BIOS
+	 * tools and ACPI tools). Use WB request for WB memory and use
+	 * UC_MINUS otherwise.
+	 */
+	actual_type = pat_x_mtrr_type(start, end, req_type & _PAGE_CACHE_MASK);
 
 	if (new_type)
 		*new_type = actual_type;
@@ -587,7 +577,8 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	if (flags != -1) {
 		retval = reserve_memtype(offset, offset + size, flags, NULL);
 	} else {
-		retval = reserve_memtype(offset, offset + size, -1, &flags);
+		retval = reserve_memtype(offset, offset + size,
+					_PAGE_CACHE_WB, &flags);
 	}
 
 	if (retval < 0)
