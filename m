Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYK1OSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYK1OSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1OSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:18:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYK1OR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:17:59 -0500
Date: Fri, 28 Nov 2008 15:17:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
	trace informations
Message-ID: <20081128141738.GE28138@elte.hu>
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu> <c62985530811280555m3b6eaa7fwb50bbe0f5c13bdd3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811280555m3b6eaa7fwb50bbe0f5c13bdd3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/28 Ingo Molnar <mingo@elte.hu>:
> > Firstly, what do you think about the additional tweaks i did - see the
> > patch below?
> >
> > Before:
> >
> > 0)           |     sys_read() {
> > 0)      0.796 us |   fget_light();
> > 0)           |       vfs_read() {
> > 0)           |         rw_verify_area() {
> > 0)           |           security_file_permission() {
> > ------------8<---------- thread sshd-1755 ------------8<----------
> >
> > After:
> >
> >  0)               |  sys_read() {
> >  0)      0.796 us |    fget_light();
> >  0)               |    vfs_read() {
> >  0)               |      rw_verify_area() {
> >  0)               |        security_file_permission() {
> >  ------------------------------------------
> >  | 1)  migration/0--1  =>  sshd-1755
> >  ------------------------------------------
> 
> Thanks! That good, but I remember you wanted a limited number of 
> characters for thread name/pid couple?

Yeah, that needs updating. I supposed you'd be working on the task+pid 
column anyway, and do a helper function that prints the task-pid couple. 
Then that helper can be used in the context-switch case too to print out 
a uniform ID.

Another thing that would be nice is to separate out the "cpu)" printing 
bits into a helper function. Right now what exists cannot be used in a 
seq-manner, so i couldnt reuse it.

Anyway, i wont change it (just wanted to get a final-ish output to look 
at) so feel free to clean it all up thoroughly :)

Today i played with the graph-tracer on a testbox _way_ too much. 
Combined with the wildcard filter it's _really_ addictive. Kernel 
developers, beware!

One thing that came up: it would be nice to have an 'inverted' wildcard 
to punch out certain functions from the filter list. For example i did in 
the shell:

 $ echo 'sys_*'    >> set_ftrace_filter
 $ echo '*socket*' >> set_ftrace_filter
 $ echo '*timer*'  >> set_ftrace_filter
 $ echo '*skb*'    >> set_ftrace_filter

and looked at the trace and found that certain functions are too verbose 
and not really interesting - so i wanted to exclude them.

We've got set_ftrace_notrace but it's not really an inverse wildcard but 
a complementary set of filter functions - which is not the same and not 
as easy to think about as a single set of filter functions.

what i think would be more natural to do is via the filter file itself, 
via an extension like:

 $ echo '!timer_*' >> set_ftrace_filter

which would eliminate the functions matching that negative pattern. Such 
negative wildcards would act on the current set of functions, while 
set_ftrace_notrace is permanent and cannot be used to shape an arbitrary 
set of functions iteratively.

> > Secondly:
> >
> >> +     /* Must not exceed 8 characters: xxxx.yyy us */
> >> +     if (duration > 10000000ULL)
> >> +             duration = 9999999ULL;
> >
> > 10 milliseconds isnt much or full system calls, etc.- so i believe the
> > rule should be what i outlined in an earlier mail. The relevant
> > transition points go like this:
> >
> >     0.000
> >  xxxx.yyy
> >  9999.999
> >  10000.00
> >  xxxxx.yy
> >  99999.99
> >  100000.0
> >  xxxxxx.y
> >  999999.9
> >   1000000
> >   9999999
> >  10000000
> >  xxxxxxxx
> >  99999999 [ 100 seconds ]
> >  100000000 ... up to infinity
> >
> > this way we can get up to 99999999 usecs with the same fixed width -
> > or 100 seconds. _That_ is enough in practice.
> >
> > But even beyond that we should print it all out: we should still not
> > clip actual information but instead shift the line to the right. The
> > slightly inconsistent line is not a big problem - we want a 100
> > seconds delay to stand out anyway ;-)
> >
> > The moving decimal point above 10 milliseconds is not a big problem
> > with the '+' and '!' marker. Maybe add a '!!' marker to these lines?
> 
> Yeah, I was sure I misunderstood your idea about it in your last email 
> :-) Ok. I will do so, I felt a bit uncomfortable with the fixed width 
> above a limit, so I like it this way. Long sleeping functions will be 
> rare enough in the trace to let us move a bit the columns to the right 
> in such cases...

yeah.

The other small detail in the scheme i suggested is that the loss of 
nanosec precision and its gradual weakening to usec precision is 
immaterial in practice as well: we still have at least 9 significant 
digits, so the relative precision is around 1:1000000000 - more than 
enough.

	Ingo
