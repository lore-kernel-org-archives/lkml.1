Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0CCWEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:04:50 -0500
Received: from xs.powerdns.com ([82.94.213.34]:59927 "EHLO xs.powerdns.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0CCWEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:04:45 -0500
X-Greylist: delayed 2100 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 17:04:44 EST
Date: Wed, 3 Mar 2010 22:29:42 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: linux-kernel@vger.kernel.org
Cc: davidel@xmailserver.org
Subject: epoll clarification sought: multithreaded epoll_wait for UDP
 sockets?
Message-ID: <20100303212942.GB24601@xs.powerdns.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel people, dear Davide,

I am currently debugging performance issues in the PowerDNS Recursor, and it
turns out I have been using epoll_wait() sub-optimally. And I need your help
to improve this. I'm more than happy to update the epoll_wait() manpage to
reflect your advice.

Essentially, what I would like to have is a way to distribute incoming UDP DNS
queries to various threads automatically.  Right now, there is one
fd that multiple threads wait on, using epoll() or select() and subsequently
recvfrom(). Crucially, each thread has its own epoll fd set (which is
wrong).

The hope is that each thread hogs a single CPU, and that UDP DNS queries
coming in arrive at a single thread that is currently in epoll_wait(), ie
not doing other things. 

As indicated by the manpage of epoll however, my setup means that threads
get woken up unnecessarily when a new packet comes in.  This results in lots
of recvfrom() calls returning EAGAIN (basically on most of the other
threads).

(this can be observed in
http://svn.powerdns.com/snapshots/rc2/pdns-recursor-3.2-rc2.tar.bz2 )

The alternative appears to be to create a single epoll set, and have all
threads call epoll_wait on that same set. 

The epoll() manpage however is silent on what this will do exactly, although
several LKML posts indicate that this might cause 'thundering herd'
problems.

My question is: what is your recommendation for achieving the scenario
outlined above? In other words, that is the 'best current practice' on
modern Linux kernels to get each packet to arrive at a single thread?

Epoll offers 'edge triggered' behaviour, would this make sense? Would it be
smart to cal epoll_wait with only a single event to be returned to prevent
starvation? Might it be useful to dup() the single fd, once for each thread? 
I also tried SO_REUSEADDR, so I could bind() multiple times to the same IP
address & port, but this does not distribute incoming queries.

Many thanks for your time, and whatever advice you might have I will be sure
to contribute to the epoll manpage or perhaps a blog post that search
engines can find.

Cheers,

Bert Hubert
