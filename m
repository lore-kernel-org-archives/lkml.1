Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbYEBLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbYEBLI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYEBLIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:08:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbYEBLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:08:21 -0400
Subject: Re: Horrendous Audio Stutter - current git
From: Peter Zijlstra <peterz@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209724553.13978.143.camel@twins>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>  <200805021232.10484.elendil@planet.nl>
	 <1209724553.13978.143.camel@twins>
Content-Type: text/plain
Date: Fri, 02 May 2008 13:08:19 +0200
Message-Id: <1209726499.13978.146.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 12:35 +0200, Peter Zijlstra wrote:
> On Fri, 2008-05-02 at 12:32 +0200, Frans Pop wrote:
> > On Friday 02 May 2008, Peter Zijlstra wrote:
> > > So by default we have both enabled; could you report if either
> > > NO_NEW_FAIR_SLEEPERS
> > > NEW_FAIR_SLEEPERS + NO_NORMALIZED_SLEEPERS
> > > works for you?
> > 
> > Both work for me. Tested with current git head (mainline) + your patch.
> > 
> > > Also, could you apply this patch, and report the bonus_max value for
> > > your music player under all three scenarios?
> > 
> > I've restarted amarok and the glibc build each time after change to 
> > sched_features.
> > 
> > # cat sched_features
> > NEW_FAIR_SLEEPERS WAKEUP_PREEMPT START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY 
> > SYNC_WAKEUPS HRTICK NO_DOUBLE_TICK NORMALIZED_SLEEPER DEADLINE
> > 
> > => skips in music (amarok)
> > 
> > /proc/20734/task/20734/sched:se.bonus_max  :     40960.000000
> > /proc/20734/task/20775/sched:se.bonus_max  :     40960.000000
> > /proc/20734/task/20779/sched:se.bonus_max  :     40960.000000
> > /proc/20734/task/20780/sched:se.bonus_max  :     40960.000000
> > /proc/20734/task/20781/sched:se.bonus_max  :     40960.000000
> > /proc/20734/task/20782/sched:se.bonus_max  :        39.960966
> > /proc/20734/task/20799/sched:se.bonus_max  :     40960.000000
> 
> Ok, that's _WAY_ too big, something went seriously wrong. Thanks!

In fact, that is exactly 1024 time too large.

How does this work for you:

Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -685,6 +685,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+	account_entity_enqueue(cfs_rq, se);
 
 	if (wakeup) {
 		place_entity(cfs_rq, se, 0);
@@ -695,7 +696,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	check_spread(cfs_rq, se);
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
-	account_entity_enqueue(cfs_rq, se);
 }
 
 static void update_avg(u64 *avg, u64 sample)


