Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXJ0IXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXJ0IXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 04:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXJ0IX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 04:23:29 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:50619 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXJ0IX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 04:23:27 -0400
Message-ID: <4722F575.8080204@cosmosbay.com>
Date: Sat, 27 Oct 2007 10:23:17 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marc Lehmann <linux-kernel@tst.eu>
CC: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
References: <20071027062236.GA12476@schmorp.de>
In-Reply-To: <20071027062236.GA12476@schmorp.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 27 Oct 2007 10:23:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Lehmann a écrit :
> Hi!
> 
> I ran into what I see as unsolvable problems that make epoll useless as a
> generic event mechanism.
> 
> I recently switched to libevent as event loop, and found that my programs
> work fine when it is using select or poll, but work eratically or halt
> when using epoll.
> 
> The reason as I found out is the peculiar behaviour of epoll over fork.
> It doesn't work as documented, and even if, it would make the use of
> third-party libraries using fork usually impossible.
> 
> Here are two scenarios where it screws up:
> 
> - some library forks, explicitly closes all fd's it doesn't need, and execs
>   another program (which is common behvaiour).
> 
>   In this case, the parent process works fine until the child closes fds,
>   after which the fds become unarmed in the parent too. This works as

I have no idea what exact problem you have. But if the child closes some file 
descriptor that were 'cloned' at fork() time, this only decrements a refcount, 
and definitely should not close it for the 'parent'. epoll in this regard uses 
a generic kernel service (file descriptor sharing between tasks).

I have some apps that are happily using epoll() and fork()/exec() and have no 
problem at all. I usually use O_CLOEXEC so that all close() are done at exec() 
time without having to do it in a loop. epoll continues to work as expected in 
the parent process.

>   documented, but since libraries expect this to work without affecting the
>   parent, this puts a new and incompatible strain on what libraries can do,
>   which in turn makes epoll unsuitable in cases where you don't control all
>   your code.
> 
> - I have a library that emulates asynchronous I/O with a thread pool, and
>   uses a pipe for event notification. That library registers a fork handler
>   that closes the pipe in the child and recreates it, so the child could
>   continue doing AIO (as could the parent).
> 
>   This, too, screws up notifications for the parent,
> 
> Now, the epoll manpage says that closing a fd will remove it from all
> fd sets. This would explain the behaviour above. Unfortunately (or
> fortunately?) this is not what happens: when the fds are being closed by
> exec or exit, the fds do not get removed from the epoll set.

at exec() (granted CLOEXEC is asserted) or exit() time, only the refcount of 
each file is decremented. Only if their refcount becomes NULL, files are then 
removed from epoll set.

> 
> This behaviour strikes me as extremely illogical. On the one hand, one
> cannot share the epoll fd between processes normally, but on fork,
> you can, even though it makes no sense (the child has a different fd
> "namespace" than the parent) and actually works on (then( unrelated fds in
> the other process.
> 
> It also strikes as weird that the order of closing fds should make so much
> of a difference: if the epoll fd is closed first in the child, the other
> fds will survive in the parent, if its closed last, they don't. Makes no
> sense to me.
> 
> Now, the problem I see is not that it makes no sense to me - thats clearly
> my problem. The problem I see is that there is no way to avoid the
> associated problems except by patching all code that would ever use fork,
> even if it never has heard anything about epoll yet. This is extremely
> nonlocal action at a distance, as this affects a lot of code not even the
> author might be aware of (fork is rather common).
> 
> To illustrate, here are some workarounds I thought about:
> 
> - rearming all fds after fork: doesn't work, as the fds get removed
>   asynchronously so I would have to wait for the child to do it.
> - closing the epoll fd after fork: doesn't work unless I control
>   the fork. I can install a handler to be called using pthreads, but
>   that won't help as other handlers might be called first (as in the case of
>   the aio library above), screwing me.
> - closing and recreating the epoll fd before the fork: isn't support event
>   remotely by libevent or similar event loops, and would not help either
>   as I cnanot control the calls to fork.
> 
> Is epoll really designed to be so incompatible with the most commno fork
> patterns? Shouldn't epoll do refcounting, as is commonly done under
> Unix? As the fd space is not shared between rpocesses, why does epoll
> try? Shouldn't the epoll information be copied just like the fd table
> itself, memory, and other resources?

Too many questions here, showing lack of understanding.

> 
> As it looks now, epoll looks useless except in the most controlled
> environments, as it doesn't duplicate state on fork as is done with the
> other fd-related resources (as opposed to the underlying files, which are
> properly shared).
> 

epoll definitly is not useless. It is used on major and critical apps.
You certainly missed something.
Please provide some code to illustrate one exact problem you have.

