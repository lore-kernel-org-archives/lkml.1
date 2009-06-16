Return-Path: <linux-kernel-owner+w=401wt.eu-S934798AbZFPFjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbZFPFjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933692AbZFPFiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:38:51 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42705 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672AbZFPFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:38:49 -0400
Subject: [RFD PATCH 1/4] powerpc: cpu: Reduce the polling interval in
	__cpu_up()
To: linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Date: Tue, 16 Jun 2009 11:08:44 +0530
Message-ID: <20090616053844.30891.79173.stgit@sofia.in.ibm.com>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu online operation on a powerpc today takes order of 200-220ms. Of
this time, approximately 200ms is taken up by __cpu_up(). This is because
we poll every 200ms to check if the new cpu has notified it's presence
through the cpu_callin_map. We poll every 200ms until the new cpu sets
the value in cpu_callin_map or 5 seconds elapse, whichever comes earlier.

However, the time taken by the new processor to indicate it's presence has
found to be less than a millisecond. Keeping this in mind, reduce the
polling interval from 200ms to 1ms while retaining the 5 second timeout.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 arch/powerpc/kernel/smp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 65484b2..00c13a1 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -411,9 +411,8 @@ int __cpuinit __cpu_up(unsigned int cpu)
 		 * CPUs can take much longer to come up in the
 		 * hotplug case.  Wait five seconds.
 		 */
-		for (c = 25; c && !cpu_callin_map[cpu]; c--) {
-			msleep(200);
-		}
+		for (c = 5000; c && !cpu_callin_map[cpu]; c--)
+			msleep(1);
 #endif
 
 	if (!cpu_callin_map[cpu]) {

