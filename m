Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYHGN22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYHGN22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYHGN2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:28:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49891 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYHGN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:28:19 -0400
Date: Thu, 7 Aug 2008 14:27:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
In-Reply-To: <1218112881.8625.33.camel@twins>
Message-ID: <Pine.LNX.4.64.0808071422120.21264@blonde.site>
References: <20080804130317.994042639@chello.nl>  <1218108349.8625.25.camel@twins>
  <Pine.LNX.4.64.0808071257200.4594@blonde.site> <1218112881.8625.33.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Peter Zijlstra wrote:
> On Thu, 2008-08-07 at 13:14 +0100, Hugh Dickins wrote:
> > On Thu, 7 Aug 2008, Peter Zijlstra wrote:
> > > 
> > > Which the locking hierarchy in mm/rmap.c confirms as 'valid'.
> > > 
> > > Although I don't think there are any users of these two locks that don't
> > > hold the mmap_sem, therefore the nesting is strictly ok, but since we
> > > already have an established order, we might as well respect it.
> > 
> > Yes, I agree.
> > 
> > > Fix this by first taking all the mapping->i_mmap_lock instances and then
> > > take all anon_vma->lock instances.
> > 
> > Okay.  I'd have preferred taking anon_vma lock after i_mmap_lock
> > each time around the loop, but imagine that's just as problematic
> > for lockdep as the original.
> 
> I'm a little confused as to what you mean here, are you suggesting:
> 
>   for_each_vma() {
>     if (file)
>       vm_lock_mapping();
>     if (anon)
>       vm_lock_anon();
>   }
> 
> ?

Yes, I would have preferred that.

> 
> That can still create the inverse lock order due to each vma being only
> of a single type, and therefore the lock order is set by the vma order,
> which can be anything.

Yes, I imagined it would be just as problematic for lockep.

Hugh
