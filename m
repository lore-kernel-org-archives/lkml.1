Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbXKOGRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbXKOGRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbXKOGQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbXKOGQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:12 -0500
Date: Wed, 14 Nov 2007 22:14:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 03/19] MIPS: MT: Fix bug in multithreaded kernels.
Message-ID: <20071115061432.GD7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mips-mt-fix-bug-in-multithreaded-kernels.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ralf Baechle <ralf@linux-mips.org>

patch a76ab5c10d99bdf458067cb495e72c0ee5f09909 in mainline.

When GDB writes a breakpoint into address area of inferior process the
kernel needs to invalidate the modified memory in the inferior which
is done by calling flush_cache_page which in turns calls
r4k_flush_cache_page and local_r4k_flush_cache_page for VSMP or SMTC
kernel via r4k_on_each_cpu().

As the VSMP and SMTC SMP kernels for 34K are running on a single shared
caches it is possible to get away without interprocessor function calls.
This optimization is implemented in r4k_on_each_cpu, so
local_r4k_flush_cache_page is only ever called on the local CPU.

This is where the following code in local_r4k_flush_cache_page() strikes:

        /*
         * If ownes no valid ASID yet, cannot possibly have gotten
         * this page into the cache.
         */
        if (cpu_context(smp_processor_id(), mm) == 0)
                return;

On VSMP and SMTC had a function of cpu_context() for each CPU(TC).

So in case another CPU than the CPU executing local_r4k_cache_flush_page
has not accessed the mm but one of the other CPUs has there may be data
to be flushed in the cache yet local_r4k_cache_flush_page will falsely
return leaving the I-cache inconsistent for the breakpoint.

While the issue was discovered with GDB it also exists in
local_r4k_flush_cache_range() and local_r4k_flush_cache().

Fixed by introducing a new function has_valid_asid which on MT kernels
returns true if a mm is active on any processor in the system.

This is relativly expensive since for memory acccesses in that loop
cache misses have to be assumed but it seems the most viable solution
for 2.6.23 and older -stable kernels.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/mm/c-r4k.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -360,11 +360,26 @@ static void r4k___flush_cache_all(void)
 	r4k_on_each_cpu(local_r4k___flush_cache_all, NULL, 1, 1);
 }
 
+static inline int has_valid_asid(const struct mm_struct *mm)
+{
+#if defined(CONFIG_MIPS_MT_SMP) || defined(CONFIG_MIPS_MT_SMTC)
+	int i;
+
+	for_each_online_cpu(i)
+		if (cpu_context(i, mm))
+			return 1;
+
+	return 0;
+#else
+	return cpu_context(smp_processor_id(), mm);
+#endif
+}
+
 static inline void local_r4k_flush_cache_range(void * args)
 {
 	struct vm_area_struct *vma = args;
 
-	if (!(cpu_context(smp_processor_id(), vma->vm_mm)))
+	if (!(has_valid_asid(vma->vm_mm)))
 		return;
 
 	r4k_blast_dcache();
@@ -383,7 +398,7 @@ static inline void local_r4k_flush_cache
 {
 	struct mm_struct *mm = args;
 
-	if (!cpu_context(smp_processor_id(), mm))
+	if (!has_valid_asid(mm))
 		return;
 
 	/*
@@ -434,7 +449,7 @@ static inline void local_r4k_flush_cache
 	 * If ownes no valid ASID yet, cannot possibly have gotten
 	 * this page into the cache.
 	 */
-	if (cpu_context(smp_processor_id(), mm) == 0)
+	if (!has_valid_asid(mm))
 		return;
 
 	addr &= PAGE_MASK;

-- 
