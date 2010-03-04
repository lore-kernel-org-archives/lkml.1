Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0CDPkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:40:49 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59500 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0CDPkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:40:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 4 Mar 2010 07:40:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: bert hubert <bert.hubert@netherlabs.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll clarification sought: multithreaded epoll_wait for UDP
 sockets?
In-Reply-To: <20100303212942.GB24601@xs.powerdns.com>
Message-ID: <alpine.DEB.2.00.1003040731170.10593@makko.or.mcafeemobile.com>
References: <20100303212942.GB24601@xs.powerdns.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, bert hubert wrote:

> Dear kernel people, dear Davide,
> 
> I am currently debugging performance issues in the PowerDNS Recursor, and it
> turns out I have been using epoll_wait() sub-optimally. And I need your help
> to improve this. I'm more than happy to update the epoll_wait() manpage to
> reflect your advice.
> 
> Essentially, what I would like to have is a way to distribute incoming UDP DNS
> queries to various threads automatically.  Right now, there is one
> fd that multiple threads wait on, using epoll() or select() and subsequently
> recvfrom(). Crucially, each thread has its own epoll fd set (which is
> wrong).
> 
> The hope is that each thread hogs a single CPU, and that UDP DNS queries
> coming in arrive at a single thread that is currently in epoll_wait(), ie
> not doing other things. 
> 
> As indicated by the manpage of epoll however, my setup means that threads
> get woken up unnecessarily when a new packet comes in.  This results in lots
> of recvfrom() calls returning EAGAIN (basically on most of the other
> threads).
> 
> (this can be observed in
> http://svn.powerdns.com/snapshots/rc2/pdns-recursor-3.2-rc2.tar.bz2 )
> 
> The alternative appears to be to create a single epoll set, and have all
> threads call epoll_wait on that same set. 
> 
> The epoll() manpage however is silent on what this will do exactly, although
> several LKML posts indicate that this might cause 'thundering herd'
> problems.
> 
> My question is: what is your recommendation for achieving the scenario
> outlined above? In other words, that is the 'best current practice' on
> modern Linux kernels to get each packet to arrive at a single thread?
> 
> Epoll offers 'edge triggered' behaviour, would this make sense? Would it be
> smart to cal epoll_wait with only a single event to be returned to prevent
> starvation? Might it be useful to dup() the single fd, once for each thread? 
> I also tried SO_REUSEADDR, so I could bind() multiple times to the same IP
> address & port, but this does not distribute incoming queries.
> 
> Many thanks for your time, and whatever advice you might have I will be sure
> to contribute to the epoll manpage or perhaps a blog post that search
> engines can find.

Use a single epoll fd, and a UDP DNS server, I'd use EPOLLET and 
EPOLLONESHOT.
The most frequent mistake that people using epoll with threads do, is to 
fetch an fd out of the ready set, handle it to a thread, and then at the 
next epoll_wait+dispatch iteration, they refetch the same fd and handle it 
to another thread (while the other one is still handling it).
Using multiple threads, you have to mark the context of the fd as "in use" 
(or you use EPOLLONESHOT), while another thread is handling that session.
Another solution is to have a single epoll_wait() fetcher, with a queue 
from where other threads feed. At that point it is fetcher responsibility 
to mark the context associated with the fd as "in use" (and notice the 
condition when fetching+dispatching following events), before feeding it 
to the queue.  When the handling thread finished with an fd (because the 
session is over, or because it got EAGAIN), the thread would give back the 
fd to the feeder, which will clear the "in use" bit in the fd's context 
(and resubmit to epoll, if necessary).


- Davide


