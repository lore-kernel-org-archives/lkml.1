Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXA2TJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXA2TJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXA2TJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:09:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55267 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbXA2TJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:09:32 -0500
Date: Mon, 29 Jan 2007 20:08:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070129190806.GA14353@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128142925.df2f4dce.akpm@osdl.org>
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


* Andrew Morton <akpm@osdl.org> wrote:

> > Eradicate global locks.
> > 
> >  - kmap_lock is removed by extensive use of atomic_t, a new flush
> >    scheme and modifying set_page_address to only allow NULL<->virt
> >    transitions.

> I really don't recall any performance problems being reported out of 
> that code in recent years.

well, almost nobody profiles 32-bit boxes. I personally always knew that 
kmap() sucks on certain 32-bit SMP workloads (and -rt's scheduling model 
makes such bottlenecks even more apparent) - but many people acted in 
the belief that 64-bit is all that matters and 32-bit scalability is 
obsolete. Here are the numbers that i think changes the picture:

 http://www.fedoraproject.org/awstats/stats/updates-released-fc6-i386.total
 http://www.fedoraproject.org/awstats/stats/updates-released-fc6-x86_64.total

For every 64-bit Fedora box there's more than seven 32-bit boxes. I 
think 32-bit is going to live with us far longer than many thought, so 
we might as well make it work better. Both HIGHMEM and HIGHPTE is the 
default on many distro kernels, which pushes the kmap infrastructure 
quite a bit.

> As Christoph says, it's very much preferred that code be migrated over 
> to kmap_atomic().  Partly because kmap() is deadlockable in situations 
> where a large number of threads are trying to take two kmaps at the 
> same time and we run out.  This happened in the past, but incidences 
> have gone away, probably because of kmap->kmap_atomic conversions.

the problem is that everything that was easy to migrate was migrated off 
kmap() already - and it's exactly those hard cases that cannot be 
converted (like the pagecache use) which is the most frequent kmap() 
users.

While "it would be nice" to eliminate kmap(), but reality is that it's 
here and the patches from Peter to make it (quite a bit) more scalable 
are here as well.

plus, with these fixes kmap() is actually faster than kmap_atomic(). 
(because kunmap_atomic() necessiates an INVLPG instruction which is 
quite slow.)

	Ingo
