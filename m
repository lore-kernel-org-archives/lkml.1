Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZKLEd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZKLEd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbZKLEd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:33:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070AbZKLEd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:33:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFB9029.9000208@jp.fujitsu.com>
Date: Thu, 12 Nov 2009 13:33:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] fix granularity of task_u/stime(), v2
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>	 <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com>	 <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com>	 <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com>
In-Reply-To: <4AFB8C21.6080404@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally task_s/utime() were designed to return clock_t but later
changed to return cputime_t by following commit:

  commit efe567fc8281661524ffa75477a7c4ca9b466c63
  Author: Christian Borntraeger <borntraeger@de.ibm.com>
  Date:   Thu Aug 23 15:18:02 2007 +0200

It only changed the type of return value, but not the implementation.
As the result the granularity of task_s/utime() is still that of
clock_t, not that of cputime_t.

So using task_s/utime() in __exit_signal() makes values accumulated
to the signal struct to be rounded and coarse grained.

This patch removes casts to clock_t in task_u/stime(), to keep
granularity of cputime_t over the calculation.

v2:
  Use div_u64() to avoid error "undefined reference to `__udivdi3`"
  on some 32bit systems.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/sched.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..1f8d028 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5172,41 +5172,45 @@ cputime_t task_stime(struct task_struct *p)
 	return p->stime;
 }
 #else
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs) \
+	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
+#endif
+
 cputime_t task_utime(struct task_struct *p)
 {
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
+	cputime_t utime = p->utime, total = utime + p->stime;
 	u64 temp;
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+	temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
 		temp *= utime;
 		do_div(temp, total);
 	}
-	utime = (clock_t)temp;
+	utime = (cputime_t)temp;
 
-	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	p->prev_utime = max(p->prev_utime, utime);
 	return p->prev_utime;
 }
 
 cputime_t task_stime(struct task_struct *p)
 {
-	clock_t stime;
+	cputime_t stime;
 
 	/*
 	 * Use CFS's precise accounting. (we subtract utime from
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
+	stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
 
 	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+		p->prev_stime = max(p->prev_stime, stime);
 
 	return p->prev_stime;
 }
-- 
1.6.5.2


