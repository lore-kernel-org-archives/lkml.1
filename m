Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZARVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZARVdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZARVdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:33:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZARVda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:33:30 -0500
Date: Sun, 18 Jan 2009 22:33:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86/Voyager
Message-ID: <20090118213317.GA30670@elte.hu>
References: <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <4972B8AB.8040001@kernel.org> <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com> <4972C53C.5050509@kernel.org> <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com> <20090118071427.GA29613@elte.hu> <1232296885.3247.17.camel@localhost.localdomain> <20090118181748.GA24570@elte.hu> <1232309514.3247.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232309514.3247.62.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > > But no-one's yet made any argument for why it's a worthwhile thing 
> > > to be doing.
> > 
> > Because the sub-arch code is butt-ugly.
> > 
> > x86 subarchitectures are a hack that should never have gone upstream - 
> > and we are now reversing that braindamage, step by step. 
> > Subarchitectures are a compile-time "HAL", but a highly 
> > non-transparent one at that. They complicates the x86 architecture in 
> > a couple of key structures and very fundamentally so - and that 
> > results in continued complications in critical areas of the x86 code.
> 
> Right: it's a compile time HAL.  Your "cleanup" is to convert it to a 
> runtime one, which is a lot more complex because voyager still has to 
> influence the x86 path in those locations regardless: it's not an x86 PC 
> architecture and so is never going to be able to boot through an APIC/MP 
> table SMP boot sequence.
> 
> I'm not actually bothered by the complexity, though ... it would be cool 
> for me to have a kernel that boots on both voyager and a PC.  What 
> worries me is the cost (both in terms of execution time and maintenance 
> burden) this would impose on the standard PC path.

That cost is negligible. Voyager already uses smp_ops which solves most of 
the callbacks. The remaining non-slowpath (non-init, non-shutdown, etc.) 
bits are, roughly:

   flush_tlb_[all|current_task|mm|page]()
   smp_apic_timer_interrupt

Which can either reuse PARAVIRT with a Voyager-specific custom template 
for these methods, or, if that's easier, we can add x86_quirk handlers as 
well.

There is near zero overhead for normal PCs, ~5 functions will have:

    if (unlikely(x86_quirks.smp_apic_timer_interrupt)) {
            ... quirk-path ...
    }

type of constructs.

> The other thing I will point out is that if you think a runtime HAL 
> simplification could be applied to the current kernel, a compile time 
> HAL could equally well be done.

There are numerous advantages. Just a few of them, from the top of my 
head:

 - The point is to not split the build space on such a fundamental level - 
   testing is way too complex already.

 - Runtime quirks tend to be tested far more than build-time quirks: for 
   example because a test kernel can just include all the runtime quirks 
   all at once - while it cannot possibly include all the
   subarchitectures.

 - It is far more apparent from the source code what happens if quirks are 
   out and visible. A compile-time 'HAL' is far less transparent: it is 
   very easy to miss that a function is present in multiple copies and 
   behaves in different ways, dependent on which subarch we are building 
   for. Developers tend to concentrate on a single piece of code, so
   consolidating code flows is a development advantage.

 - Runtime quirks tend to be much more usable. A distro kernel can include
   all the quirks with near zero impact. Now in the specific case of
   x86/Voyager this is probably not a big factor: as you seem to be owning 
   the last two (one?) working Voyager box in existence that runs
   development kernels? But it is a factor in the general push to
   eliminate subarchitectures.

(For similarly good reasons most of the hw quirks in the normal Linux 
driver space are done via runtime constructs and not via build-time 
constructs.)

Anyway, none of this is really new. We eliminated the ES7000, the VISWS 
and the RDC321X subarchitectures already - Voyager is the holdout.

	Ingo
