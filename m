Return-Path: <linux-kernel-owner+w=401wt.eu-S2993096AbXEBMp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993096AbXEBMp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993097AbXEBMp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:45:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:64285 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993096AbXEBMp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:45:58 -0400
Date: Wed, 2 May 2007 13:45:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 12:45:57.0039 (UTC) FILETIME=[D43363F0:01C78CB7]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Christoph Lameter wrote:
> On Tue, 1 May 2007, Hugh Dickins wrote:
> 
> > Yes, to me it does.  If it could be defaulted to on throughout the
> > -rcs, on every architecture, then I'd say that's "finishing work";
> > and we'd be safe knowing we could go back to slab in a hurry if
> > needed.  But it hasn't reached that stage yet, I think.
> 
> Why would we need to go back to SLAB if we have not switched to SLUB? SLUB 
> is marked experimental and not the default.

I said above that I thought SLUB ought to be defaulted to on throughout
the -rcs: if we don't do that, we're not going to learn much from having
it in Linus' tree.

And perhaps that line which appends "PREEMPT " to an oops report ought
to append "SLUB " too, for so long as there's a choice.

> The only problems that I am aware of is(or was) the issue with arches 
> modifying page struct fields of slab pages that SLUB needs for its own 
> operations. And I thought it was all fixed since the powerpc guys were 
> quiet and the patch was in for i386.

You're forgetting your unions in struct page: in the SPLIT_PTLOCK
case (NR_CPUS >= 4) the pagetable code is using spinlock_t ptl,
which overlays SLUB's first_page and slab pointers.

I just tried rebuilding powerpc with the SPLIT_PTLOCK cutover
edited to 8 cpus instead, and then no crash.

I presume the answer is just to extend your quicklist work to
powerpc's lowest level of pagetables.  The only other architecture
which is using kmem_cache for them is arm26, which has
"#error SMP is not supported", so won't be giving this problem.

Hugh
