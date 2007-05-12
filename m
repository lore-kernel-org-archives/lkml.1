Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXELOeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXELOeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbXELOeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:34:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbXELOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:34:14 -0400
Date: Sat, 12 May 2007 16:33:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Message-ID: <20070512143328.GA24803@elte.hu>
References: <20070511131541.992688403@chello.nl> <Pine.LNX.4.64.0705121120210.26287@frodo.shire> <1178964103.6810.55.camel@twins> <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
User-Agent: Mutt/1.4.2.2i
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


* Esben Nielsen <nielsen.esben@googlemail.com> wrote:

> I notice that the rwsems used now isn't priority inversion safe (thus 
> destroying the perpose of having PI futexes). We thus already have a 
> bug in the mainline.

you see everything in black and white, ignoring all the grey scales! 
Upstream PI futexes are perfectly fine as long as the mm semaphore is 
not write-locked (by anyone) while the critical path is running. Given 
that real-time tasks often use mlockall and other practices to simplify 
their workload so this is not all that hard to achieve.

> I suggest making a rw_mutex which does read side PI: A reader boosts 
> the writer, but a writer can't boost the readers, since there can be a 
> large amount of those.

this happens automatically when you use Peter's stuff on -rt. But 
mainline should not be bothered with this.

> I don't have time to make such a rw_mutex but I have a simple idea for 
> one, where the rt_mutex can be reused.

Peter's stuff does this already if you remap all the mutex ops to 
rt_mutex ops. Which is also what happens on -rt automatically. Ok?

[ for mainline it is totally pointless and unnecessary to slow down all 
  MM ops via an rt_mutex, because there are so many other, much larger 
  effects that make execution time unbound. (interrupts for example) ]

	Ingo
