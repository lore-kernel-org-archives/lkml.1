Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYBGUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYBGUhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYBGUhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:37:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYBGUhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:37:19 -0500
Date: Thu, 7 Feb 2008 21:37:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: davej@codemonkey.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080207203705.GA19083@elte.hu>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207200308.GA26555@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Feb 07, 2008 at 08:13:37PM +0100, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > [probably stable material too]
> > > 
> > > Use global TLB flushes in MTRR code
> > > 
> > > Obviously kernel mappings should be flushed here too.
> > 
> > no, your patch is not needed:
> 
> Yes you're right.  Thanks makes more sense.  The weird style fooled 
> me.
> 
> It seems to come from the pseudo code in the Intel manual, but I think 
> it would be still cleaner/more idiomatic to use two __flush_tlb_all() 
> and remove the explicit code. The only drawback would be some more cr4 
> accesses, which does not seem like a big issue.
> 
> Updated patch follows.

... and this patch of yours breaks MTRR setting subtly:

> -	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
> -	if ( cpu_has_pge ) {
> -		cr4 = read_cr4();
> -		write_cr4(cr4 & ~X86_CR4_PGE);
> -	}
> -
> -	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
> -	__flush_tlb();
> +	/* Flush all TLBs */
> +	__flush_tlb_all();

because it's not just an open-coded __tlb_flush_all(), it _disables PGE 
and keeps it so while the MTRR's are changed on all CPUs_.

Your patch adds __flush_tlb_all() which re-enables the PGE bit in cr4, 
see asm-x86/tlbflush.h:

        /* clear PGE */
        write_cr4(cr4 & ~X86_CR4_PGE);
        /* write old PGE again and flush TLBs */
        write_cr4(cr4);

so we'll keep PGE enabled during the MTRR setting - which changes 
behavior.

	Ingo
