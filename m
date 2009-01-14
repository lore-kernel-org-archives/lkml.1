Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbZANJOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbZANJOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZANJNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:13:55 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:46484 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZANJNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:13:52 -0500
Message-ID: <496DACBE.3030701@cosmosbay.com>
Date: Wed, 14 Jan 2009 10:13:34 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Volker.Lendecke@SerNet.DE
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       netdev@vger.kernel.org
Subject: Re: maximum buffer size for splice(2) tcp->pipe?
References: <E1LKrp3-004Tub-IR@intern.SerNet.DE> <20090113123702.ad29cd13.akpm@linux-foundation.org> <496D2078.9080302@cosmosbay.com> <E1LN0MC-00DaJs-M2@intern.SerNet.DE>
In-Reply-To: <E1LN0MC-00DaJs-M2@intern.SerNet.DE>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 14 Jan 2009 10:13:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Lendecke a écrit :
> On Wed, Jan 14, 2009 at 12:15:04AM +0100, Eric Dumazet wrote:
>> Volker, your splice() is a blocking one, from tcp socket to a pipe ?
> 
> Yes, it is.
> 
>> If no other thread is reading the pipe, then you might block forever
>> in splice_to_pipe() as soon pipe is full (16 pages).
> 
> Why does it block when the pipe is full? Why doesn't it
> return a short read, just like the read(2) call does? We
> need to cope with that behaviour anyway.

Well, check code in fs/splice.c, function splice_to_pipe().

If SPLICE_F_NONBLOCK is not set, it is *expected* to block on pipe.

In this mode, only another thread is able to drain the pipe and wakeup the blocked thread.

Code review :

When all pages are used "if (pipe->nrbufs == PIPE_BUFFERS)"

                if (spd->flags & SPLICE_F_NONBLOCK) {
                        if (!ret)
                                ret = -EAGAIN;
                        break;
                }

                if (signal_pending(current)) {
                        if (!ret)
                                ret = -ERESTARTSYS;
                        break;
                }

                if (do_wakeup) {
                        smp_mb();
                        if (waitqueue_active(&pipe->wait))
                                wake_up_interruptible_sync(&pipe->wait);
                        kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
                        do_wakeup = 0;
                }

                pipe->waiting_writers++;
HERE >>         pipe_wait(pipe);
                pipe->waiting_writers--;


> 
>> As pages are not necessarly full (each skb will use at least one page, even if 
>> its length is small), it is not really possible to use splice() like this.
>>
>> In your case, only safe way with current kernel would be to call splice()
>> asking for no more than 16 bytes, that would be really insane for your needs.
>>
>> You may prefer a non blocking mode, at least when calling splice_to_pipe()
> 
> Which fd do I have to set the nonblocking flag on? The TCP
> socket I read from, or the pipe I write to?

I would say, use the SPLICE_F_NONBLOCK flag on splice() system call,
but let tcp socket in blocking mode... But with current kernel it
wont work. In order to avoid busy looping, you might add a poll()/select()
to call splice(SPLICE_F_NONBLOCK) only when socket has data
in its receive queue.

for (;;) {
	struct pollfd pfd;
	pfd.fd = socket;
	pfd.events = POLLIN;
	if (poll(&pfd, 1, -1) != 1)
		continue;
	res = splice(socket, NULL, pipefds[1], NULL, 65536, SPLICE_F_MOVE|SPLICE_F_NONBLOCK);
	if (res > 0)
		nwritten = splice(pipefds[0], NULL, file_fd, NULL, res, SPLICE_F_MOVE|SPLICE_F_MORE);
}

splice() from tcp socket to pipe is not working as is unfortunatly if !SPLICE_F_NONBLOCK)
and if using the same thread to write and read the pipe. Or risk deadlock.


