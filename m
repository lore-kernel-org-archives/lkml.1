Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZA1FcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZA1FcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZA1FcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:32:09 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59540 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbZA1FcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:32:08 -0500
Date: Wed, 28 Jan 2009 16:32:04 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128053204.GB8720@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 08:00:30PM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Bron Gondwana wrote:
> 
> > Both Postfix and Apache use an epoll instance per child, which
> > leads to significant scalability issues with max_user_instances
> > set so low.  Bump the default to 1024 so medium sized sites are
> > not impacted.
> 
> NACK. Epoll allocates globally about 100 to 160 bytes (32/64 bit) for each 
> file added to the interface:
> 
> 	for i 1..1024
> 		for j 1..1024
> 			if i!=j
> 				add j -> i
> 
> That's (N^2 * {100, 160}) = 100MB to 160MB of pinned kernel memory, 

Woah - that's serious.

This:

instances_uid     0  (root)
num_instances	142
max_instances  4096
watches_uid     107  (postfix)
num_watches    1097
max_watches  266555

isn't serious.  It's pretty sane.  142 processes with an epoll watcher,
and fewer than 10 fds per epoll.  Unfortunately, it wouldn't work on an
unpatched and un-specially-configured stock kernel.  That's steady-state
too, not a peak.  I just grabbed it off a running MX:

[brong@mx1 ~]$ free
             total       used       free     shared    buffers
cached
Mem:       4151652    3113128    1038524          0     130808
2014152
-/+ buffers/cache:     968168    3183484
Swap:      2047992      50364    1997628
[brong@mx1 ~]$ uptime
 00:31:05 up 2 days, 18:03,  2 users,  load average: 0.86, 1.23, 1.08

Hardly looking stressed right now.

If I'm reading it right, your concern is the massively recursive case,
where every single epoll gets added to every other epoll as a chained
file descriptor?

That's clearly not happening here - so it seems that maybe our "happy
medium" is actually in closer inspection of what's going on rather than
a blanket low N to keep N^2 down.

Bron.
