Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJTMNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJTMNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYJTMNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:13:40 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:37279 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYJTMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:13:39 -0400
Message-ID: <48FC75EF.1020705@motion-twin.com>
Date: Mon, 20 Oct 2008 14:13:35 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: swivel@shells.gnugeneration.com
CC: linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
References: <48FC4066.9060303@motion-twin.com> <20081020101549.GH2811@fc6222126.aspadmin.net> <48FC61A0.7010003@motion-twin.com> <20081020113942.GJ2811@fc6222126.aspadmin.net>
In-Reply-To: <20081020113942.GJ2811@fc6222126.aspadmin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swivel@shells.gnugeneration.com a écrit :
> When the other end of the TCP is _gone_ that leads me to believe a FIN
> will not be coming, hence the indefinite ESTABLISHED state.  Why it's
> gone is a different question, maybe your problem is at the other end?
> The end initiating a shutdown has to enter FIN_WAIT_1 then FIN_WAIT_2,
> these transitions require the other side to leave ESTABLISHED (receive a
> FIN then ACK) at the very least to proceed.
> 
>> I agree with your comment in general, except that we have been running 
>> the same application in single-thread environment for years without 
>> running into this very specific problem.
>>
> 
> Perhaps when you run in multicore/threaded you are stressing the network
> stacks at both ends more, including everything in-between?  The
> threading vs. single process relationship is probably not causal, but
> just coincidental.

Not sure why this should happen, since it's the same servers. What only 
change is part of the software that we are using to handle our server 
requests. It's either embedded in Apache 1.3 with fork() or a standalone 
multithread server which acts as Apache backend.

So the only difference for networking is that we have additional 
Apache<->MT-Server communications, but they should be on 127.0.0.1 so I 
think they are purely software and not hardware-related.

> What is the protocol?  Are there any timeouts to take care of these
> situations?  Do you schedule an alarm or use SO_RCVTIMEO to shutdown
> dead connections and free up consumed threads?

The protocol is MySQL. Since we had the problem with libmysqlclient, we 
reimplemented it again from scratch to make sure that it was not 
software-related.

What happens at the protocol-level is the following :

a) we connect to the server
b) we make several requests and get answers back
c) at some (random+rare) point - always after making a request - we're 
stuck while waiting for the answer.

Sadly, this can happen inside a transaction while we hold the lock on 
some shared resource. This will lock the whole website until we run out 
of File Descriptor due to accept'ed pending connections. In that case we 
get an exception and the server (the multithread one, not MySQL) 
restarts, which release the lock.

In some other cases when we don't hold a lock, the thread remains 
blocked in poll() as I described it. After a timeout (I think it's 28800 
seconds) the MySQL server closes the connection. The client - which is 
waiting in poll() - does not have any timeout activated (it's relying on 
the mysql server). But it doesn't notice that the socket has been closed 
either.

We investigated a lot about signals since poll() can also be interrupted 
by Garbage Collector and child process signals, but we correctly handle 
EINTR everywhere it's needed. So unless there's a possibility that 
interrupting poll() with a signal might somehow consume the data, this 
is not the problem here.

> TCP being reliable can block indefinitely, you can employ TCP keepalive
> to change indefinite to quite a long time.

Sure. We could also use a client timeout, but we don't want to hold the 
lock more than required, and we can't make the difference between a 
given request that would take too much time to complete and a lost 
connection.

Hope we can somehow understand what's going on.
Thanks for the answers so far,

Best,
Nicolas
