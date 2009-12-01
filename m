Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZLAAE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZLAAE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZLAAE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:04:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44848 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZLAAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:04:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Dec 2009 09:02:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/9] ksm: share anon page without allocating
Message-Id: <20091201090201.7acb3d90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0911301054230.20054@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
	<Pine.LNX.4.64.0911241645460.25288@sister.anvils>
	<20091130090448.71cf6138.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0911301054230.20054@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 11:18:51 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Mon, 30 Nov 2009, KAMEZAWA Hiroyuki wrote:
> > 
> > Sorry for delayed response.
> 
> No, thank you very much for spending your time on it.
> 
> > 
> > On Tue, 24 Nov 2009 16:48:46 +0000 (GMT)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > > When ksm pages were unswappable, it made no sense to include them in
> > > mem cgroup accounting; but now that they are swappable (although I see
> > > no strict logical connection)
> > I asked that for throwing away too complicated but wast of time things.
> 
> I'm sorry, I didn't understand that sentence at all!
> 
Sorry. At implementation of ksm. I don't want to consinder how to account it
because there was problems around swap accounting. So, I asked to
limit usage by itself.

> > If not on LRU, its own limitation (ksm's page limit) works enough.
> 
> Yes, I think it made sense the way it was before when unswappable,
> but that once they're swappable and that limitation is removed,
> they do then need to participate in mem cgroup accounting.
> 
> I _think_ you're agreeing, but I'm not quite sure!
> 
I agree. No objections.


> > > @@ -864,15 +865,24 @@ static int try_to_merge_one_page(struct
> ...
> > >  
> > > -	if ((vma->vm_flags & VM_LOCKED) && !err) {
> > > +	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
> > >  		munlock_vma_page(page);
> > >  		if (!PageMlocked(kpage)) {
> > >  			unlock_page(page);
> > > -			lru_add_drain();
> > 
> > Is this related to memcg ?
> > 
> > >  			lock_page(kpage);
> > >  			mlock_vma_page(kpage);
> 
> Is the removal of lru_add_drain() related to memcg?  No, or only to
> the extent that reusing the original anon page is related to memcg.
> 
> I put lru_add_drain() in there before, because (for one of the calls
> to try_to_merge_one_page) the kpage had just been allocated an instant
> before, with lru_cache_add_lru putting it into the per-cpu array, so
> in that case mlock_vma_page(kpage) would need an lru_add_drain() to
> find it on the LRU (of course, we might be preempted to a different
> cpu in between, and lru_add_drain not be enough: but I think we've
> all come to the conclusion that lru_add_drain_all should be avoided
> unless there's a very strong reason for it).
> 
> But with this patch we're reusing the existing anon page as ksm page,
> and we know that it's been in place for at least one circuit of ksmd
> (ignoring coincidences like the jhash of the page happens to be 0),
> so we've every reason to believe that it will already be on its LRU:
> no need for lru_add_drain().
> 

Thank you for clarification.

Regards,
-Kame

