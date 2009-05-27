Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbZE0WqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbZE0WqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZE0WqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:46:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZE0WqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:46:11 -0400
Date: Thu, 28 May 2009 00:41:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090527224140.GC6770@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527021131.4778BFC36B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> > But is the current code correct? If we are not traced any longer
> > si_pid/si_uid are not necessary right either, we should calculate them
> > before ptrace_stop(), no?
>
> Yes, though nothing really cares about these values for such cases.
> (It's really only there for dealing with debuggers that were written
> before PTRACE_SETSIGINFO was invented.)
>
> It's probably best now to clean this up so that this logic is
> applied in the tracer causing the resumption rather than in the
> tracee.  i.e. do it in ptrace_resume() and ptrace_detach().

Hmm. Didn't think about this, and I agree this looks nicer...
So, we need something like

	void ptrace_set_exit_code(struct task_struct *child, int exit_code)
	{
		unsigned long flags;

		if (!exit_code)
			child->exit_code = exit_code;

		if (child->exit_code == exit_code)
			return;

		if (lock_task_sighand(child, &flags)) {
			siginfo_t *info = child->last_siginfo;

			if (info && info->info->si_signo != exit_code) {
				info->si_signo = exit_code;
				info->si_errno = 0;
				info->si_code = SI_USER;
				info->si_pid = task_pid_nr_ns(current, child->nsproxy->pid_ns);
				info->si_uid = task_uid(current);

			}
			child->exit_code = exit_code;
			unlock_task_sighand(child, &flags);
		}
	}

And ptrace_resume/ptrace_detach should use ptrace_set_exit_code()
instead of child->exit_code = data.

The disadvantage is, ptrace_notify() does not need this, we add the
little pessimization...

And. This change adds another dependency with arches which implement
their own resume.

So. Do you think this cleanup should be done before/with this series
or we can do it later?

Oleg.

