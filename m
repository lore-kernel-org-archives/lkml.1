Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbZJLSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbZJLSHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZJLSHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:07:03 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:17751 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757185AbZJLSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:07:01 -0400
X-Trace: 270066315/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.57.235/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.57.235
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAOYM00pPRTnr/2dsb2JhbACBUtVPhC0EgVg
X-IronPort-AV: E=Sophos;i="4.44,547,1249254000"; 
   d="scan'208";a="270066315"
Date: Mon, 12 Oct 2009 19:06:04 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: David Miller <davem@davemloft.net>, Nitin Gupta <ngupta@vflare.org>,
       Nick Piggin <npiggin@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Paul Mundt <lethal@lethal-sh.org>,
       Chen Liqin <liqin.chen@sunplusct.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
In-Reply-To: <20091012170312.GB9453@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0910121855070.21347@sister.anvils>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
 <20091012090710.GA29310@n2100.arm.linux.org.uk> <20091012.023744.157085851.davem@davemloft.net>
 <20091012100023.GC29310@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0910121634170.7327@sister.anvils>
 <20091012170312.GB9453@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Russell King wrote:
> On Mon, Oct 12, 2009 at 05:09:53PM +0100, Hugh Dickins wrote:
> > Sorry to muddy the waters on this, if you and Dave are sure that
> > you have the right fix, down in your architectures, and that fix
> > isn't going to hurt your performance significantly.
> 
> If I look at the issue from this point of view:
> 
> - we are using PG_arch_1 to delay cache handling for the page
> 
> - if PG_arch_1 is set on a page, we set it explicitly because we
>   didn't do some flushing between the allocation of the page and
>   mapping it into userspace
> 
> - if a page with PG_arch_1 set ever gets to userspace, this can
>   only be because we did the lazy flushing thing
> 
> I don't see that there should have been any bearing on whether a page
> has a mapping or not when we get to update_mmu_cache.  The issue here
> is that > if PG_arch_1 is set on a page, then we didn't flush it at
> the time when we believed it was appropriate to do so. <
> 
> Tell me I'm wrong (having only just sent it to Linus...)

I wouldn't dare!  Put that way, it seems very clear that it was always
at best a redundant test, which Nitin now shows can go wrong.  Okay,
thanks, let's forget about whether file invalidation can or cannot
also put a page into this state, and proceed with your fix.

The architectures which appear to need fixing in the same way are
arm, mips, parisc, sh and sparc64 (xtensa looks right already, and
score just looks confused - a whole function __update_cache() which
checks for PG_arch_1, yet nothing sets it?).

Hugh
