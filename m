Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZBIHWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZBIHWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZBIHWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:22:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZBIHWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:22:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: proof-of-concept, utrace->ftrace engine
In-Reply-To: Frank Ch. Eigler's message of  Tuesday, 27 January 2009 14:54:26 -0500 <20090127195425.GF32568@redhat.com>
References: <20090127195425.GF32568@redhat.com>
X-Windows: you'd better sit down.
Message-Id: <20090209072218.214FBFC35D@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 23:22:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's the start of a little ditty that ties process-related events as
> hooked by the Roland McGrath's utrace code into the ftrace
> buffer/control widgetry.  If nothing else, think of it as one
> potential in-tree user of utrace.

Cool!  I won't comment on the use of the tracer or its interface code,
I'll leave that to others.  (It's simplistic and kludgey, but I know
that's what it's going for.)  I'll just review your use of the utrace API.

> +/* Should tracing apply to given task?  Compare against filter
> +   values. */
> +static int trace_test (struct task_struct *tsk) 
> +{
> +        if (trace_taskcomm_filter[0]
> +            && strcmp (trace_taskcomm_filter, tsk->comm))
> +                return 0;

Note that this is the most simple-minded approach for this.  The ->comm
value only changes at exec.  So the "normal", slightly more sophisticated,
way to approach this would be to check at attach time if ->comm matches.
If so, enable full tracing.  If not, enable only EXEC and CLONE events.  In
your report_exec callback, check ->comm to see if the task now should be
filtered in or now should be filtered out, and call utrace_set_events with
more or fewer bits set accordingly.  You always need the report_clone
callback to attach the new child so you can see when it execs; give the new
child the thin or fat event mask as its parent has.

This way, you don't go off the fast paths in signals, etc. when you are
never going to care about those events.  For a trivial hack like this one,
you might not care.  But for more serious use, you want to bother doing it
the fancier way.  If you added syscall tracing support, you probably would
care about the overhead of enabling that on all the uninteresting tasks.

> +        if (trace_taskuid_filter != (u32)-1 
> +            && trace_taskuid_filter != task_uid (tsk))
> +                return 0;

We don't have a utrace event for uid changes, so this one you do have to do
"eagerly".  (Some day in the future, we might well have an event for this
so it can be treated intelligently on transitions as with exec as the
"->comm change event".)

> +static struct utrace_engine_ops process_trace_ops __read_mostly;

This is normally const.  utrace never touches it (all const pointers).
You could change it yourself, but that would not be a normal way to do things.

> +        engine = utrace_attach_task (tsk, UTRACE_ATTACH_CREATE,
> +                                     & process_trace_ops, NULL);

Given how you use UTRACE_ATTACH_MATCH_OPS to effect detach, you might want
to use UTRACE_ATTACH_MATCH_OPS|UTRACE_ATTACH_EXCLUSIVE here.  It's probably
impossible to have another call than yours with the same ops pointer, but
if not then it probably indicates that your later detach could well foul
something up.

> +                /* XXX: Why is this not implicit from the fields
> +                   set in the process_trace_ops? */
> +                rc = utrace_set_events (tsk, engine,

The same reason FWRITE on a struct file is not implicit from having a
.write field set in your struct file_operations.  Your ops struct says
statically what your code is written to handle.  An engine's event mask
says what callbacks you want from that specific thread to that specific
engine at the moment.

> +                                        UTRACE_EVENT(SIGNAL) |

Note this means (exactly as documented):

	_UTRACE_EVENT_SIGNAL,	/* Signal delivery will run a user handler.  */

You might have had UTRACE_EVENT_SIGNAL_ALL in mind.  
That is the union of the five different kinds of SIGNAL* event.

> +u32 process_trace_report_clone (enum utrace_resume_action action,
[...]
> +        return action;
> +}

This is wrong.  If you have nothing special you want to do (just
observing, not perturbing), then "return UTRACE_RESUME;" is what you say.
In report_signal, the non-utrace_resume_action part of the return value
matters, so:
	return UTRACE_RESUME | utrace_signal_action(action);
is what doesn't change anything there.

As documented under 'struct utrace_engine_ops', the action argument is
what other engines are causing to be done independent of what your
engine does.  The utrace_resume_action part of the return value is
what *your engine* wants done, independent of what other engines say.
Your choices might be informed by what other engines are doing in some
cases, but it is not right to mimic what they said.  If some other
engine said UTRACE_STOP, then now you say UTRACE_STOP, but you'll
never call utrace_control to resume, and the thread will be stopped
forever.  If he says UTRACE_STOP and you don't care, you say
UTRACE_RESUME, and the thread stops (UTRACE_STOP < UTRACE_RESUME).
When he calls utrace_control in the future, the thread resumes because
there is no engine left whose last command was UTRACE_STOP.

The non-utrace_resume_action part of the return value (only nonempty for
SIGNAL* and SYSCALL* events) is different.  Unlike utrace_resume_action,
the different choices of different engines can't be combined into a
"least common denominator".  The choice of utrace_signal_action or
utrace_syscall_action setting is what the user-visible disposition
resolving the event will be; all the choices are mutually exclusive and
their effects final.  The last callback to run chooses the final answer.
So each callback has to decide something.  It gets the incoming choice
in its action argument, either from the preceding callback or from the
original normal default (what prevails in the absence of tracing).  The
idiom above passes through the incoming value to leave that choice alone.

> +                /* Skip over kernel threads. */
> +                mm = get_task_mm (tsk);
> +                if (!mm)
> +                        continue;

This should just check PF_KTHREAD.  (As it is, you leak an mm ref here.)
Or just don't bother and handle utrace_attach returning ERR_PTR(-EPERM),
which it will for a kernel thread.


Thanks,
Roland
