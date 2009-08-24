Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZHXI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZHXI7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZHXI7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:59:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51496 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZHXI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:59:44 -0400
Date: Mon, 24 Aug 2009 17:59:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824085944.GA15330@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824084101.GE2424@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:41:01AM +0200, Ingo Molnar wrote:
> * Paul Mundt <lethal@linux-sh.org> wrote:
> > On Sun, Aug 23, 2009 at 11:14:24PM +0200, Frederic Weisbecker wrote:
> > > On Fri, Aug 21, 2009 at 09:58:43PM -0700, Josh Stone wrote:
> > > > The bodies of syscall_regfunc and syscall_unregfunc need the
> > > > arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
> > > > on x86 and s390, so they should live in arch-specific files.
> > > 
> > > Sh also does, but currently in a seperate development branch. 
> > > (Adding Paul Mundt in Cc to prevent from further linux-next 
> > > breakage).
> > 
> > Thanks, I'll take care of this as well as the other ftrace 
> > syscalls breakage during the merge window. At the moment I don't 
> > have any good ideas on how to fix the workflow issues, and -tip 
> > likewise doesn't care about -next impact, so there's somewhat of 
> > an impasse.
> 
> Where did you take the nonsense from that '-tip likewise doesn't 
> care about -next impact'? It's a false statement on several levels.
> 
> The thing is, there is just a single 'breakage' here (SH does not 
> build if the tracing tree is mixed with the SH tree), and you 
> inflicted it upon yourself: you mixed ftrace development into the SH 
> tree (thinking that the syscall-tracing facility was a stable API - 
> where did _that_ nonsense come from?), while the tracing tree did 
> development of ftrace too (surprise), so when the two versions were 
> mixed in linux-next it broke.
> 
I think this is the source of confusion, given that I expected the
interface would remain reasonable stable until all of the existing users
had had a chance to catch up. As it is now it is impossible to make any
changes to things that are taken over by -tip given that the first sign
of there being any changes are failures introduced through -next, which
would have been avoided if folks eagerly merging things in to -tip
considered the implications for -next.

Pointing fingers however is rather pointless at this stage, and is not
what I am trying to do. I've lost count of the number of times -tip has
broken things in -next that were easily avoidable, and at this point I
don't even care anymore (as I've stated before, it's not just -tip,
people in general seem to be doing a lot of aggressive merging without
even a cursory grep to check for the build implications). I fix them up
as I encounter them, and try to keep my configs in general buildable
shape. You call that nonsense, I call it statistics.

In any event, at least some of these issues are self-inflicted given that
some feature implementation is done in my tree directly without passing
through -tip first, but none of that changes the fact that -tip is
merging things in to -next without any consideration of the impact it
will have. This is what I have a fundamental issue with, given that there
are a lot more trees than just -tip being merged, and at least some
effort should be made to permit things to co-exist rather than just
blaming it all on workflow.

> There's numerous ways to resolve this and i'm willing to help out 
> with any of the solutions your chose (or with some other variant if 
> it makes sense):
> 
>  - Easiest: you can turn off the old-API based ftrace bits in the SH 
>    tree, in your for-next branch. This is the easiest, but keeps new 
>    SH ftrace bits untested in linux-next.
> 
I've already done this.

>  - The proper workflow: you can actually help out the development of 
>    tracing facilities by doing tracing development in the tracing 
>    tree. We merged a number of architecture ftrace improvements via 
>    the tracing tree already, as long as it's acked by the maintainer 
>    (which is a given here - you maintain SH) and as long as it does 
>    not touch non-ftrace bits of the architecture unreasonably.
> 
>    This is the most natural workflow and the fastest one as well. 
>    The ftrace bits are well separated (or should be well separated). 
>    We didnt do ftrace development via the x86 tree either.
> 
> I'd favor the third one as it's the most intelligent variant and we 
> used that in a number of other cases - but it's up to you.
> 
Agreed, this is the way we will try to handle ftrace bits for sh from now
on. There is not much to be done about the present mess other than
waiting for things to sync up in the merge window, which I'm fine with at
present given that it's not so far off.
