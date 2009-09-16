Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbZIPWkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbZIPWkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbZIPWkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:04 -0400
Received: from kroah.org ([198.145.64.141]:48953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760341AbZIPWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223715.733319934@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 17/45] powerpc/perf_counters: Reduce stack usage of power_check_constraints
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-perf_counters-reduce-stack-usage-of-power_check_constraints.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mackerras <paulus@samba.org>

commit e51ee31e8af22948dcc3b115978469b09c96c3fd upstream.

Michael Ellerman reported stack-frame size warnings being produced
for power_check_constraints(), which uses an 8*8 array of u64 and
two 8*8 arrays of unsigned long, which are currently allocated on the
stack, along with some other smaller variables.  These arrays come
to 1.5kB on 64-bit or 1kB on 32-bit, which is a bit too much for the
stack.

This fixes the problem by putting these arrays in the existing
per-cpu cpu_hw_counters struct.  This is OK because two of the call
sites have interrupts disabled already; for the third call site we
use get_cpu_var, which disables preemption, so we know we won't
get a context switch while we're in power_check_constraints().
Note that power_check_constraints() can be called during context
switch but is not called from interrupts.

Reported-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/perf_counter.c |   55 +++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -32,6 +32,9 @@ struct cpu_hw_counters {
 	unsigned long mmcr[3];
 	struct perf_counter *limited_counter[MAX_LIMITED_HWCOUNTERS];
 	u8  limited_hwidx[MAX_LIMITED_HWCOUNTERS];
+	u64 alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	unsigned long amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	unsigned long avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
 };
 DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
@@ -245,13 +248,11 @@ static void write_pmc(int idx, unsigned 
  * and see if any combination of alternative codes is feasible.
  * The feasible set is returned in event[].
  */
-static int power_check_constraints(u64 event[], unsigned int cflags[],
+static int power_check_constraints(struct cpu_hw_counters *cpuhw,
+				   u64 event[], unsigned int cflags[],
 				   int n_ev)
 {
 	unsigned long mask, value, nv;
-	u64 alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
-	unsigned long amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
-	unsigned long avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
 	unsigned long smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
 	int n_alt[MAX_HWCOUNTERS], choice[MAX_HWCOUNTERS];
 	int i, j;
@@ -266,21 +267,23 @@ static int power_check_constraints(u64 e
 		if ((cflags[i] & PPMU_LIMITED_PMC_REQD)
 		    && !ppmu->limited_pmc_event(event[i])) {
 			ppmu->get_alternatives(event[i], cflags[i],
-					       alternatives[i]);
-			event[i] = alternatives[i][0];
+					       cpuhw->alternatives[i]);
+			event[i] = cpuhw->alternatives[i][0];
 		}
-		if (ppmu->get_constraint(event[i], &amasks[i][0],
-					 &avalues[i][0]))
+		if (ppmu->get_constraint(event[i], &cpuhw->amasks[i][0],
+					 &cpuhw->avalues[i][0]))
 			return -1;
 	}
 	value = mask = 0;
 	for (i = 0; i < n_ev; ++i) {
-		nv = (value | avalues[i][0]) + (value & avalues[i][0] & addf);
+		nv = (value | cpuhw->avalues[i][0]) +
+			(value & cpuhw->avalues[i][0] & addf);
 		if ((((nv + tadd) ^ value) & mask) != 0 ||
-		    (((nv + tadd) ^ avalues[i][0]) & amasks[i][0]) != 0)
+		    (((nv + tadd) ^ cpuhw->avalues[i][0]) &
+		     cpuhw->amasks[i][0]) != 0)
 			break;
 		value = nv;
-		mask |= amasks[i][0];
+		mask |= cpuhw->amasks[i][0];
 	}
 	if (i == n_ev)
 		return 0;	/* all OK */
@@ -291,10 +294,11 @@ static int power_check_constraints(u64 e
 	for (i = 0; i < n_ev; ++i) {
 		choice[i] = 0;
 		n_alt[i] = ppmu->get_alternatives(event[i], cflags[i],
-						  alternatives[i]);
+						  cpuhw->alternatives[i]);
 		for (j = 1; j < n_alt[i]; ++j)
-			ppmu->get_constraint(alternatives[i][j],
-					     &amasks[i][j], &avalues[i][j]);
+			ppmu->get_constraint(cpuhw->alternatives[i][j],
+					     &cpuhw->amasks[i][j],
+					     &cpuhw->avalues[i][j]);
 	}
 
 	/* enumerate all possibilities and see if any will work */
@@ -313,11 +317,11 @@ static int power_check_constraints(u64 e
 		 * where k > j, will satisfy the constraints.
 		 */
 		while (++j < n_alt[i]) {
-			nv = (value | avalues[i][j]) +
-				(value & avalues[i][j] & addf);
+			nv = (value | cpuhw->avalues[i][j]) +
+				(value & cpuhw->avalues[i][j] & addf);
 			if ((((nv + tadd) ^ value) & mask) == 0 &&
-			    (((nv + tadd) ^ avalues[i][j])
-			     & amasks[i][j]) == 0)
+			    (((nv + tadd) ^ cpuhw->avalues[i][j])
+			     & cpuhw->amasks[i][j]) == 0)
 				break;
 		}
 		if (j >= n_alt[i]) {
@@ -339,7 +343,7 @@ static int power_check_constraints(u64 e
 			svalues[i] = value;
 			smasks[i] = mask;
 			value = nv;
-			mask |= amasks[i][j];
+			mask |= cpuhw->amasks[i][j];
 			++i;
 			j = -1;
 		}
@@ -347,7 +351,7 @@ static int power_check_constraints(u64 e
 
 	/* OK, we have a feasible combination, tell the caller the solution */
 	for (i = 0; i < n_ev; ++i)
-		event[i] = alternatives[i][choice[i]];
+		event[i] = cpuhw->alternatives[i][choice[i]];
 	return 0;
 }
 
@@ -752,7 +756,7 @@ int hw_perf_group_sched_in(struct perf_c
 		return -EAGAIN;
 	if (check_excludes(cpuhw->counter, cpuhw->flags, n0, n))
 		return -EAGAIN;
-	i = power_check_constraints(cpuhw->events, cpuhw->flags, n + n0);
+	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n + n0);
 	if (i < 0)
 		return -EAGAIN;
 	cpuhw->n_counters = n0 + n;
@@ -807,7 +811,7 @@ static int power_pmu_enable(struct perf_
 	cpuhw->flags[n0] = counter->hw.counter_base;
 	if (check_excludes(cpuhw->counter, cpuhw->flags, n0, 1))
 		goto out;
-	if (power_check_constraints(cpuhw->events, cpuhw->flags, n0 + 1))
+	if (power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n0 + 1))
 		goto out;
 
 	counter->hw.config = cpuhw->events[n0];
@@ -1012,6 +1016,7 @@ const struct pmu *hw_perf_counter_init(s
 	unsigned int cflags[MAX_HWCOUNTERS];
 	int n;
 	int err;
+	struct cpu_hw_counters *cpuhw;
 
 	if (!ppmu)
 		return ERR_PTR(-ENXIO);
@@ -1090,7 +1095,11 @@ const struct pmu *hw_perf_counter_init(s
 	cflags[n] = flags;
 	if (check_excludes(ctrs, cflags, n, 1))
 		return ERR_PTR(-EINVAL);
-	if (power_check_constraints(events, cflags, n + 1))
+
+	cpuhw = &get_cpu_var(cpu_hw_counters);
+	err = power_check_constraints(cpuhw, events, cflags, n + 1);
+	put_cpu_var(cpu_hw_counters);
+	if (err)
 		return ERR_PTR(-EINVAL);
 
 	counter->hw.config = events[n];


