Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYC0Xuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYC0Xuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYC0Xun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:50:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:57733 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752333AbYC0Xum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:50:42 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/kudc+79TkxU70RZUPPJfUcWxuM0dl6OocKtIFXL
	ox3ehBFFWmT/qX
Date: Fri, 28 Mar 2008 00:50:39 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20080327235039.GA26291@atjola.homenet>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.27 16:20:53 +0100, Thomas Gleixner wrote:
> On Tue, 25 Mar 2008, Andrew Morton wrote:
> > > Code: 53 c0 e8 20 08 fc ff c1 e3 02 8b 14 33 89 54 24 20 8b 44 24 20 85 c0 75 10 eb 51 8b 12 89 54 24 20 8b 44 24 20 85 c0 74 43 8b 02 <0f> 18 00 90 8d 5a d8 39 6b 34 75 e4 8b 7c 24 0c 39 7b 30 75 db 
> 
> It faults in a prefetch.
> 
> > Markus reported what looks to be the same thing here:
> > http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.
> 
> Same here. And both are AMD X2 early stepping machines.
>  
> > I guess you've confirmed that this wasn't a mystery
> > once-off-on-that-machine.
> > 
> > I can't think what we did to cause this.
> 
> I had a lengthy bug decoding session with Ingo and we found the root
> cause:
> 
> A dropped workaround for the prefetch bug in early X2s and
> Opterons. Patch below.
> 
> Thanks,
> 
> 	tglx
> 
> --------------->
> Subject: x86: fix prefetch workaround
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu Mar 27 15:58:28 CET 2008
> 
> some early Athlon XP's and Opterons generate bogus faults on prefetch
                    ^^

Umh, XP? Didn't you say X2 above? And looking at the patch, X2 seems
more plausible as well, I don't think that the XP supported the NX bit,
did it?

Björn

> instructions. The workaround for this regressed over .24 - reinstate it.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  arch/x86/mm/fault.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-x86.q/arch/x86/mm/fault.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mm/fault.c
> +++ linux-x86.q/arch/x86/mm/fault.c
> @@ -104,7 +104,8 @@ static int is_prefetch(struct pt_regs *r
>  	unsigned char *max_instr;
>  
>  #ifdef CONFIG_X86_32
> -	if (!(__supported_pte_mask & _PAGE_NX))
> +	/* Catch an obscure case of prefetch inside an NX page: */
> +	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
>  		return 0;
>  #endif
>  
> 
> 
