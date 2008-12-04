Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYLDN4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYLDN4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYLDN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:56:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40007 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbYLDN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:56:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
	<20081204001803.598063f5.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0812040803340.5240@gandalf.stny.rr.com>
Date: Thu, 04 Dec 2008 05:52:06 -0800
In-Reply-To: <alpine.DEB.1.10.0812040803340.5240@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 4 Dec 2008 08:12:27 -0500 (EST)")
Message-ID: <m1ljuwt5dl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 4 Dec 2008, Andrew Morton wrote:
>
>> On Thu, 04 Dec 2008 00:26:41 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
>> 
>> > From: Steven Rostedt <srostedt@redhat.com>
>> > 
>> > Impact: New feature
>> > 
>> > This patch lets the swapper tasks of all CPUS be filtered by the
>> > set_ftrace_pid file.
>> 
>> "filtered" is one of those nasty words.  It is unclear whether the
>> filteree is included or excluded.
>> 
>> > If '0' is echoed into this file, then all the idle tasks (aka swapper)
>> > is flagged to be traced.  This affects all CPU idle tasks.
>> > 
>> 
>> s/is/are/
>
> My English is much better before midnight.
> But warning, it is worse before my first coffee. ;-)
>
>> 
>> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>> 
>> What does this patch actually do?  Is swapper currently excluded from
>> tracing for undisclosed reasons and this patch permits it to be traced?
>> If so, why was swapper thus excluded?  Or am I totally off track?
>
> Yes, it is excluded. For two reasons:
>
> 1) you can not get to the swapper task using struct pid
> 2) the swapper task is not part of the task link list. Well, the first
>   swapper task may be, but not the ones for other CPUS.
>
> In fork.c:
>
> 	if (likely(p->pid)) {
> 		[...]
> 		if (thread_group_leader(p)) {
> 			[...]
> 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
>
>
>

>> > ---
>> > kernel/trace/ftrace.c | 74 +++++++++++++++++++++++++++++++++++++++++-------
>> >  1 files changed, 63 insertions(+), 11 deletions(-)
>> > 
>> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> > index 10b1d7c..eb57dc1 100644
>> > --- a/kernel/trace/ftrace.c
>> > +++ b/kernel/trace/ftrace.c
>> > @@ -49,6 +49,7 @@ static int last_ftrace_enabled;
>> >  
>> >  /* set when tracing only a pid */
>> >  struct pid *ftrace_pid_trace;
>> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
>> 
>> eh?
>
> The swapper task has no pid structure
It does have a pid structure it just isn't hashed.

>, if we want to trace it, we
> need to find it outside the pid code. But other parts of ftrace use the
> ftrace_pid_trace to see if it it should only trace the tasks that have
> the trace bit set. We have:
>
> 	if (ftrace_pid_trace)
> 		/* only trace this task if it is marked to trace */
>
> But, I get your point. That line deserves a comment ;-)

>> What locking does this traversal need, and does this function have it?
>
> No idea, I only did what Eric suggested.

Sorry I'm tired going fast and was just sketching the highlights.

> And people wonder why we still stick to "task->pid"

Hey thanks for trying to figure it out.

Eric

