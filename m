Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYBILNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYBILNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYBILNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:13:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYBILNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:13:14 -0500
Date: Sat, 9 Feb 2008 12:48:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080209114826.GA21172@one.firstfloor.org>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org> <20080207203705.GA19083@elte.hu> <20080208114419.GB4745@one.firstfloor.org> <20080209094037.GA23418@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209094037.GA23418@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 10:40:37AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > because it's not just an open-coded __tlb_flush_all(), it _disables PGE 
> > > and keeps it so while the MTRR's are changed on all CPUs_.
> > 
> > Yes and? 
> 
> your first patch was outright wrong then you declared the second one a 
> "cleanup" while it changes behavior: bad in my book ;-)

I didn't claim that it didn't change the code -- you know
that I'm not a white space warrior, so I normally don't bother
with these kinds of patches -- just that it uses the usual Linux 
idioms for global TLB flushing.

> > > Your patch adds __flush_tlb_all() which re-enables the PGE bit in cr4, 
> > > see asm-x86/tlbflush.h:
> > > 
> > >         /* clear PGE */
> > >         write_cr4(cr4 & ~X86_CR4_PGE);
> > >         /* write old PGE again and flush TLBs */
> > >         write_cr4(cr4);
> > > 
> > > so we'll keep PGE enabled during the MTRR setting - which changes 
> > > behavior.
> > 
> > It changes behaviour in some minor ways but I don't think it makes any 
> > difference. PGE only influences TLB flushes (according to its 
> > specification) and all the TLB flushes still run with PGE disabled.
> 
> now that i pointed out the difference, your position changed to "changes 
> behavior in minor ways" ;-)

The instruction stream changes (more cr* accesses), but the actual flushes 
do not.  There is the exact same number of global TLB flushes (three
as requested by the Intel manual); just instead of in weird open coded 
style they are done in standard Linux style. 

I think it's an improvement because the old code fooled me at least,
so it's not 100% obvious.

> This is fragile code and almost nothing in the MTRR area is "minor", we 
> are just not touching this code unless it's really justified.

I don't think that's true actually; at least it doesn't match my experience
from maintaing that code for quite some time. MTRR was never particularly
fragile, just ugly.

Anyways I personally won't be fooled by that code again, so if 
you're not interested in (IMHO) cleaner and more readable and 
more maintaintable code then it's fine for me to not apply the patch.

-Andi

