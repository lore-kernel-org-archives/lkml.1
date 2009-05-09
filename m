Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZEIPYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZEIPYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZEIPYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:24:37 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:52272 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZEIPYh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:24:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8GAJo2BUpMQW1W/2dsb2JhbACBUM0wg34F
Date: Sat, 9 May 2009 11:24:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509152435.GB4071@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal> <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com> <20090509141556.GA24082@elte.hu> <20090509142952.GA3511@Krystal> <c62985530905090801x1a2c34der364d4636ec667429@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <c62985530905090801x1a2c34der364d4636ec667429@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:22:13 up 70 days, 11:48,  5 users,  load average: 0.26, 0.41,
	0.47
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> 2009/5/9 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> >>
> >> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> >>
> >> > > I would expect to use copy_string_from_user (for strings) and
> >> > > copy_from_user for structures, because without any strings
> >> > > (especially), the trace information become much less useful.
> >> >
> >> > Yeah, for structures we would just need the copy_from_user.
> >>
> >> There's just a few places (mainly related to VFS APIs) where we
> >> really want to do that, and there we want to do it a bit later, not
> >> at syscall time: we want to do it after the getname(), to output a
> >> stable (and already copied to kernel space) copy of the file name.
> >>
> >> So the right solution there would be to add special, case by case
> >> tracepoints to those few places. We dont need strings for the
> >> majority of the 300+ system calls that exist on Linux.
> >>
> >>       Ingo
> >
> > Hrm, this is an important design decision.. I cover a lot of those sites
> > in my LTTng instrumentation, and this is clearly one way to do it, at
> > the expense of adding tracepoints in many kernel locations when there
> > could be a functionnal equivalent with syscall instrumentation.
> 
> 
> Yeah, these tracepoints defined from DEFINE_SYSCALL are a good way
> to proceed generically.
> For specific cases, we can later add some upper layer, such as described below.
> 
> 
> > The thing we would need to do it from the syscall tracing site is a
> > table to map the system call numbers to their specific types (for the
> > syscalls we care about) and therefore which would also map to a
> > serialisation function to extract the parameters and write the correct
> > content into the trace buffers.
> 
> 
> I would rather see this not using the syscalls as a key but the type
> of a parameter.
> We can find a same specific complex type used by several syscalls.
> 

Agreed.

> If we want even better precision, we can also pair that with syscalls
> mapping for specific post-computing in output time. As an exemple to
> print O_RDONLY instead of the matching number.
> 

Yep.

> 
> >
> > We could also use getname()/putname() in the syscall tracing primitive.
> > Note that architectures like x86 64 needs some tweaks I have in my
> > patchset to correctly ensure that syscall entry/exit are always paired.
> > This is required because we change the thread flag synchronously with
> > thread execution upen activation/deactivation.
> 
> 
> Not sure I understand your point here. The only resulting problem of such
> race would be rare unpaired syscall exit or entry traces... Is it that
> much important?
> 

If we have non-symmetric getname()/putname(), it will cause bogus ref
counting, and will leak memory.

Having non-matching syscall entry/exit is OK as long as tracing has no
side-effect on the rest of the kernel (e.g. only using local variables).
If we start playing with getname/putname for synchronization, we have to
be extra careful, because we start modifying external state.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
