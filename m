Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbYEHTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbYEHTwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYEHTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:52:33 -0400
Received: from waste.org ([66.93.16.53]:54225 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYEHTwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:52:30 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
       Hans Rosenfeld <hans.rosenfeld@amd.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0805081914210.16611@blonde.site>
References: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
	 <20080506202201.GB12654@escobedo.amd.com>
	 <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
	 <1210258350.7905.45.camel@nimitz.home.sr71.net>
	 <20080508151145.GG12654@escobedo.amd.com>
	 <1210261882.7905.49.camel@nimitz.home.sr71.net>
	 <20080508161925.GH12654@escobedo.amd.com>
	 <20080508163352.GN23990@us.ibm.com>
	 <20080508165111.GI12654@escobedo.amd.com>
	 <20080508171657.GO23990@us.ibm.com>
	 <Pine.LNX.4.64.0805081914210.16611@blonde.site>
Content-Type: text/plain
Date: Thu, 08 May 2008 14:49:13 -0500
Message-Id: <1210276153.7018.90.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 19:48 +0100, Hugh Dickins wrote:
> On Thu, 8 May 2008, Nishanth Aravamudan wrote:
> > 
> > So, is there any way to either add a is_vm_hugetlb_page(vma) check into
> > pagemap_read()? Or can we modify walk_page_range to take the a vma and
> > skip the walking if is_vm_hugetlb_page(vma) is set [to avoid
> > complications down the road until hugepage walking is fixed]. I guess
> > the latter isn't possible for pagemap_read(), since we are just looking
> > at arbitrary addresses in the process space?
> > 
> > Dunno, seems quite clear that the bug is in pagemap_read(), not any
> > hugepage code, and that the simplest fix is to make pagemap_read() do
> > what the other walker-callers do, and skip hugepage regions.
> 
> Yes, I'm afraid it needs an is_vm_hugetlb_page(vma) in there somehow:
> as you observe, that's what everything else uses to avoid huge issues.
>
> A pmd_huge(*pmd) test is tempting, but it only ever says "yes" on x86:
> we've carefully left it undefined what happens to the pgd/pud/pmd/pte
> hierarchy in the general arch case, once you're amongst hugepages.
> 
> Might follow_huge_addr() be helpful, to avoid the need for a vma?
> Perhaps, but my reading is that actually we've never really been
> testing that path's success case (because get_user_pages already
> skipped is_vm_hugetlb_page), so it might hold further surprises
> on one architecture or another.
> 
> Many thanks to Hans for persisting, and pointing us to pagemap
> to explain this hugepage leak: yes, the pmd_none_or_clear_bad
> will be losing it - and corrupting target user address space.

Ouch.

> Cc'ed Matt: he may have a view on what he wants his pagewalker
> to do with hugepages: I fear it would differ from one usage to
> another.  Skip over them has to be safest, though not ideal.

There are folks who want to be able to get information about hugepages
from pagemap. Thanks to Hans, there's room in the output format for it.

I'd gone to some lengths to pull VMAs out of the picture as it's quite
ugly to have to simultaneously walk VMAs and pagetables. But I may have
to concede that living with hugepages requires it.

-- 
Mathematics is the supreme nostalgia of our time.

