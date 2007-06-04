Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXFDONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXFDONS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXFDONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:13:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbXFDONI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:13:08 -0400
Date: Mon, 4 Jun 2007 16:12:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-ID: <20070604141235.GA24352@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1> <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com> <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu> <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org> <20070604122857.1399e3fc.dada1@cosmosbay.com> <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com> <20070604152540.985c186a.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604152540.985c186a.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> O(1) lookup doesnt imply it needs to be super-fast. You make a 
> confusion about this.

Davide has written many good speedups for the kernel and he is one of 
the best scalability experts the Linux kernel has today. You could learn 
from Davide a thing or two, instead of lecturing him about O(1) ...

For example, the recent futex.c changes you did in commit 34f01cc1 are, 
and unfortunately there's no better word i can find: plain disgusting. 
You apparently have plopped the 'fshared' code into the existing logic 
via conditionals and have blown up the complexity of the functions for 
no good reason - instead of neatly separating them out. You have added 
_33_ (thirty-three!) new 'if' branches to futex.c! The feature you 
introduced is nice and useful, but for heaven's sake please work on 
cleanliness of your code some more and undo that colossal damage ... 
preferably before working on other areas of the kernel.

> O(128) is still O(1) for instance. Having to search a bit in a PAGE is 
> a sensible compromise, if we dont add overhead on each fget() calls.

hm, i'm not sure what you are talking about here. Look at Davide's stuff 
- it's clearly not O(128)...

> You add conditional branches on very hot spots.
>
> When you open/close a file, you need to access previous and next 
> cells, so you need 3 cache lines, exactly like current *legacy* code. 
> (one for file pointer, one on each bitmap flags(open/close_on_exec) )

the fd spaces will be separated _no matter what_, that is a physical 
inevitability of the ABI in question. Whether you hide that into 'extra 
complexity by trying to bend bitmaps in a way that the new users dont 
need' or do it explicitly like Davide, i'll go for the explicit 
separation. Davide's approach, besides being cleaner, simpler and faster 
also has the advantage of enabling the possible demoting of the 'legacy' 
fd space in the future. Or demoting the 'new' fd space in the future, if 
the interface does not take off.

	Ingo
