Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbXH0VKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbXH0VKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXH0VKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:10:04 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50305 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbXH0VKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:10:02 -0400
Date: Mon, 27 Aug 2007 22:09:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bogus hotplug cpu warning
In-Reply-To: <20070827135212.6a5a847e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708272157260.3851@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
 <20070827111802.8d0a675b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0708272126050.29594@blonde.wat.veritas.com>
 <20070827135212.6a5a847e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Andrew Morton wrote:
> On Mon, 27 Aug 2007 21:37:14 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > > So I agree with the patch, but not with its description.
> > 
> > I don't see which part of the description you disagree with, but please
> > do improve it if you can.
> 
> I'd change the description to
> 
> 
> current_is_keventd() is a stupid load of crap.  It does
> 
> int current_is_keventd(void)
> {
> 	struct cpu_workqueue_struct *cwq;
> 	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */
> 
> but that comment (and the code itself) only make sense when
> current_is_keventd() is called by keventd.  In which case thers is no point
> in the function even existing!

I disagree.  The comment (your very own, I think?) and the code made
sense to me.  It's saying this is rather unusual, but safe against
preemption, because keventd is per-cpu (it might perhaps be better
if it said each keventd is bound to a cpu).

The code works in such a way that if it is a keventd, then it'll
correctly arrive at the answer yes; and if it's not a keventd,
then even if it's preempted to a different cpu in the middle,
the test won't match any keventd and so it'll correctly arrive
at the answer no.

But I'm content with the half-liner already there.

> 
> We need to use raw_smp_processor_id() so that non-keventd (or, more
> specifically, non-pinned-to-one-cpu) callers won't generate "using
> smp_processor_id() in preemptible" warnings.

Yes, that's true, raw_smp_processor_id() is needed to avoid the
warning; but it was already preempt-safe with smp_processor_id(),
just in danger of giving an inappropriate warning.

Hugh
