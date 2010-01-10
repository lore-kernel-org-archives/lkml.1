Return-Path: <linux-kernel-owner+w=401wt.eu-S1751456Ab0AJEAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab0AJEAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062Ab0AJEAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:00:51 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38064 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0AJEAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qOT/SoKoiaLrCmfXemSr5UrvxQ+6CQ8Yj1yH5nIutMAh1Qpg8HYPmGml+mXhC8rnTe
         CqKcCB3gGRXbfW8HK0bYaTYrIbG5PZYZ9BAlAN3Wmq4QVfxY96SXJKbQWnvfdyWPv3oT
         QGfxVLoKkh3IqT+/mJT93zRwPc+ogSDaVDLMs=
Date: Sun, 10 Jan 2010 05:00:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20100110040045.GE15195@nowhere>
References: <20091217172010.GB5457@in.ibm.com> <20091217172253.GC5457@in.ibm.com> <20091218204744.GC5004@nowhere> <20091221184631.GB24535@in.ibm.com> <20091230222837.GI6322@nowhere> <20091231184804.GA3676@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231184804.GA3676@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 12:18:04AM +0530, K.Prasad wrote:
> On Wed, Dec 30, 2009 at 11:28:39PM +0100, Frederic Weisbecker wrote:
> > On Tue, Dec 22, 2009 at 12:16:31AM +0530, K.Prasad wrote:
> > > On Fri, Dec 18, 2009 at 09:47:48PM +0100, Frederic Weisbecker wrote:
> > 
> > > > And this function needs rcu too.
> > > > 
> > > > I don't see any in-kernel user for this new feature.
> > > > That would be required to integrate it.
> > > >
> > > 
> > > The proposed interfaces, as obvious, are mere wrappers over existing
> > > (un)register_user_* interfaces, and don't do anything vastly different
> > > in order to demonstrate them separately.
> > > 
> > > I can get a sample kernel module ready - that consumes pid and user-space
> > > address to track write accesses, if you prefer it.
> > 
> > 
> > Ok. The code looks good and useful.
> > 
> > But the usual philosophy in the kernel is to not add code
> > that is left unused upstream. And samples don't substitute a user.
> > I'm not sure this is a good idea to merge this.
> >
> 
> Back to the old trick!...How about an ftrace plugin that accepts pid,
> user-space address and memory access type and traces all the IP
> addresses that caused access?
> 
> echo <pid>:<user_addr><access_type>  >  usym_trace_filter
> echo 567:0x1234567:rw- > usym_trace_filter
> 
> Breakpoint	IP
> ------------	---------
> 567:0x1234567	0x0abcdef
> 
> I'm unsure if it sounds interesting at all, but I suspect it wouldn't be
> as easy as above to gather the shown information through any existing
> tools.


That's a good idea to trace userspace breakpoints but:

I think the perf interface to use breakpoints is much more powerful
than the breakpoint ftrace plugin, which is somehow deprecated now.

The fact is that ftrace plugins in general (I mean the plugins based
on struct tracer, not the trace events) are mostly deprecated in favor
of trace events.

There are still some areas where the plugins are necessary though, such as
function tracing, and some other tracers. But these are exceptions.
And breakpoints interface was one of them, but now we have
a much more powerful existing interface for it in perf tools.

When it comes to think about improving or adding a new ftrace plugin,
if we know an existing interface that is proven better, let's rather
improve the latter (that's why I'll try to convert the function graph
tracer into a trace event...not an easy task).

The breakpoint ftrace plugin can only trace the whole kernel, has no
per-cpu or per task (+inheritance) granularity, backtraces,
or whatever the perf tools can already offer.

To sum-up, sure we could improve it but:

- we already have better, as a unified and easier to improve interface.
  Extending this ftrace plugin would make it even harder to maintain.

- ftrace plugins are deprecated, except for particular cases


So, concerning breakpoints, I really suggest to focus on the perf tools
and deprecate this breakpoint ftrace plugin.

Also, I'm pretty sure that this would already work:

	./perf record -e mem:@addr_in_ls:rw ls /usr
or:
	./perf record -e mem:@addr_in_ls:rw --pid $(pid_of_a_running_ls)

I've never tested it, but if that doesn't work, that's probably because
of a guardian inside the kernel that only accepts userspace breakpoints
from ptraced processes. I should check that. But if it doesn't work yet,
that would require very few changes for it to work.

