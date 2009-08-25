Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZHYOmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZHYOmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZHYOmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZHYOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:42:54 -0400
Date: Tue, 25 Aug 2009 10:41:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v4 0/4] tracing: tweaks for generic syscall events
Message-ID: <20090825144122.GC2656@redhat.com>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1251150194-1713-1-git-send-email-jistone@redhat.com> <20090824230509.GB5124@nowhere> <20090825102858.GB19941@elte.hu> <20090825134203.GC6114@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825134203.GC6114@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:42:08PM +0200, Frederic Weisbecker wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Mon, Aug 24, 2009 at 02:43:10PM -0700, Josh Stone wrote:
> > > > This patch series moves the callbacks for the syscall tracepoints to the
> > > > definition site, and adds generic TRACE_EVENTs which capture all syscall
> > > > arguments.
> > > > 
> > > > New in v3:
> > > > - Give the thread flag a more generic name: TIF_SYSCALL_TRACEPOINT.
> > > > - Move the regfuncs to arch-specific files, per Jason's suggestion.
> > > > - Change _WITH_CALLBACK to just _FN, per Ingo's suggestion.
> > > > 
> > > > New in v4:
> > > > - Give the config flag a more generic name: HAVE_SYSCALL_TRACEPOINTS.
> > > > - Undo the arch reorg of the regfuncs, but conditionalize on above.
> > > > 
> > > > 
> > > > Sample trace output:
> > > >         sendmail-974   [000] 55665.464492: sys_enter: NR 14 (1, 7fff60f3af40, 7fff60f3aec0, 8, 0, 7fb1b6a05161)
> > > > 
> > > >         sendmail-974   [000] 55665.464496: sys_exit: NR 14 = 0
> > > > 
> > > >         sendmail-974   [000] 55665.464507: sys_enter: NR 23 (5, 7fff60f3b0d0, 0, 0, 7fff60f3b150, 7fff60f3ef01)
> > > > 
> > > >             sshd-978   [000] 55667.845359: sys_exit: NR 23 = 1
> > > > 
> > > >             sshd-978   [000] 55667.845373: sys_enter: NR 14 (0, 7fffc645ce90, 7fffc645cf10, 8, 0, 101010101010101)
> > > > 
> > > >             sshd-978   [000] 55667.845381: sys_exit: NR 14 = 0
> > > > 
> > > >             sshd-978   [000] 55667.845383: sys_enter: NR 14 (2, 7fffc645cf10, 0, 8, 0, 101010101010101)
> > > > 
> > > >             sshd-978   [000] 55667.845386: sys_exit: NR 14 = 0
> > > > 
> > > >             sshd-978   [000] 55667.845395: sys_enter: NR 0 (3, 7fffc6458f80, 4000, 1, 0, 0)
> > > > 
> > > >             sshd-978   [000] 55667.845478: sys_exit: NR 0 = 48
> > > > 
> > > > 
> > > > Signed-off-by: Josh Stone <jistone@redhat.com>
> > > > Cc: Jason Baron <jbaron@redhat.com>
> > > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > > Cc: Jiaying Zhang <jiayingz@google.com>
> > > > Cc: Martin Bligh <mbligh@google.com>
> > > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > Cc: Paul Mundt <lethal@linux-sh.org>
> > > 
> > > 
> > > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > How about compat syscalls? If we touch this code we better cover 
> > them as well.
> > 
> > 	Ingo
> 
> 
> They should be covered by these generic tracepoint I guess.
> The remaining bits that are necessary to cover individual compat syscall
> tracepoints are the missing DEFINE_SYSCALL() uses in fs/compat.c
> 

right, the compat layer as well as the core kernel need additional
DEFINE_SYSCALL() macros to catch all the the syscalls. However, I think
the compat layer is a bit more involved in that it often makes use of
the core kernel syscalls, but the mapping between syscall number is
different. So, we need another array, or to augment the existing one, to
cover the compat syscalls. We also need to detect 32-bit processes in
the syscall entry path to determine which array to use, and we need to
grab the arguments differently. So there is a bunch of work here.

Also, we have the question of whether we need separate entries in the
events/syscalls directly for 32-bit process syscalls that call the same
64-bit syscall interfaces. Should they be parsed as 64-bit argument
values event thought they are 32-bit? To reduce complexity, I would say
the 32-bit syscall entries should be the same as the 64-bit ones. That
said there will be a bunch of new "compat_sys*" etc. entries.


> Is someone willing to cover them?
> 

I can take a stab at it.

thanks,

-Jason
