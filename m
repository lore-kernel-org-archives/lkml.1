Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXD3LPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXD3LPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXD3LPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:15:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:54871 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXD3LPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:15:39 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
	<20070430035838.GC77450368@melbourne.sgi.com>
	<20070430091754.24df88df@the-village.bc.nu>
	<p73wszuyx7h.fsf@bingen.suse.de>
	<20070430104806.GA14944@infradead.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Apr 2007 14:13:16 +0200
In-Reply-To: <20070430104806.GA14944@infradead.org>
Message-ID: <p73slaiys9v.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Apr 30, 2007 at 12:26:42PM +0200, Andi Kleen wrote:
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > > If this still occurs for some
> > > combinations then the fix would be 8K + 4K IRQ stack, not just to use 8K
> > > stack
> > 
> > Yes i've been thinking for some time doing that would be a good idea.
> 
> Yes, the non-irqstack case should definitively go away.  And 8k
> kernel stacks isn't that little given how much most 64bit architectures
> have.

Actually looking at the code it would need some fixes first:

/*
 * These should really be __section__(".bss.page_aligned") as well, but
 * gcc's 3.0 and earlier don't handle that correctly.
 */
static char softirq_stack[NR_CPUS * THREAD_SIZE]
                __attribute__((__aligned__(THREAD_SIZE)));

static char hardirq_stack[NR_CPUS * THREAD_SIZE]
                __attribute__((__aligned__(THREAD_SIZE)));


With 8K stacks and NR_CPUS==128 that would be 2MB statically reserved. Yuck.
Really needs to be dynamically allocated. I'll take a look once the .22 
big merge is done.

-Andi
