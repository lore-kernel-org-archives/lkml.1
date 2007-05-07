Return-Path: <linux-kernel-owner+w=401wt.eu-S966039AbXEGRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966039AbXEGRSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965752AbXEGRSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:18:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2421 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965662AbXEGRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:18:45 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 7 May 2007 10:18:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Chase Venters <chase.venters@clientec.com>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <Pine.LNX.4.64.0705071038560.1227@turbotaz.ourhouse>
Message-ID: <Pine.LNX.4.64.0705071009020.29173@alien.or.mcafeemobile.com>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705071038560.1227@turbotaz.ourhouse>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Chase Venters wrote:

> I'm working on event handling code for multiple projects right now, and my
> method of calling epoll_wait() is to do so from several threads. I've glanced
> at the epoll code but obviously haven't noticed the wake-all behavior... good
> to know. I suppose I'm going to have to hack around this problem by wrapping
> epoll_wait() calls in a mutex. That sucks - it means other threads won't be
> able to 'get ahead' by preparing their wait before it is their turn to dequeue
> events.
> 
> In any case, I think having multiple threads blocking on epoll_wait() is a
> much saner idea than one thread which then passes out events, so I must voice
> my support for fixing this case. Why this is the exception instead of the norm
> is a little baffling, but I've seen so many perverse things in multi-threaded
> code...

The problem that you can have with multiple threads calling epoll_wait() 
on an SMP system, is that if you sweep 100 events in one thread, and this 
thread goes alone in processing those, you may have other CPUs idle while 
the other thread is handling those. Either you call epoll_wait() from 
multiple thread by keeping the event buffer passed to epoll_wait() farily 
limited, on you use a single epoll_wait() fetcher with a queue(s) from 
which worker threads pull from.
Davi's patch will be re-factored against 22-rc1 and submitted in any case 
though.



- Davide


