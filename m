Return-Path: <linux-kernel-owner+w=401wt.eu-S966474AbXJPW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966474AbXJPW3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933746AbXJPW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:29:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:51830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935517AbXJPW3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:29:23 -0400
Date: Wed, 17 Oct 2007 00:29:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <20071016222921.GA29378@wotan.suse.de>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:33:54PM +0200, Mikulas Patocka wrote:
> 
> 
> On Tue, 16 Oct 2007, Nick Piggin wrote:
> 
> > > > The cpus also have an explicit set of instructions that deliberately do 
> > > > unordered stores/loads, and s/lfence etc are mostly designed for those.
> > > 
> > > I know about unordered stores (movnti & similar) --- they basically use 
> > > write-combining method on memory that is normally write-back --- and they 
> > > need sfence. But which one instruction does unordered load and needs 
> > > lefence?
> > 
> > Also, for non-wb memory. I don't think the Intel document referenced
> > says anything about this, but the AMD document says that loads can pass
> > loads (page 8, rule b).
> > 
> > This is why our rmb() is still an lfence.
> 
> I see, AMD says that WC memory loads can be out-of-order.
> 
> There is very little usability to it --- framebuffer and AGP aperture is 
> the only piece of memory that is WC and no kernel structures are placed 
> there, so it is possible to remove that lfence.

No. In Linux kernel, rmb() means that all previous loads, including to
any IO regions, will be executed before any subsequent load.

How can you possibly get rid of lfence from there just because you may
happen to *know* that it isn't used (btw. the IO serialisation isn't for
kernel data structures, it is for actual IO operations, generally).

Doing that would lead to an unmaintainable mess. If drivers don't need rmb,
then they don't call it.
