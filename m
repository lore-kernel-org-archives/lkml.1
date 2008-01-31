Return-Path: <linux-kernel-owner+w=401wt.eu-S933713AbYAaM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbYAaM6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbYAaM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:58:20 -0500
Received: from mx1.suse.de ([195.135.220.2]:56845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbYAaM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:58:19 -0500
Date: Thu, 31 Jan 2008 13:58:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: fix PageUptodate data race
Message-ID: <20080131125817.GD10469@wotan.suse.de>
References: <20080122040114.GA18450@wotan.suse.de> <20080126220356.0b77f0e9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220356.0b77f0e9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, way behind on email here. I'll get through it slowly...

On Sat, Jan 26, 2008 at 10:03:56PM -0800, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 05:01:14 +0100 Nick Piggin <npiggin@suse.de> wrote:
> > 
> > After running SetPageUptodate, preceeding stores to the page contents to
> > actually bring it uptodate may not be ordered with the store to set the page
> > uptodate.
> > 
> > Therefore, another CPU which checks PageUptodate is true, then reads the
> > page contents can get stale data.
> > 
> > Fix this by having an smp_wmb before SetPageUptodate, and smp_rmb after
> > PageUptodate.
> > 
> > Many places that test PageUptodate, do so with the page locked, and this
> > would be enough to ensure memory ordering in those places if SetPageUptodate
> > were only called while the page is locked. Unfortunately that is not always
> > the case for some filesystems, but it could be an idea for the future.
> > 
> > Also bring the handling of anonymous page uptodateness in line with that of
> > file backed page management, by marking anon pages as uptodate when they _are_
> > uptodate, rather than when our implementation requires that they be marked as
> > such. Doing allows us to get rid of the smp_wmb's in the page copying
> > functions, which were especially added for anonymous pages for an analogous
> > memory ordering problem. Both file and anonymous pages are handled with the
> > same barriers.
> > 
> 
> So...  it's two patches in one.

I guess so. Hmm, at least I appreciate it (them) getting testing in -mm
for now. I guess I should break it in two, do you agree Hugh? Do you
like/dislike the anonymous page change?


> What kernel is this against?  Looks like mainline.  Is it complete and
> correct when applied against the large number of pending MM changes?

Uh, I forget. But luckily this one should be quite correct reglardless
of pending mm changes... unless something there has fundamentally changed
the semantics or locking of PG_uptodate... which wouldn't be too surprising
actually ;)

No, it should be OK. I'll double check when I look at resubmitting it as
2 patches.
