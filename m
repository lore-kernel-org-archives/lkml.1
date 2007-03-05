Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXCEKz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXCEKz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933095AbXCEKz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:55:27 -0500
Received: from mail.screens.ru ([213.234.233.54]:43991 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXCEKz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:55:27 -0500
Date: Mon, 5 Mar 2007 13:54:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Paul Mundt <lethal@linux-sh.org>, John Reiser <jreiser@BitWagon.com>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070305105444.GA85@tv-sign.ru>
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com> <20070302221854.GA162@tv-sign.ru> <20070305101231.GA12363@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305101231.GA12363@linux-sh.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Paul Mundt wrote:
>
> On Sat, Mar 03, 2007 at 01:18:54AM +0300, Oleg Nesterov wrote:
> > On 03/02, John Reiser wrote:
> > > Paul Mundt has commented on setup_rt_frame() and provided a patch which
> > > bullet-proofs that area.  I will include that patch into the next revision.
> > 
> > Confused. I still think his patch incomplete. Don't we need the same check
> > in setup_rt_frame() ?
> > 
> Yes, you're right. The patch is missing the proper restorer logic in the
> setup_rt_frame() case. This should handle both of them, restoring the
> previous logic when the VDSO is disabled.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> --
> 
>  arch/i386/kernel/signal.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
> index 4f99e87..26c2497 100644
> --- a/arch/i386/kernel/signal.c
> +++ b/arch/i386/kernel/signal.c
> @@ -350,7 +350,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
>  			goto give_sigsegv;
>  	}
>  
> -	if (current->binfmt->hasvdso)
> +	if (current->binfmt->hasvdso && current->mm->context.vdso)

I think this is correct, but a bit strange.

The "->context.vdso != NULL" check relies on the fact that .vdso == NULL
after mm_alloc (because arch_setup_additional_pages() doesn' initialize
it when vdso_enabled == 0, and it has to be != NULL otherwise).

This means that binfmt->hasvdso in essence is not used, at least for i386.
Isn't it better to kill ->hasvdso and just use ->context.vdso ? Every usage
of ->hasvdso should also check ->context.vdso anyway.

Oleg.

