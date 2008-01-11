Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYAKIqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYAKIqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYAKIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:46:40 -0500
Received: from styx.suse.cz ([82.119.242.94]:40613 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754655AbYAKIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:46:39 -0500
Message-ID: <47872DE1.4000409@suse.cz>
Date: Fri, 11 Jan 2008 09:50:41 +0100
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
References: <20071208183801.GA9943@tv-sign.ru> <m1wsroogi0.fsf@ebiederm.dsl.xmission.com> <20071209140525.GA131@tv-sign.ru> <4785F675.3070709@suse.cz> <20080110213932.GA3396@tv-sign.ru>
In-Reply-To: <20080110213932.GA3396@tv-sign.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 01/10, Petr Tesarik wrote:
>> I can actually see a bug which may be related:
>>
>>   1. a process creates a thread (or more threads)
>>   2. I attach/detach to that thread with strace several times
>>      (each time pressing CTRL-C to quit strace)
>>   3. the whole thread group (except the traced thread) ends in
>>      TASK_STOPPED
>>
>> I looked at what strace was doing to that thread, and it sometimes sends
>> SIGSTOP shortly before detaching. This is done when the thread is
>> running, i.e. not waiting in ptrace_stop. Then PTRACE_DETACH returns
>> - -ESRCH because it requires the tracee to be stopped -- just like all
>> PTRACE_* requests except TRACEME and ATTACH. So, strace has no other
>> option than to send an explicit SIGSTOP to the thread to stop it and
>> discard it afterwards.
>>
>> Could this be related?
> 
> Perhaps yes. But there are so many oddities in this area. I don't know what
> really happens with your test-case, but afaics this can happen even without
> ptrace_stop() playing with the group stop.
> 
> Let's suppose that strace detached all sub-threads except T which is running,
> and now strace does ptrace(PTRACE_DETACH, T). This fails, so strace does
> kill(T, SIGSTOP).
> 
> Note that it use kill(), not tkill(). This means another sub-thread can
> dequeue this signal and initiate the group stop (remember, it was already
> detached and thus it is not traced any longer).

In fact, it had been never traced - I attached strace to the PID of the
sub-thread, not to the thread group leader. Anyway, I haven't seen the
erroneous stop again since I changed detach() to call tkill() instead of
kill(). It's not a proof, because the failure was very seldom, so I'll
keep testing, but it makes much sense to me.

Petr

> Now strace does wait4(T, __WALL). T notices the group stop in progress,
> calls handle_group_stop(), and notifies its parent - strace.
> 
> wait4() returns success, strace does ptrace(PTRACE_DETACH, T) again. Now
> T is TASK_STOPPED, ptrace() changes the state to TASK_TRACED and finally
> does ptrace_untrace().
> 
> ptrace_untrace() sees TASK_TRACED. But it is possible that the group stop
> is not completed yet (some sub-thread didn't pass handle_group_stop()), in
> that case we are doing signal_wake_up(T, 1) so it becomes running.
> 
> 
> I still think this series makes sense even if not complete.
> 
> Oleg.
> 

