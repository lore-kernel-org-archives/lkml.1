Return-Path: <linux-kernel-owner+w=401wt.eu-S935724AbXJPXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724AbXJPXF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXJPXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:05:19 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:40462 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXJPXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:05:17 -0400
Date: Wed, 17 Oct 2007 01:05:16 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Nick Piggin <npiggin@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
In-Reply-To: <20071016222921.GA29378@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
 <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
 <20071016222921.GA29378@wotan.suse.de>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I see, AMD says that WC memory loads can be out-of-order.
> > 
> > There is very little usability to it --- framebuffer and AGP aperture is 
> > the only piece of memory that is WC and no kernel structures are placed 
> > there, so it is possible to remove that lfence.
> 
> No. In Linux kernel, rmb() means that all previous loads, including to
> any IO regions, will be executed before any subsequent load.

You already must not place any data structures into WC memory --- for 
example, spinlocks wouldn't work there. wmb() also won't work on WC 
memory, because it assumes that writes are ordered.

> How can you possibly get rid of lfence from there just because you may
> happen to *know* that it isn't used (btw. the IO serialisation isn't for
> kernel data structures, it is for actual IO operations, generally).

IO regions are in uncached memory, and x86 already serializes it fine. It 
flushes any write buffers on access to uncached memory.

(BTW. what is the general portable rule for serializing writel() and 
readl()? On x86 they are serialized in hardware, but what on other archs?)

> Doing that would lead to an unmaintainable mess. If drivers don't need rmb,
> then they don't call it.

If wmb() doesn't currently work on write-combining memory, why should 
rmb() work there?

The purpose of rmb() is to enforce ordering on architectures that don't 
force it in hardware --- that is not the case of x86.

Mikulas
