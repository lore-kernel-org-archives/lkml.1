Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYAJKiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYAJKiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAJKh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:37:58 -0500
Received: from styx.suse.cz ([82.119.242.94]:39489 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbYAJKh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:37:57 -0500
Message-ID: <4785F675.3070709@suse.cz>
Date: Thu, 10 Jan 2008 11:41:57 +0100
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE CR, s.r.o.
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_stop: remove the wrong ->group_stop_count
 bookkeeping
References: <20071208183801.GA9943@tv-sign.ru> <m1wsroogi0.fsf@ebiederm.dsl.xmission.com> <20071209140525.GA131@tv-sign.ru>
In-Reply-To: <20071209140525.GA131@tv-sign.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Oleg Nesterov wrote:
> On 12/08, Eric W. Biederman wrote:
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>>
>>> ptrace_stop() decrements ->group_stop_count to "participate" in group stop.
>>> This looks very wrong to me, the task can in fact decrement this counter twice.
>>> If the tracee returns to the user-space before other threads complete the group
>>> stop, it will notice TIF_SIGPENDING and do it again.
>> This is one of those interesting weird cases.  The ptrace interface remains per
>> task.
>>
>> So need to handle a simultaneous thread group stop and a per task stop.
>>
>>
>>> Another problem is that we don't set SIGNAL_STOP_STOPPED if the counter becomes
>>> zero.
>>>
>>> I must admit, I don't undestand the reason why this code was added, it is very
>>> old.
>> I haven't dug in enough yet to understand better, but it is my hunch we
>> need to do something when we have both kinds of stop happening simultaneously.
> 
> Looking further, I think it was done to match the !is_task_stopped_or_traced()
> check in do_signal_stop().
> 
> Still, I don't understand why we really need this decrement. The ptrace interface
> needs only per-thread TASK_TRACED ot TASK_STOPPED, it doesn't need the completion
> of the group stop. We can delay the completion of the group stop, but why this is
> bad? At worse, the tracer recieves the extra CLD_STOPPED when the tracee resumes.
> And do_signal_stop() probably can s/is_task_stopped_or_traced/is_task_stopped/.
> 
> OK, it is better to ignore this patch, I don't understand all implications of this
> change. But this all doesn't look very good. Suppose we have a lot of threads and
> the task with _TIF_SYSCALL_TRACE does system call. So ptrace_notify() decrements
> the counter before syscall, after, and before the return to user-space.
> 
> Hopefully Roland can clarify.

Roland, could you help here?

I can actually see a bug which may be related:

  1. a process creates a thread (or more threads)
  2. I attach/detach to that thread with strace several times
     (each time pressing CTRL-C to quit strace)
  3. the whole thread group (except the traced thread) ends in
     TASK_STOPPED

I looked at what strace was doing to that thread, and it sometimes sends
SIGSTOP shortly before detaching. This is done when the thread is
running, i.e. not waiting in ptrace_stop. Then PTRACE_DETACH returns
- -ESRCH because it requires the tracee to be stopped -- just like all
PTRACE_* requests except TRACEME and ATTACH. So, strace has no other
option than to send an explicit SIGSTOP to the thread to stop it and
discard it afterwards.

Could this be related?

Kind regards,
Petr Tesarik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHhfZ0jpY2ODFi2ogRAmCdAJ0dfhCoXMavThBKF7ZQSQ7J0t3ApACfYxdH
ZxEvTOrGrVO6rliHzPxBlEo=
=oxx4
-----END PGP SIGNATURE-----
