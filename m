Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYHGMlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYHGMlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHGMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:41:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10695 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYHGMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:41:39 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <Pine.LNX.4.64.0808071257200.4594@blonde.site>
References: <20080804130317.994042639@chello.nl>
	 <1218108349.8625.25.camel@twins>
	 <Pine.LNX.4.64.0808071257200.4594@blonde.site>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 14:41:21 +0200
Message-Id: <1218112881.8625.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 13:14 +0100, Hugh Dickins wrote:
> On Thu, 7 Aug 2008, Peter Zijlstra wrote:
> > 
> > Which the locking hierarchy in mm/rmap.c confirms as 'valid'.
> > 
> > Although I don't think there are any users of these two locks that don't
> > hold the mmap_sem, therefore the nesting is strictly ok, but since we
> > already have an established order, we might as well respect it.
> 
> Yes, I agree.
> 
> > Fix this by first taking all the mapping->i_mmap_lock instances and then
> > take all anon_vma->lock instances.
> 
> Okay.  I'd have preferred taking anon_vma lock after i_mmap_lock
> each time around the loop, but imagine that's just as problematic
> for lockdep as the original.

I'm a little confused as to what you mean here, are you suggesting:

  for_each_vma() {
    if (file)
      vm_lock_mapping();
    if (anon)
      vm_lock_anon();
  }

?

That can still create the inverse lock order due to each vma being only
of a single type, and therefore the lock order is set by the vma order,
which can be anything.


