Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0BKSoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:44:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab0BKSoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:44:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U5yJYWiQlpGaXullFWPs4lo0vh+ZILVTxg7v40YOnSaJcGdWCWRkUW+lyks8cRRvT
	UwYo+Lf4QE7a/lWkUIfuw==
MIME-Version: 1.0
In-Reply-To: <20100211165059.GA16053@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com>
	 <20100208143231.6d804590.akpm@linux-foundation.org>
	 <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com>
	 <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
	 <20100211125607.GA5086@redhat.com>
	 <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
	 <20100211165059.GA16053@redhat.com>
Date: Thu, 11 Feb 2010 10:43:59 -0800
Message-ID: <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
Subject: Re: Race in ptrace.
From: Salman Qazi <sqazi@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 8:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/11, Salman Qazi wrote:
>>
>> On Thu, Feb 11, 2010 at 4:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > But this all is correct, you can't expect PTRACE_SYSCALL can succeed
>> > is the tracee is running, it must be stopped or traced.
>> >
>> > The tracee is running because it was TASK_STOPPED and antagonist()
>> > sends SIGCONT.
>> >
>> > The tracee was TASK_STOPPED because the tracer passes sig = SIGSTOP
>> > via ptrace(PTRACE_SYSCALL, WSTOPSIG(status).
>> >
>> > Where do you see the bug?
>>
>> Shouldn't ptrace(PTRACE_SYSCALL, WSTOPSIG(status)...), cause any
>> future signals to the child be intercepted by the parent?
>
> Not sure I understand your question. Of course the tracee will report any
> future signals signals, after it has a chance to dequeue a signal.
>
> But if you mean that after, say, ptrace(PTRACE_SYSCALL, SIGTERM) the
> tracee should report _this_ SIGTERM to the tracer - then no. Well,
> actually "this depends", but if PTRACE_SYSCALL (or any other req)
> is called after the tracee reported the signal - no. The signal was
> already reported.
>
>> >        int main(void)
>> >        {
>> >                int stat, ret;
>> >                int pid = fork();
>> >
>> >                if (!pid) {
>> >                        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
>> >                        for (;;)
>> >                                ;
>> >                }
>> >
>> >                sleep(1);       // wait for PTRACE_TRACEME
>> >                kill(pid, SIGSTOP);
>> >
>> >                // the child reports SIGSTOP, it is TASK_TRACED
>> >                assert(pid == wait(&stat) && WIFSTOPPED(stat));
>> >
>> >                // the tracee should stop, we pass sig = SIGSTOP
>> >                assert(ptrace(PTRACE_SYSCALL, pid, 0, WSTOPSIG(stat)) == 0);
>> >
>> >                // the child reports the group stop, it is TASK_STOPPED
>> >                assert(pid == wait(&stat) && WIFSTOPPED(stat));
>> >
>> >                // the tracee is STOPPED as requested, not TRACED,
>> >                // SIGCONT wakes it up
>> >                kill(pid, SIGCONT);

I am still missing something.  There's probably a gap in my
understanding, so let's try to clarify it.  The last "kill" call,
sends a SIGCONT.  But, shouldn't this SIGCONT be intercepted by the
tracer before the tracee sees it?

>>
>>                    According to the man page, any signals to the
>> process are supposed to be intercepted by the parent and that is how
>> one is supposed to be able to control which signals make it to the
>> child.  I am not sure if it makes any difference if the signal
>> originates at the parent.  But in our test case, it doesn't.   So, why
>> doesn't the parent get a notification first?
>
> It does. You can insert another wait() (or just sleep(1)) between
> kill(SIGCONT) and PTRACE_SYSCALL below, the tracee will stop to report
> SIGCONT and the tracer will be notified. In this case the following
> PTRACE_SYSCALL should succeed.
>
> Perhaps I should have mentioned that the code above is racy. It is,
> I only did it to simplify the explanations.
>
> Oleg.
>
>
