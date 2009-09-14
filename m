Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZINVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZINVd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZINVd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:33:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:29060 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZINVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rHYXU9RgEWKktPcU40KJZufZmC6DTqmJcvuFhmr78U8t9uXcWLakXBFZdoZqx0kx9H
         yt93tR2KCRFpwyQpqElAIiiwLFxm5EVB4Oy6clShOH4C97xT7Qx+yGm/DJGaPFhKgZ8L
         GuSjb3pYGJIIo4352b+uqNZnx8F2/B+lOI4b0=
Date: Mon, 14 Sep 2009 23:33:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914213352.GK6045@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <20090910142540.GA3512@in.ibm.com> <20090910185304.GD6421@nowhere> <20090914171741.GA29531@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914171741.GA29531@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 10:47:41PM +0530, K.Prasad wrote:
> > Yeah it would be very convenient to have that. Is it possible considering
> > the current internal design of perf?
> >
> 
> It is already done by hw-breakpoints (which can also support cpumask) and
> finding ways to re-use existing breakpoint code post perf integration should
> do the trick.


Yeah but a single struct hw_breakpoint is attached to only
one counter, which can't be cross cpu wide in essence.

Also since we have a 1:1 relationship between the counter and the
struct hw_breakpoint, it would be nice to merge its content into
the counter and drop the struct hw_breakpoint,
that would schrink some code which always have to handle both.

 
> There's an unconditional __perf_counter_init() and
> perf_install_in_context() in register_user_hw_breakpoint_cpu() in
> your patch which can rather be done after checks that ensure the
> availability of a debug register on every CPU requested, update some
> book-keeping variables and run on those CPUs (through IPIs?). By virtue
> of being 'pinned' onto the CPU, I presume, they would remain enabled until
> being removed through an explicit 'unregister' request - functionally
> the same as the present register_kernel_hw_breakpoint() in -tip.
>


But that would rather overlap the role of perfcounter which
is supposed to handle the context attachment to a cpu.


> The other suggestion to enable/disable all breakpoints atomically (to
> implement breakpoints on all CPUs), if possible, would be elegant too.



It's not necessarilly needed to disable all running breakpoints because
a wide brakpoint is coming. The patchset implements all the constraints
that check every possible conflicts (check that there are never more
than HBP_NUM breakpoints running).

Also the idea of preempting a breakpoint looks rather invasive for
the other users.


> In any case, an iterative registration for all CPUs from the end-user
> doesn't provide the abstraction that exists, and is undesirable.


True, this is something that existed in your work and that I couldn't
support after the rebase against perfcounter.

That said, only ftrace and kgdb would use it. But still, this is
something we may want to fix to avoid ftrace and kgdb to handle
these iterations.



> For instance, it cannot handle cases where a CPU becomes online post
> breakpoint registration (and such misses are expensive during
> debugging).


Oh that's not that much a problem I think.
You can register a breakpoint for all possible cpu.
So that once a cpu gets online, the breakpoint is toggled.
If perfcounter support cpu hotplug...not sure.

