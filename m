Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZKYPBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZKYPBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZKYPBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:01:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZKYPBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:01:32 -0500
Date: Wed, 25 Nov 2009 15:55:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091125145556.GA5394@redhat.com>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com> <20091124212619.GB29096@one.firstfloor.org> <20091124214450.GA12828@redhat.com> <20091125084617.GD29096@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125084617.GD29096@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Andi Kleen wrote:
>
> > This is subjective, but personally I disagree. Contrary, imho it
> > is good that tracehook hides the (simple) details. I do not understand
> > why the reader of, say, do_fork() should see the contents of
> > tracehook_report_clone_complete(). This will complicate the understanding.
>
> Someone who has to debug or review fork needs to know what's going on.
>
> Yes they can find out by going through inlines, but that
> just costs more time and distracts from the actual problem.
>
> > Those people who want to understand/change fork() do not care about
> > utrace/ptrace usually.
> >
> > And please note that it is much, much easier to change this code
> > when it lives in tracehooks.h instead of sched.c/signal.c/etc.
>
> The problem is that when you have to trace this code when something
> goes wrong the extra layer just holds you up. For debugging usually
> abstraction is a bad idea.
>
> My experience is also that in general such extra "abstraction layers"
> are frowned upon in Linux kernel code style. For example when new
> vendor drivers are submitted for hardware like NICs etc,
> they frequently tend to have all kinds of "abstraction layers".
> Typically the first step to linuxify them is to get rid of those.
>
> This makes the code more readable, shorter, better to debug and read.

OK, let's try to remove these helpers. Let's take a random one,
tracehook_report_exec().

The current code in search_binary_handler:

		if (retval >= 0) {
			if (depth == 0)
				tracehook_report_exec(fmt, bprm, regs);
			put_binfmt(fmt);
			allow_write_access(bprm->file);
			if (bprm->file)
				fput(bprm->file);
			bprm->file = NULL;
			current->did_exec = 1;
			proc_exec_connector(current);
			return retval;
		}

becomes:	

		if (retval >= 0) {
			if (depth == 0) {
				if (unlikely(task_utrace_flags(current) & UTRACE_EVENT(EXEC)))
					utrace_report_exec(fmt, bprm, regs);
				if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
				    unlikely(task_ptrace(current) & PT_PTRACED))
					send_sig(SIGTRAP, current, 0);
			}
			put_binfmt(fmt);
			allow_write_access(bprm->file);
			if (bprm->file)
				fput(bprm->file);
			bprm->file = NULL;
			current->did_exec = 1;
			proc_exec_connector(current);
			return retval;
		}

Cleanup? I don't think so.

OK, when CONFIG_UTRACE goes away, we can kill a lot of old code, and
in tracehooks too. So the code above becomes

		if (retval >= 0) {
			if (depth == 0) {
				if (unlikely(task_utrace_flags(current) & UTRACE_EVENT(EXEC)))
					utrace_report_exec(fmt, bprm, regs);
			}
			put_binfmt(fmt);
			allow_write_access(bprm->file);
			if (bprm->file)
				fput(bprm->file);
			bprm->file = NULL;
			current->did_exec = 1;
			proc_exec_connector(current);
			return retval;
		}

Much better. But in this case please note that most of tracehooks
just do:

		if (unlikely(task_utrace_flags(current) & SOME_EVENT))
			utrace_report_some_event();

I really don't understand why we shouldn't have (trivial!) helpers
for this. (As for naming - personally I do not care at all ;)

You can argue that some tracehooks (say, exit_notify() path) can be
simplified. Yes, we are going to do this. And again, when CONFIG_UTRACE
goes away, we can just kill some tracehooks. Say, most of them in
do_fork() path.

> Because the inlines do not add anything to functionality and actually
> hide what the code does, that is obfuscation.

This applies to any function. As for tracehooks, they mostly hide
"if (task_utrace_flags(current))" check and nothing more.

> For you it might be obvious
> because you've been hacking that code for quite some time, but for
> someone who is not in your position that's different.

Yes, this is true. Let me repeat, I know that this is subjective and
I am biased.

Oleg.

