Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXA2R0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXA2R0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXA2R0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:26:51 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:25263 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbXA2R0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:26:50 -0500
X-AuditID: d80ac287-a257fbb000007e48-32-45be3082230e 
Date: Mon, 29 Jan 2007 17:26:56 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ken Chen <kenchen@google.com>
cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       William Irwin <wli@holomorphy.com>,
       David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't allow the stack to grow into hugetlb reserved
 regions
In-Reply-To: <b040c32a0701281227r11fe02eblba07df7aa7400787@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701291703530.31023@blonde.wat.veritas.com>
References: <20070125214052.22841.33449.stgit@localhost.localdomain> 
 <Pine.LNX.4.64.0701262025590.22196@blonde.wat.veritas.com> 
 <b040c32a0701261448k122f5cc7q5368b3b16ee1dc1f@mail.gmail.com> 
 <Pine.LNX.4.64.0701270904360.15686@blonde.wat.veritas.com>
 <b040c32a0701281227r11fe02eblba07df7aa7400787@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 29 Jan 2007 17:26:48.0833 (UTC) FILETIME=[A83C5710:01C743CA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007, Ken Chen wrote:
> 
> For ia64, the hugetlb address region is reserved at the top of user
> space address.  Stacks are below that region.  Throw in the mix, we
> have two stacks, one memory stack that grows down and one register
> stack backing store that grows up.  These two stacks are always in
> pair and grow towards each other. And lastly, we have virtual address
> holes in between regions.  It's just impossible to grow any of these
> two stacks into hugetlb region no matter how I played it.
> 
> So, AFAICS this bug doesn't apply to ia64 (and certainly not x86). The
> new check of is_hugepage_only_range() is really a noop for both arches.

Certainly not a problem on x86.

But, never mind hugetlb, you still not quite convinced me that there's
no problem at all with get_user_pages find_extend_vma growing on ia64.

I repeat that ia64_do_page_fault has REGION tests to guard against
expanding either kind of stack across into another region.  ia64_brk,
ia64_mmap_check and arch_get_unmapped_area have RGN_MAP_LIMIT checks.
But where is the equivalent paranoia when ptrace calls get_user_pages
calls find_extend_vma?

If your usual stacks face each other across the same region, they're
not going to pose problem.  But what if someone mmaps MAP_GROWSDOWN
near the base of a region, then uses ptrace to touch an address near
the top of the region below?

Hugh
