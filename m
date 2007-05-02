Return-Path: <linux-kernel-owner+w=401wt.eu-S1766893AbXEBRiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766893AbXEBRiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766898AbXEBRiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:38:00 -0400
Received: from haxent.com ([65.99.219.155]:2030 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766899AbXEBRhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:37:54 -0400
Message-ID: <4638CC6D.6080505@haxent.com.br>
Date: Wed, 02 May 2007 14:37:49 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br>	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>	 <20070502095503.a06f5472.dada1@cosmosbay.com>	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>	 <20070502104936.674a4b54.dada1@cosmosbay.com>	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>	 <4638C37D.7050503@haxent.com.br> <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
In-Reply-To: <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> thread A:
>>     int fd = plfutex(addr, 0);
>>     do
>>         poll(fdset+fd);
>>         process network events
>>         queue obj to thread B
>>         if fd:
>>             job processed
>>
>> thread B:
>>     wait_job();
>>     process_job();
>>     raise_event(addr);
>
> This is not the model you can implement with your changes.  Because
> every single waiter is woken you need one thread listening for the
> jobs and then distribute the work.  Otherwise you have thundering
> herds of threads and only one gets to do some work.
>

NO! Every single waiter of the _file descriptor_ is waked, not of the futex.
One can associate N fds with a single futex address. FUTEX_WAKE with
nproc = 1 will only wake one of the file descriptors. Its up to the user
to decide if he wants a broadcast or not.

Have you seen the email where I told you exactly this?

>> It simple as is, there is no need to overdesign.
>
> There is no reason to go with a limited, too-simple minded design if
> we've already identified a much better design.  The fact that poll is
> used today does not excuse piling on more and more code which makes
> additional functions which don't fit into the poll framework barely
> work.  Plus, poll/epoll itself is a problem.
>
epoll itself is a problem?! sorry, but i didn't know that. Care to 
elaborate?
I really need some guidance here. I just want to unify the epoll for various
event sources. It seems a lot of people like this, just look at the 
popularity
of libevent and other "unifying" event loops.

I don't think we need another epoll clone.

> And you cannot talk about little changes and no "overdesign".  You
> have 22 patches for all this.  It's not just limited to futexes, it's
> the whole thing which IMO is unnecessary ballast going forward.
davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v 
syscall | wc -l
10

davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v 
syscall |grep futex
patches/pollfs-futex-async-wait.patch
patches/pollfs-futex.patch

--
Davi Arnaut

