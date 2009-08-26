Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZHZGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZHZGtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbZHZGtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:49:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZHZGtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:49:21 -0400
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090825194219.GA8215@nowhere>
References: <20090825141547.GE6114@nowhere>
	 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
	 <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere>
	 <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal>
	 <20090825194219.GA8215@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 08:48:07 +0200
Message-Id: <1251269287.7538.1218.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 21:42 +0200, Frederic Weisbecker wrote:
> On Tue, Aug 25, 2009 at 02:31:19PM -0400, Mathieu Desnoyers wrote:
> > (Well, I do not have time currently to look into the gory details
> > (sorry), but let's try to take a step back from the problem.)
> > 
> > The design proposal for this kthread behavior wrt syscalls is based on a
> > very specific and current kernel behavior, that may happen to change and
> > that I have actually seen proven incorrect. For instance, some
> > proprietary Linux driver does very odd things with system calls within
> > kernel threads, like invoking them with int 0x80.
> > 
> > Yes, this is odd, but do we really want to tie the tracer that much to
> > the actual OS implementation specificities ?
> 
> 
> I really can't see the point in doing this. I don't expect the kernel
> behaviour to change soon and have explicit syscalls interrupts done
> from it. It's not about a current kernel implementation fashion,
> it's about kernel design sanity that is not likely to go backward.
> 
> Is it worth it to trace kernel threads, maintain their tracing
> specificities (such as workarounds with ret_from_fork that implies)
> just because we want to support tracing on some silly proprietary drivers?
> 
> 
> > 
> > That sounds like a recipe for endless breakages and missing bits of
> > instrumentation.
> >
> > So my advice would be: if we want to trace the syscall entry/exit paths,
> > let's trace them for the _whole_ system, and find ways to make it work
> > for corner-cases rather than finding clever ways to diminish
> > instrumentation coverage.
> 
> 
> If developers of out of tree drivers want to implement buggy things
> that would never be accepted after a minimal review here, and then instrument
> their bugs, then I would suggest them to implement their own ad hoc instrumentation,
> really :-/
> 
> What's the point in supporting out of tree bugs?
> 
> Well, the only advantage of doing this would be to support reverse engineering
> in tiny and rare corner cases. Not that worth the effort.
> 
>  
> > Given the ret from fork example happens to be the first event fired
> > after the thread is created, we should be able to deal with this problem
> > by initializing the thread structure used by syscall exit tracing to an
> > initial "ret from fork" value.
> > 
> > Mathieu
> 
> 
> It means we have to support and check this corner case in every archs
> that support syscall tracing, deal with crashes because we omitted it, etc...
> 
> For all the things I've explained above I don't think it's worth the effort.
> 
> But it's just my opinion...

I fully agree, let out of tree people deal with their own crap.
