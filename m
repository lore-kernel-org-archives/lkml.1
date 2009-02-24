Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZBXSMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZBXSMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZBXSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:12:29 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:53073 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXSM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:12:28 -0500
Message-ID: <49A4387D.2020801@cosmosbay.com>
Date: Tue, 24 Feb 2009 19:12:13 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tony Battersby <tonyb@cybernetics.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
References: <49A42DDE.8060605@cybernetics.com>
In-Reply-To: <49A42DDE.8060605@cybernetics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Feb 2009 19:12:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Battersby a écrit :
>>From the epoll manpage:
> Q: Will closing a file descriptor cause it to be removed from all
>    epoll sets automatically?
> A: Yes
> 
> sys_close() calls filp_close(), which calls fput().  If no one else
> holds a reference to the file, then fput() calls __fput(), and __fput()
> calls eventpoll_release(), which prevents epoll_wait() from returning
> events on the fd to userspace.  In the rare case that sys_close()
> doesn't call __fput() because someone else has a reference to the file,
> a subsequent epoll_wait() may still unexpectedly return events on the
> fd after it has been closed.  This can end up confusing or crashing
> a userspace program that doesn't do epoll_ctl(EPOLL_CTL_DEL) before
> closing the fd.  I have reports of this actually happening under
> heavy load with a program using epoll with network sockets on 2.6.27.
> 
> This patch fixes the problem by calling eventpoll_release_file()
> from filp_close() instead of from __fput().
> 
> The locking in eventpoll_release() and eventpoll_release_file() needs
> to be changed because previously it relied on the fact that no one
> else could have a reference to the file when called from __fput(),
> and this is no longer true.  The new locking is admittedly ugly,
> but I believe it works.
> 
> ep_insert() now also needs to check if the file has been closed
> to avoid races in multi-threaded programs where one thread is doing
> epoll_ctl(EPOLL_CTL_ADD) and another thread is closing the fd.  This is
> done by checking that fget_light still returns the same struct file *
> as before.
> 
> Note that the list_del_init(&epi->fllink) previously done in
> eventpoll_release_file() was unnecessary because it is also done
> by ep_remove().
> 
> Userspace programs that might run on kernels with this bug can work
> around the problem by doing epoll_ctl(EPOLL_CTL_DEL) before close().
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> CC: <stable@kernel.org>

Your patch may solve part of the problem. In your programs, maybe you
have one thread doing all epoll_wait() and close() syscalls, but what
of other programs ?

What prevents a thread doing close(fd) right after an other thread
got this fd from epoll_wait() ?
Nothing, and application may strangely react.

The moment you have several threads doing read()/write()/close() syscalls
on the same fd at the same time, you obviously get problems, not
only with epoll.

In a typical epoll driven application, with a pool of N worker threads all doing :

while (1) {
	fd = epoll_wait(epoll_fd);
	work_on_fd(fd); /* possibly calling close(fd); */
}

Then, you must be prepared to get a *false* event, ie an fd that another worker
already closed (and eventually reopened)


