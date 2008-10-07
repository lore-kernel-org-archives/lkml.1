Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYJGON0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYJGON0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYJGONS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:13:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYJGONS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:13:18 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48EB6D2C.30806@linux-foundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <48EB6D2C.30806@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 16:13:08 +0200
Message-Id: <1223388788.26330.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 09:07 -0500, Christoph Lameter wrote:
> > Which basically shows us that the content of the pcpu_size[] array got
> > corrupted after the krealloc() call in split_block().
> > 
> > Which made me look at which slab allocator I had selected, which turned
> > out to be SLOB (from testing the network swap stuff).
> 
> krealloc() is in generic core code (mm/util.c) and is the same for all allocators.

Joy :/

> krealloc uses ksize() which is somewhat dicey for SLOB because it only works
> on kmalloc'ed memory. Is the krealloc used on memory allocated with kmalloc()?
> Slob's ksize could use a BUG_ON for the case in which ksize() is used on
> kmem_cache_alloc'd memory.

kernel/module.c: perpcu_modinit() reads:

	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
			    GFP_KERNEL);

kernel/module.c: split_block() reads:

		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
			       GFP_KERNEL);



