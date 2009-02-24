Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZBXTxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZBXTxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZBXTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:52:58 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:40655 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZBXTw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:52:58 -0500
Message-ID: <49A44FEB.6000803@cosmosbay.com>
Date: Tue, 24 Feb 2009 20:52:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tony Battersby <tonyb@cybernetics.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
References: <49A42DDE.8060605@cybernetics.com> <49A4387D.2020801@cosmosbay.com> <49A43FF0.2070703@cybernetics.com>
In-Reply-To: <49A43FF0.2070703@cybernetics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Feb 2009 20:52:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Battersby a écrit :
> Eric Dumazet wrote:
>> Your patch may solve part of the problem. In your programs, maybe you
>> have one thread doing all epoll_wait() and close() syscalls, but what
>> of other programs ?
>>
>> What prevents a thread doing close(fd) right after an other thread
>> got this fd from epoll_wait() ?
>> Nothing, and application may strangely react.
>>
>> The moment you have several threads doing read()/write()/close() syscalls
>> on the same fd at the same time, you obviously get problems, not
>> only with epoll.
>>
>> In a typical epoll driven application, with a pool of N worker threads all doing :
>>
>> while (1) {
>> 	fd = epoll_wait(epoll_fd);
>> 	work_on_fd(fd); /* possibly calling close(fd); */
>> }
>>
>> Then, you must be prepared to get a *false* event, ie an fd that another worker
>> already closed (and eventually reopened)
>>
>>
>>
>>   
> Yes, I agree that userspace threads do need synchronization to prevent
> one thread from stomping on another thread's data.  If userspace can't
> prove that close() returned before the call to epoll_wait(), then
> epoll_wait() may legitimately return an event on a closed fd.  That's
> why my test program did close() and then epoll_wait() from the same
> thread - to prove that they were serialized.
> 
> I am not actually using epoll in any of my programs right now; I was
> just investigating a bug reported to me by another programmer at my
> company.  So my test program isn't intented to reflect anything other
> than a way to reproduce the problem reliably.  However, I can imagine
> that a network program might want to spawn separate rx/tx threads on the
> same socket, in which case it might make sense to have separate threads
> accessing the same file descriptor.  As you say, the two threads would
> have to use proper locking, but that is purely a userspace issue that
> kernel developers need not worry about.  So I am only concerned with the
> case that userspace can prove that close() and epoll_wait() were
> properly serialized, and epoll_wait() still returned an event on the
> closed fd.

I believe Davide already said that close() meant the real close, not
the file descriptor freeing. 

And current documentations clearly states it, maybe your man page is too old ?

---

Q6  Will closing a file descriptor cause it to be removed from all epoll sets automatically?

A6  Yes,  but  be  aware  of  the  following  point.   A  file descriptor is a reference to an open file description (see
    open(2)).  Whenever a descriptor is duplicated via dup(2), dup2(2), fcntl(2) F_DUPFD, or fork(2), a new file descriptor  referring  to  the same open file description is created.  An open file description continues to exist until all
    file descriptors referring to it have been closed.  A file descriptor is removed from an epoll set only after all the
    file  descriptors  referring to the underlying open file description have been closed (or before if the descriptor is
    explicitly removed using epoll_ctl() EPOLL_CTL_DEL).  This means that even after a file descriptor that is part of an
    epoll set has been closed, events may be reported for that file descriptor if other file descriptors referring to the
    same underlying file description remain open.



