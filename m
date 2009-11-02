Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZKBPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZKBPgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZKBPgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:36:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38406 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZKBPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:36:15 -0500
Date: Tue, 3 Nov 2009 00:35:30 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200911012238.13083.rjw@sisk.pl>
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <200911012238.13083.rjw@sisk.pl>
Message-Id: <20091103002506.8869.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Then, This patch changed shrink_all_memory() to only the wrapper function of 
> > do_try_to_free_pages(). it bring good reviewability and debuggability, and solve 
> > above problems.
> > 
> > side note: Reclaim logic unificication makes two good side effect.
> >  - Fix recursive reclaim bug on shrink_all_memory().
> >    it did forgot to use PF_MEMALLOC. it mean the system be able to stuck into deadlock.
> >  - Now, shrink_all_memory() got lockdep awareness. it bring good debuggability.
> 
> As I said previously, I don't really see a reason to keep shrink_all_memory().
> 
> Do you think that removing it will result in performance degradation?

Hmm...
Probably, I misunderstood your mention. I thought you suggested to kill
all hibernation specific reclaim code. I did. It's no performance degression.
(At least, I didn't observe)

But, if you hope to kill shrink_all_memory() function itsef, the short answer is,
it's impossible.

Current VM reclaim code need some preparetion to caller, and there are existing in
both alloc_pages_slowpath() and try_to_free_pages(). We can't omit its preparation.

Please see following shrink_all_memory() code. it's pretty small. it only have
few vmscan preparation. I don't think it is hard to maintainance.


=====================================================
unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
{
        struct reclaim_state reclaim_state;
        struct scan_control sc = {
                .gfp_mask = GFP_HIGHUSER_MOVABLE,
                .may_swap = 1,
                .may_unmap = 1,
                .may_writepage = 1,
                .nr_to_reclaim = nr_to_reclaim,
                .hibernation_mode = 1,
                .swappiness = vm_swappiness,
                .order = 0,
                .isolate_pages = isolate_pages_global,
        };
        struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
        struct task_struct *p = current;
        unsigned long nr_reclaimed;

        p->flags |= PF_MEMALLOC;
        lockdep_set_current_reclaim_state(sc.gfp_mask);
        reclaim_state.reclaimed_slab = 0;
        p->reclaim_state = &reclaim_state;

        nr_reclaimed = do_try_to_free_pages(zonelist, &sc);

        p->reclaim_state = NULL;
        lockdep_clear_current_reclaim_state();
        p->flags &= ~PF_MEMALLOC;

        return nr_reclaimed;
}


