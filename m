Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZHYTnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZHYTnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZHYTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:43:06 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56076 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbZHYTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=efXVNruPJEZCQ+nwaznAie52W4Pokm2ucO0Cj6hok2C1PKhdMzOI9Ny+2AezPLiPZg
         nDQ50DaS4kJhuqhbS2I0HfCkszkWimQhFjQAI6HTIG+r1RtyuyBfxRwV4VQBL7dcXV66
         6WYqJ+6iYBsa2uOsxIHi0JGYp4ZBnGNO+isM0=
Date: Tue, 25 Aug 2009 21:42:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825194219.GA8215@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825183119.GC2448@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:31:19PM -0400, Mathieu Desnoyers wrote:
> (Well, I do not have time currently to look into the gory details
> (sorry), but let's try to take a step back from the problem.)
> 
> The design proposal for this kthread behavior wrt syscalls is based on a
> very specific and current kernel behavior, that may happen to change and
> that I have actually seen proven incorrect. For instance, some
> proprietary Linux driver does very odd things with system calls within
> kernel threads, like invoking them with int 0x80.
> 
> Yes, this is odd, but do we really want to tie the tracer that much to
> the actual OS implementation specificities ?


I really can't see the point in doing this. I don't expect the kernel
behaviour to change soon and have explicit syscalls interrupts done
from it. It's not about a current kernel implementation fashion,
it's about kernel design sanity that is not likely to go backward.

Is it worth it to trace kernel threads, maintain their tracing
specificities (such as workarounds with ret_from_fork that implies)
just because we want to support tracing on some silly proprietary drivers?


> 
> That sounds like a recipe for endless breakages and missing bits of
> instrumentation.
>
> So my advice would be: if we want to trace the syscall entry/exit paths,
> let's trace them for the _whole_ system, and find ways to make it work
> for corner-cases rather than finding clever ways to diminish
> instrumentation coverage.


If developers of out of tree drivers want to implement buggy things
that would never be accepted after a minimal review here, and then instrument
their bugs, then I would suggest them to implement their own ad hoc instrumentation,
really :-/

What's the point in supporting out of tree bugs?

Well, the only advantage of doing this would be to support reverse engineering
in tiny and rare corner cases. Not that worth the effort.

 
> Given the ret from fork example happens to be the first event fired
> after the thread is created, we should be able to deal with this problem
> by initializing the thread structure used by syscall exit tracing to an
> initial "ret from fork" value.
> 
> Mathieu


It means we have to support and check this corner case in every archs
that support syscall tracing, deal with crashes because we omitted it, etc...

For all the things I've explained above I don't think it's worth the effort.

But it's just my opinion...

