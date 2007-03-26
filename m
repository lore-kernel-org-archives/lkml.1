Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXCZFA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXCZFA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXCZFA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:00:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:33881 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750968AbXCZFA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:00:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX190KLpfUlp01KkkqWGhtw8LHrFLShV7JOk9y2sa7A
	AyJORTSWl++C9Y
Subject: Re: rSDl cpu scheduler version 0.34-test patch
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703261100.22467.kernel@kolivas.org>
References: <200703261100.22467.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 07:00:53 +0200
Message-Id: <1174885253.7040.57.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 11:00 +1000, Con Kolivas wrote:
> This is just for testing at the moment! The reason is the size of this patch.

(no testing done yet, but I have a couple comments)

> In the interest of evolution, I've taken the RSDL cpu scheduler and increased 
> the resolution of the task timekeeping to nanosecond resolution.

+	/* All the userspace visible cpu accounting is done here */
+	time_diff = now - p->last_ran;
...
+		/* cpu scheduler quota accounting is performed here */
+		if (p->policy != SCHED_FIFO)
+			p->time_slice -= time_diff;

If we still have any jiffies resolution clocks out there, this could be
a bit problematic.

+static inline void enqueue_pulled_task(struct rq *src_rq, struct rq *rq,
+				       struct task_struct *p)
+{
+	int queue_prio;
+
+	p->array = rq->active; <== set
+	if (!rt_task(p)) {
+		if (p->rotation == src_rq->prio_rotation) {
+			if (p->array == src_rq->expired) { <== evaluate
+				queue_expired(p, rq);
+				goto out_queue;
+			}
+			if (p->time_slice < 0)
+				task_new_array(p, rq);
+		} else
+			task_new_array(p, rq);
+	}
+	queue_prio = next_entitled_slot(p, rq);

(bug aside, this special function really shouldn't exist imho, because
there's nothing special going on.  we didn't need it before to do the
same thing, so we shouldn't need it now.)

+static void recalc_task_prio(struct task_struct *p, struct rq *rq)
+{
+	struct prio_array *array = rq->active;
+	int queue_prio;
+
+	if (p->rotation == rq->prio_rotation) {
+		if (p->array == array) {
+			if (p->time_slice > 0)
+				return;
+			p->time_slice = p->quota;
+		} else if (p->array == rq->expired) {
+			queue_expired(p, rq);
+			return;
+		} else
+			task_new_array(p, rq);
+	} else

Dequeueing a task still leaves a stale p->array laying around to be
possibly evaluated later.  try_to_wake_up() doesn't currently evaluate
and set p->rotation (but should per design doc), so when you get here, a
cross-cpu waking task won't continue it's rotation.  If it did evaluate
and set, recalc_task_prio() would evaluate the guaranteed to fail these
tests array pointer, so the task will still not continue it's rotation.
Stale pointers are evil.

	-Mike

