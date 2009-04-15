Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZDOQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZDOQvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZDOQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:51:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZDOQvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:51:00 -0400
Date: Wed, 15 Apr 2009 18:49:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Message-ID: <20090415164929.GA10345@elte.hu>
References: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <2193.1239791070@redhat.com> <alpine.LFD.2.00.0904150808550.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904150808550.4132@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009, David Howells wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > Hmm. Why not move it all above the '#include <asm/percpu.h>'?
> > 
> > There are circular dependencies between the x86 arch headers that both use
> > this and are used to implement this, and it's a bit fragile.
> 
> Grr. Indeed it seems to be. Nasty. Header files seem to want that 
> DECLARE_PER_CPU() thing without all the other baggage that is 
> implied by including all of <linux/percpu.h>, so they just include 
> <asm/percpu.h> directly instead.
> 
> What a mess.
> 
> So maybe we could move DEFINE_PER_CPU in there too? It's less than 
> perfect, but at least we'd have things together rather than split 
> in really odd ways.

I think splitting the type related defines away into percpu_types.h, 
and updating the lowlevel headers to include linux/percpu_types.h 
[which would include asm/percpu.h] would do the trick.

Even the exising percpu.h could be made lighter:

slab.h:    is needed for the kzalloc in the !SMP wrapper case. That 
           could be eliminated by uninlining the UP wrappers.

preempt.h: is needed for preempt_disable/enable() in the 
           get_cpu_var()/put_cpu_var() methods.

smp.h:     not sure what it's needed for - nothing obvious at first
           sight.

Most of them could be eliminated.

	Ingo
