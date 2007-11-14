Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbXKNVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbXKNVlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXKNVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:41:24 -0500
Received: from pat.uio.no ([129.240.10.15]:51169 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbXKNVlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:41:21 -0500
Subject: Re: [PATCH 3/3] nfs: use ->mmap_prepare() to avoid an AB-BA
	deadlock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1195075905.22457.3.camel@lappy>
References: <20071114200136.009242000@chello.nl>
	 <20071114201528.514434000@chello.nl> <20071114212246.GA31048@wotan.suse.de>
	 <1195075905.22457.3.camel@lappy>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 16:41:25 -0500
Message-Id: <1195076485.7584.66.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=12.0, autolearn=disabled, AWL=-0.397)
X-UiO-Scanned: A3799A1FAD3D5436EB734A56D14358C5DFB97A1A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 703 total 5136702 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 22:31 +0100, Peter Zijlstra wrote:
> On Wed, 2007-11-14 at 22:22 +0100, Nick Piggin wrote:
> > On Wed, Nov 14, 2007 at 09:01:39PM +0100, Peter Zijlstra wrote:
> > > Normal locking order is:
> > > 
> > >   i_mutex
> > >     mmap_sem
> > > 
> > > However NFS's ->mmap hook, which is called under mmap_sem, can take i_mutex.
> > > Avoid this potential deadlock by doing the work that requires i_mutex from
> > > the new ->mmap_prepare().
> > > 
> > > [ Is this sufficient, or does it introduce a race? ]
> > 
> > Seems like an OK patchset in my opinion. I don't know much about NFS
> > unfortunately, but I wonder what prevents the condition fixed by
> > nfs_revalidate_mapping from happening again while the mmap is active...?
> 
> As the changelog might have suggested, I'm not overly sure of the nfs
> requirements myself. I think it just does a best effort at getting the
> pages coherent with other clients, and then hopes for the best.
> 
> I'll let Trond enlighten us further before I make an utter fool of
> myself :-)

The NFS client needs to check the validity of already cached data before
it allows those pages to be mmapped. If it finds out that the cache is
stale, then we need to call invalidate_inode_pages2() to clear out the
cache and refresh it from the server. The inode->i_mutex is necessary in
order to prevent races between the new writes and the cache invalidation
code.

Cheers
  Trond

