Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXKFAu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXKFAu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXKFAue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:34 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25182 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754890AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/8] RT: scheduler migration/wakeup enhancements
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:48:32 -0700
Message-ID: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Steven, Thomas,

Please consider this series for inclusion in 23-rt6, as it has shown
to make a substantial improvement in our local testing.  Independent
verification and/or comments/review are more than welcome.

-Greg

---------
RT: scheduler migration/wakeup enhancements

This series applies to 23.1-rt5 and includes numerous tweaks to the
scheduler.  The primary goal of this set of patches is to further improve
wake-up latencies (particularly on larger SMP systems) and decrease migration
overhead.  This is accomplished by making improvements on several fronts:

1) We factor in CPU topology in the routing decision to pick the best
   migration target according to cache hierarchy.

2) We moved some CFS load calculation code as a member function of the CFS
   sched_class.  This removes this unecessary code from the RT fastpath for
   tasks in the RT sched_class.

3) We make further improvements against non-migratable tasks by factoring in
   the RQ overload state, instead of just the RQ depth.

4) We replace the linear priority search with a 2-d algorithm.

In past -rt releases, latencies could become quickly absymal on larger SMP (8+
cpus) to the order of 350us+.  The recent work in -rt2 and -rt4 dropped this
figure by a large margin, bringing things in the order of approximately
~120us.  This new series improves upon this work even further, bringing
latencies down to the sub 80us mark on our reference 8-way Intel C2D 5335
Xeon.

These figures were obtained by simultaneous execution of:

# ./cyclictest -n -p 90 -t 8 -d 100 -i 100
# while true; do make mrproper; make alldefconfig; make -j 128; done

for long durations.  The following are the results from one particular run,
though the results are similar across various short and long term trials in
our labs.

23.1-rt5-baseline
--------------------------
138.60 110.62 70.96 23/808 10246

T: 0 ( 5179) P:90 I:100 C:9011636 Min:      2 Act:    4 Avg:    4 Max:     117
T: 1 ( 5180) P:89 I:200 C:4505819 Min:      2 Act:    5 Avg:    4 Max:      95
T: 2 ( 5181) P:88 I:300 C:3003879 Min:      2 Act:    9 Avg:    5 Max:      85
T: 3 ( 5182) P:87 I:400 C:2252910 Min:      2 Act:    3 Avg:    4 Max:      75
T: 4 ( 5183) P:86 I:500 C:1802328 Min:      2 Act:    7 Avg:    5 Max:      71
T: 5 ( 5184) P:85 I:600 C:1501940 Min:      2 Act:    4 Avg:    5 Max:      74
T: 6 ( 5185) P:84 I:700 C:1287377 Min:      2 Act:    6 Avg:    6 Max:      85
T: 7 ( 5186) P:83 I:800 C:1126455 Min:      2 Act:    4 Avg:    5 Max:      75

23.1-rt5-gh
--------------------------
146.47 127.99 85.35 30/815 32289

T: 0 ( 5027) P:90 I:100 C:10856538 Min:      2 Act:    4 Avg:    4 Max:
60
T: 1 ( 5028) P:89 I:200 C:5428270 Min:      2 Act:    7 Avg:    5 Max:      57
T: 2 ( 5029) P:88 I:300 C:3618846 Min:      2 Act:    5 Avg:    5 Max:      48
T: 3 ( 5030) P:87 I:400 C:2714135 Min:      2 Act:    7 Avg:    5 Max:      61
T: 4 ( 5031) P:86 I:500 C:2171308 Min:      2 Act:    6 Avg:    6 Max:      51
T: 5 ( 5032) P:85 I:600 C:1809424 Min:      2 Act:    5 Avg:    7 Max:      59
T: 6 ( 5033) P:84 I:700 C:1550935 Min:      2 Act:    6 Avg:    6 Max:      54
T: 7 ( 5034) P:83 I:800 C:1357068 Min:      2 Act:    7 Avg:    6 Max:      62

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
