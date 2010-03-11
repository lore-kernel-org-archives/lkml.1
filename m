Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0CKGSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 01:18:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0CKGSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 01:18:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=ojwqPRjihJd6VO9h3M4OtR+NH60yjeptVr1Lffq8Cr7cz2VQbfGMAorFfRbIuXYGf
	TZmwGvBYmcdKDY0PrO22Q==
From: eranian@google.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: [PATCH] perf_events: fix X86 bogus counts when multiplexing
Date: Wed, 10 Mar 2010 22:17:39 -0800
Message-Id: <1268288259-4011-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in 2.6.33 X86 event scheduling whereby
all counts are bogus as soon as events need to be multiplexed
because the PMU is overcommitted.

The code in hw_perf_enable() was causing multiplexed events
to accumulate collected counts twice causing bogus results.

This is demonstrated on AMD Barcelona with the example
below. First run, no conflict, you obtain the actual counts.
Second run, PMU overcommitted, multiplexing, all events are
over-counted. Third run, patch applied, you obtain the correct
count through scaling.

Intel processors would be affected in the same way.

	# perf stat -e instructions,cycles ./noploop 10
	noploop for 10 seconds
	
	 Performance counter stats for './noploop 10':
	
	        10884992991  instructions             #      0.495 IPC  
	        21976457932  cycles                  
	
	       10.000906311  seconds time elapsed
	
	# perf stat -e instructions,instructions,instructions,instructions,cycles ./noploop 10
	noploop for 10 seconds
	
	 Performance counter stats for './noploop 10':
	
	        16342703033  instructions             #      1.000 IPC    (scaled from 80.00%)
	        16337667144  instructions             #      0.999 IPC    (scaled from 80.00%)
	        16342494809  instructions             #      1.000 IPC    (scaled from 80.00%)
	        16344432632  instructions             #      1.000 IPC    (scaled from 80.00%)
	        16346620711  cycles                    (scaled from 80.00%)
	
	       10.015941304  seconds time elapsed
	
	# perf stat -e instructions,instructions,instructions,instructions,cycles ./noploop 10
	noploop for 10 seconds
	
	 Performance counter stats for './noploop 10':
	
	        10865832804  instructions             #      0.495 IPC    (scaled from 80.00%)
	        10866436957  instructions             #      0.495 IPC    (scaled from 80.00%)
	        10866172153  instructions             #      0.495 IPC    (scaled from 80.00%)
	        10866276672  instructions             #      0.495 IPC    (scaled from 80.00%)
	        21944300714  cycles                    (scaled from 80.00%)
	
	       10.000686860  seconds time elapsed
	
	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 perf_event.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 97cddbf..ef5d63f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -818,8 +818,6 @@ void hw_perf_enable(void)
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			x86_pmu_stop(event);
-
 			hwc->idx = -1;
 		}
 
