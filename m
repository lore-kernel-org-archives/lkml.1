Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZK3LSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZK3LSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZK3LSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:18:48 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:42960 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZK3LSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:18:48 -0500
X-Trace: 299053986/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBALc4E0tPRTgw/2dsb2JhbAAI1TyEMQQ
X-IronPort-AV: E=Sophos;i="4.47,312,1257120000"; 
   d="scan'208";a="299053986"
Date: Mon, 30 Nov 2009 11:18:51 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/9] ksm: share anon page without allocating
In-Reply-To: <20091130090448.71cf6138.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911301054230.20054@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241645460.25288@sister.anvils>
 <20091130090448.71cf6138.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> Sorry for delayed response.

No, thank you very much for spending your time on it.

> 
> On Tue, 24 Nov 2009 16:48:46 +0000 (GMT)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > When ksm pages were unswappable, it made no sense to include them in
> > mem cgroup accounting; but now that they are swappable (although I see
> > no strict logical connection)
> I asked that for throwing away too complicated but wast of time things.

I'm sorry, I didn't understand that sentence at all!

> If not on LRU, its own limitation (ksm's page limit) works enough.

Yes, I think it made sense the way it was before when unswappable,
but that once they're swappable and that limitation is removed,
they do then need to participate in mem cgroup accounting.

I _think_ you're agreeing, but I'm not quite sure!

> 
> > the principle of least surprise implies
> > that they should be accounted (with the usual dissatisfaction, that a
> > shared page is accounted to only one of the cgroups using it).
> > 
> > This patch was intended to add mem cgroup accounting where necessary;
> > but turned inside out, it now avoids allocating a ksm page, instead
> > upgrading an anon page to ksm - which brings its existing mem cgroup
> > accounting with it.  Thus mem cgroups don't appear in the patch at all.
> > 
> ok. then, what I should see is patch 6.

Well, that doesn't have much in it either.  It should all be
happening naturally, from using the page that's already accounted.

> > @@ -864,15 +865,24 @@ static int try_to_merge_one_page(struct
...
> >  
> > -	if ((vma->vm_flags & VM_LOCKED) && !err) {
> > +	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
> >  		munlock_vma_page(page);
> >  		if (!PageMlocked(kpage)) {
> >  			unlock_page(page);
> > -			lru_add_drain();
> 
> Is this related to memcg ?
> 
> >  			lock_page(kpage);
> >  			mlock_vma_page(kpage);

Is the removal of lru_add_drain() related to memcg?  No, or only to
the extent that reusing the original anon page is related to memcg.

I put lru_add_drain() in there before, because (for one of the calls
to try_to_merge_one_page) the kpage had just been allocated an instant
before, with lru_cache_add_lru putting it into the per-cpu array, so
in that case mlock_vma_page(kpage) would need an lru_add_drain() to
find it on the LRU (of course, we might be preempted to a different
cpu in between, and lru_add_drain not be enough: but I think we've
all come to the conclusion that lru_add_drain_all should be avoided
unless there's a very strong reason for it).

But with this patch we're reusing the existing anon page as ksm page,
and we know that it's been in place for at least one circuit of ksmd
(ignoring coincidences like the jhash of the page happens to be 0),
so we've every reason to believe that it will already be on its LRU:
no need for lru_add_drain().

Hugh
