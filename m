Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZKBTCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZKBTCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZKBTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:02:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbZKBTCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:02:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Date: Mon, 2 Nov 2009 20:03:52 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <200911012238.13083.rjw@sisk.pl> <20091103002506.8869.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091103002506.8869.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911022003.52125.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, KOSAKI Motohiro wrote:
> > > Then, This patch changed shrink_all_memory() to only the wrapper function of 
> > > do_try_to_free_pages(). it bring good reviewability and debuggability, and solve 
> > > above problems.
> > > 
> > > side note: Reclaim logic unificication makes two good side effect.
> > >  - Fix recursive reclaim bug on shrink_all_memory().
> > >    it did forgot to use PF_MEMALLOC. it mean the system be able to stuck into deadlock.
> > >  - Now, shrink_all_memory() got lockdep awareness. it bring good debuggability.
> > 
> > As I said previously, I don't really see a reason to keep shrink_all_memory().
> > 
> > Do you think that removing it will result in performance degradation?
> 
> Hmm...
> Probably, I misunderstood your mention. I thought you suggested to kill
> all hibernation specific reclaim code. I did. It's no performance degression.
> (At least, I didn't observe)
> 
> But, if you hope to kill shrink_all_memory() function itsef, the short answer is,
> it's impossible.
> 
> Current VM reclaim code need some preparetion to caller, and there are existing in
> both alloc_pages_slowpath() and try_to_free_pages(). We can't omit its preparation.

Well, my grepping for 'shrink_all_memory' throughout the entire kernel source
code seems to indicate that hibernate_preallocate_memory() is the only current
user of it.  I may be wrong, but I doubt it, unless some new users have been
added since 2.6.31.

In case I'm not wrong, it should be safe to drop it from
hibernate_preallocate_memory(), because it's there for performance reasons
only.  Now, since hibernate_preallocate_memory() appears to be the only user of
it, it should be safe to drop it entirely.

> Please see following shrink_all_memory() code. it's pretty small. it only have
> few vmscan preparation. I don't think it is hard to maintainance.

No, it's not, but I'm really not sure it's worth keeping.

Thanks,
Rafael


> =====================================================
> unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
> {
>         struct reclaim_state reclaim_state;
>         struct scan_control sc = {
>                 .gfp_mask = GFP_HIGHUSER_MOVABLE,
>                 .may_swap = 1,
>                 .may_unmap = 1,
>                 .may_writepage = 1,
>                 .nr_to_reclaim = nr_to_reclaim,
>                 .hibernation_mode = 1,
>                 .swappiness = vm_swappiness,
>                 .order = 0,
>                 .isolate_pages = isolate_pages_global,
>         };
>         struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
>         struct task_struct *p = current;
>         unsigned long nr_reclaimed;
> 
>         p->flags |= PF_MEMALLOC;
>         lockdep_set_current_reclaim_state(sc.gfp_mask);
>         reclaim_state.reclaimed_slab = 0;
>         p->reclaim_state = &reclaim_state;
> 
>         nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
> 
>         p->reclaim_state = NULL;
>         lockdep_clear_current_reclaim_state();
>         p->flags &= ~PF_MEMALLOC;
> 
>         return nr_reclaimed;
> }
