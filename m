Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbXEJXOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbXEJXOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXEJXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:14:37 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33654 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEJXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:14:36 -0400
Date: Fri, 11 May 2007 00:14:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070510203102.GO19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510203102.GO19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 10 May 2007 23:14:35.0586 (UTC) FILETIME=[F982EA20:01C79358]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGFrQHN1c2UuZGUAbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGNsYW1ldGVyQHNnaS5jb20Ad2xpQGhvbG9tb3JwaHkuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:
> On Thu, May 10, 2007 at 09:03:39PM +0100, Hugh Dickins wrote:
> > Though when I look at the patchset (copied below), I do wonder why
> > it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
> > neither is where I'd expect us to be secretly freeing pages.  Ah,
> > several arches do it in cpu_idle(): how odd, oh well.
> 
> So now quicklist semantics vs. TLB flushing are the motive behind the
> odd flush_tlb_mm() affair. The real trick with it is that flushing
> must never occur until the TLB flush. Any change to the core quicklist
> code that retires pages back to the page allocator earlier (e.g. based
> on some limit) will break things badly.

I don't think that's right.  It's vital that TLB (of an active mm)
be flushed before freeing its page back to the quicklist, before it's
recycled to another mm (or elsewhere in this mm); but having done that,
it really doesn't matter much when quicklist_trim() (check_pgt_cache)
is called to free surplus pages from quicklist back to page_alloc.c.

tlb_finish_mmu() happens to be the traditional place it's done, and
that's where we expect it.  flush_tlb_mm() avoids flushing TLB unless
it's actually required for the mm in question: so wouldn't be a good
place to rely on flushing TLB for pages freed earlier from other mms
(but we'd already be in trouble to be leaving them that late).

I'm guessing (haven't rechecked source) that the cpu_idle() call comes
about because the top level pgd of a process gets freed very late in
its exit, and after a great flurry of processes have just exited,
perhaps there was nothing to free up the accumulation.  Though
it still strikes me as an odd place to do it.

Hugh
