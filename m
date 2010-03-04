Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0CDNT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:19:58 -0500
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:35344
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0CDNT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:19:57 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 08:19:57 EST
Message-ID: <4B8FB1A9.8030407@mit.edu>
Date: Thu, 04 Mar 2010 08:12:09 -0500
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: bert hubert <bert.hubert@netherlabs.nl>
CC: linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: epoll clarification sought: multithreaded epoll_wait for UDP
 sockets?
References: <20100303212942.GB24601@xs.powerdns.com>
In-Reply-To: <20100303212942.GB24601@xs.powerdns.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bert hubert wrote:
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

EPOLLET sounds like the right approach.  But if you don't want to drain 
the entire buffer in one thread and you use EPOLLET, you'll have to 
manually wake another thread.  You could use eventfd for that, or maybe 
add a syscall to inject a new edge on a file descriptor.  Good luck.

(FWIW, a couple days ago I got one machine handling over 9 GBps of 
incoming UDP packets on a single core without drops.  It's a hefty 
machine, and I was using jumbo frames, but still.)

--Andy
