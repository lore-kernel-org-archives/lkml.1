Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXEPRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXEPRVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbXEPRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:21:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:10288 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbXEPRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:21:32 -0400
Date: Wed, 16 May 2007 18:21:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
In-Reply-To: <20070513033210.GA3667@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705161737140.7914@blonde.wat.veritas.com>
References: <20070508113709.GA19294@wotan.suse.de> <20070508114003.GB19294@wotan.suse.de>
 <1178659827.14928.85.camel@localhost.localdomain> <20070508224124.GD20174@wotan.suse.de>
 <20070508225012.GF20174@wotan.suse.de> <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
 <20070510033736.GA19196@wotan.suse.de> <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com>
 <20070511085424.GA15352@wotan.suse.de> <Pine.LNX.4.64.0705111357120.3350@blonde.wat.veritas.com>
 <20070513033210.GA3667@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 May 2007 17:21:30.0935 (UTC) FILETIME=[A4F43470:01C797DE]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AG5waWdnaW5Ac3VzZS5kZQBsaW51eC1hcmNoQHZnZXIua2VybmVsLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAYmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Nick Piggin wrote:
> On Fri, May 11, 2007 at 02:15:03PM +0100, Hugh Dickins wrote:
> 
> > But again I wonder just what the gain has been, once your double
> > unmap_mapping_range is factored in.  When I suggested before that
> > perhaps the double (well, treble including the one in truncate.c)
> > unmap_mapping_range might solve the problem you set out to solve
> > (I've lost sight of that!) without pagelock when faulting, you said:
> > 
> > > Well aside from being terribly ugly, it means we can still drop
> > > the dirty bit where we'd otherwise rather not, so I don't think
> > > we can do that.
> > 
> > but that didn't give me enough information to agree or disagree.
> 
> Oh, well invalidate wants to be able to skip dirty pages or have the
> filesystem do something special with them first. Once you have taken
> the page out of the pagecache but still mapped shared, then blowing
> it away doesn't actually solve the data loss problem... only makes
> the window of VM inconsistency smaller.

Right, I think I see what you mean now, thanks: userspace
must not for a moment be allowed to write to orphaned pages.

Whereas it's not an issue for the privately COWed pages you added
the second unmap_mapping_range for: because it's only truncation
that has to worry about them, so they're heading for SIGBUS anyway.

Yes, and the page_mapped tests in mm/truncate.c are just racy
heuristics without the page lock you now put into faulting.

Hugh
