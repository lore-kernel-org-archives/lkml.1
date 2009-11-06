Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZKFJgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZKFJgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKFJgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:36:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:34315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZKFJgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:36:49 -0500
X-ExtLoop1: 1
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast string.
Date: Fri,  6 Nov 2009 17:41:22 +0800
Message-Id: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Hi All

Intel Nehalem improves the performance of REP strings significantly
over previous microarchitectures in several ways:

1. Startup overhead have been reduced in most cases.
2. Data transfer throughput are improved.
3. REP string can operate in "fast string" even if address is not
   aligned to 16bytes.

According to the experiment when copy size is big enough
movsq almost can get 16bytes throughput per cycle, which
approximate SSE instruction set. The patch intends to utilize 
the optimization when copy size is over 1024.

Experiment data speedup under Nehalem platform:
  Len    alignment   Speedup
 1024,    0/ 0:      1.04x
 2048,    0/ 0:      1.36x
 3072,    0/ 0:      1.51x
 4096,    0/ 0:      1.60x
 5120,    0/ 0:      1.70x
 6144,    0/ 0:      1.74x
 7168,    0/ 0:      1.77x
 8192,    0/ 0:      1.80x
 9216,    0/ 0:      1.82x
 10240,   0/ 0:      1.83x
 11264,   0/ 0:      1.85x
 12288,   0/ 0:      1.86x
 13312,   0/ 0:      1.92x
 14336,   0/ 0:      1.84x
 15360,   0/ 0:      1.74x

'perf stat --repeat 10 ./static_orig' command get data before patch:

 Performance counter stats for './static_orig' (10 runs):

    2835.650105  task-clock-msecs         #      0.999 CPUs    ( +-   0.051% )
              3  context-switches         #      0.000 M/sec   ( +-   6.503% )
              0  CPU-migrations           #      0.000 M/sec   ( +-     nan% )
           4429  page-faults              #      0.002 M/sec   ( +-   0.003% )
     7941098692  cycles                   #   2800.451 M/sec   ( +-   0.051% )
    10848100323  instructions             #      1.366 IPC     ( +-   0.000% )
         322808  cache-references         #      0.114 M/sec   ( +-   1.467% )
         280716  cache-misses             #      0.099 M/sec   ( +-   0.618% )

    2.838006377  seconds time elapsed   ( +-   0.051% )

'perf stat --repeat 10 ./static_new' command get data after patch:

 Performance counter stats for './static_new' (10 runs):

    7401.423466  task-clock-msecs         #      0.999 CPUs    ( +-   0.108% )
             10  context-switches         #      0.000 M/sec   ( +-   2.797% )
              0  CPU-migrations           #      0.000 M/sec   ( +-     nan% )
           4428  page-faults              #      0.001 M/sec   ( +-   0.003% )
    20727280183  cycles                   #   2800.445 M/sec   ( +-   0.107% )
     1472673654  instructions             #      0.071 IPC     ( +-   0.013% )
        1092221  cache-references         #      0.148 M/sec   ( +-  12.414% )
         290550  cache-misses             #      0.039 M/sec   ( +-   1.577% )

    7.407006046  seconds time elapsed   ( +-   0.108% )

Appreciate your comments.

Thanks
Ma Ling

---
 arch/x86/lib/memcpy_64.S |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index ad5441e..2ea3561 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -50,6 +50,12 @@ ENTRY(memcpy)
 	movl %edx, %ecx
 	shrl   $6, %ecx
 	jz .Lhandle_tail
+	/*
+	 * If length is more than 1024 we chose optimized MOVSQ,
+	 * which has more throughput.
+	 */
+	cmpl $0x400, %edx 
+	jae .Lmore_0x400
 
 	.p2align 4
 .Lloop_64:
@@ -119,6 +125,17 @@ ENTRY(memcpy)
 
 .Lend:
 	ret
+
+	.p2align 4
+.Lmore_0x400:
+	movq %rdi, %rax
+	movl %edx, %ecx
+	shrl $3, %ecx
+	andl $7, %edx
+	rep movsq
+	movl %edx, %ecx
+	rep movsb
+	ret
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)
-- 
1.6.2.5

