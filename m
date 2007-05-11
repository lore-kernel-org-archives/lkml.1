Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbXEKJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbXEKJ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXEKJ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:28:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:2864 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXEKJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:28:11 -0400
Date: Fri, 11 May 2007 10:27:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070511004200.6d30152e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705111026200.25712@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
 <20070511082930.GP2012@bingen.suse.de> <20070511004200.6d30152e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 11 May 2007 09:28:10.0282 (UTC) FILETIME=[B0C7B8A0:01C793AE]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AGFrQHN1c2UuZGUAbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGNsYW1ldGVyQHNnaS5jb20AZGF2ZW1AZGF2ZW1sb2Z0Lm5ldAB3bGlAaG9sb21vcnBoeS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Andrew Morton wrote:
> On Fri, 11 May 2007 10:29:30 +0200 Andi Kleen <ak@suse.de> wrote:
> 
> > > I'm guessing (haven't rechecked source) that the cpu_idle() call comes
> > > about because the top level pgd of a process gets freed very late in
> > > its exit, and after a great flurry of processes have just exited,
> > > perhaps there was nothing to free up the accumulation.  Though
> > > it still strikes me as an odd place to do it.
> > 
> > I always found it odd and probably the wrong place too.
> 
> so... what's the bottom line here, guys?  Should we change that patch?

The bottom line... I can see why you're asking for that ;)

I'd say delete the change to arch/i386/kernel/smp.c - contrary to
what Christoph says, no other arch buries a check_pgt_cache() call
in flush_tlb_mm(), that just seems to be a thinko: i386 has the usual
call to it from tlb_finish_mmu() - _that_ is the one which he and
David were talking about.

I'm just worried that there might somewhere be a call to flush_tlb_mm()
which would now be surprised to be freeing pages: almost certainly not,
but why raise that concern?  It's just not flush_tlb_mm()'s business.

The cpu_idle() call should stay for now: we're agreed that it's odd,
but there's plenty of precedent for it, and it's easier to imagine it
serves a real purpose, and shouldn't be removed without replacement.

Bill raised a real concern about unnecessary PAE pgd memory usage,
but let's get the patch into -rc1 to enable the wider SLUB testing,
before coming back to fix that up.  His micro-optimizations can wait.

IMHO
Hugh
