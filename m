Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbYHTNcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbYHTNcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYHTNcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:32:25 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:29477 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbYHTNcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:32:24 -0400
X-SourceIP: 80.57.229.25
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <20080820105141.GA18226@elte.hu>
References: <20080804070508.GA4028@linux.vnet.ibm.com>
	 <1217833939.9016.47.camel@twins> <1912217169.25608.228.camel@ymzhang>
	 <1218180605.8625.64.camel@twins>
	 <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
	 <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
	 <20080820105141.GA18226@elte.hu>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:32:17 +0200
Message-Id: <1219239137.8651.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 12:51 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > And I must admit to having overlooked the effect on wake_affine..
> > 
> > Chris, could you see the effect of this on smp group fairness?

Just realized my brainfart..

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

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel.h |    6 ++++++
 kernel/sched.c         |   10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define avg(x, y) ({				\
+	typeof(x) _avg1 = ((x)+1)/2;		\
+	typeof(x) _avg2 = ((y)+1)/2;		\
+	(void) (&_avg1 == &_avg2);		\
+	_avg1 + _avg2; })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
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
 


