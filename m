Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439Ab0ANPU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0ANPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598Ab0ANPU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:20:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0ANPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:20:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=_N7Pc1iYQ8sA:10 a=7U3hwN5JcxgA:10 a=rOUgymgbAAAA:8 a=qR4S59VHF1IjLDLJif4A:9 a=DuQ39y2hQ_DEemOt3iwA:7 a=NRxhg_NH0fK-ZuY3n6NAhrFvE6IA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: linux-next: manual merge of the tip tree with the kgdb tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B4F31D4.1000707@windriver.com>
References: <20100114161302.285ebe27.sfr@canb.auug.org.au>
	 <20100114092600.GA13503@elte.hu>  <4B4F31D4.1000707@windriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 10:20:52 -0500
Message-ID: <1263482452.28171.3853.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 09:01 -0600, Jason Wessel wrote:
> Ingo Molnar wrote:
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >   
> >> Hi all,
> >>
> >> Today's linux-next merge of the tip tree got a conflict in
> >> kernel/trace/trace.c between commit
> >> d304af88a0105ff5b64cffc9108636ecad1fdd78 ("ftrace,kdb: Extend kdb to be
> >> able to dump the ftrace buffer") from the kgdb tree and commit
> >> 7e53bd42d14c75192b99674c40fcc359392da59d ("tracing: Consolidate
> >> protection of reader access to the ring buffer") from the tip tree.
> >>     
> >
> > Hm, Jason, what is that large commit to kernel/trace/ doing in the KGDB tree, 
> > without any apparent acks from the affected people?
> >   
> 
> I had been corresponding with Steven Rostedt directly.  This is actually
> the 3rd iteration of the patch (the first two never got checked in
> anywhere) and there is still an outstanding question, which I will
> inline at the bottom of this email.  The ftdump patch is at the very end
> of the kdb series, because this patch will get nuked if Steven or anyone
> else has a problem with it.

Yep, we've been talking, I just didn't know it went into a public git
tree yet :-)

> 
> As for what the patch does, it is routine for dumping the ftrace buffer
> while in the kernel debugger context.
> 
> > I dont see it anywhere on lkml nor in my mbox. Please submit it to the 
> > affected maintainers - for the Cc: line see the output of:
> >   
> 
> The v2 version of the kdb  series was supposed to go out yesterday
> morning (also known as kdb_prototype11).   The new patch is included in
> the post, look for: "[PATCH 40/40] ftrace,kdb: Extend kdb to be able to
> dump the ftrace buffer"
> 
> -- prior inlined correspondence --
> 
> Steven Rostedt wrote:
> 
> > > On Tue, 2010-01-05 at 23:57 -0600, Jason Wessel wrote:
> >   
> >> >> Here is another try at adding a dump function for kdb.  I had to
> >> >> changes some of the static -> global scope in kernel/trace/trace.c in
> >> >> order to be able to reference other semi-private via "trace.h".
> >>     
> > > 
> > > Actually, could you write access functions instead. If we make these
> > > items global in scope, then others will just start accessing them
> > > directly. I've had this issue before because others have tried to make
> > > the global_trace visible by all. But that variable may disappear and
> > > break all that use it.
> > > 
> >   
> 
> Thanks for the insight.
> 
> Here is v3.
> 
> I added a function called trace_init_global_iter().  I'll rename it if
> you like.  I also changed the ftrace_dump() to make use of it as well
> so we are more likely to see an issue when it changes if there are
> more consumers of the function.
> 
> The other question it brings up is if you want a helper function for
> the atomic_inc / atomic_dec of the tracing cpus.  That would move that
> for_each_tracing_cpu macro back into trace.c.


I think the point Ingo is making, is that the changes to the
kernel/trace directory would best go through the tip tree. This will
ensure that this change does not have any undesirable effects to other
parts of tracing that is being worked on.

There's always an issue with having one subsystem depend on changes in
another subsystem. What I did in the past when PPC needed changes to the
trace directory, was that I made the changes in the trace code directly
against Linus's tree in a separate branch. Then the two git repo's (PPC
and tip) could pull that change in. Which ever one went first to Linus
would get the required change without causing duplicates.

But since this is the last patch in the series, perhaps it can just go
directly into tip?

-- Steve


