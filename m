Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbZFXS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbZFXS5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZFXS5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:57:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZFXS5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:57:04 -0400
Subject: [PATCH -tip] perf_counter x86: fix cache_event_ids table
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 00:25:58 +0530
Message-Id: <1245869758.3038.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed followings in cache_event_ids table without changing any logic:
1. made it easier (3 dimension to 1 dimension array)
2. made more space for comments
3. decrease number of lines
4. fixed style problems
5. fixed 80 characters issues

Style problems in arch/x86/kernel/cpu/perf_counter.c :

Before :
  total: 492 errors, 32 warnings, 1713 lines checked
After :
  total: 0 errors, 10 warnings, 1537 lines checked

Fixed : 492 errors, 22 warnings and Reduced 176 lines.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |  530 ++++++++++++------------------------
 1 files changed, 177 insertions(+), 353 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a310d19..ba0c936 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -92,284 +92,154 @@ static u64 intel_pmu_event_map(int event)
  * ID.
  */
 
-#define C(x) PERF_COUNT_HW_CACHE_##x
+#define PERF_COUNT_HW_CACHE_RESULT_MISSES PERF_COUNT_HW_CACHE_RESULT_MISS
+#define C(x, y, z) \
+ ((PERF_COUNT_HW_CACHE_##x * PERF_COUNT_HW_CACHE_OP_MAX *		\
+   PERF_COUNT_HW_CACHE_RESULT_MAX) + PERF_COUNT_HW_CACHE_RESULT_##z +	\
+  (PERF_COUNT_HW_CACHE_OP_##y * PERF_COUNT_HW_CACHE_RESULT_MAX))
+
+#define PERF_CACHE_MAX \
+	(PERF_COUNT_HW_CACHE_MAX * PERF_COUNT_HW_CACHE_OP_MAX *		\
+	 PERF_COUNT_HW_CACHE_RESULT_MAX)
 
 static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
-static const u64 nehalem_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+static const u64 nehalem_hw_cache_event_ids[PERF_CACHE_MAX] =
 {
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
-		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
-		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI   (alias)  */
-		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI   (alias)  */
-		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0x0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
-		[ C(RESULT_MISS)   ] = 0x20c8, /* ITLB_MISS_RETIRED            */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
-		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
+ [C(L1D,  READ,     ACCESS)] = 0x0f40,	/* L1D_CACHE_LD.MESI		*/
+ [C(L1D,  READ,     MISSES)] = 0x0140,	/* L1D_CACHE_LD.I_STATE		*/
+ [C(L1D,  WRITE,    ACCESS)] = 0x0f41,	/* L1D_CACHE_ST.MESI		*/
+ [C(L1D,  WRITE,    MISSES)] = 0x0141,	/* L1D_CACHE_ST.I_STATE		*/
+ [C(L1D,  PREFETCH, ACCESS)] = 0x014e,	/* L1D_PREFETCH.REQUESTS	*/
+ [C(L1D,  PREFETCH, MISSES)] = 0x024e,  /* L1D_PREFETCH.MISS		*/
+
+ [C(L1I,  READ,     ACCESS)] = 0x0380,	/* L1I.READS			*/
+ [C(L1I,  READ,     MISSES)] = 0x0280,	/* L1I.MISSES			*/
+ [C(L1I,  WRITE,    ACCESS)] = -1,
+ [C(L1I,  WRITE,    MISSES)] = -1,
+ [C(L1I,  PREFETCH, ACCESS)] = 0x0,
+ [C(L1I,  PREFETCH, MISSES)] = 0x0,
+
+ [C(LL,   READ,     ACCESS)] = 0x0324, /* L2_RQSTS.LOADS		*/
+ [C(LL,   READ,     MISSES)] = 0x0224, /* L2_RQSTS.LD_MISS		*/
+ [C(LL,   WRITE,    ACCESS)] = 0x0c24, /* L2_RQSTS.RFOS		*/
+ [C(LL,   WRITE,    MISSES)] = 0x0824, /* L2_RQSTS.RFO_MISS		*/
+ [C(LL,   PREFETCH, ACCESS)] = 0x4f2e, /* LLC Reference		*/
+ [C(LL,   PREFETCH, MISSES)] = 0x412e, /* LLC Misses			*/
+
+ [C(DTLB, READ,     ACCESS)] = 0x0f40, /* L1D_CACHE_LD.MESI   (alias)	*/
+ [C(DTLB, READ,     MISSES)] = 0x0108, /* DTLB_LOAD_MISSES.ANY		*/
+ [C(DTLB, WRITE,    ACCESS)] = 0x0f41, /* L1D_CACHE_ST.MESI   (alias)	*/
+ [C(DTLB, WRITE,    MISSES)] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS	*/
+ [C(DTLB, PREFETCH, ACCESS)] = 0x0,
+ [C(DTLB, PREFETCH, MISSES)] = 0x0,
+
+ [C(ITLB, READ,     ACCESS)] = 0x01c0, /* INST_RETIRED.ANY_P		*/
+ [C(ITLB, READ,     MISSES)] = 0x20c8, /* ITLB_MISS_RETIRED		*/
+ [C(ITLB, WRITE,    ACCESS)] = -1,
+ [C(ITLB, WRITE,    MISSES)] = -1,
+ [C(ITLB, PREFETCH, ACCESS)] = -1,
+ [C(ITLB, PREFETCH, MISSES)] = -1,
+
+ [C(BPU,  READ,     ACCESS)] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES	*/
+ [C(BPU,  READ,     MISSES)] = 0x03e8, /* BPU_CLEARS.ANY		*/
+ [C(BPU,  WRITE,    ACCESS)] = -1,
+ [C(BPU,  WRITE,    MISSES)] = -1,
+ [C(BPU,  PREFETCH, ACCESS)] = -1,
+ [C(BPU,  PREFETCH, MISSES)] = -1,
 };
 
-static const u64 core2_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+static const u64 core2_hw_cache_event_ids[PERF_CACHE_MAX] =
 {
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI          */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE       */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI          */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE       */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x104e, /* L1D_PREFETCH.REQUESTS      */
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* L1I.READS                  */
-		[ C(RESULT_MISS)   ] = 0x0081, /* L1I.MISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0208, /* DTLB_MISSES.MISS_LD        */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0808, /* DTLB_MISSES.MISS_ST        */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
-		[ C(RESULT_MISS)   ] = 0x1282, /* ITLBMISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
-		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
+ [C(L1D,  READ,     ACCESS)] = 0x0f40, /* L1D_CACHE_LD.MESI		*/
+ [C(L1D,  READ,     MISSES)] = 0x0140, /* L1D_CACHE_LD.I_STATE		*/
+ [C(L1D,  WRITE,    ACCESS)] = 0x0f41, /* L1D_CACHE_ST.MESI		*/
+ [C(L1D,  WRITE,    MISSES)] = 0x0141, /* L1D_CACHE_ST.I_STATE		*/
+ [C(L1D,  PREFETCH, ACCESS)] = 0x104e, /* L1D_PREFETCH.REQUESTS	*/
+ [C(L1D,  PREFETCH, MISSES)] = 0,
+
+ [C(L1I,  READ,     ACCESS)] = 0x0080, /* L1I.READS			*/
+ [C(L1I,  READ,     MISSES)] = 0x0081, /* L1I.MISSES			*/
+ [C(L1I,  WRITE,    ACCESS)] = -1,
+ [C(L1I,  WRITE,    MISSES)] = -1,
+ [C(L1I,  PREFETCH, ACCESS)] = 0,
+ [C(L1I,  PREFETCH, MISSES)] = 0,
+
+ [C(LL,   READ,     ACCESS)] = 0x4f29, /* L2_LD.MESI			*/
+ [C(LL,   READ,     MISSES)] = 0x4129, /* L2_LD.ISTATE			*/
+ [C(LL,   WRITE,    ACCESS)] = 0x4f2A, /* L2_ST.MESI			*/
+ [C(LL,   WRITE,    MISSES)] = 0x412A, /* L2_ST.ISTATE			*/
+ [C(LL,   PREFETCH, ACCESS)] = 0,
+ [C(LL,   PREFETCH, MISSES)] = 0,
+
+ [C(DTLB, READ,     ACCESS)] = 0x0f40, /* L1D_CACHE_LD.MESI  (alias)	*/
+ [C(DTLB, READ,     MISSES)] = 0x0208, /* DTLB_MISSES.MISS_LD		*/
+ [C(DTLB, WRITE,    ACCESS)] = 0x0f41, /* L1D_CACHE_ST.MESI  (alias)	*/
+ [C(DTLB, WRITE,    MISSES)] = 0x0808, /* DTLB_MISSES.MISS_ST		*/
+ [C(DTLB, PREFETCH, ACCESS)] = 0,
+ [C(DTLB, PREFETCH, MISSES)] = 0,
+
+ [C(ITLB, READ,     ACCESS)] = 0x00c0, /* INST_RETIRED.ANY_P		*/
+ [C(ITLB, READ,     MISSES)] = 0x1282, /* ITLBMISSES			*/
+ [C(ITLB, WRITE,    ACCESS)] = -1,
+ [C(ITLB, WRITE,    MISSES)] = -1,
+ [C(ITLB, PREFETCH, ACCESS)] = -1,
+ [C(ITLB, PREFETCH, MISSES)] = -1,
+
+ [C(BPU,  READ,     ACCESS)] = 0x00c4, /* BR_INST_RETIRED.ANY		*/
+ [C(BPU,  READ,     MISSES)] = 0x00c5, /* BP_INST_RETIRED.MISPRED	*/
+ [C(BPU,  WRITE,    ACCESS)] = -1,
+ [C(BPU,  WRITE,    MISSES)] = -1,
+ [C(BPU,  PREFETCH, ACCESS)] = -1,
+ [C(BPU,  PREFETCH, MISSES)] = -1,
 };
 
-static const u64 atom_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+static const u64 atom_hw_cache_event_ids[PERF_CACHE_MAX] =
 {
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE.LD               */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE.ST               */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                  */
-		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                 */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f29, /* L2_LD.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x4129, /* L2_LD.ISTATE               */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2A, /* L2_ST.MESI                 */
-		[ C(RESULT_MISS)   ] = 0x412A, /* L2_ST.ISTATE               */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE_LD.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0508, /* DTLB_MISSES.MISS_LD        */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE_ST.MESI  (alias) */
-		[ C(RESULT_MISS)   ] = 0x0608, /* DTLB_MISSES.MISS_ST        */
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c0, /* INST_RETIRED.ANY_P         */
-		[ C(RESULT_MISS)   ] = 0x0282, /* ITLB.MISSES                */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ANY        */
-		[ C(RESULT_MISS)   ] = 0x00c5, /* BP_INST_RETIRED.MISPRED    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
+ [C(L1D,  READ,     ACCESS)] = 0x2140, /* L1D_CACHE.LD			*/
+ [C(L1D,  READ,     MISSES)] = 0,
+ [C(L1D,  WRITE,    ACCESS)] = 0x2240, /* L1D_CACHE.ST			*/
+ [C(L1D,  WRITE,    MISSES)] = 0,
+ [C(L1D,  PREFETCH, ACCESS)] = 0x0,
+ [C(L1D,  PREFETCH, MISSES)] = 0,
+
+ [C(L1I,  READ,     ACCESS)] = 0x0380, /* L1I.READS			*/
+ [C(L1I,  READ,     MISSES)] = 0x0280, /* L1I.MISSES			*/
+ [C(L1I,  WRITE,    ACCESS)] = -1,
+ [C(L1I,  WRITE,    MISSES)] = -1,
+ [C(L1I,  PREFETCH, ACCESS)] = 0,
+ [C(L1I,  PREFETCH, MISSES)] = 0,
+
+ [C(LL,   READ,     ACCESS)] = 0x4f29, /* L2_LD.MESI			*/
+ [C(LL,   READ,     MISSES)] = 0x4129, /* L2_LD.ISTATE			*/
+ [C(LL,   WRITE,    ACCESS)] = 0x4f2A, /* L2_ST.MESI			*/
+ [C(LL,   WRITE,    MISSES)] = 0x412A, /* L2_ST.ISTATE			*/
+ [C(LL,   PREFETCH, ACCESS)] = 0,
+ [C(LL,   PREFETCH, MISSES)] = 0,
+
+ [C(DTLB, READ,     ACCESS)] = 0x2140, /* L1D_CACHE_LD.MESI  (alias)	*/
+ [C(DTLB, READ,     MISSES)] = 0x0508, /* DTLB_MISSES.MISS_LD		*/
+ [C(DTLB, WRITE,    ACCESS)] = 0x2240, /* L1D_CACHE_ST.MESI  (alias)	*/
+ [C(DTLB, WRITE,    MISSES)] = 0x0608, /* DTLB_MISSES.MISS_ST		*/
+ [C(DTLB, PREFETCH, ACCESS)] = 0,
+ [C(DTLB, PREFETCH, MISSES)] = 0,
+
+ [C(ITLB, READ,     ACCESS)] = 0x00c0, /* INST_RETIRED.ANY_P		*/
+ [C(ITLB, READ,     MISSES)] = 0x0282, /* ITLB.MISSES			*/
+ [C(ITLB, WRITE,    ACCESS)] = -1,
+ [C(ITLB, WRITE,    MISSES)] = -1,
+ [C(ITLB, PREFETCH, ACCESS)] = -1,
+ [C(ITLB, PREFETCH, MISSES)] = -1,
+
+ [C(BPU,  READ,     ACCESS)] = 0x00c4, /* BR_INST_RETIRED.ANY		*/
+ [C(BPU,  READ,     MISSES)] = 0x00c5, /* BP_INST_RETIRED.MISPRED	*/
+ [C(BPU,  WRITE,    ACCESS)] = -1,
+ [C(BPU,  WRITE,    MISSES)] = -1,
+ [C(BPU,  PREFETCH, ACCESS)] = -1,
+ [C(BPU,  PREFETCH, MISSES)] = -1,
 };
 
 static u64 intel_pmu_raw_event(u64 event)
@@ -390,95 +260,49 @@ static u64 intel_pmu_raw_event(u64 event)
 	return event & CORE_EVNTSEL_MASK;
 }
 
-static const u64 amd_hw_cache_event_ids
-				[PERF_COUNT_HW_CACHE_MAX]
-				[PERF_COUNT_HW_CACHE_OP_MAX]
-				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+static const u64 amd_hw_cache_event_ids[PERF_CACHE_MAX] =
 {
- [ C(L1D) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
-		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
-	},
- },
- [ C(L1I ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction cache fetches  */
-		[ C(RESULT_MISS)   ] = 0x0081, /* Instruction cache misses   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(LL  ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
-		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(DTLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
-	},
- },
- [ C(ITLB) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
-		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
- [ C(BPU ) ] = {
-	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x00c2, /* Retired Branch Instr.      */
-		[ C(RESULT_MISS)   ] = 0x00c3, /* Retired Mispredicted BI    */
-	},
-	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
-	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
-	},
- },
+ [C(L1D,  READ,     ACCESS)] = 0x0040, /* Data Cache Accesses		*/
+ [C(L1D,  READ,     MISSES)] = 0x0041, /* Data Cache Misses		*/
+ [C(L1D,  WRITE,    ACCESS)] = 0x0142, /* Data Cache Refills :system	*/
+ [C(L1D,  WRITE,    MISSES)] = 0,
+ [C(L1D,  PREFETCH, ACCESS)] = 0x0267, /* Data Prefetcher :attempts	*/
+ [C(L1D,  PREFETCH, MISSES)] = 0x0167, /* Data Prefetcher :cancelled	*/
+
+ [C(L1I,  READ,     ACCESS)] = 0x0080, /* Instruction cache fetches	*/
+ [C(L1I,  READ,     MISSES)] = 0x0081, /* Instruction cache misses	*/
+ [C(L1I,  WRITE,    ACCESS)] = -1,
+ [C(L1I,  WRITE,    MISSES)] = -1,
+ [C(L1I,  PREFETCH, ACCESS)] = 0x014B, /* Prefetch Instructions :Load	*/
+ [C(L1I,  PREFETCH, MISSES)] = 0,
+
+ [C(LL,   READ,     ACCESS)] = 0x037D, /* Requests to L2 Cache :IC+DC	*/
+ [C(LL,   READ,     MISSES)] = 0x037E, /* L2 Cache Misses : IC+DC	*/
+ [C(LL,   WRITE,    ACCESS)] = 0x017F, /* L2 Fill/Writeback		*/
+ [C(LL,   WRITE,    MISSES)] = 0,
+ [C(LL,   PREFETCH, ACCESS)] = 0,
+ [C(LL,   PREFETCH, MISSES)] = 0,
+
+ [C(DTLB, READ,     ACCESS)] = 0x0040, /* Data Cache Accesses		*/
+ [C(DTLB, READ,     MISSES)] = 0x0046, /* L1 DTLB and L2 DLTB Miss	*/
+ [C(DTLB, WRITE,    ACCESS)] = 0,
+ [C(DTLB, WRITE,    MISSES)] = 0,
+ [C(DTLB, PREFETCH, ACCESS)] = 0,
+ [C(DTLB, PREFETCH, MISSES)] = 0,
+
+ [C(ITLB, READ,     ACCESS)] = 0x0080, /* Instruction fecthes        */
+ [C(ITLB, READ,     MISSES)] = 0x0085, /* Instr. fetch ITLB misses   */
+ [C(ITLB, WRITE,    ACCESS)] = -1,
+ [C(ITLB, WRITE,    MISSES)] = -1,
+ [C(ITLB, PREFETCH, ACCESS)] = -1,
+ [C(ITLB, PREFETCH, MISSES)] = -1,
+
+ [C(BPU,  READ,     ACCESS)] = 0x00c2, /* Retired Branch Instr.      */
+ [C(BPU,  READ,     MISSES)] = 0x00c3, /* Retired Mispredicted BI    */
+ [C(BPU,  WRITE,    ACCESS)] = -1,
+ [C(BPU,  WRITE,    MISSES)] = -1,
+ [C(BPU,  PREFETCH, ACCESS)] = -1,
+ [C(BPU,  PREFETCH, MISSES)] = -1,
 };
 
 /*
-- 
1.6.0.6



