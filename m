Return-Path: <linux-kernel-owner+w=401wt.eu-S1161268AbXBZWHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268AbXBZWHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161270AbXBZWHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:07:11 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:43501
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161268AbXBZWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:07:09 -0500
Date: Mon, 26 Feb 2007 14:06:44 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226220644.GA8352@gnuppy.monkey.org>
References: <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru> <20070226203543.GB23357@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226203543.GB23357@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:35:43PM +0100, Ingo Molnar wrote:
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > If kernelspace rescheduling is that fast, then please explain me why 
> > userspace one always beats kernel/userspace?
> 
> because 'user space scheduling' makes no sense? I explained my thinking 
> about that in a past mail:
> 
> -------------------------->
> One often repeated (because pretty much only) performance advantage of 
> 'light threads' is context-switch performance between user-space 
> threads. But reality is, nobody /cares/ about being able to 
> context-switch between "light user-space threads"! Why? Because there 
> are only two reasons why such a high-performance context-switch would 
> occur:
... 
>  2) there has been an IO event. The thing is, for IO events we enter the
>     kernel no matter what - and we'll do so for the next 10 years at
>     minimum. We want to abstract away the hardware, we want to do
>     reliable resource accounting, we want to share hardware resources,
>     we want to rate-limit, etc., etc. While in /theory/ you could handle
>     IO purely from user-space, in practice you dont want to do that. And
>     if we accept the premise that we'll enter the kernel anyway, there's
>     zero performance difference between scheduling right there in the
>     kernel, or returning back to user-space to schedule there. (in fact
>     i submit that the former is faster). Or if we accept the theoretical
>     possibility of 'perfect IO hardware' that implements /all/ the
>     features that the kernel wants (in a secure and generic way, and
>     mind you, such IO hardware does not exist yet), then /at most/ the
>     performance advantage of user-space doing the scheduling is the
>     overhead of a null syscall entry. Which is a whopping 100 nsecs on
>     modern CPUs! That's roughly the latency of a /single/ DRAM access!

Ingo and Evgeniy,

I was trying to avoid getting into this discussion, but whatever. M:N
threading systems also require just about all of the threading semantics
that are inside the kernel to be available in userspace. Implementations
of the userspace scheduler side of things must be able to turn off
preemption to do per CPU local storage, report blocking/preempting via
(via upcall or a mailbox) and other scheduler-ish things in reliable way
so that the complexity of a system like that ends up not being worth it
and is often monsteriously large to implement and debug. That's why
Solaris 10 removed their scheduler activations framework and went with
1:1 like in Linux since the scheduler activations model is so difficult
to control. The slowness of the futex stuff might be compounded by some
VM mapping issues that Bill Irwin and Peter Ziljstra have pointed out in
the past regard, if I understand correctly.

Bryan Cantril of Solaris 10/dtrace fame can comment on that if you ask
him sometime.

For an exercise, think about all of things you need to either migrate
or to do a cross CPU wake of a task. It goes to hell in complexity
really quick. Erlang and other language based concurrency systems get
their regularities by indirectly oversimplifying what threading is from
what kernel folks are use to. Try doing a cross CPU wake quickly a
system like that, good luck. Now think about how to do an IPI in
userspace ? Good luck.

That's all :)

bill

