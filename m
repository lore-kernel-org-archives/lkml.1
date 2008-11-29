Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYK2KvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYK2KvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYK2KvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:51:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37454 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2KvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:51:09 -0500
Date: Sat, 29 Nov 2008 11:52:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20081129105229.GA9643@uranus.ravnborg.org>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com> <20081129164736.0b5a71db.h.mitake@gmail.com> <20081129093858.GC26691@elte.hu> <20081129192610.716a2d57.h.mitake@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129192610.716a2d57.h.mitake@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But this is old way. ARCH_HAS_READQ and ARCH_HAS_WRITEQ are new ways
> to determine existence of readq/writeq. Drivers which use readq/writeq should
> depend on these values in their Kconfig file.

If we look at arch/x86/Kconfig we see:
### Arch settings
config X86
        def_bool y
        select HAVE_AOUT if X86_32
        select HAVE_UNSTABLE_SCHED_CLOCK
        select HAVE_IDE
        select HAVE_OPROFILE
        select HAVE_IOREMAP_PROT
        select HAVE_KPROBES
        select ARCH_WANT_OPTIONAL_GPIOLIB
	...

So the normal syntax here is "HAVE_XXX_XXX" - not ARCH_HAS_XXX_XXX

If you update your patch please use this syntax,
and locate the select under X86 - not under the 32/64 entries.

But I do not see why adding these in the first place.

See following advice from Linus:
http://marc.info/?l=linux-arch&m=121710129310710&w=2

===> Quote:
I really think that whoever started that 'HAVE_ARCH_x'/'ARCH_HAS_x' mess 
with totally random symbols that have NOTHING WHAT-SO-EVER to do with the 
actual symbols in question (so they do _not_ show up in grep'ing for some 
use) should be shot. 

We should never _ever_ use that model. And we use it way too much.

We should generally strive for the simpler and much more obvious

	/* Generic definition */
	#ifndef symbol
	int symbol(..)
	...
	#endif

and then architecture code can do

	#define symbol(x) ...

or if they want to do a function, and you _really_ don't like the '__weak' 
part (or you want to make it an inline function and don't want the clash 
with the real declaration), then you can just do

	static inline int symbol(x)
	{
		...
	}
	#define symbol symbol

and again it all works fine WITHOUT having to introduce some idiotic new 
and unrelated element called ARCH_HAS_SYMBOL.

<====

	Sam
