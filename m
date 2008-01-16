Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYAPOyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYAPOyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYAPOym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:54:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYAPOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:54:41 -0500
Date: Wed, 16 Jan 2008 15:54:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116145427.GA640@elte.hu>
References: <patchbomb.1200435425@localhost> <478D4197.8060904@goop.org> <20080116142242.GA23993@elte.hu> <200801161544.15884.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801161544.15884.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> >  #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
> 
> 
> I haven't tested yet, but we looked at that one earlier and I thought 
> it was ok because
> 
> #define __PHYSICAL_MASK          _AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
> 
> and 
> 
> typedef u64     phys_addr_t;
> 
> for PAE. So the expression above should have been already 64bit.

no. The problem is that PAGE_MASK is:

  #define PAGE_MASK        (~(PAGE_SIZE-1))

  #define PAGE_SIZE        (_AC(1,UL) << PAGE_SHIFT)

that's u32 on PAE, and __PHYSICAL_MASK is u64. So PAGE_MASK gets 
zero-extended to u64. So the combined mask:

  #define PHYSICAL_PAGE_MASK      (PAGE_MASK & __PHYSICAL_MASK)

has the high bits chopped off. Please try my patch.

(PHYSICAL_PAGE_MASK is broken too in the same way, i just fixed that in 
my tree - but it's not used by anything on 32-bit PAE but by PAGE_MASK)

> So I would be surprised if the patch works.

try it ...

	Ingo
