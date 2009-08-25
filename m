Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZHYVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZHYVIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbZHYVIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:08:53 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60630 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbZHYVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cKxTnX7SEHHjMZTOFFUC969Zzw1c4DvrqB+WPU/fDfT3mvRjDKnCHByanZyyN0ntKN
         91QzUYQyWIeEcLofKDd6DvaTu2ehZxkJq83Y+0jM7NOU+10pkalOknC4dtZJZ4UJGMCG
         JrTv1ofFzDWAi17WfydJrBwrY2YPqjNrjCfRI=
Date: Tue, 25 Aug 2009 23:08:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v4 0/4] tracing: tweaks for generic syscall events
Message-ID: <20090825210848.GD8215@nowhere>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1251150194-1713-1-git-send-email-jistone@redhat.com> <20090824230509.GB5124@nowhere> <20090825102858.GB19941@elte.hu> <20090825134203.GC6114@nowhere> <20090825144122.GC2656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825144122.GC2656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:41:22AM -0400, Jason Baron wrote:
> right, the compat layer as well as the core kernel need additional
> DEFINE_SYSCALL() macros to catch all the the syscalls. However, I think
> the compat layer is a bit more involved in that it often makes use of
> the core kernel syscalls, but the mapping between syscall number is
> different. So, we need another array, or to augment the existing one, to
> cover the compat syscalls. We also need to detect 32-bit processes in
> the syscall entry path to determine which array to use, and we need to
> grab the arguments differently. So there is a bunch of work here.


Hmm, indeed we may need a parallel compat_syscall_table for the metadata
and other kind of special treatements.
I wonder how ptrace sort it out in syscall_trace_enter() to guess the
origin of the syscall (ia32 or normal), since the table is not mapped
with the same numbers.

 
> Also, we have the question of whether we need separate entries in the
> events/syscalls directly for 32-bit process syscalls that call the same
> 64-bit syscall interfaces. Should they be parsed as 64-bit argument
> values event thought they are 32-bit? To reduce complexity, I would say
> the 32-bit syscall entries should be the same as the 64-bit ones. That
> said there will be a bunch of new "compat_sys*" etc. entries.
> 


We could probably re-route the compat syscall tracing to their
homologuous 64 bits tracepoints, but one may want to only trace the
compat_syscalls, use filters only on them, activate only some of them,
etc...

To do such routing, we could have a simple table that resolves
a compat syscall number to its real 64 bits syscall number and we could
then pass this number plus a flag that set its compat state in the ring
buffer entry.
That would avoid the need of using the DEFINE_SYSCALLx() in fs/compat.c

But such ghost tracepoints would also complexify too much the filter
processing, the individual tracepoints toggling, etc...
So I think having real compat tracepoints would actually be more simple.

We could still use shortcuts in userspace if we want to enable
sys_enter_open and sys_enter_compat_open at the same time.

Hmm?

> > Is someone willing to cover them?
> > 
> 
> I can take a stab at it.


Thanks a lot!


> thanks,
> 
> -Jason

