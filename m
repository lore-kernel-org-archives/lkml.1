Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYHTRXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYHTRXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYHTRXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:23:35 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:45991 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYHTRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:23:34 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
References: <1912217169.25608.228.camel@ymzhang>
	 <20080820143209.GA32156@x200.localdomain> <1219242796.8651.54.camel@twins>
	 <200808210110.37204.nickpiggin@yahoo.com.au>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 19:21:41 +0200
Message-Id: <1219252901.8651.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so one last time (I hope!)..

Everybody happy with this?

---
Subject: sched: load-balance bias fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Aug 20 15:28:51 CEST 2008

Yanmin spotted a regression with my patch that introduces LB_BIAS:

  commit 93b75217df39e6d75889cc6f8050343286aff4a5
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Fri Jun 27 13:41:33 2008 +0200

And I just spotted the brainfart - I should have replaced min/max with avg
instead of removing it completely.

[ray-lk@madrabbit.org: better avg implementation]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel.h |    6 ++++++
 kernel/sched.c         |   10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2008,9 +2008,12 @@ static unsigned long source_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0)
 		return total;
 
+	if (!sched_feat(LB_BIAS))
+		return avg(rq->cpu_load[type-1], total);
+
 	return min(rq->cpu_load[type-1], total);
 }
 
@@ -2023,9 +2026,12 @@ static unsigned long target_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0)
 		return total;
 
+	if (!sched_feat(LB_BIAS))
+		return avg(rq->cpu_load[type-1], total);
+
 	return max(rq->cpu_load[type-1], total);
 }
 
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define avg(x, y) ({				\
+	typeof(x) _avg1 = (x);			\
+	typeof(y) _avg2 = (y);			\
+	(void) (&_avg1 == &_avg2);		\
+	_avg1 + (_avg2 - _avg1)/2; })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value


