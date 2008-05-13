Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYEMMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYEMMOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYEMMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:14:35 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:24851 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754310AbYEMMOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:14:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k9QQ9b1mU+ztucp8bhJVe4FeRFoEy8SezX1tNLgs5WHPPnzU65h0djByycp4YjBGuRlWGdHvVuOmYBUQpnzICVdTS5yb/o8WDVvCDEj1LeYvJOc4K73hyo8mxtEiJyvSV0jjkj9tC6ZTOU8j41Xb8LF1wuOx8VeL5VFdJt5f144=  ;
X-YMail-OSG: Flc5lsoVM1nJgIsHUQxXx6Om5xQudEIhs.1FWZyLKAWV0msczQiygiH8ROQL77XfbAoDQLGZZ5RyALoOEQryhElJIpDMjdD7jy7BGj8l0teju9msxx.DzZvbqmzkNWxjF.q2Db7BH0vG7bsvIKrbBRft
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Date: Tue, 13 May 2008 22:14:24 +1000
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
References: <6b384bb988786aa78ef0.1210170958@duo.random> <20080507234521.GN8276@duo.random> <20080508013459.GS8276@duo.random>
In-Reply-To: <20080508013459.GS8276@duo.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805132214.27510.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008 11:34, Andrea Arcangeli wrote:
> Sorry for not having completely answered to this. I initially thought
> stop_machine could work when you mentioned it, but I don't think it
> can even removing xpmem block-inside-mmu-notifier-method requirements.
>
> For stop_machine to solve this (besides being slower and potentially
> not more safe as running stop_machine in a loop isn't nice), we'd need
> to prevent preemption in between invalidate_range_start/end.
>
> I think there are two ways:
>
> 1) add global lock around mm_lock to remove the sorting
>
> 2) remove invalidate_range_start/end, nuke mm_lock as consequence of
>    it, and replace all three with invalidate_pages issued inside the
>    PT lock, one invalidation for each 512 pte_t modified, so
>    serialization against get_user_pages becomes trivial but this will
>    be not ok at all for SGI as it increases a lot their invalidation
>    frequency

This is what I suggested to begin with before this crazy locking was
developed to handle these corner cases... because I wanted the locking
to match with the tried and tested Linux core mm/ locking rather than
introducing this new idea.

I don't see why you're bending over so far backwards to accommodate
this GRU thing that we don't even have numbers for and could actually
potentially be batched up in other ways (eg. using mmu_gather or
mmu_gather-like idea).

The bare essential, matches-with-Linux-mm mmu notifiers that I first
saw of yours was pretty elegant and nice. The idea that "only one
solution must go in and handle everything perfectly" is stupid because
it is quite obvious that the sleeping invalidate idea is just an order
of magnitude or two more complex than the simple atomic invalidates
needed by you. We should and could easily have had that code upstream
long ago :(

I'm not saying we ignore the sleeping or batching cases, but we should
introduce the ideas slowly and carefully and assess the pros and cons
of each step along the way.



>
> For KVM both ways are almost the same.
>
> I'll implement 1 now then we'll see...
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
