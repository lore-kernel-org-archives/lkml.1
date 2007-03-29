Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbXC2FvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbXC2FvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXC2FvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:51:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:49159 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752228AbXC2FvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:51:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CoD4GCdhCZFbR6HEwH6rdtZGFIxA81GN9qWoiAG
	uw2rTcQDg0M8bc
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200703290944.45888.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070328184843.GA17420@elte.hu>  <200703290944.45888.kernel@kolivas.org>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 07:50:55 +0200
Message-Id: <1175147455.6430.91.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 09:44 +1000, Con Kolivas wrote:
> On Thursday 29 March 2007 04:48, Ingo Molnar wrote:
> > hm, how about the questions Mike raised (there were a couple of cases of
> > friction between 'the design as documented and announced' and 'the code
> > as implemented')? As far as i saw they were still largely unanswered -
> > but let me know if they are all answered and addressed:
> 
> I spent less time emailing and more time coding. I have been working on 
> addressing whatever people brought up.
> 
> >  http://marc.info/?l=linux-kernel&m=117465220309006&w=2
> 
> Attended to.
> 
> >  http://marc.info/?l=linux-kernel&m=117489673929124&w=2
> 
> Attended to.
> 
> >  http://marc.info/?l=linux-kernel&m=117489831930240&w=2
> 
> Checked fine.

That one's not fine.

+static void recalc_task_prio(struct task_struct *p, struct rq *rq)
+{
+	struct prio_array *array = rq->active;
+	int queue_prio;
+
+	update_if_moved(p, rq);
+	if (p->rotation == rq->prio_rotation) {
+		if (p->array == array) {
+			if (p->time_slice > 0)
+				return;
+			p->time_slice = p->quota;
+		} else if (p->array == rq->expired) {

You implemented nanosecond accounting, but here you give a task which
has either missed the tick ofter enough, or accumulated enough cross cpu
clock drift to have an I.O.U. in it's wallet a shiny new $8 bill.

WRT  clock drift/timewarps, your latest code cedes that these do occur,
but where these timewarps can be anywhere between minuscule with Intel
same package processors, up to a tick elsewhere, charges a tick. 
 
-       /* cpu scheduler quota accounting is performed here */
+       if (tick) {
+               /*
+                * Called from scheduler_tick() there should be less
than two
+                * jiffies worth, and not negative/overflow.
+                */
+               if (time_diff > JIFFIES_TO_NS(2) || time_diff <
min_diff)
+                       time_diff = JIFFIES_TO_NS(1); 

> > and the numbers he posted:
> >
> >  http://marc.info/?l=linux-kernel&m=117448900626028&w=2
> 
> Attended to.

Hm.  How, where?

I'm getting inconsistent results with current, but sleeping tasks still
don't _appear_ to be able to compete with hogs on an equal footing, and
I don't see how they really can.

What happens if a sleeper sleeps after using say half of it's slice, and
the hog it's sharing the CPU with then sleeps briefly after using most
of it's slice.  That's the end of the rotation.  They are put back on an
equal footing, but what just happened to the differential in cpu usage?

> > his test conclusion was that under CPU load, RSDL (SD) generally does
> > not hold up to mainline's interactivity.
> 
> There have been improvements since the earlier iterations but it's still a 
> fairness based design. Mike's "sticking point" test case should be improved 
> as well.

The behavior is different, and is less ragged, but I wouldn't say it's
really been improved.  The below was added as a workaround.

+ * This contains a bitmap for each dynamic priority level with empty slots
+ * for the valid priorities each different nice level can have. It allows
+ * us to stagger the slots where differing priorities run in a way that
+ * keeps latency differences between different nice levels at a minimum.
+ * ie, where 0 means a slot for that priority, priority running from left to
+ * right:
+ * nice -20 0000000000000000000000000000000000000000
+ * nice -10 1001000100100010001001000100010010001000
+ * nice   0 0101010101010101010101010101010101010101
+ * nice   5 1101011010110101101011010110101101011011
+ * nice  10 0110111011011101110110111011101101110111
+ * nice  15 0111110111111011111101111101111110111111
+ * nice  19 1111111111111111111011111111111111111111

I don't really know what to say about this.  I think it explains reduced
context switching, but I don't see how this could be a good thing.
Consider a nice -20 fast/light task trying to get CPU with nice 0 tasks
being constantly spawned.  How can this latency bound fast mover perform
if it can't preempt?  What am I missing?

> My call based on my own testing and feedback from users is: 
> 
> Under niced loads it is 99% in favour of SD.
> 
> Under light loads it is 95% in favour of SD.
> 
> Under Heavy loads it becomes proportionately in favour of mainline. The 
> crossover is somewhere around a load of 4.

Opinion polls are nice, but I'm more interested in gathering numbers
which either validate or invalidate the claims of the design documents.
 
WRT this subjective opinion thing, I see regressions with all loads, and
I don't see what a < 95% load really means.  If CPU isn't contended,
dishing it out is dirt simple.  Just give everybody frequent, and fairly
short chunks, and everybody is fairly happy.  The only time scheduling
becomes interesting is when there IS contention, and mainline seems to
do much better at this, with the caveat that the history mechanism
indeed doesn't always get it right.

	-Mike

