Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXFDO1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXFDO1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXFDO1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:27:23 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:45390 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXFDO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:27:23 -0400
Date: Mon, 4 Jun 2007 16:27:21 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604162721.500211c9.dada1@cosmosbay.com>
In-Reply-To: <20070604141235.GA24352@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
	<20070604122857.1399e3fc.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
	<20070604152540.985c186a.dada1@cosmosbay.com>
	<20070604141235.GA24352@elte.hu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 16:12:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > O(1) lookup doesnt imply it needs to be super-fast. You make a 
> > confusion about this.
> 
> Davide has written many good speedups for the kernel and he is one of 
> the best scalability experts the Linux kernel has today. You could learn 
> from Davide a thing or two, instead of lecturing him about O(1) ...
> 

I know who is Davide, thank you :)

> For example, the recent futex.c changes you did in commit 34f01cc1 are, 
> and unfortunately there's no better word i can find: plain disgusting. 
> You apparently have plopped the 'fshared' code into the existing logic 
> via conditionals and have blown up the complexity of the functions for 
> no good reason - instead of neatly separating them out. You have added 
> _33_ (thirty-three!) new 'if' branches to futex.c! The feature you 
> introduced is nice and useful, but for heaven's sake please work on 
> cleanliness of your code some more and undo that colossal damage ... 
> preferably before working on other areas of the kernel.
> 

This code took the normal path for inclusion and discussion. If you find it so horrible, 
you should complained before. Fact is that you Acked it :)

If you wanted to make a joke, I find it quite misplaced.

> > O(128) is still O(1) for instance. Having to search a bit in a PAGE is 
> > a sensible compromise, if we dont add overhead on each fget() calls.
> 
> hm, i'm not sure what you are talking about here. Look at Davide's stuff 
> - it's clearly not O(128)...

I am talking about my suggestion to use a bitmap search limited to one page.

So I named it O(128), this clearly should be labeled O(PAGE_SIZE/L1_CACHE_BYTES)

> 
> > You add conditional branches on very hot spots.
> >
> > When you open/close a file, you need to access previous and next 
> > cells, so you need 3 cache lines, exactly like current *legacy* code. 
> > (one for file pointer, one on each bitmap flags(open/close_on_exec) )
> 
> the fd spaces will be separated _no matter what_, that is a physical 
> inevitability of the ABI in question. Whether you hide that into 'extra 
> complexity by trying to bend bitmaps in a way that the new users dont 
> need' or do it explicitly like Davide, i'll go for the explicit 
> separation. Davide's approach, besides being cleaner, simpler and faster 
> also has the advantage of enabling the possible demoting of the 'legacy' 
> fd space in the future. Or demoting the 'new' fd space in the future, if 
> the interface does not take off.
> 
> 	Ingo
> 

