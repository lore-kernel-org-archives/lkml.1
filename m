Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbZITMET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbZITMET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 08:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZITMET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 08:04:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZITMES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 08:04:18 -0400
Date: Sun, 20 Sep 2009 14:04:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/5] kbuild: Set -fconserve-stack option for gcc 4.5
Message-ID: <20090920120417.GA30185@one.firstfloor.org>
References: <200909141018.915641783@firstfloor.org> <20090914201811.187B3B1757@basil.firstfloor.org> <20090914143615.9ee47a1a.akpm@linux-foundation.org> <20090919092003.GA25916@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919092003.GA25916@merkur.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 11:20:03AM +0200, Sam Ravnborg wrote:
> On Mon, Sep 14, 2009 at 02:36:15PM -0700, Andrew Morton wrote:
> > On Mon, 14 Sep 2009 22:18:11 +0200 (CEST)
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > 
> > > The upcomming gcc 4.5 has a new -fconserve-stack option 
> > > that tells the inliner to take stack frame size in account.
> > > Set it if the compiler supports it.
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > 
> > > ---
> > >  Makefile |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > Index: linux-2.6.31-rc3-ak/Makefile
> > > ===================================================================
> > > --- linux-2.6.31-rc3-ak.orig/Makefile
> > > +++ linux-2.6.31-rc3-ak/Makefile
> > > @@ -575,6 +575,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
> > >  # revert to pre-gcc-4.4 behaviour of .eh_frame
> > >  KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
> > >  
> > > +# conserve stack if available
> > > +KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
> > 
> > Do we have any info about what effects this option has upon the
> > generated code?  Text size changes, runtime stack usage changes, etc?
> 
> I merged this despite the relevant questions above was not answered.
> But maybe we should wait until Andi gets back with numbers?

It only changes some inlining decisions, nothing dramatic.  The main
value is in avoiding surprises in the future when the gcc inlining
algorithms change again or long term when everyone uses gcc 4.5 
the current manual hacks to avoid this could be dropped.

Here's some quick data for 64bit with a slightly older gcc snapshot:

   text    data     bss     dec     hex filename
8288629 1399680 1512012 11200321         aae741 vmlinux-45-no-conserve
8298155 1403776 1512012 11213943         ab1c77 vmlinux-45-with-conserve

Only a few hundred bytes difference in text size, at the cost of a 4k
larger data segment (I suspect that's because of the 4K padding)

At least the top stack users don't really change significantly (I suspect
because most of the inline problems have been handled manually already)

If I do statistics over all stack users there's about 4K less stack
used over all functions. Not dramatic.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
