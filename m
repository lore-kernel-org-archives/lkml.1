Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYEIJEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYEIJEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYEIJEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:04:45 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:5360 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752756AbYEIJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:04:43 -0400
Date: Fri, 9 May 2008 18:03:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080509090306.GA4221@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Hans Rosenfeld <hans.rosenfeld@amd.com>,
	Hugh Dickins <hugh@veritas.com>,
	Nishanth Aravamudan <nacc@us.ibm.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Gabriel C <nix.or.die@googlemail.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net> <20080508151145.GG12654@escobedo.amd.com> <1210261882.7905.49.camel@nimitz.home.sr71.net> <20080508200239.GJ12654@escobedo.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508200239.GJ12654@escobedo.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 10:02:39PM +0200, Hans Rosenfeld wrote:
> On Thu, May 08, 2008 at 07:48:51PM +0100, Hugh Dickins wrote:
> > > Dunno, seems quite clear that the bug is in pagemap_read(), not any
> > > hugepage code, and that the simplest fix is to make pagemap_read() do
> > > what the other walker-callers do, and skip hugepage regions.
> > 
> > Yes, I'm afraid it needs an is_vm_hugetlb_page(vma) in there somehow:
> > as you observe, that's what everything else uses to avoid huge issues.
> > 
> > A pmd_huge(*pmd) test is tempting, but it only ever says "yes" on x86:
> > we've carefully left it undefined what happens to the pgd/pud/pmd/pte
> > hierarchy in the general arch case, once you're amongst hugepages.
> 
> AFAIK the reason for this is that pmd_huge() and pud_huge() are
> completely x86-specific. When I looked at the huge page support for
> other archs in Linux the last time, all of them marked hugepages with
> some page size bits in the PTE, using several PTEs for a single huge
> page. So for anything but x86, the pgd/pud/pmd/pte hierarchy should work
> for hugepages, too.
> 
s390 also does hugepages at the pmd level, so it's not only x86. And
while it's not an issue today, it's worth noting that ARM also has the
same characteristics for larger sizes. Should someone feel compelled to
implement hugepages there, this will almost certainly come up again -- at
least in so far as pmd_huge() is concerned.

At a quick glance, sparc64 also looks like it might need some special
handling in the pagemap case, too..
