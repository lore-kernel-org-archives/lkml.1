Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0BKQxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:53:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab0BKQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:53:04 -0500
Date: Thu, 11 Feb 2010 17:50:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100211165059.GA16053@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com> <20100208143231.6d804590.akpm@linux-foundation.org> <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com> <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com> <20100211125607.GA5086@redhat.com> <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Salman Qazi wrote:
>
> On Thu, Feb 11, 2010 at 4:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > But this all is correct, you can't expect PTRACE_SYSCALL can succeed
> > is the tracee is running, it must be stopped or traced.
> >
> > The tracee is running because it was TASK_STOPPED and antagonist()
> > sends SIGCONT.
> >
> > The tracee was TASK_STOPPED because the tracer passes sig = SIGSTOP
> > via ptrace(PTRACE_SYSCALL, WSTOPSIG(status).
> >
> > Where do you see the bug?
>
> Shouldn't ptrace(PTRACE_SYSCALL, WSTOPSIG(status)...), cause any
> future signals to the child be intercepted by the parent?

Not sure I understand your question. Of course the tracee will report any
future signals signals, after it has a chance to dequeue a signal.

But if you mean that after, say, ptrace(PTRACE_SYSCALL, SIGTERM) the
tracee should report _this_ SIGTERM to the tracer - then no. Well,
actually "this depends", but if PTRACE_SYSCALL (or any other req)
is called after the tracee reported the signal - no. The signal was
already reported.

> >        int main(void)
> >        {
> >                int stat, ret;
> >                int pid = fork();
> >
> >                if (!pid) {
> >                        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
> >                        for (;;)
> >                                ;
> >                }
> >
> >                sleep(1);       // wait for PTRACE_TRACEME
> >                kill(pid, SIGSTOP);
> >
> >                // the child reports SIGSTOP, it is TASK_TRACED
> >                assert(pid == wait(&stat) && WIFSTOPPED(stat));
> >
> >                // the tracee should stop, we pass sig = SIGSTOP
> >                assert(ptrace(PTRACE_SYSCALL, pid, 0, WSTOPSIG(stat)) == 0);
> >
> >                // the child reports the group stop, it is TASK_STOPPED
> >                assert(pid == wait(&stat) && WIFSTOPPED(stat));
> >
> >                // the tracee is STOPPED as requested, not TRACED,
> >                // SIGCONT wakes it up
> >                kill(pid, SIGCONT);
>
>                    According to the man page, any signals to the
> process are supposed to be intercepted by the parent and that is how
> one is supposed to be able to control which signals make it to the
> child.  I am not sure if it makes any difference if the signal
> originates at the parent.  But in our test case, it doesn't.   So, why
> doesn't the parent get a notification first?

It does. You can insert another wait() (or just sleep(1)) between
kill(SIGCONT) and PTRACE_SYSCALL below, the tracee will stop to report
SIGCONT and the tracer will be notified. In this case the following
PTRACE_SYSCALL should succeed.

Perhaps I should have mentioned that the code above is racy. It is,
I only did it to simplify the explanations.

Oleg.

