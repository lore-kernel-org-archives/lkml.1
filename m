Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXA1PSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXA1PSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbXA1PSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:18:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39272 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXA1PSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:18:44 -0500
Date: Sun, 28 Jan 2007 16:17:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070128151700.GA7644@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128144933.GD16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128144933.GD16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 03:11:34PM +0100, Peter Zijlstra wrote:
> > Eradicate global locks.
> > 
> >  - kmap_lock is removed by extensive use of atomic_t, a new flush
> >    scheme and modifying set_page_address to only allow NULL<->virt
> >    transitions.
> 
> What's the point for this? [...]

scalability. I did lock profiling on the -rt kernel, which exposes such 
things nicely. Half of the lock contention events during kernel compile 
were due to kmap(). (The system had 2 GB of RAM, so 40% lowmem, 60% 
highmem.)

> [...] In doubt we just need to convert that caller to kmap_atomic.

the pagecache ones cannot be converted to kmap_atomic, because we can 
block while holding them. Plus kmap_atomic is quite a bit slower than 
this scalable version of kmap().

	Ingo

ps. please fix your mailer to not emit Mail-Followup-To headers. In Mutt
    you can do this via "set followup_to=no" in your .muttrc.
