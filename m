Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886Ab0AVO4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0AVO4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791Ab0AVO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:56:36 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8647 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0AVOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:33 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFM-01-74A-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/12] perf/core, x86: use test_and_set_bit() to when grabbing a counter
Date: Fri, 22 Jan 2010 15:22:04 +0100
Message-ID: <1264170127-17402-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0611 (UTC) FILETIME=[DC2EC4B0:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using test_and_set_bit() in the generic counter allocator makes this
atomic. Otherwise a counter could have been allocated twice.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4eb0355..3f81f91 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1395,8 +1395,13 @@ gen_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
 	int idx;
 
+again:
 	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_counters);
-	return idx == x86_pmu.num_counters ? -1 : idx;
+	if (idx == x86_pmu.num_counters)
+		return -1;
+	if (test_and_set_bit(idx, cpuc->used_mask))
+		goto again;
+	return idx;
 }
 
 /*
@@ -1465,7 +1470,6 @@ try_generic:
 			if (idx == -1)
 				return -EAGAIN;
 
-			set_bit(idx, cpuc->used_mask);
 			hwc->idx = idx;
 		}
 		hwc->config_base = x86_pmu.eventsel;
-- 
1.6.6


