Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZKBXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZKBXpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZKBXpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:45:45 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:36830 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbZKBXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:45:44 -0500
X-Trace: 279609710/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.71.196/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.71.196
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAID+7kpPRUfE/2dsb2JhbACBUNpahD0E
X-IronPort-AV: E=Sophos;i="4.44,670,1249254000"; 
   d="scan'208";a="279609710"
Date: Mon, 2 Nov 2009 23:45:44 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: Filtering bits in set_pte_at()
In-Reply-To: <1257200367.7907.50.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0911022342070.30581@sister.anvils>
References: <1256957081.6372.344.camel@pasglop>  <Pine.LNX.4.64.0911021256330.32400@sister.anvils>
 <1257200367.7907.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-11-02 at 13:27 +0000, Hugh Dickins wrote:
> 
> > You're being a very good citizen to want to bring this so forcefully
> > to the attention of any user of set_pte_at(); but given how few care,
> > and the other such functions you'd want to change too, am I being
> > disgracefully lazy to suggest that you simply change the occasional
> > 
> > 		update_mmu_cache(vma, address, pte);
> > to
> > 		/* powerpc's set_pte_at might have adjusted the pte */
> > 		update_mmu_cache(vma, address, *ptep);
> > 
> > ?  Which would make no difference to those architectures whose
> > update_mmu_cache() is an empty macro.  And fix the mm/hugetlb.c
> > instance in a similar way?
> 
> That would do fine. In fact, I've always been slightly annoyed by
> set_pte_at() not taking the PTE pointer for other reasons such as on
> 64-K pages, we have a "hidden" part of the PTE that is at PTE address +
> 32K, or we may want to get to the PTE page for some reason (some arch
> store things there) etc...
> 
> IE. update_mmu_cache() would be more generally useful if it took the
> ptep instead of the pte. Of course, I'm sure some embedded archs are
> going to cry for the added load here ... 
> 
> I like your idea. I'll look into doing a patch converting it and will
> post it here.

Well, I wasn't proposing

		update_mmu_cache(vma, address, ptep);
but
		update_mmu_cache(vma, address, *ptep);

which may not meet your future idea, but is much less churn for now
i.e. no change to any of the arch's update_mmu_cache(),
just a change to some of its callsites.

Hugh
