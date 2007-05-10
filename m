Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXEJVJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXEJVJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXEJVI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:08:58 -0400
Received: from holomorphy.com ([66.93.40.71]:46428 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbXEJVI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:08:57 -0400
Date: Thu, 10 May 2007 14:09:35 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070510210935.GP19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:
>> This is wrong; pgd's are smaller than PAGE_SIZE on PAE. Burning lowmem
>> like this is very, very bad for such systems. pmd_cache is rather
>> trivial to convert to quicklists, since all it does is zero pages. I
>> still don't approve of even the !SHARED_KERNEL_PMD case using PAGE_SIZE
>> -sized pgd's. Xen should really be fixed to avoid requiring guests to
>> have recursive pagetables or whatever it's doing.

On Thu, May 10, 2007 at 01:35:25PM -0700, Christoph Lameter wrote:
> But the Xen guys need the full sized pgd?

Xen is not mandatory as it now stands. Also, I intend to fix up Xen
at some point so it doesn't need this.


On Thu, 10 May 2007, William Lee Irwin III wrote:
>> This comment deletion is bogus, as the locking scheme has not changed.

On Thu, May 10, 2007 at 01:35:25PM -0700, Christoph Lameter wrote:
> The interaction with SLAB has changed with the conversion to
> quicklists. AFAIK Manfred's suggestions were due to the use of the
> slab allocator to manage pgds.

The suggestion was to keep cached preconstructed pgd's on a list for
pageattr.c to traverse instead of the mmlist. The quicklist code
retains that list (in fact, even for the PAE shared kernel pmd case
where it's not necessary) despite it being a different allocator, so
manfred's suggestion remains implemented.

The alternative was 64-bit generation numbers incremented at the time
of change_page_attr(). If generation numbers were used, it would be
possible to dispose of the list altogether. Given the awkwardness of
the list maintenance for Xen, it may be worth using them now. PAE
pgd's could merely double in size to maintain those for the unshared
kernel pmd case, and remain 32B otherwise. Full PAGE_SIZE -sized pgd's
for 2-level pagetables could distribute the generation number across
page->index and page->private, or any other fields available.


-- wli
