Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZEIOaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZEIOaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZEIO3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:29:55 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:36743 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbZEIO3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:29:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8GAM8vBUpMQW1W/2dsb2JhbACBUM04g34F
Date: Sat, 9 May 2009 10:29:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509142952.GA3511@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal> <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com> <20090509141556.GA24082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090509141556.GA24082@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:25:05 up 70 days, 10:51,  4 users,  load average: 0.16, 0.45,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > I would expect to use copy_string_from_user (for strings) and 
> > > copy_from_user for structures, because without any strings 
> > > (especially), the trace information become much less useful.
> > 
> > Yeah, for structures we would just need the copy_from_user.
> 
> There's just a few places (mainly related to VFS APIs) where we 
> really want to do that, and there we want to do it a bit later, not 
> at syscall time: we want to do it after the getname(), to output a 
> stable (and already copied to kernel space) copy of the file name.
> 
> So the right solution there would be to add special, case by case 
> tracepoints to those few places. We dont need strings for the 
> majority of the 300+ system calls that exist on Linux.
> 
> 	Ingo

Hrm, this is an important design decision.. I cover a lot of those sites
in my LTTng instrumentation, and this is clearly one way to do it, at
the expense of adding tracepoints in many kernel locations when there
could be a functionnal equivalent with syscall instrumentation.

The thing we would need to do it from the syscall tracing site is a
table to map the system call numbers to their specific types (for the
syscalls we care about) and therefore which would also map to a
serialisation function to extract the parameters and write the correct
content into the trace buffers.

We could also use getname()/putname() in the syscall tracing primitive.
Note that architectures like x86 64 needs some tweaks I have in my
patchset to correctly ensure that syscall entry/exit are always paired.
This is required because we change the thread flag synchronously with
thread execution upen activation/deactivation.

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
