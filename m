Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZHXVrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZHXVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZHXVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:47:20 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:11485 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbZHXVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:47:20 -0400
X-Trace: 248066021/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.101.200/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.101.200
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAHSnkkpPRWXI/2dsb2JhbACBU9VohBoF
X-IronPort-AV: E=Sophos;i="4.44,267,1249254000"; 
   d="scan'208";a="248066021"
Date: Mon, 24 Aug 2009 22:46:44 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
In-Reply-To: <4A930313.9070404@vflare.org>
Message-ID: <Pine.LNX.4.64.0908242224530.10534@sister.anvils>
References: <200908241007.47910.ngupta@vflare.org>
 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
 <4A92EBB4.1070101@vflare.org> <Pine.LNX.4.64.0908242132320.8144@sister.anvils>
 <4A930313.9070404@vflare.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Nitin Gupta wrote:
> On 08/25/2009 02:09 AM, Hugh Dickins wrote:
> > On Tue, 25 Aug 2009, Nitin Gupta wrote:
> > > On 08/24/2009 11:03 PM, Pekka Enberg wrote:
> > > >
> > > > What's the purpose of passing PFNs around? There's quite a lot of PFN
> > > > to struct page conversion going on because of it. Wouldn't it make
> > > > more sense to return (and pass) a pointer to struct page instead?
> > >
> > > PFNs are 32-bit on all archs
> >
> > Are you sure?  If it happens to be so for all machines built today,
> > I think it can easily change tomorrow.  We consistently use unsigned long
> > for pfn (there, now I've said that, I bet you'll find somewhere we don't!)
> >
> > x86_64 says MAX_PHYSMEM_BITS 46 and ia64 says MAX_PHYSMEM_BITS 50 and
> > mm/sparse.c says
> > unsigned long max_sparsemem_pfn = 1UL<<  (MAX_PHYSMEM_BITS-PAGE_SHIFT);
> >
> 
> For PFN to exceed 32-bit we need to have physical memory > 16TB (2^32 * 4KB).
> So, maybe I can simply add a check in ramzswap module load to make sure that
> RAM is indeed < 16TB and then safely use 32-bit for PFN?

Others know much more about it, but I believe that with sparsemem you
may be handling vast holes in physical memory: so a relatively small
amount of physical memory might in part be mapped with gigantic pfns.

So if you go that route, I think you'd rather have to refuse pages
with oversized pfns (or refuse configurations with any oversized pfns),
than base it upon the quantity of physical memory in the machine.

Seems ugly to me, as it did to Pekka; but I can understand that you're
very much in the business of saving memory, so doubling the size of some
of your tables (I may be oversimplifying) would be repugnant to you.

You could add a CONFIG option, rather like CONFIG_LBDAF, to switch on
u64-sized pfns; but you'd still have to handle what happens when the
pfn is too big to fit in u32 without that option; and if distros always
switch the option on, to accomodate the larger machines, then there may
have been no point to adding it.

I'm undecided.

Hugh
