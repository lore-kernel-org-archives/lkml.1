Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZBSM5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZBSM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZBSM5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:57:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:49041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZBSM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:57:41 -0500
Date: Thu, 19 Feb 2009 13:57:36 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: krh@bitplanet.net, eric@anholt.net, Wang Chen <wangchen@cn.fujitsu.com>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order violations.
Message-ID: <20090219125736.GC1747@wotan.suse.de>
References: <499BC08C.5000603@cn.fujitsu.com> <1234975113-4941-1-git-send-email-krh@bitplanet.net> <1235035145.4612.38.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235035145.4612.38.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 10:19:05AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-02-18 at 11:38 -0500, krh@bitplanet.net wrote:
> > From: Kristian Høgsberg <krh@redhat.com>
> > 
> > A number of GEM operations (and legacy drm ones) want to copy data to
> > or from userspace while holding the struct_mutex lock.  However, the
> > fault handler calls us with the mmap_sem held and thus enforces the
> > opposite locking order.  This patch downs the mmap_sem up front for
> > those operations that access userspace data under the struct_mutex
> > lock to ensure the locking order is consistent.
> > 
> > Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> > ---
> > 
> > Here's a different and simpler attempt to fix the locking order
> > problem.  We can just down_read() the mmap_sem pre-emptively up-front,
> > and the locking order is respected.  It's simpler than the
> > mutex_trylock() game, avoids introducing a new mutex.

The "simple" way to fix this is to just allocate a temporary buffer
to copy a snapshot of the data going to/from userspace. Then do the
real usercopy to/from that buffer outside the locks.

You don't have any performance critical bulk copies (ie. that will
blow the L1 cache), do you? 

