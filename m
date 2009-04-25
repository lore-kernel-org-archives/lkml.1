Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZDYCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZDYCvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZDYCvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 22:51:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZDYCvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 22:51:05 -0400
Date: Fri, 24 Apr 2009 22:51:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, kosaki.motohiro@jp.fujitsu.com,
       tzanussi@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
In-Reply-To: <20090424192415.1291a76b.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904242238350.24293@gandalf.stny.rr.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
 <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <alpine.DEB.2.00.0904242149150.24293@gandalf.stny.rr.com>
 <20090424192415.1291a76b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Andrew Morton wrote:

> On Fri, 24 Apr 2009 22:00:20 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > I agree that we need to be frugal with the addition of trace points. But 
> > I don't think the bugs that can be solved with this is always reproducible 
> > by the developer.
> > 
> > If you have a distribution kernel that is running at a customers location, 
> > you may not have the privilege of shutting down that kernel, patching the 
> > code, recompiling and booting up this temporary kernel. It would be nice 
> > to have strategic locations in the kernel where we can easily enable a 
> > trace point and monitor what is going on.
> > 
> > If the customer calls and tells you there's some strange performance 
> > issues when running such and such a load, it would be nice to look at 
> > things like workqueues to analyze the situation.
> 
> Would it?  What's the probability that anyone anywhere will *really*
> solve an on-site problem using workqueue tracepoints?  Just one person?
> 
> I think the probability is quite small, and I doubt if it's high enough
> to add permanent code to the kernel.
> 
> Plus: what we _really_ should be looking at is
> 
> p(someone uses this for something) -
> 	p(they could have used a kprobes-based tracer)

This is starting to sound a lot like catch 22. We don't want it in the 
kernel if nobody is using it. But nobody is using it because it is not in 
the kernel.

> 
> no?
> 
> > Point being, the events are not for me on the box that runs my machines.
> > Hell, I had Logdev for 10 years doing that for me. But now to have 
> > something that is running at a customers site with extremely low overhead 
> > that we can enable when problems arise. That is what makes this worth 
> > while.
> > 
> > Note, when I was contracting, I even had logdev prints inside the 
> > production (custom) kernel that I could turn on and off. This was exactly 
> > for this purpose. To monitor what is happening inside the kernel when in 
> > the field.
> 
> We seem to be thrashing around grasping at straws which might justify
> the merging of these tracing patches.  It ain't supposed to be that way.


Unfortunately, analyzing system behavior is a lot like grasping at straws. 
You may never know what is causing some problem unless you view the entire 
picture.

Perhaps the workqueue tracer is not by itself useful for the majority of 
people. I'm not arguing that. It comes pretty much free if you are not 
using it.

I'm looking more at the TRACE_EVENTs in the workqueue (and other places). 
Because having strategically located trace points through out the kernel 
that you can enable all at once, can help analyze the system for issues 
that might be causing problems. You might be thinking you are having 
interrupt issues but enable all events, then you might notice that the 
issues is in the workqueues. Picking your own kprobe locations is not 
going to help in that regard.

In the old -rt patch series, we had trace points scattered all over the 
kernel. This was the original "event tracer". It was low overhead and can 
still give a good overview of the system when the function tracer was too 
much data. Yes, we solved many issues in -rt because of the event tracer. 

Ideally, you want to minimalize the trace points so that it does not look 
like a debug session going wild.  I could maintain a set of tracepoints 
out of tree, but it will only be good for me, and not others.

BTW, you work for Google, doesn't google claim to have some magical 
20-some tracepoints that is all they need? Could you give us a hint to 
what and where they are?

-- Steve
