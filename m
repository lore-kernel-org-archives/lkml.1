Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0BJSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:38:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7744 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0BJSiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:38:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=caASFbOvCA4cWrMylw5+lRg7qt0cfYJBN8CJHAGJvrMq8RrdYsc+rZaNO6baf+Dgn
	1LkkIl+jD5zb7mzIXcKFQ==
MIME-Version: 1.0
In-Reply-To: <20100210133556.GA21925@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com>
	 <20100208143231.6d804590.akpm@linux-foundation.org>
	 <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com>
Date: Wed, 10 Feb 2010 10:38:05 -0800
Message-ID: <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
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

[+tavis]

Sorry for the delayed response.  I was out sick yesterday.  I have
made a simpler version of tavis's test case:

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sched.h>
#include <errno.h>
#include <sys/ptrace.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>

int child_pid;
int ant_pid;

void child(void)
{
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        asm("int3");
        while(1);
}

void antagonist(void)
{
        while (1) {
                kill(child_pid, SIGSTOP);
                usleep(2);
                kill(child_pid, SIGCONT);
                usleep(2);
        }
}

int do_fork(void (*callback)(void))
{
        int pid;
        pid = fork();
        if (pid)
                return pid;
        callback();

        exit(EXIT_SUCCESS);
}

int main(int argc, char **argv)
{
        int status;
        assert((child_pid = do_fork(child)) > 0);
        assert((ant_pid = do_fork(antagonist)) > 0);
        waitpid(child_pid, &status, 0);
        ptrace(PTRACE_SYSCALL, child_pid, NULL, NULL);
        while(1) {
                if (waitpid(child_pid, &status, 0) <= 0) {
                        printf("Errno %d\n", errno);
                        exit(EXIT_FAILURE);
                }
                if (WIFSTOPPED(status)) {
                        printf("stopped: %d\n", WSTOPSIG(status));

                        /* This should work, but sometimes it doesn't */
                        if (ptrace(PTRACE_SYSCALL, child_pid,
                                                NULL, WSTOPSIG(status)) < 0) {
                                /* Oddly it works the second time! */
                                assert (ptrace(PTRACE_SYSCALL,
                                        child_pid, NULL, WSTOPSIG(status)) < 0);
                        }
                }
        }
}


On Wed, Feb 10, 2010 at 5:35 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/09, Oleg Nesterov wrote:
>>
>> Salman Qazi wrote:
>> >
>> > A race in ptrace was pointed to us by a fellow Google engineer, Tavis
>> > Ormandy.  The race involves interaction between a tracer, a tracee and
>> > an antagonist.  The tracer is tracing the tracee with PTRACE_SYSCALL and
>> > waits on the tracee.  In the mean time, an antagonist blasts the tracee
>> > with SIGCONTs.
>>
>> Could you please explain how did observe this race? Do you have a
>> test-case, or could you explain how we can reproduce it?
>>
>> Because,
>>
>> > It turns out that a SIGCONT wakes up the
>> > tracee in kernel mode,
>>
>> SIGCONT must not wake up a TASK_TRACED task.
>
> In case I wasn't clear...
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -697,6 +697,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
>                 * and wake all threads.
>                 */
>                rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
> +               if (p->ptrace & PT_PTRACED) {
> +                       p->ptrace |= PT_WAKING;
> +                       mb();
> +               }
>
> Please note that we are going to do wake_up_state(state), and
> this state can never have __TASK_TRACED bit set.
>
> And we can't change ->ptrace here, we can race with the tracer.
>
> There are other problems with this patch, but the main problem
> is that I can't understand what this patch tries to fix.
>
> IOW, please provide more info ;)
>
> Oleg.
>
>
