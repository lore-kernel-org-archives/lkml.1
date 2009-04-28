Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZD1Nm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZD1Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZD1NmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:42:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:34664 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbZD1NmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u0nW4LYUXwBvBzbgFRzymTeOAhn8rjAAQQ4UnfIgCkGgx1kJfpKFfgQ8hdbjE25lz/
         2CmW0fgHyyUWWlYangpvs2FMEfXGEEjTwtTIUWjEBFRrkNTaWlr5WWEHgsJgNSvvt/X1
         otC/GAW8RLqIY3iAatk0fKi2dIlSOA0vVWr1c=
Date: Tue, 28 Apr 2009 15:42:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       zhaolei@cn.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090428134209.GA5978@nowhere>
References: <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <20090426104747.GA5983@elte.hu> <20090426224450.8ea9f724.akpm@linux-foundation.org> <20090427150241.GA23700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427150241.GA23700@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:02:41PM +0200, Oleg Nesterov wrote:
> On 04/26, Andrew Morton wrote:
> >
> > Most workqueue work lately has come from Oleg.  I'm unaware that he has
> > expressed an interest in this feature?  Oleg, would it have been useful
> > in any of the work you've done?
> 
> Well. Probably not. But I don't think this matters. Other people (and
> not only kernel developers) can find this useful.
> 
> I _think_ that if you are going to hack workqueue.c itself, it is
> more easy to just add some printks, may be I am wrong. But, probably
> tracepoints can help to write/debug, say, device drivers. Or admins
> can use debugfs to see whats going on, or to provide more info for
> the bugreports.
> 
> I try to avoid "do we need this feauture" discussions as much as
> possible. Because I never know. My usage of kernel is very, very
> limited, I never do something "interesting" on my machine. This reminds
> me the discussion about the ability to trace /sbin/init. Some developers
> were unhappy with the trivial patch I sent. They said it is trivial
> to change your kernel if you need this. But no, it was not trivial
> to me when I was admin. So, I just can't judge.
> 
> > > And the thing is, the workqueue code has been pretty problematic
> > > lately - with lockups and other regressions.
> 
> Hmm. Perhaps I missed some bug-reports... But I don't remember any
> recent problems with workueues except the "usual" bugs like "flush
> shares the lock with work->func".
> 
> 
> As for the patches, I can't review them now. They are on top of
> some other changes which I didn't see (or perhaps I lost the patches
> I was cc'ed? sorry in this case).


I'm currently gathering Zhaolei patches and I will push them all in
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
 tracing/workqueue

Once it's done, I will also push the fixes that address some of your
comments from your last review.

 
> But at least the change in workqueue.c looks very simple, and do
> not complicate the code for readers. And, if we add any tracing
> to workqueues, then it is very natural to add entry/exit handlers.
> 
> 
> I must admit, I don't really understand why trace_workqueue.c uses
> cwq->thread as a "primary key". I have the feeling we can simplify
> this code if we pass "struct workqueue_struct *" instead, but I am
> not sure.



Indeed, I wanted to use it as the identifier first. The problem
is that this structure is privately defined inside kernel/workqueue.c
And because struct cpu_workqueue * and struct cpu_workqueue::thread
is a 1:1 relation, I've used the thread as the real identifier, so
that I can access the thread_comm and other things.

But actually it's not really a 1:1 matching in CONFIG_HOTPLUG_CPU
case, because the thread can destroyed and the cpu_workqueue assigned
with a new one later.

I managed it by also destroying the workqueue in that case on the stat.


> In particular, trace_workqueue_flush(cwq->thread) looks a bit strange
> to me. I can't imagine how it can be useful per-thread and without
> trace_workqueue_flush_end() or something. I mean, if we need to trace
> flushes, then imho it makes much more sense to add flush_start/flush_end
> handlers into flush_workqueue().


True. The flush would make more sense if it's embraced with a begin/end.
The result would be:

wq_name flush_begin
 cpu_workqueue1
	worklet1 exec
	worklet2 exec
 cpu_workqueue2
	worklet3 exec
	worklet4 exec
 ...
wq_name flush_end

So that we can more easily eye-parse this section and have the
execution time of the whole wait for completion.


> Oleg.
> 

