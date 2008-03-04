Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYCDUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYCDUwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYCDUvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:51:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYCDUvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:51:53 -0500
Date: Tue, 4 Mar 2008 21:51:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Roskin <proski@gnu.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080304205117.GA21803@elte.hu>
References: <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu> <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> On Tue, 4 Mar 2008, Ingo Molnar wrote:
> > 
> > so ... i suspect the requirement would be for 
> > NdisMAllocateSharedMemory() to return a linear address that is 
> > DMA-able, and to properly map it to a physical address via 
> > dma_map_single(). I can see only one complication in pushing this to 
> > user-space: physical fragmentation of allocations. What are the 
> > typical buffer sizes that NDIS drivers request from the kernel? Is 
> > it frequently above 4K?
> 
> Ingo, i's simply not possible to put ndiswrapper in user-space sanely.
> 
> Drivers are drivers. They'll want (shared) interrupts, they want DMA, 
> they want to do things like cli/sti.
> 
> The USB drivers *may* be abstracted enough that they don't do any of
> that, but quite frankly, I doubt it.

yeah, i agree that putting it into userspace is quite insane.

it might possible to do it halfways sanely via existing arch/x86/kvm/ 
infrastructure though. VMX/SVM context will properly emulate the IRQ 
flag so cli/sti will work fine, and as long as DMA is properly 
quarantined via an iommu it might even not corrupt the rest of the 
system. Right now KVM is tailored for full system emulation but there's 
no strong reason why it couldnt emulate just a single hardware domain, 
with an NDIS driver sitting in that domain - talking to the rest of the 
system via hypercalls.

> It sounds like there aren't that many symbols affected at the core: 
> the workqueue stuff certainly isn't worth bothering about. The USB 
> things that ndiswrapper wants is much more involved, and more likely 
> to have issues, but I'm cc'ing Greg here to see.
> 
> IOW: I _personally_ don't think there are any license issues, but I do 
> want to have the situation clear to people involved.

the ugliest technical aspect of them being in the Linux host kernel is 
that NDIS drivers are used to a larger kernel stack, so they very 
frequently overflow the Linux kernel stack. Not sure whether recent 
versions of ndiswrapper have solved this problem.

	Ingo
