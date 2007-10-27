Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXJ0JWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXJ0JWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXJ0JWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:22:36 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48848 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXJ0JWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:22:35 -0400
Message-ID: <47230351.8040100@cosmosbay.com>
Date: Sat, 27 Oct 2007 11:22:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marc Lehmann <linux-kernel@tst.eu>
CC: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de>
In-Reply-To: <20071027085125.GC12326@schmorp.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 27 Oct 2007 11:22:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Lehmann a écrit :
> On Sat, Oct 27, 2007 at 10:23:17AM +0200, Eric Dumazet <dada1@cosmosbay.com> wrote:
>>>  In this case, the parent process works fine until the child closes fds,
>>>  after which the fds become unarmed in the parent too. This works as
>> I have no idea what exact problem you have. 
> 
> Well, I explained it rather succinctly, I think. If you tell me whats unclear
> I can explain...
> 
>> But if the child closes some 
>> file descriptor that were 'cloned' at fork() time, this only decrements a 
>> refcount, and definitely should not close it for the 'parent'.
> 
> It doesn't. It removes it from the epoll set, though, so the parent will not
> receive events for that fd anymore.
> 
>> I have some apps that are happily using epoll() and fork()/exec() and have 
> 
> The problem I described is fork/close/exec. close being the explicit
> syscall.
> 
>> no problem at all. I usually use O_CLOEXEC so that all close() are done at 
>> exec() time without having to do it in a loop. epoll continues to work as 
>> expected in the parent process.
> 
> This is because epoll doesn't behave like documented: It removes the fd
> from the parents epoll set only on an explicit close() syscall, not on an
> implicit close from exec.
> 
>>> fd sets. This would explain the behaviour above. Unfortunately (or
>>> fortunately?) this is not what happens: when the fds are being closed by
>>> exec or exit, the fds do not get removed from the epoll set.
>> at exec() (granted CLOEXEC is asserted) or exit() time, only the refcount 
>> of each file is decremented. Only if their refcount becomes NULL, files are 
>> then removed from epoll set.
> 
> Yes. But thats obviously not the only way to close fds.
> 
>>> Is epoll really designed to be so incompatible with the most commno fork
>>> patterns? Shouldn't epoll do refcounting, as is commonly done under
>>> Unix? As the fd space is not shared between rpocesses, why does epoll
>>> try? Shouldn't the epoll information be copied just like the fd table
>>> itself, memory, and other resources?
>> Too many questions here, showing lack of understanding.
> 
> You already said you don't the problem. No need to get insulting :(
> 
>> epoll definitly is not useless. It is used on major and critical apps.
>> You certainly missed something.
> 
> Well, it behaves like documented, which is the problem. You admit you
> don't understand the problem or the documentation, so again, no need to
> insult me.

Hum... I will update my english vocabulary and mark "missed" as an insult.

I have no problem with epoll nor its documentation.

> 
>> Please provide some code to illustrate one exact problem you have.
> 
>    // assume there is an open epoll set that listens for events on fd 5
>    if (fork () = 0)
>      {
>        close (5);
>        // fd 5 is now removed from the epoll set of the parent.
>        _exit (0);
>      }
> 

It doesnt on every kernels I had played with. And I played with *lot* of 
kernels you know.

If such a bug exists on your kernel, please fill a complete bug report, giving 
details.

Thank you

