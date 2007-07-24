Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXGXToa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXGXToa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXGXToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:44:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:54439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXGXToV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:44:21 -0400
Date: Tue, 24 Jul 2007 21:44:18 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070724194418.GH19559@v2.random>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718133222.GM11781@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 06:32:22AM -0700, William Lee Irwin III wrote:
> Actually I'd worked on what was called MPSS (Multiple Page Size Support)
> before I ever started on pgcl. Some large portion of the pgcl proposal
> as I presented it internally was to reduce the order of large page
> allocations and provide a promotion and demotion mechanism enabling
> different processes to have different sized translations for the same
> large page, and hence no out-of-context pagetable/TLB updates during
> promotion and demotion, essentially by making the TLB translation to
> page relation M:N. ISTR describing this in a KS presentation for which
> IIRC you were present. But that's neither here nor there.

Well the whole difference between you back then and SGI now, is that
your stuff wasn't being pushed to be merged very hard (it was proposed
but IIRC more as research topic, like the large PAGE_SIZE also fallen
into that same research area). See now the emails from SGI fs folks
about variable order page size, they want it merged badly instead.

My whole point is that the single moment the variable order page size
isn't pure research anymore like MPSS, the CONFIG_PAGE_SHIFT isn't
research anymore either, like the tail packing in pagecache with
kmalloc also isn't research anymore.

About the fs deciding the size of the pagecache granularity I totally
dislike that design, there's no reason why the fs should control that,
whatever clever algorithm deciding which pagecache granularity to use
should be outside fs/xfs. I like the pagecache layer to be in charge
of everything. The fs should stay a simple remapper between logical
inode offset to physical disk offset. That can take into account raid,
or other stuff, that's still a logical->raid->physical translation,
but the highelevel "brainer" intellgigence of deciding which
granularity the pagecache should use, would better be in the
pagecache/vfs layer to benefit everyone. And anyway I prefer to keep
the PAGE_SIZE big, and allocate fragments for small files with kmalloc
down to 32 bytes granularity, and memcpy them away if you mmap the
file. After the first time we move from kmalloc fragment to real
PAGE_SIZE pagecache, we add a bitflag to the inode somewhere to be
sure we never use the kmalloc fragment anymore later even if the page
is evicted from pagecache (inodes may well live longer than pagecache
so a bitflag is going to be worth it).
