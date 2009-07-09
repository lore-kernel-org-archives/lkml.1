Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbZGINuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbZGINuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760531AbZGINuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:50:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:57752 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760239AbZGINuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:50:09 -0400
Date: Thu, 9 Jul 2009 15:51:17 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC][PATCH 0/8] Use EDF to throttle RT task groups
Message-ID: <20090709135117.GR14563@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis> <1247135773.9777.357.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247135773.9777.357.camel@twins>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu, Jul 09, 2009 12:36:13PM +0200
>
> Hi Fabio,
> 
> Sorry for the delay, but we already spoke in person about this last
> week, a bit more detail here.
> 

No problem, thank you for looking at this.


> On Mon, 2009-06-15 at 20:55 +0200, Fabio Checconi wrote:
> > This patchset introduces a group level EDF scheduler to extend the
> > current throttling mechanism, in order to make it support generic
> > period assignments.  With this patch, the rt_runtime and rt_period
> > parameters can be used to specify arbitrary CPU reservations for
> > RT tasks.
> 
> > This is an early RFC, I'm interested in having an idea of what people
> > think about this feature, if it's worth working on it, what can be
> > improved in the design, etc.
> > 
> > The main design issues involved:
> > 
> >   - It is no more possible to specify RUNTIME_INF for a task group
> >     when throttling is enabled.  Rationale: supporting both throttled
> >     and unthrottled groups would have required too much extra complexity
> >     (I didn't find anything simpler than two parallel runqueues, one for
> >     throttled and one for unthrottled groups).
> 
> I would think this is more than reasonable to the point that I wonder if
> it was possible to begin with. I was assuming the current bandwidth
> validation stuff would already exclude this possibility.
> 

>From the scheduling code it seemed possible, but I think I overlooked
the admission control part, sorry about that.


> >   - Since it is not easy to mix tasks and groups on the same scheduler
> >     queue (tasks have no deadlines), the bandwidth reserved to the tasks
> >     in a group is controlled with two additional cgroup attributes:
> >     rt_task_runtime_us and rt_task_period_us.  These attrinutes control,
> >     within a cgroup, how much bandwidth is reserved to the tasks it
> >     contains.
> 
> Agreed.
> 
> >   - Shared resources are still handled using boosting.  When a group
> >     contains a task inside a critical section it is scheduled according
> >     the highest priority among the ones of the tasks it contains.
> >     In this way, the same group has two modes: when it is not boosted
> >     it is scheduled according to its deadline; when it is boosted, it
> >     is scheduled according its priority.  Boosted groups are always
> >     favored over non-boosted ones.
> 
> Yeah, for now this PCP like solution is the best we have. Preferably
> we'll come up with something really smart soon :-)
> 
> >   - The old priority array is now gone.  To use only a single data
> >     structure for entities using both priorities and deadlines (due
> >     to boosting), the only possible choice was to use an rb-tree;
> >     the function used to order the keys takes into account the
> >     prioritization described above (boosted tasks, ordered by
> >     priority are favored to non-boosted tasks, ordered by increasing
> >     deadline).
> > 
> >   - Given that the various rt_rq's belonging to the same task group
> >     are activated independently, there is the need of a timer per
> >     each rt_rq.
> 
> Like I suggested last week, we could flatten the full hierarchy to a 2
> level one, the top level being a EDF like scheduler which purely
> schedules the 'phantom' task groups as created by the new rt_task_*_us
> parameters.
> 

I really like this idea, it would simplify things a lot, with almost
no changes from the scheduling theory POV.  I'll give it a try as soon
as possible.


> Once such a task group is selected we use the regular FIFO rules to pick
> a task.
> 
> Further, like mentioned, you remove the bandwidth distribution between
> cpus in patch 4. You do this because you schedule the groups using PEDF,
> however I was thinking that when we use GEDF to schedule the groups we
> can use the theory from:
> 
>   H. Leontyev and J. Anderson, " A Hierarchical Multiprocessor Bandwidth
>   Reservation Scheme with Timing Guarantees ", Proceedings of the 20th
>   Euromicro Conference on Real-Time Systems, pp. 191-200, July 200
> 
>     http://www.cs.unc.edu/~anderson/papers/ecrts08c.pdf
> 
> This would allow us to lift this constraint.
> 
> As to load-balancing. The current scheme of load-balancing the tasks
> utterly ignores the deadline settings and would also need some suitable
> changes. I fear this part will be a little more challenging.
> 

I was thinking about doing things gradually: first extend throttling
to handle generic periods, then extend the push-pull logic (I think you
are referring to it with load-balancing) to fully support it, and then
think about global EDF.  I think it would be difficult to do all the
things at one time.

I'm not sure that a pure GEDF approach would scale well given the
number of CPUs Linux can support in extreme configurations, maybe a
clustered approach would be more suitable (Anderson's group has published
interesting results both about GEDF scalability and C-EDF).  The focus
on bounded tardiness for soft real time tasks in GEDF would also give
a slightly different meaning to the runtime/period assignments done at
the interface level.

So my proposal was in the direction of introducing group EDF scheduling
consistently with the current throttling implementation, to obtain a more
flexible form of assigning CPU reservations.  GEDF can be implemented on
top of it, adding a push-pull logic to the PEDF queues; anyway I would
not do this without extended benchmarking in various hw configurations.

(Other schemes to implement GEDF would require major surgery to the
 scheduler code, a thing that I wanted to avoid.)

I understand your concern with the removal of the bandwidth distribution
logic, I'll try to reintroduce it in my next post, taking into account
the PEDF schedulability constraints.


> I would think that by using the GEDF and minimal concurrency group
> scheduling we'd get the desired deadline behaviour. After that we'd get
> the task of selecting the FIFO tasks within the dynamic vcpu range
> resulting from the deadline server.
> 
> We could simply implement global-fifo to make it work, and then move
> towards adapting the current (!group) load-balancer to work within these
> more dynamic constraints.
> 
> Thoughts?

About minimal concurrency group scheduling, I am not sure of how we
would handle CPUs hot insertion/extraction, or how the allocation would
be done efficiently (avoiding bin-packing issues) online inside the kernel.

To adapt the current load-balancer to the choices of the deadline-based
scheduler I was thinking about using a cpupri-like structure per task_group,
but now I'm not able to estimate the resulting overhead...

Do you think that this gradual approach makes sense?
