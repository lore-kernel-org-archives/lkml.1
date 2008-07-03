Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYGCPPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYGCPPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYGCPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:15:15 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:63272 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYGCPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:15:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAA6HbEhMQWVt/2dsb2JhbACBXLA0
Date: Thu, 3 Jul 2008 11:12:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
Message-ID: <20080703151238.GA3102@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133009.GC13751@Krystal> <48655464.5040000@redhat.com> <20080630154002.GE17388@Krystal> <48693AFB.1020304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48693AFB.1020304@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:04:25 up 28 days, 19:45,  4 users,  load average: 1.27, 0.49,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Mathieu,
> 
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >> Mathieu Desnoyers wrote:
> >>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >>>  >
> >>>>> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
> >>>> What would you think redesigning markers on tracepoints? because most of the
> >>>> logic (scaning sections, multiple probe and activation) seems very similar
> >>>> to markers.
> >>>>
> >>> We could, although markers, because they use var args, allow to put the
> >>> iteration on the multi probe array out-of-line. Tracepoints cannot
> >>> afford this and the iteration must be done at the initial call-site.
> >>>
> >>> From what I see in your proposal, it's mostly to extract the if() call()
> >>> code from the inner __trace_mark() macro and to put it in a separate
> >>> macro, am I correct ? This would make the macro more readable.
> >> Sure, I think marker and tracepoint can share below functions;
> >> - definition of static local variables in specific sections
> > 
> > Given that we could want to keep activation of tracepoints and markers
> > separate (so they don't share the same namespace), declaring the static
> > variables in separated sections seems to make sense to me.
> 
> Sorry, I'm not sure what is "separate activation".
> As far as I can see, both tracepoints and markers are activated
> when its probe handlers are registered on each tracepoint/marker.
> Aren't it separated?
> 

Yes, it is separate. This is insured by the fact that markers and
tracepoints are declared in different sections. Therefore, even if they
have the same "name", they won't be used by each other.

> I did not mean integrating registering interfaces, but
> I think that they can share base(internal) functions.
> for example, both of them has XXX_update_range/_module_XXX_update etc.
> 

Hrm, but the sections and symbols on which these function iterate are
different. I am unsure it's worth trying to merge such tiny functions.

> IMHO, current code is not so good for maintenance. there are
> many code duplications (ex. kernel/module.c, I think
> that both of them (and imv too?) can share the code for
> handling its section and iterating entries). I'm not sure those
> duplications are acceptable.

Given it's only slmost one-liners, and that there is some ordering to
keep (markers and tracepoints must be updated before immediate values
because they might influence the immediate value state), I don't think
having a special section for these callbacks (a little bit like
initcalls, but for module load) is a good option.

> 
> >> - probe activation code (if() call())
> >> - multi probe handling
> > 
> > Hrm, the thing here is that because markers allow to do the iteration on
> > the multiple probe callbacks within an internal wrapper (instead of
> > doing it on-site as in the tracepoints), it allows to do some further
> > optimizations (less memory allocation and less pointer dereference in
> > the single probe case, not having to prepare the va_args in the
> > MARK_NOARGS case) which are only done because it does not have to add
> > code to the instrumentation site. However, tracepoints cannot have such
> > "generic" wrapper and we have to do the iteration on callbacks in the
> > code added to the instrumented object. Therefore, I keep it as small as
> > possible in terms of bytes of instructions.
> 
> OK, I see. So, __tracepoint_block() macro can specify handler function.
> what would you think about it?
> 

When I originally designed the markers, I tried to make sure there was
absolutely no code duplication until I discovered that trying to read a
huge amount of nested macros is just a pain starting from a certain
level. If we only save a few duplicated lines but end up tying up
markers and tracepoints, I am far from certain that it will make the
code more readable.

I'll post a tracepoint version with the modifications you proposed (it's
now placed earlier in the patchset), except the merge with markers.

Mathieu

> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
