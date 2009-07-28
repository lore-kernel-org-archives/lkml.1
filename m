Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZG1AZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZG1AZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZG1AZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:25:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38469 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1AZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:25:30 -0400
Date: Tue, 28 Jul 2009 09:25:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       ralf <ralf@linux-mips.org>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Message-ID: <20090728002529.GB22668@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux-Arch <linux-arch@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Hugh Dickins <hugh@tiscali.co.uk>, ralf <ralf@linux-mips.org>
References: <20090715074952.A36C7DDDB2@ozlabs.org> <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop> <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain> <1248310415.3367.22.camel@pasglop> <alpine.LFD.2.01.0907271210210.25224@localhost.localdomain> <1248740260.30993.26.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248740260.30993.26.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:17:40AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-07-27 at 12:11 -0700, Linus Torvalds wrote:
> > On Thu, 23 Jul 2009, Benjamin Herrenschmidt wrote:
> > > 
> > > Hrm... my powerpc-next branch will contain stuff that depend on it, so
> > > I'll probably have to pull it in though, unless I tell all my
> > > sub-maintainers to also pull from that other branch first :-)
> > 
> > Ok, I'll just apply the patch. It does look obvious enough.
> 
> There seem to be a MIPS and SH breakage as a result but I can't see
> how my patch would have broken it, ie, it looks like the bug was
> already in those two archs. The error is that it complains about a
> duplicate definition of __pmd_free_tlb() between those arch pgalloc.h
> and pgtable-nopmd.h
> 
> For MIPS, when CONFIG_32BIT is set, asm/pgalloc.h redefines
> __pmd_free_tlb despite the fact that it's already defined by
> asm-generic/pgtable-nopmd.h (via via pgtable.h via linux/mm.h).
> 
> I -suspect- what happens is that the compiler, before, would ignore the
> double definition (or maybe just warn) due to the definition being
> strictly identical. With the new argument added, it's no longer the case
> as it's called "a" in asm-generic and "addr" in mips... oops.
> 
> In any case, can Ralf and Paul check if the following patch is correct ?
> 
Yup, that seems to be what happened. I've never seen a warning about this
with any compiler version, otherwise we would have caught this much
earlier. As soon as the addr -> a rename took place it blew up
immediately as a redefinition. Is there a magical gcc flag we can turn on
to warn on identical definitions, even if just for testing?

> >From 41928c7945d855ae0eb053eadad590ab6876847e Mon Sep 17 00:00:00 2001
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 28 Jul 2009 10:16:48 +1000
> Subject: [PATCH] mm: Remove duplicate definitions in MIPS and SH
> 
> Those definitions are already provided by asm-generic
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Builds and boots fine, thanks.

Acked-by: Paul Mundt <lethal@linux-sh.org>
