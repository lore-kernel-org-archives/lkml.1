Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYDBXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYDBXHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYDBXHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:07:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42460 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755720AbYDBXHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:07:18 -0400
Date: Wed, 2 Apr 2008 16:04:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
In-Reply-To: <20080402220936.GW19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021551500.32273@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <20080402215334.GT19189@duo.random> <Pine.LNX.4.64.0804021453350.31247@schroedinger.engr.sgi.com>
 <20080402220936.GW19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Andrea Arcangeli wrote:

> I said try_to_unmap_cluster, not get_user_pages.
> 
>   CPU0					CPU1
>   try_to_unmap_cluster:
>   emm_invalidate_start in EMM (or mmu_notifier_invalidate_range_start in #v10)
>   walking the list by hand in EMM (or with hlist cleaner in #v10)
>   xpmem method invoked
>   schedule for a long while inside invalidate_range_start while skbs are sent
> 					gru registers
> 					synchronize_rcu (sorry useless now)

All of this would be much easier if you could stop the drivel. The sync 
rcu was for an earlier release of the mmu notifier. Why the sniping?

> 					single threaded, so taking a page fault
>   					secondary tlb instantiated

The driver must not allow faults to occur between start and end. The 
trouble here is that GRU and xpmem are mixed. If CPU0 would have been 
running GRU instead of XPMEM then the fault would not have occurred 
because the gru would have noticed that a range op is active. If both
systems would have run xpmem then the same would have worked.
 
I guess this means that an address space cannot reliably registered to 
multiple subsystems if some of those do not take a refcount. If all 
drivers would be required to take a refcount then this would also not 
occur.

> In general my #v10 solution mixing seqlock + rcu looks more robust and
> allows multithreaded attachment of mmu notifers as well. I could have

Well its easy to say that if no one else has looked at it yet. I expressed 
some concerns in reply to your post of #v10.

