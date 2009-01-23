Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbZAWBTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbZAWBTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbZAWBOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:45 -0500
Received: from kroah.org ([198.145.64.141]:50390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758682AbZAWBOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:44 -0500
Date: Thu, 22 Jan 2009 17:11:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 07/46] sched: fix update_min_vruntime
Message-ID: <20090123011139.GH19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-update_min_vruntime.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit e17036dac189dd034c092a91df56aa740db7146d upstream.

Impact: fix SCHED_IDLE latency problems

OK, so we have 1 running task A (which is obviously curr and the tree is
equally obviously empty).

'A' nicely chugs along, doing its thing, carrying min_vruntime along as it
goes.

Then some whacko speed freak SCHED_IDLE task gets inserted due to SMP
balancing, which is very likely far right, in that case

update_curr
  update_min_vruntime
    cfs_rq->rb_leftmost := true (the crazy task sitting in a tree)
      vruntime = se->vruntime

and voila, min_vruntime is waaay right of where it ought to be.

OK, so why did I write it like that to begin with...

Aah, yes.

Say we've just dequeued current

schedule
  deactivate_task(prev)
    dequeue_entity
      update_min_vruntime

Then we'll set

  vruntime = cfs_rq->min_vruntime;

we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
do vruntime = se->vruntime, because

 vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)

will not advance vruntime, and cause lags the other way around (which we
fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
(sched: more accurate min_vruntime accounting).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Mike Galbraith <efault@gmx.de>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -283,7 +283,7 @@ static void update_min_vruntime(struct c
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
+		if (!cfs_rq->curr)
 			vruntime = se->vruntime;
 		else
 			vruntime = min_vruntime(vruntime, se->vruntime);

