Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXBKCuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXBKCuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXBKCuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:50:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbXBKCux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:50:53 -0500
Date: Sat, 10 Feb 2007 18:49:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: zach.brown@oracle.com, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org, mingo@elte.hu
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <20070210.165602.07642259.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702101841450.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <20070210.165602.07642259.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, David Miller wrote:
> 
> Even if you have everything, every page, every log file, in the page
> cache, everything talking over the network wants to block.
> 
> Will you create a thread every time tcp_sendmsg() hits the send queue
> limits?

No. You use epoll() for those. 

> The idea is probably excellent for operations on real files, but it's
> going to stink badly for networking stuff.

And I actually talked about that in one of the emails already. There is no 
way you can beat an event-based thing for things that _are_ event-based. 
That means mainly networking.

For things that aren't event-based, but based on real IO (ie filesystems 
etc), event models *suck*. They suck because the code isn't amenable to it 
in the first place (ie anybody who thinks that a filesystem is like a 
network stack and can be done as a state machine with packets is just 
crazy!).

So you would be crazy to makea web server that uses this to handle _all_ 
outstanding IO. Network connections are often slow, and you can have tens 
of thousands outstanding (and some may be outstanding for hours until they 
time out, if ever). But that's the whole point: you can easily mix the 
two, as given in several examples already (ie you can easily make the main 
loop itself basically do just

	for (;;) {
		async(epoll);	/* wait for networking events */
		async_wait();	/* wait for epoll _or_ any of the outstanding file IO events */
		handle_completed_events();
	}

and it's actually a lot better than an event model, exactly because now 
you can handle events _and_ non-events well (a pure event model requires 
that _everything_ be an event, which works fine for some things, but works 
really badly for other things).

There's a reason why a lot of UNIX system calls are blocking: they just 
don't make sense as event models, because there is no sensible half-way 
point that you can keep track of (filename lookup is the most common 
example).

		Linus
