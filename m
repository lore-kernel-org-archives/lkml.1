Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYJTNEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYJTNEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYJTNEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:04:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36857 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYJTNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:04:45 -0400
Date: Mon, 20 Oct 2008 07:04:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020130439.GD26184@parisc-linux.org>
References: <20081020040823.871BDDDDEC@ozlabs.org> <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop> <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu> <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop> <20081020113143.GB14097@elte.hu> <20081020113602.GA2697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020113602.GA2697@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:36:02PM +0200, Ingo Molnar wrote:
> One open question would be whether to set the width to 8 on 32-bit 
> platforms and 16 on 64-bit platforms - right now it's 8 on both. Since 
> this is specifically a 'physical address' thing it might make sense to 
> extend that on 64-bit systems. (although it's quite a bit of screen real 
> estate so i think the current width of 8 should be fine)

Maybe we should let architectures configure it -- after all, they know
the real size of a physical address.  I'm thinking something like this:

#ifndef PHYS_ADDR_T_SIZE
#ifdef CONFIG_64BIT
#define PHYS_ADDR_T_SIZE 64
#else
#define PHYS_ADDR_T_SIZE 32
#endif
#endif

static char *phys_addr_string(char *buf, char *end, phys_addr_t *val, int field_width, int precision, int flags)
{
	/* room for the actual number, the "0x" and the final zero */
	char sym[2*sizeof(phys_addr_t) + 3];
	char *p = sym, *pend = sym + sizeof(sym);
	int size = DIV_ROUND_UP(PHYS_ADDR_T_SIZE, 4);

	p = number(p, pend, *val, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
	*p = 0;

	return string(buf, end, sym, field_width, precision, flags);
}

Architectures can define PHYS_ADDR_T_SIZE to a variable if they want
to be able to detect it at boot-time.  Or just define it to a number
(eg 36 for PAE).

By the way, the patch I'm replying to has a bug; you mis-sized 'sym'.
It needs three extra bytes, not two.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
