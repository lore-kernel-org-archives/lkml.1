Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYBGTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYBGTP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933096AbYBGTN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:13:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088AbYBGTNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:13:55 -0500
Date: Thu, 7 Feb 2008 20:13:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: davej@codemonkey.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080207191337.GA13111@elte.hu>
References: <20080207190241.GA9449@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207190241.GA9449@basil.nowhere.org>
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

> [probably stable material too]
> 
> Use global TLB flushes in MTRR code
> 
> Obviously kernel mappings should be flushed here too.

no, your patch is not needed:

>  	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
> -	__flush_tlb();
> +	__flush_tlb_all();

read the complete code:

        /*  Save value of CR4 and clear Page Global Enable (bit 7)  */
        if ( cpu_has_pge ) {
                cr4 = read_cr4();
                write_cr4(cr4 & ~X86_CR4_PGE);
        }

        /* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
        __flush_tlb();

first first turn off PGE and do a cr3 flush - that gets rid of all TLBs.

but even if it didnt get rid of it, the mirror image function, 
post_set(), we turn PGE back on in the cr4 _after_ we've flushed the 
TLBs via the cr3 - that will flush all TLBs again.

	Ingo
