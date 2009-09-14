Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZINSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZINSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZINSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:01:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64758 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZINSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NbKwLbFSMzH7aeeBRxoxve208fPZWNVjxnVOiY2rVd3aztU1QpUvrwSji1h098qvM1
         Oo5gY4AlJgddDbus00d62xAMSCOZX5aqDnVA3IpDQM01T+XYkJ4w4gCE1fHosNuYsnoK
         t47daerrYw0L2LpDC5d/A6gzRwfDXfa12PR7M=
Date: Mon, 14 Sep 2009 20:01:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914180104.GA6045@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <4AAACAA4.2030707@web.de> <20090914034131.GF14306@nowhere> <4AADE19D.7030808@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AADE19D.7030808@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 08:24:29AM +0200, Jan Kiszka wrote:
> > I don't quite understand what must be NMI-safe here. Is it when
> > we request a breakpoint or when we hit one?
> > 
> 
> Both. With kgdb, the kernel may be interrupted (almost) everywhere, and
> then the operator may decide to add/remove hardware breakpoints during
> this interruption.



Ok, a breakpoint can trigger in NMI context since the trigger callback
doesn't take any lock, and doesn't need to. And perf is NMI safe
in this scope too.

But register a breakpoint while in NMI can't be done in this
patchset. You can't even do that from common interrupts because
we are taking mutexes.

So this part will indeed need a bit of a rework, not a large change
though.


 
> > 
> >  
> >> Still on my wishlist for KVM is a cheap & easy way to obtain the current
> >> register content or to refresh it in hardware. It's not yet clear to me
> >> where to hook this in the given design. It looks like this information
> >> can be scattered over the current thread and some perf counters.
> > 
> > 
> > With this design approach, the debug registers are not anymore stored
> > in the thread structure. They are not stored anymore actually.
> > 
> > Especially because the breakpoint are not anymore assigned to a
> > specific address register. This one is decided when the counter
> > is enabled. And the counter is often toggled on/off, depending
> > if we start/end profiling the desired context. It can be a single task,
> > in which case the counter is enabled while the task is sched in, and
> > disabled when it is sched out.
> > And between two sched atoms, the register used for a breakpoint
> > can be different.
> > 
> > The arch informations about the breakpoints (len/type/addr) are stored
> > in the counter structure, and the address/control registers contents
> > are now dynamically computed.
> > 
> > For your needs, basically the control must be done from perfcounters.
> > When you switch from host to guest, the counter must be sched out.
> > And in the reverse direction, it must be sched in.
> > Then perf will take care of that by itself.
> 
> Actually, we wanted to avoid sched-out activity, and so far this is
> possible. But if both steps are cheap enough, specifically if the
> sched-out does _not_ touch the hardware and is very cheap if no
> breakpoints are set, KVM will likely be a happy user.
> 
> Does that API already exist or what additional work is required?
> 
> Jan
> 


Well, what you could do is walking through the list of counters of
the current context, look at breakpoint type counters and disable
their pmu.

Ok it's not very cheap, I must admit.


It would be much less costly to just save the debug registers
actually, which is not that much costy in itself btw.

