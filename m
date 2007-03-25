Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXCYW7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXCYW7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXCYW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:59:51 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:40536 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563AbXCYW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:59:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: debug rsdl 0.33
Date: Mon, 26 Mar 2007 08:59:26 +1000
User-Agent: KMail/1.9.5
Cc: "Andy Whitcroft" <apw@shadowen.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Steve Fox" <drfickle@us.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <64bb37e0703251128q3f9db894u24c4638dcf97224a@mail.gmail.com> <200703260849.07943.kernel@kolivas.org>
In-Reply-To: <200703260849.07943.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260859.27272.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 08:49, Con Kolivas wrote:
> On Monday 26 March 2007 04:28, Torsten Kaiser wrote:
> > On 3/24/07, Con Kolivas <kernel@kolivas.org> wrote:
> > >  kernel/sched.c |   51
> > > +++++++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 51
> > > insertions(+)
> >
> > 2.6.21-rc4-mm1 also fails for me.
> >
> > I tried pure 2.6.21-rc4-mm1, +hotfixes, +hotfixes+rsdl33 and at last
> > also added above debug patch.
>
> Thank you very much for the effort!
>
> > The oops from with the debug-patch added:
> > [   65.426126] Freeing unused kernel memory: 312k freed
> > (on the console the system is starting up, getting until "Letting udev
> > process events ...")
> > [   66.665611] Unable to handle kernel NULL pointer dereference at
> > 0000000000000020 RIP:
> > [   66.682030]  [<ffffffff8026167c>] __sched_text_start+0x4dc/0xa0e
>
> The debug patch didn't do anything. This means it is not an unset bitmap
> problem at all otherwise it should have self corrected itself.
>
> > The system in x86_64, two 2218 on a MCP55 nvidia chipset.
> >
> > 2.6.21-rc3-mm1 works fine.
> >
> > (gdb) list *0xffffffff8026167c
> > 0xffffffff8026167c is in schedule (kernel/sched.c:3619).
>
> 	next = list_entry(queue->next, struct task_struct, run_list);
> 	rq->prio_level = idx;
>
> > 3614            /*
> > 3615             * When the task is chosen it is checked to see if its
> > quota has been
> > 3616             * added to this runqueue level which is only performed
> > once per 3617             * level per major rotation for each running
> > task. 3618             */
> > 3619            if (next->rotation != rq->prio_rotation) {
>
> Urgh. Dereferencing there? That can only be next that's deferencing meaning
> the run_list entry is bogus. That should only ever be done under runqueue
> lock so I have a race somewhere where it's not. Time for more looking.

This is about the only place I can see the run_list is looked at unlocked. Can
you see if this simple patch helps? The debug patch is unnecessary now.

Thanks!

--
Ensure checking task_queued() is only done under runqueue lock.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.21-rc4-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/sched.c	2007-03-26 08:54:15.000000000 +1000
+++ linux-2.6.21-rc4-mm1/kernel/sched.c	2007-03-26 08:55:21.000000000 +1000
@@ -3421,16 +3421,16 @@ static inline void rotate_runqueue_prior
 
 static void task_running_tick(struct rq *rq, struct task_struct *p, int tick)
 {
-	if (unlikely(!task_queued(p))) {
-		/* Task has expired but was not scheduled yet */
-		set_tsk_need_resched(p);
-		return;
-	}
 	/* SCHED_FIFO tasks never run out of timeslice. */
 	if (unlikely(p->policy == SCHED_FIFO))
 		return;
 
 	spin_lock(&rq->lock);
+	if (unlikely(!task_queued(p))) {
+		/* Task has expired but was not scheduled off yet */
+		set_tsk_need_resched(p);
+		goto out_unlock;
+	}
 	/*
 	 * Accounting is performed by both the task and the runqueue. This
 	 * allows frequently sleeping tasks to get their proper quota of


-- 
-ck
