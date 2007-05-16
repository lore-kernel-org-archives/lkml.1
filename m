Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbXEPUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbXEPUUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbXEPUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:20:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39056 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759175AbXEPUUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:20:04 -0400
Date: Wed, 16 May 2007 22:21:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC64 symbols start with '.'
Message-ID: <20070516202100.GA31701@uranus.ravnborg.org>
References: <20070511154501.1961fb92.sfr@canb.auug.org.au> <20070515203935.GB22966@uranus.ravnborg.org> <20070516135953.b8b7320c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516135953.b8b7320c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 01:59:53PM +1000, Stephen Rothwell wrote:
> Hi Sam,
> 
> On Tue, 15 May 2007 22:39:35 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > On Fri, May 11, 2007 at 03:45:01PM +1000, Stephen Rothwell wrote:
> > > which we want to skip during modpost processing.  We need this to make
> > > some of the whitelisting work.
> >
> > I have a popwerpc64 crosscompiler and would like to reproduce
> > this bug.
> > What config shall I use to try it out.
> 
> I use allmodconfig, but that doesn't really build at the moment, so I
> have attached a config that should build (with a recent Linus tree).
> 
> > Can you please supply the exact warning message too.
> 
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text:.__alloc_bootmem_node from .text between '.sparse_index_alloc' (at offset 0x27df0) and '.__section_nr'
> 
> The '.sparse_index_alloc' doesn't match "sparse_index_alloc" in pat4sym
> due to the '.' at the beginning.  I have seen another one as well, but
> cannot reproduce it at the moment.

I'm reluctant to apply this patch for two reasons.
1) I cannot reproduce it
2) The cases that this patch would repair are most likely
   better addressed by the upcoming __init_refok marker.

ad 1) I think the alloc_bootmem warning was fixed by
correcting the __init / __initdata markes so it got
fixed in the rigt way and not by whitelisting.

I had a bunch or warnings like this:
WARNING: arch/ppc/platforms/built-in.o(.data+0x18): Section mismatch: reference to .init.text:Powerplus_Map_Non0 (between 'mot_info' and 'Mesquite_pci_IRQ_map')
This is mot_info that should be marked __initdata - shall I post a patch?

And one warning like this:
WARNING: arch/ppc/mm/built-in.o(.text+0x1000): Section mismatch: reference to .init.text:early_get_page (between 'pte_alloc_one_kernel' and 'hash_page_sync')

The latter is a __init_Refok candidate.
The logic make sure we call early_get_page only if we are in init mode.

I also saw a number of:
WARNING: "next_slot" [arch/ppc/mm/built-in] is COMMON symbol

I can see where modpost post this warning but I do not know the rationale
behind it.
The symbols that modpost complain about are all assembler defined symbols.
Maybe something needs to be fixed in the assembler code?
The offending symbols are marked with .comm but other global symbols
are marked with _GLOBAL(symbol).

	Sam
