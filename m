Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbXB0NeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbXB0NeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXB0NeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:34:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:51950 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXB0NeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:34:05 -0500
Message-ID: <45E432D3.8060208@argo.co.il>
Date: Tue, 27 Feb 2007 15:32:03 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Theodore Tso <tytso@mit.edu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227123421.GA21616@elte.hu>
In-Reply-To: <20070227123421.GA21616@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Theodore Tso <tytso@mit.edu> wrote:
>
>   
>> I think what you are not hearing, and what everyone else is saying 
>> (INCLUDING Linus), is that for most programmers, state machines are 
>> much, much harder to program, understand, and debug compared to 
>> multi-threaded code. [...]
>>     
>
> btw., another crutial thing that i think Evgeniy is missing is that 
> threadlets /enable/ event loops to be used in practice! Right now the 
> epoll/kevent programming model requires a total 100% avoidance of all 
> context-switching in the 'main' event handler context while handling a 
> request. If just 1% of all requests happen to block it might cause a 
> /complete/ breakdown of an event loop's performance - it can easily 
> cause a 10x drop in performance or worse!
>
> So context-switching has to be avoided in 100% of the code that runs 
> while handling requests, file descriptors have to be set to nonblocking 
> (causing extra system calls), and all the syscalls that might return 
> incomplete with either -EINVAL or with a short read/write have to be 
> converted into a state machine. (or in the alternative, user-space 
> threading has to be used, which opens up another hornet's nest)
>
> /That/ is the main inhibiting factor of the measured use of event loops 
> within Linux! It has zero integration capabilities with 'usual' coding 
> techniques - driving the costs of its application up in the sky, and 
> pushing event based servers into niches.
>
>   

Having written such a niche event based server, I can 100% confirm what 
Ingo is saying here.  We had a single process drive I/O to the kernel 
through an event model (based on kernel aio extended with IO_CMD_POLL), 
and user level threads managed by a custom scheduler that managed I/O, 
timeouts, and thread scheduling.

We once considered dropping from a user-level thread model to a state 
machine model, but the effort was astronomical and we wouldn't see the 
rewards until it was all done, so naturally we didn't do it.

> With threadlets the picture changes dramatically: all we have to 
> concentrate on to get the performance of "100% event based servers" is 
> to handle 'most' rescheduling events in the event loop. A 10-20% context 
> switching ratio does not hurt at all. (it causes ~1% of throughput 
> loss.)
>
> Furthermore, even if a particular configuration or module of the server 
> (say Apache) happens to trigger a high rate of scheduling, the 
> performance breakdown model of threadlets is /vastly/ superior to event 
> based servers. The measurements so far have shown that the absolute 
> worst-case threading server performance is at around 60% of that of 
> non-context-switching servers - and even that level is reached 
> gradually, leaving time for action for the server owner. While with 
> fully event based servers there are mostly only two modes of 
> performance: 100% performance and near-0% performance: total breakdown.
>   

Yes.  Threadlets as the default aio solution (easy to use, acceptable 
performance even in worst cases), with specialized solutions where 
applicable (epoll for networking, aio for O_DIRECT disk) look like a 
good mix of performance and sanity.



-- 
error compiling committee.c: too many arguments to function

