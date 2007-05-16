Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbXEPRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbXEPRys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbXEPRyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:54:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56939 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759882AbXEPRyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:54:37 -0400
Date: Wed, 16 May 2007 18:54:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
In-Reply-To: <20070513065246.GA15071@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705161838080.16762@blonde.wat.veritas.com>
References: <1178659827.14928.85.camel@localhost.localdomain>
 <20070508224124.GD20174@wotan.suse.de> <20070508225012.GF20174@wotan.suse.de>
 <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
 <20070510033736.GA19196@wotan.suse.de> <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com>
 <20070511085424.GA15352@wotan.suse.de> <Pine.LNX.4.64.0705111357120.3350@blonde.wat.veritas.com>
 <20070513033210.GA3667@wotan.suse.de> <Pine.LNX.4.64.0705130535410.3015@blonde.wat.veritas.com>
 <20070513065246.GA15071@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 May 2007 17:54:36.0522 (UTC) FILETIME=[4474BCA0:01C797E3]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AG5waWdnaW5Ac3VzZS5kZQBsaW51eC1hcmNoQHZnZXIua2VybmVsLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAYmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Nick Piggin wrote:
> On Sun, May 13, 2007 at 05:39:03AM +0100, Hugh Dickins wrote:
> > On Sun, 13 May 2007, Nick Piggin wrote:
> > > On Fri, May 11, 2007 at 02:15:03PM +0100, Hugh Dickins wrote:
> > > 
> > > > Hmm, well, I think that's fairly horrid, and would it even be
> > > > guaranteed to work on all architectures?  Playing with one char
> > > > of an unsigned long in one way, while playing with the whole of
> > > > the unsigned long in another way (bitops) sounds very dodgy to me.
> > > 
> > > Of course not, but they can just use a regular atomic word sized
> > > bitop. The problem with i386 is that its atomic ops also imply
> > > memory barriers that you obviously don't need on unlock.
> > 
> > But is it even a valid procedure on i386?
> 
> Well I think so, but not completely sure.

That's not quite enough to convince me!

I do retract my "fairly horrid" remark, that was a kneejerk reaction
to cleverness; it's quite nice, if it can be guaranteed to work (and
if lowering FLAGS_RESERVED from 9 to 7 doesn't upset whoever carefully
chose 9).

Please seek out those guarantees.  Like you, I can't really see how
it would go wrong (how could moving in the unlocked char mess with
the flag bits in the rest of the long? how could atomically modifying
the long have a chance of undoing that move?), but it feels like it
might take us into errata territory.

Hugh

> OTOH, I admit this is one
> of the more contentious speedups ;) It is likely to be vary a lot by
> the arch (I think the P4 is infamous for expensive locked ops, others
> may prefer not to mix the byte sized ops with word length ones).
