Return-Path: <linux-kernel-owner+w=401wt.eu-S966805AbXEGVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966805AbXEGVek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966776AbXEGVei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:34:38 -0400
Received: from haxent.com ([65.99.219.155]:4554 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966629AbXEGVeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:34:37 -0400
Message-ID: <463F9B68.305@haxent.com.br>
Date: Mon, 07 May 2007 18:34:32 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br>	 <463BC3CA.6050109@haxent.com.br>	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>	 <463CFA37.3020809@haxent.com.br> <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
In-Reply-To: <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/5/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> A google search turns up a few users. It also addresses some complaints
>> from Drepper.
> 
> There is a huge problem with this approach and we're back at the
> inadequate interface.
> 
> select/poll/epoll are thread cancellation points.  I.e., the thread
> can be canceled before returning to the user.  If this cancellation
> happens between the kernel deciding to give this thread the event (and
> no other thread) and the thread testing for cancellation in the libc
> wrapper around the syscall, then the event is lost and the process(es)
> might hang.
> 
> With kevent we in the end fixed the problem by requiring that part of
> the cancellation handling the thread tries to wake up another thread
> waiting for the event queue.  This is easily possible since the event
> data is in the shared memory segment and it's just purely the thread
> wakeup that is needed.
> 
> To make something like this work for poll you'd have to push back the
> revents fields of the result back to the kernel which might then cause
> another thread to be woken up.  I find this too ugly to consider.  You
> guys will not believe this but I really thought all these things
> through before writing the OLS paper.  poll cannot be salvaged.

See Linus's message on this same thread.

> There is another thing about this selective wakeup: do I assume it
> correctly that if more than one file descriptor is reported ready more
> than one thread is woken?  I think nothing else can be justified.

Correct.

> Will in this case both threads get the same set of descriptors
> reported or will they see disjunct sets?

Disjunct. In reality, only if the event is edge triggered.

--
Davi Arnaut
