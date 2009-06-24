Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZFXJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZFXJ0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFXJ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:26:41 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55425 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZFXJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:26:40 -0400
Subject: [PATCH] pseries: cpu: Reduce the polling interval in __cpu_up()
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Nathan Lynch <ntl@pobox.com>
Date: Wed, 24 Jun 2009 14:56:37 +0530
Message-ID: <20090624092637.32078.88042.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Time time taken for a single cpu online operation on a pseries machine
is as follows:
Dedicated LPAR (POWER6): ~220ms.
Shared LPAR (POWER5)   : ~240ms.

Of this time, approximately 200ms is taken up by __cpu_up(). This is because
we poll every 200ms to check if the new cpu has notified it's presence
through the cpu_callin_map. We repeat this operation until the new cpu sets
the value in cpu_callin_map or 5 seconds elapse, whichever comes earlier.

However, using completion_structs instead of polling loops,
the time taken by the new processor to indicate it's presence has
found to be less than 1ms on pseries. This method however may not
work on all powerpc platforms due to the time-base synchronization code.

Keeping this in mind, we could reduce msleep polling interval from
200ms to 1ms while retaining the 5 second timeout.

With this, the time taken for a cpu online operation changes as follows:
Dedicated LPAR (POWER6): 20-25ms.
Shared LPAR (POWER5)   : 60-80ms.

In both these cases, it was found that the code polls through the loop
only once indicating that 1ms is a reasonable value, atleast on pseries.

The code needs testing on other powerpc platforms.

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

