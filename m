Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZBITj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZBITj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZBITjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:39:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZBITjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:39:46 -0500
Date: Mon, 9 Feb 2009 20:36:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090209193625.GA4808@redhat.com>
References: <20090209010233.GA26444@redhat.com> <20090209012824.GA26461@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Metzger, Markus T wrote:
>
> >PTRACE_BTS_CONFIG allocates ->bts_buffer via alloc_locked_buffer()
> >which updates mm->total_vm/locked_vm.
> >
> >ptrace_detach() does free_locked_buffer() which "restores" mm->xxx_vm.
>
> That's what I expect to be the normal case.
>
>
> >But if the tracer exits we are doing __ptrace_unlink()->ptrace_bts_untrace()
> >which uses a plain kfree(), in that case we don't update mm->xxx_vm ?
>
> That's correct.
> When the tracer dies, do_exit() first calls exit_mm() and then calls exit_notify(), which eventually calls __ptrace_unlink() and ptrace_bts_untrace().
>
> At this time, the tracer's mm is already gone,

It is not if we have sub-threads (which share the same ->mm),

> but the bts buffer is not.
> The code reclaims the memory; so we should not leak memory.

yes, there is no memory leak,

> The user should not see any problems with his ulimit, either, since the task that had the memory accounted against his locked and total limit is as good as dead.

again, if the process is multithreaded, it is not dead. It (other threads)
continues to run with the same ->mm. Only the tracer thread is dead.

> >Or, the tracer can reap a zombie tracee without PTRACE_DETACH, in that
> >case we don't update ->mm too.
>
> I'm not sure I understand that scenario.
> A task ptraces another task, requests branch trace, and does not detach when the tracee dies?

Yes. Again, we don't leak the memory, but the accounting in mm->total_vm/locked_vm
is not right.

> Ideally (that is, from my point of view, at least), the tracer would call
> ptrace_detach() very early in do_exit(), so ptrace would not have to distinguish
> the various ways a tracer or tracee could die.

Well, yes I agree. Please look at http://marc.info/?t=123411902800001

> >Oh, and afaics ptrace_detach()->ptrace_bts_detach() can race with the
> >tracer's sub-thread which does do_wait()->release_task() (if the tracee
> >was killed before detach takes tasklist), the kernel can crash in this
> >case.
>
> Are you saying that ptrace_detach() should call ptrace_disable() with tasklist_lock held for write?

We can't do this. And btw one of the reasons we can't is that
ptrace_bts_free_buffer() needs ->mmap_sem ;)

Oleg.

