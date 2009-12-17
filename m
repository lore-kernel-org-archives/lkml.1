Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbZLQEvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbZLQEvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763554AbZLQEu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:50:56 -0500
Received: from kroah.org ([198.145.64.141]:55258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762693AbZLQEDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.529151031@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [012/151] sched: Check for an idle shared cache in select_task_rq_fair()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit a1f84a3ab8e002159498814eaa7e48c33752b04b upstream.

When waking affine, check for an idle shared cache, and if
found, wake to that CPU/sibling instead of the waker's CPU.

This improves pgsql+oltp ramp up by roughly 8%. Possibly more
for other loads, depending on overlap. The trade-off is a
roughly 1% peak downturn if tasks are truly synchronous.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1256654138.17752.7.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1398,11 +1398,36 @@ static int select_task_rq_fair(struct ta
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+			int candidate = -1, i;
 
-			affine_sd = tmp;
-			want_affine = 0;
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
+				candidate = cpu;
+
+			/*
+			 * Check for an idle shared cache.
+			 */
+			if (tmp->flags & SD_PREFER_SIBLING) {
+				if (candidate == cpu) {
+					if (!cpu_rq(prev_cpu)->cfs.nr_running)
+						candidate = prev_cpu;
+				}
+
+				if (candidate == -1 || candidate == cpu) {
+					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpu_rq(i)->cfs.nr_running) {
+							candidate = i;
+							break;
+						}
+					}
+				}
+			}
+
+			if (candidate >= 0) {
+				affine_sd = tmp;
+				want_affine = 0;
+				cpu = candidate;
+			}
 		}
 
 		if (!want_sd && !want_affine)


