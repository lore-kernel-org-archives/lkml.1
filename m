Return-Path: <linux-kernel-owner+w=401wt.eu-S1762559AbXEPQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559AbXEPQhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEPQhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:37:06 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48187 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXEPQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:37:04 -0400
Date: Wed, 16 May 2007 17:36:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
In-Reply-To: <464A533B.8040507@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com>
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
 <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
 <20070515144007.f87d9be5.akpm@linux-foundation.org> <464A533B.8040507@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 May 2007 16:36:59.0029 (UTC) FILETIME=[6C5FB450:01C797D8]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBkaG93ZWxsc0ByZWRoYXQuY29tAG5pY2twaWdnaW5AeWFob28uY29tLmF1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Nick Piggin wrote:
> Andrew Morton wrote:
> > I need to work out what to do with
> > 
> > mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> > mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> > mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
> > mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
> > mm-merge-nopfn-into-fault.patch
> > convert-hugetlbfs-to-use-vm_ops-fault.patch
> > mm-remove-legacy-cruft.patch
> > mm-debug-check-for-the-fault-vs-invalidate-race.patch
> > mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
> > 
> > Probably merge them, I guess.  Hugh had concerns, I think over small
> > additional overhead from the lock_page()?

That's right, the overhead of the lock_page()/unlock_page() in the common
path of faulting, and of the extra call to unmap_mapping_range() when
truncating (because page lock doesn't satisfactorily replace the old
sequence count when COWing).

> Yes he did. It seems to only be noticable in microbenchmarks.

So far, yes.  I expect it'll surface in some reallife workload
sometime, but let's not get too depressed about that.  I guess
your blithe "Scalability is not an issue" comment still irks me.

> In my opinion not enough to withhold pagecache corruption bug fixes.

It is a pity to be adding overhead to a common path in order to fix
such very rare cases, but yes, we probably have to live with that.

> Still, I have some lock_page speedup work that eliminates that regression
> anyway.

Again, rather too blithely said.  You have a deep well of ingenuity,
but I doubt it can actually wash away all of the small overhead added.

> However, Hugh hasn't exactly said yes or no yet...

Getting a "yes" or "no" out of me is very hard work indeed.
But I didn't realize that was gating this work: if the world
had to wait on me, we'd be in trouble.

I think there are quite a few people eager to see the subsequent
->fault changes go in.  And I think I'd just like to minimize the
difference between -mm and mainline, so maximize comprehensibilty,
by getting this all in.  I've not heard of any correctness issues
with it, and we all agree that the page lock there is attractively
simple.

If I ever find a better way of handling it,
I'm free to send patches in future, after all.

Did that sound something like a "yes"?

Hugh
