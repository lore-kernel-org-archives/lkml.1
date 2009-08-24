Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZHXOuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZHXOuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZHXOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:50:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33413 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZHXOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:50:12 -0400
Date: Mon, 24 Aug 2009 23:50:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090824145011.GA20517@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jason Baron <jbaron@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
	rostedt@goodmis.org, peterz@infradead.org,
	mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
	mbligh@google.com, lizf@cn.fujitsu.com
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere> <20090824134151.GB18974@linux-sh.org> <20090824140629.GA2656@redhat.com> <20090824141539.GA19978@linux-sh.org> <20090824144228.GB2656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824144228.GB2656@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:42:28AM -0400, Jason Baron wrote:
> On Mon, Aug 24, 2009 at 11:15:39PM +0900, Paul Mundt wrote:
> > On Mon, Aug 24, 2009 at 10:06:29AM -0400, Jason Baron wrote:
> > > On Mon, Aug 24, 2009 at 10:41:52PM +0900, Paul Mundt wrote:
> > > > I hope you can clarify what the meaning of this is supposed to be
> > > > exactly. Is this number supposed to be the last usable syscall, or is it
> > > > supposed to be the equivalent of NR_syscalls?
> > > > 
> > > 
> > > I am using as the equivalent of NR_syscalls.
> > > 
> > NR_syscalls has always been the total number of system calls, not the
> > last one.
> > 
> > > > Presently on SH we have this as NR_syscalls - 1, while on s390 I see it
> > > > is treated as NR_syscalls directly. s390 opencodes the NR_syscalls
> > > > directly and so presently blows up in -next due to a missing
> > > > FTRACE_SYSCALL_MAX definition:
> > > > 
> > > > 	http://kisskb.ellerman.id.au/kisskb/buildresult/1120523/
> > > > 
> > > > I was in the process of fixing that up when I noticed this difference.
> > > > x86 seems to also treat this as NR_syscalls - 1, but that looks to me
> > > > like there is an off-by-1 in arch_init_ftrace_syscalls() causing the last
> > > > syscall to be skipped?
> > > 
> > > I don't see how its used as 'NR_syscalls - 1' on x86,
> > > arch_init_ftrace_syscalls() does:
> > > 
> > >         for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
> > >                 meta = find_syscall_meta(psys_syscall_table[i]);
> > >                 syscalls_metadata[i] = meta;
> > >         }
> > > 
> > > So the last syscall should not be skipped.
> > > 
> > 
> > In today's -next:
> > 
> > #ifdef CONFIG_X86_64
> > # define FTRACE_SYSCALL_MAX     299
> > #else
> > # define FTRACE_SYSCALL_MAX     337
> > #endif
> > 
> > unistd_32.h:
> > 
> > #define __NR_reflinkat          337
> > 
> > unistd_64.h:
> > 
> > #define __NR_reflinkat          299
> > 
> > The first syscall starts at 0, but I don't see how this last syscall is
> > handled. If there were a __NR_syscalls 300 and 338 respectively, that
> > would seem to do the right thing. Or am I missing something?
> 
> No, you are right. When I changed the FTRACE_SYSCALL_MAX to 299, and
> 337, there was no reflinkat syscall in the tree. So, it was equivalent
> to NR_syscalls at that point in time. So that's where the confusion is.
> 
> Clearly, all the more reason to drop FTRACE_SYSCALL_MAX and change to
> NR_syscalls...
> 
If FTRACE_SYSCALL_MAX is dropped then s390 will be fixed, and I'll take
care of the sh update. If you want to hold off on adding NR_syscalls back
to x86, then s390 will need a #define FTRACE_SYSCALL_MAX __NR_syscalls in
arch/s390/include/asm/ftrace.h. Keeping FTRACE_SYSCALL_MAX around seems
to be asking for trouble, though (although I don't know what the original
rationale behind adding it was).
