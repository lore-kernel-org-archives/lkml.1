Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842Ab0APT6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0APT6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 14:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931Ab0APT6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 14:58:38 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49207 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0APT6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 14:58:38 -0500
Date: Sun, 17 Jan 2010 01:28:22 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix broken mmiotrace due to dr6 by reference change
Message-ID: <20100116195822.GB31079@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 10:39:30AM +0100, Luca Barbieri wrote:
> Commit 62edab9056a6cf0c9207339c8892c923a5217e45 (from June 2009 but merged
> in 2.6.33) changes notify_die to pass dr6 by reference.
> 
> However, it forgets to fix the check for DR_STEP in kmmio.c, breaking
> mmiotrace. It also passes a wrong value to the post handler.
> 

Yes, looks like I missed it...must have hunted down all those registered
to the die notifier...to propagate the fix.

> This simple fix makes mmiotrace work again.
> 
> Please send to Linus for inclusion in 2.6.33
> 
> Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>

Thanks,
K.Prasad

> ---
>  arch/x86/mm/kmmio.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> index c0f6198..536fb68 100644
> --- a/arch/x86/mm/kmmio.c
> +++ b/arch/x86/mm/kmmio.c
> @@ -538,14 +538,15 @@ static int
>  kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
>  {
>  	struct die_args *arg = args;
> +	unsigned long* dr6_p = (unsigned long *)ERR_PTR(arg->err);
> 
> -	if (val == DIE_DEBUG && (arg->err & DR_STEP))
> -		if (post_kmmio_handler(arg->err, arg->regs) == 1) {
> +	if (val == DIE_DEBUG && (*dr6_p & DR_STEP))
> +		if (post_kmmio_handler(*dr6_p, arg->regs) == 1) {
>  			/*
>  			 * Reset the BS bit in dr6 (pointed by args->err) to
>  			 * denote completion of processing
>  			 */
> -			(*(unsigned long *)ERR_PTR(arg->err)) &= ~DR_STEP;
> +			*dr6_p &= ~DR_STEP;
>  			return NOTIFY_STOP;
>  		}
> 
> -- 
> 1.6.3.3
> 
