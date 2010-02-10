Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0BJNhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:37:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0BJNhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:37:11 -0500
Date: Wed, 10 Feb 2010 14:35:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100210133556.GA21925@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com> <20100208143231.6d804590.akpm@linux-foundation.org> <20100209112700.GA4258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209112700.GA4258@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Oleg Nesterov wrote:
>
> Salman Qazi wrote:
> >
> > A race in ptrace was pointed to us by a fellow Google engineer, Tavis
> > Ormandy.  The race involves interaction between a tracer, a tracee and
> > an antagonist.  The tracer is tracing the tracee with PTRACE_SYSCALL and
> > waits on the tracee.  In the mean time, an antagonist blasts the tracee
> > with SIGCONTs.
>
> Could you please explain how did observe this race? Do you have a
> test-case, or could you explain how we can reproduce it?
>
> Because,
>
> > It turns out that a SIGCONT wakes up the
> > tracee in kernel mode,
>
> SIGCONT must not wake up a TASK_TRACED task.

In case I wasn't clear...

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -697,6 +697,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		 * and wake all threads.
 		 */
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
+		if (p->ptrace & PT_PTRACED) {
+			p->ptrace |= PT_WAKING;
+			mb();
+		}

Please note that we are going to do wake_up_state(state), and
this state can never have __TASK_TRACED bit set.

And we can't change ->ptrace here, we can race with the tracer.

There are other problems with this patch, but the main problem
is that I can't understand what this patch tries to fix.

IOW, please provide more info ;)

Oleg.

