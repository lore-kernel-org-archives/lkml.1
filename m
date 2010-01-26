Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151Ab0AZAmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0AZAmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066Ab0AZAmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:42:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:18096 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0AZAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sybv+7AxFaDy3kcHE3UlHZiohGClLqYBRW0NHavKJ0+X+5szRnzGtQ/I59plDBnx/n
         6Ak1GSXcSxEqpXKkTOuUt9iKd+HLj+37RqRj9ei7/XoohS02h7EqbgmsKaxKE5xIkZSe
         t459XHYP4nnLrWta1kh4x/ccDRswlA+5pkK0E=
Date: Tue, 26 Jan 2010 01:41:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100126004153.GJ5087@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122022858.GA2604@Krystal> <1264129978.31321.333.camel@gandalf.stny.rr.com> <20100122040959.GA11827@Krystal> <1264135966.31321.375.camel@gandalf.stny.rr.com> <20100122123450.GA19348@Krystal> <20100125205814.GD5087@nowhere> <4B5E17B8.4090002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E17B8.4090002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 05:14:16PM -0500, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Fri, Jan 22, 2010 at 07:34:51AM -0500, Mathieu Desnoyers wrote:
> >> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >>> On Thu, 2010-01-21 at 23:09 -0500, Mathieu Desnoyers wrote:
> >>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >>>
> >>>>> Hmm, interesting. Maybe something like that might work. But what if
> >>>>> CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?
> >>>>
> >>>> Then you may want to make the function tracer depend on CONFIG_FREEZER,
> >>>> but maybe Masami has other ideas ?
> >>>
> >>> egad no! This is just to help add guarantees to those that use the
> >>> function tracer that when the tracing is disabled, it is guaranteed that
> >>> no more tracing will be called by the function tracer. Currently,
> >>> nothing relies on this. But we may add cases that might need this.
> >>
> >> Yep, identifying tracer quiescent state can become handy.
> >>
> >>>
> >>> In fact, only those that need this requirement would need to do this
> >>> trick. Anyway, we could make those depend on CONFIG_FREEZER, but that
> >>> just seems to be a strange dependency.
> >>
> >> This makes me wonder (question for Masami)...
> >>
> >> static int __kprobes check_safety(void)
> >> {
> >>         int ret = 0;
> >> #if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
> >>         ret = freeze_processes();
> >>         if (ret == 0) {
> >>                 struct task_struct *p, *q;
> >>                 do_each_thread(p, q) {
> >>                         if (p != current && p->state == TASK_RUNNING &&
> >>                             p->pid != 0) {
> >>                                 printk("Check failed: %s is running\n",p->comm);
> >>                                 ret = -1;
> >>                                 goto loop_end;
> >>                         }
> >>                 } while_each_thread(p, q);
> > 
> > 
> > 
> > How does that deal with kernel threads that don't freeze?
> 
> Hmm, right. It can't handle non-freezable kernel threads.
> 
> > Also freezing every processes seems a bit of a heavy thing for that.
> > Looks like a synchronize_tasks() would be really useful.
> 
> Sure :-)
> Maybe, I'd better remove booster support on preemptive kernel until then.


I don't know as I haven't looked deeper into check_safety(), but does the
fact we have non-freezable tasks break the assumptions that make
kprobes booster safe? If so then yeah, may be deactivate it for now.

