Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYLDNbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYLDNbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYLDNa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:30:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYLDNa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:30:56 -0500
Date: Thu, 4 Dec 2008 08:30:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
In-Reply-To: <20081204083507.GE32594@elte.hu>
Message-ID: <alpine.DEB.1.10.0812040817260.5240@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org> <20081204083507.GE32594@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > This series has three patches.
> > 
> > The first patch adds a new feature that I've been wanting to have for 
> > some time and Arjan even requested. That is to pick a function and only 
> > trace that function and its children. Dynamic ftrace and function graph 
> > needs to be enabled for this.
> > 
> > To do the above, I added a "trace" flags field in the task structure. 
> > The second patch uses this for the ftrace pid code. It searches for the 
> > task based on the pid and sets the trace flag, then in the ftrace 
> > function caller it only needs to check this flag.
> 
> Btw., i'd love to see this done via the regular regexp interface though, 
> if possible - instead of the add-on interface you added.

So would I. Unfortunately the regex is tightly coupled to turning on or 
off the function. This needs all functions enabled because we do not
know which functions the flagged one will call.

I could reuse the regex code if I add a call back to handle what to do on 
a match.  This is a bit more work, and will take some time to do.
If someone else has the time to do it, I would offer suggestions and 
review the code. Right now I do not have the time myself.

> 
> ( Also perhaps enable to toggle tracing via the /proc/<PID>/ hierarchy - 
>   a /proc/<PID>/tracing_enabled switch or so. )
> 
> Regarding the filter functions, the basic principle should be 
> mathematical set operations, like we have it now: add and remove, union, 
> wildcards, etc.
> 
> I'd suggest a natural and intuitive extension of the current syntax. 
> (while keeping all the current bits)
> 
> I already suggested a 'inverse' filter in a previous mail:
> 
>   echo "-schedule*" >> set_ftrace_filter

Ah, I did not see the '>>' that might be easier to do. I think you first
suggested this with a "!sched*" > set_ftrace_filter where the '>' would
truncate. But doing it with append '>>', might work.

> 
> This rule operates on the current set of filter functions: it strikes out 
> all existing filter functions that match this pattern.
> 
> To handle PIDs, we could do something like:
> 
>   echo "sshd-312:schedule" > set_ftrace_filter
> 
> This would restrict tracing to the sshd-pid:312 task.
> 
> Note: the PID portion of the filter rules still stay separate from the 
> function names - we dont want per task function filter rules.

Yep, agreed, A function is traced if the following conditions are true:

- function tracing is enabled
- the function is set to trace (not in set_ftrace_notrace)
- the pid filter is on and the current task has its trace bit set
 or the pid filter is off.
- the function filter is on and the function is in the trace array
 or the function filter is off

> 
> A natural variation would be:
> 
>   echo "312:schedule" > set_ftrace_filter
> 
> to only specify the PID, or:
> 
>   echo "312,313:schedule" > set_ftrace_filter
> 
> to specify two PIDs, or:
> 
>   echo "sshd:schedule" > set_ftrace_filter
> 
> to only specify the 'comm' part, which expands to all PIDs where 
> task->comm matches sshd. Another variation would be:
> 
>   echo "loop*:schedule" > set_ftrace_filter
> 
> that matches all PIDs where task->comm matches loop*.
> 
> To specify recursive tracing, we could use something like:
> 
>   echo "loop*+schedule" > set_ftrace_filter
> 
> the '+' would signal that the 'schedule' function is 'expanded' and all 
> its child functions are traced as well.
> 
> btw., maybe it makes sense to separate the regexp rule-set from the set 
> of functions that we are tracing right now. For example:
> 
>   $ echo "schedule*" >  set_ftrace_filter
>   $ echo "time*"     >> set_ftrace_filter
>   $ echo "sys_*"     >> set_ftrace_filter
> 
>   $ cat set_ftrace_filter
>   schedule*
>   time*
>   sys_*
> 
> We'd also have a separate, current_ftrace_functions file as well which 
> shows all traced functions. (on a global basis - with possible PID filter 
> rules added where applicable)
> 
> I know this will be hellishly hard to implement, but it would be _very_ 
> elegant, and _very_ usable.
> 
> What do you think?

Hmm, that is starting to get quite complex, just to use. This is something 
we need to experiment with to find the best solution. I'd like to know use 
cases first. Currently I have a simple program that forks, traces itself 
and execs code to trace. It is exectued like:

  ./trace-func ls -ltr

to trace "ls -lrt",  this code would become a little more complex with the 
above methods.  But I'm not set in stone in any of these options. I just 
do not want to spend the days coding this to find out no one uses any of 
it but what is already there.

-- Steve

