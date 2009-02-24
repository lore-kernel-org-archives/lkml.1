Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZBXSoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZBXSoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZBXSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:44:04 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3302 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZBXSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:44:03 -0500
Message-ID: <49A43FF0.2070703@cybernetics.com>
Date: Tue, 24 Feb 2009 13:44:00 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
References: <49A42DDE.8060605@cybernetics.com> <49A4387D.2020801@cosmosbay.com>
In-Reply-To: <49A4387D.2020801@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Your patch may solve part of the problem. In your programs, maybe you
> have one thread doing all epoll_wait() and close() syscalls, but what
> of other programs ?
>
> What prevents a thread doing close(fd) right after an other thread
> got this fd from epoll_wait() ?
> Nothing, and application may strangely react.
>
> The moment you have several threads doing read()/write()/close() syscalls
> on the same fd at the same time, you obviously get problems, not
> only with epoll.
>
> In a typical epoll driven application, with a pool of N worker threads all doing :
>
> while (1) {
> 	fd = epoll_wait(epoll_fd);
> 	work_on_fd(fd); /* possibly calling close(fd); */
> }
>
> Then, you must be prepared to get a *false* event, ie an fd that another worker
> already closed (and eventually reopened)
>
>
>
>   
Yes, I agree that userspace threads do need synchronization to prevent
one thread from stomping on another thread's data.  If userspace can't
prove that close() returned before the call to epoll_wait(), then
epoll_wait() may legitimately return an event on a closed fd.  That's
why my test program did close() and then epoll_wait() from the same
thread - to prove that they were serialized.

I am not actually using epoll in any of my programs right now; I was
just investigating a bug reported to me by another programmer at my
company.  So my test program isn't intented to reflect anything other
than a way to reproduce the problem reliably.  However, I can imagine
that a network program might want to spawn separate rx/tx threads on the
same socket, in which case it might make sense to have separate threads
accessing the same file descriptor.  As you say, the two threads would
have to use proper locking, but that is purely a userspace issue that
kernel developers need not worry about.  So I am only concerned with the
case that userspace can prove that close() and epoll_wait() were
properly serialized, and epoll_wait() still returned an event on the
closed fd.

Tony

