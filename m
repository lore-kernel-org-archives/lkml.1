Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZCORd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZCORd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 13:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZCORdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 13:33:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZCORdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 13:33:17 -0400
Date: Sun, 15 Mar 2009 18:29:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Signal delivery order
Message-ID: <20090315172926.GA21095@redhat.com>
References: <200903141750.37238.mega@retes.hu> <20090315094400.GA455@redhat.com> <200903151540.00542.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903151540.00542.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Gábor Melis wrote:
>
> On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> >
> > If test_signal (SIGUSR1) is blocked, this means it is already
> > delivered, and the handler will be invoked when we return from
> > sigsegv_handler(), please see below.
>
> SIGUSR1 is delivered, its sigmask is added to the current mask but the
> handler is not yet invoked and in this instant synchronous sigsegv is
> delivered, its handler invoked?

Can't understand the question. Could you reiterate?

> > When sigprocmask(SIG_UNBLOCK) returns, both signals are delivered.
> > The kernel deques 1 first, then 2. This means that the handler for
> > "2" will be called first.
>
> My mental model that matches what I quickly glean from the sources (from 
> kernel/signal.c, arch/x86/kernel/signal_32.c) goes like this:
>
> - signal 1 and signal 2 are generated and made pending
> - they are unblocked by sigprocmask
> - signal 1 is delivered: signals in its mask (only itself here) are
> blocked

yes.

the kernel changes ip (instruction pointer) to sig_1.

> its handler is invoked

no.

We never return to user-space with a pending signal. We dequeue signal 2
too, and change ip to sig_2.

Now, since there are no more pending signals, we return to the user space,
and start sig_2().

> I can't find how 'handler for "2" will be called first'.

see above,

> Furthermore, if
> it's indeed sig_2 that's invoked first then sig_1's sigmask is added to
> the current mask upon dequeueing???

sig_1's sigmask was added to ->blocked when we dequeued signal 1.

Oleg.

