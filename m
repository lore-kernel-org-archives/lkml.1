Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZHXKcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZHXKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZHXKcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:32:51 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47647 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZHXKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:32:51 -0400
Date: Mon, 24 Aug 2009 19:32:51 +0900
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
Message-ID: <20090824103251.GA18106@linux-sh.org>
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
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824095652.GC25267@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:56:52AM +0200, Ingo Molnar wrote:
> * Paul Mundt <lethal@linux-sh.org> wrote:
> > I think this is the source of confusion, given that I expected the 
> > interface would remain reasonable stable until all of the existing 
> > users had had a chance to catch up. [...]
> 
> All existing upstream users of APIs were fixed up. Which was x86 and 
> s390. (and yes, we initially missed s390)
> 
> Stable APIs are not how upstream Linux kernel development works - it 
> would be way too inflexible.
> 
> Instead facility trees (such as the tracing tree) are either 
> expected to convert all upstream API uses (which we did), or are 
> supposed to provide different versions of APIs, if an API is so 
> widespread (used by hundreds of callsites, etc.) that it's not 
> reasonable to convert it in one go.
> 
No Ingo, this is not what you did, this is what you did after the
breakage was pointed out to you. And before that, you had:

commit 60d970c254b95ec7a0fc4c590b510253987b64a0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Aug 13 23:37:26 2009 +0200

    tracing: Fix syscall tracing on !HAVE_FTRACE_SYSCALLS architectures

    The new syscall_regfunc()/unregfunc() functions rely on
    the existence of TIF_SYSCALL_FTRACE - but that TIF flag
    is only offered by HAVE_FTRACE_SYSCALLS.

    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jason Baron <jbaron@redhat.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Which you at least managed to catch before it went in to -next.

At the time that this patch series was pulled in to -tip, it was basically
broken for 21 out of 22 architectures. And while it's great that you caught
this during your builds and so only a couple were broken instead, it still
should never have made it in to the tree when it was clear it had had precisely
zero testing. What happens if anyone is unfortunate enough to bisect in between
these versions now? It's this sort of development methodology I take issue
with, regardless of how you want to pass it off.

> > [...] As it is now it is impossible to make any changes to things 
> > that are taken over by -tip given that the first sign of there 
> > being any changes are failures introduced through -next, which 
> > would have been avoided if folks eagerly merging things in to -tip 
> > considered the implications for -next.
> 
> Paul, what you say is not making any sense to me. All those ftrace 
> patches were sent to lkml multiple times (as all ftrace patches), so 
> if you wanted you could have known about them.
> 
> If there's someone who failed to notify it was _you_. You might as 
> well have Cc:-ed the guys who wrote the code you started using in 
> SH.
> 
And for what purpose? When has adding feature support to an architecture _ever_
worked that way? The expectation is that a new feature is added, folks add
support for it, and as changes are made in the future, a reasonable attempt is
made to keep folks using it aware of the changes being planned. Ok, in the
future I will be more proactive with Ccing ftrace people on these changes, but
it doesn't change the fact that _no one_ on the -tip side paid any attention at
all to the impact it would have on -next. The s390 case also had to be pointed
out to you, and you don't have the excuse that it was out of tree there.

If this doesn't make sense to you, I'm not sure how else to phrase it. Blindly
merging crap in to -next with zero regard for the impact on others is simply
unacceptable as far as I'm concerned. If enough people feel otherwise, then
there's not much to be done about it.

> > Pointing fingers however is rather pointless at this stage, and is 
> > not what I am trying to do. [...]
> 
> ( Hey what was the purpose of the previous 3 paragraphs then? ;-)
> 
The purpose of the previous 3 paragraphs was pointing out that there is an
issue with untested code being regularly merged in to -next, and that people
are not doing even basic due diligence to ensure that things will not break
before pushing to their trees. -tip is only the current case, my point is that
I am not attempting to make an example of -tip specifically, only that this is
a problem in general.

> I know it as i always cross-build SH (too) before i push out to 
> linux-next. I dont remember a _single_ SH breakage in the past few 
> months, and we push thousands of commits. In fact the last time the 
> ftrace tree broke linux-next was 8 months ago:
> 
But you probably only build -tip and not -next. The point is that the end
result in -next ends up broken, so whether -tip builds or not is not the issue
(although of course I'm glad that you build sh for -tip too, that probably
catches a lot more of these issues before they end up popping up in
-next at least).

> So i'd really like you to back up your claims with facts. Your mail 
> is basically unsubstantiated FUD right now and i'll just ignore you 
> if you continue this pattern of unsubstantiated attacks and 
> unconstructive behavior.
> 
I could sit here and itemize individual breakages all day long, but what would
be the point? Is it likely to force -tip people to even do a cursory grep to
check for what they are going to end up breaking? You obviously have your
perspective on -tip and -next interaction which differs wildly for anyone on
the receiving end. This doesn't seem likely to change, and I am growing weary
of trying to even get you to acknowledge that there is a problem.

Rather than wasting any more of my time on this, I'll just go back to fixing up
all of the breakage introduced in -next by others who likewise couldn't be
bothered doing the bare minimum.
