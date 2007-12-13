Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXLMPHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXLMPHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbXLMPGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:06:39 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31688 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbXLMPGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:06:30 -0500
From: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>
To: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Picco, Robert W." <robert.picco@hp.com>,
       "tony.luck@intel.com" <tony.luck@intel.com>
Date: Thu, 13 Dec 2007 15:03:07 +0000
Subject: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Thread-Topic: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating
 memory
Thread-Index: Acg9mUUMdTafVzrMTvSV0jj3/Kue7Q==
Message-ID: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve performance of memory allocations on ia64 by avoiding a global TLB purge to purge a single page from the file cache. This happens whenever we evict a page from the buffer cache to make room for some other allocation.

Test case: Run 'find /usr -type f | xargs cat > /dev/null' in the background to fill the buffer cache, then run something that uses memory, e.g. 'gmake -j50 install'. Instrumentation showed that the number of global TLB purges went from a few millions down to about 170 over a 12 hours run of the above.

The performance impact is particularly noticeable under virtualization, because a virtual TLB is generally both larger and slower to purge than a physical one.

Signed-off-by: Christophe de Dinechin <ddd@hp.com>

---

diff --git a/arch/ia64/mm/tlb.c b/arch/ia64/mm/tlb.c
index 1682fc6..66ae9c4 100644
--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -10,6 +10,7 @@
  *              IPI based ptc implementation and A-step IPI implementation.
  * Rohit Seth <rohit.seth@intel.com>
  * Ken Chen <kenneth.w.chen@intel.com>
+ * Christophe de Dinechin <ddd@hp.com>: Avoid ptc.e on memory allocation
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -89,9 +90,16 @@ ia64_global_tlb_purge (struct mm_struct *mm, unsigned long start,
 {
        static DEFINE_SPINLOCK(ptcg_lock);

-       if (mm != current->active_mm || !current->mm) {
-               flush_tlb_all();
-               return;
+       struct mm_struct *active_mm = current->active_mm;
+
+       if (mm != active_mm) {
+               /* Restore region IDs for mm */
+               if (mm && active_mm) {
+                       activate_context(mm);
+               } else {
+                       flush_tlb_all();
+                       return;
+               }
        }

        /* HW requires global serialization of ptc.ga.  */
@@ -107,6 +115,10 @@ ia64_global_tlb_purge (struct mm_struct *mm, unsigned long start,
                } while (start < end);
        }
        spin_unlock(&ptcg_lock);
+
+        if (mm != active_mm) {
+                activate_context(active_mm);
+        }
 }

 void
