Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZHXOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZHXOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZHXOe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:34:26 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58267 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZHXOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j034MIUCC+8Gb8I+Kljxp2GC2WCMjt5n88XgOJbcspa3Mnb8EW3qdM6WvhZB+YtKMH
         zTUEkmK9YRNJuMlP6paaq7I/NRqDjBFF3tbwpNtng434s2N+asir/FQJJALfja0Ke3ui
         0LzKmKbp6dW6+TNwIGtjo8jzQ2yUWsMmDddGw=
Date: Mon, 24 Aug 2009 16:34:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090824143417.GB6130@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere> <20090824134151.GB18974@linux-sh.org> <20090824140629.GA2656@redhat.com> <20090824141539.GA19978@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824141539.GA19978@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:15:39PM +0900, Paul Mundt wrote:
> On Mon, Aug 24, 2009 at 10:06:29AM -0400, Jason Baron wrote:
> > On Mon, Aug 24, 2009 at 10:41:52PM +0900, Paul Mundt wrote:
> > > I hope you can clarify what the meaning of this is supposed to be
> > > exactly. Is this number supposed to be the last usable syscall, or is it
> > > supposed to be the equivalent of NR_syscalls?
> > > 
> > 
> > I am using as the equivalent of NR_syscalls.
> > 
> NR_syscalls has always been the total number of system calls, not the
> last one.
> 
> > > Presently on SH we have this as NR_syscalls - 1, while on s390 I see it
> > > is treated as NR_syscalls directly. s390 opencodes the NR_syscalls
> > > directly and so presently blows up in -next due to a missing
> > > FTRACE_SYSCALL_MAX definition:
> > > 
> > > 	http://kisskb.ellerman.id.au/kisskb/buildresult/1120523/
> > > 
> > > I was in the process of fixing that up when I noticed this difference.
> > > x86 seems to also treat this as NR_syscalls - 1, but that looks to me
> > > like there is an off-by-1 in arch_init_ftrace_syscalls() causing the last
> > > syscall to be skipped?
> > 
> > I don't see how its used as 'NR_syscalls - 1' on x86,
> > arch_init_ftrace_syscalls() does:
> > 
> >         for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
> >                 meta = find_syscall_meta(psys_syscall_table[i]);
> >                 syscalls_metadata[i] = meta;
> >         }
> > 
> > So the last syscall should not be skipped.
> > 
> 
> In today's -next:
> 
> #ifdef CONFIG_X86_64
> # define FTRACE_SYSCALL_MAX     299
> #else
> # define FTRACE_SYSCALL_MAX     337
> #endif
> 
> unistd_32.h:
> 
> #define __NR_reflinkat          337
> 
> unistd_64.h:
> 
> #define __NR_reflinkat          299
> 
> The first syscall starts at 0, but I don't see how this last syscall is
> handled. If there were a __NR_syscalls 300 and 338 respectively, that
> would seem to do the right thing. Or am I missing something?


Yeah, I guess what we need here is NR_syscalls + 1.

