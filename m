Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYAFVpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYAFVpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYAFVo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:44:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:30053 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbYAFVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=m0U4hNdOM5KLJaYY7TicK1izYFTVBshqbbTiYg1VMRO97Lk57C0VWvgH6QQNr2PolGMnzwYI4HfJG3ElV9FHpQPGpMup3cTAt4KgP+beBugYIXFgerzgw6djHXP5G59ACBClKnxT6UIV1MzKa36dweLhs83pzKmWyNopkOZ+/IE=
Date: Mon, 7 Jan 2008 00:44:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
Message-ID: <20080106214442.GA32187@cvg>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de> <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu> <20080105071205.GA28936@gondor.apana.org.au> <1199552016.31975.41.camel@lappy> <1199552476.31975.45.camel@lappy> <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Davide Libenzi - Sat, Jan 05, 2008 at 01:35:25PM -0800]
| On Sat, 5 Jan 2008, Peter Zijlstra wrote:
| 
[...snip...] 
| I remember I talked with Arjan about this time ago. Basically, since 1) 
| you can drop an epoll fd inside another epoll fd 2) callback-based wakeups 
| are used, you can see a wake_up() from inside another wake_up(), but they 
| will never refer to the same lock instance.
| Think about:
| 
| 	dfd = socket(...);
| 	efd1 = epoll_create();
| 	efd2 = epoll_create();
| 	epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
| 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
| 
| When a packet arrives to the device underneath "dfd", the net code will 
| issue a wake_up() on its poll wake list. Epoll (efd1) has installed a 
| callback wakeup entry on that queue, and the wake_up() performed by the 
| "dfd" net code will end up in ep_poll_callback(). At this point epoll 
| (efd1) notices that it may have some event ready, so it needs to wake up 
| the waiters on its poll wait list (efd2). So it calls ep_poll_safewake() 
| that ends up in another wake_up(), after having checked about the 
| recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to 
| avoid stack blasting. Never hit the same queue, to avoid loops like:
| 
| 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
| 	epoll_ctl(efd3, EPOLL_CTL_ADD, efd2, ...);
| 	epoll_ctl(efd4, EPOLL_CTL_ADD, efd3, ...);
| 	epoll_ctl(efd1, EPOLL_CTL_ADD, efd4, ...);
| 
| The code "if (tncur->wq == wq || ..." prevents re-entering the same 
| queue/lock.
| I don't know how the lockdep code works, so I can't say about 
| wake_up_nested(). Although I have a feeling is not enough in this case.
| A solution may be to move the call to ep_poll_safewake() (that'd become a 
| simple wake_up()) inside a tasklet or whatever is today trendy for delayed 
| work. But his kinda scares me to be honest, since epoll has already a 
| bunch of places where it could be asynchronously hit (plus performance 
| regression will need to be verified).
| 
| 
| 
| - Davide
| 
| 

it's quite possible that i'm wrong but just interested...
why in ep_poll_safewake() the assignment

	struct list_head *lsthead = &psw->wake_task_list;

is not protected by spinlock?

		- Cyrill -
