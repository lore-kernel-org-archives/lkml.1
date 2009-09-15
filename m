Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZIOOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZIOOip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZIOOil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:38:41 -0400
Received: from bamako.nerim.net ([62.4.17.28]:59389 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZIOOik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:38:40 -0400
Date: Tue, 15 Sep 2009 16:38:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] Re: [GIT PULL] AMD64 EDAC updates,
 p1
Message-ID: <20090915163837.35701344@hyperion.delvare>
In-Reply-To: <20090915110940.GA8134@elte.hu>
References: <20090914171905.GD13615@aftab>
	<20090915110940.GA8134@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 13:09:40 +0200, Ingo Molnar wrote:
> -tip testing found this build failure with the attached config:
> 
> drivers/edac/edac_mce_amd.c: In function ‘decode_mce’:
> drivers/edac/edac_mce_amd.c:408: error: ‘per_cpu__cpu_llc_id’ undeclared (first use in this function)
> drivers/edac/edac_mce_amd.c:408: error: (Each undeclared identifier is reported only once
> drivers/edac/edac_mce_amd.c:408: error: for each function it appears in.)
> 
> I did the patchlet below but this needs a cleaner fix eventually. A 
> proper node abstraction needs to be factored out and provided as a 
> facility regardless of config settings.
> 
> 	Ingo
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/edac/edac_mce_amd.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux2/drivers/edac/edac_mce_amd.c
> ===================================================================
> --- linux2.orig/drivers/edac/edac_mce_amd.c
> +++ linux2/drivers/edac/edac_mce_amd.c
> @@ -405,8 +405,11 @@ void decode_mce(struct mce *m)
>  		regs.nbsh  = (u32)(m->status >> 32);
>  		regs.nbeal = (u32) m->addr;
>  		regs.nbeah = (u32)(m->addr >> 32);
> +#ifdef CONFIG_X86_HT
>  		node       = per_cpu(cpu_llc_id, m->extcpu);
> -
> +#else
> +		node	   = 0;
> +#endif
>  		amd_decode_nb_mce(node, &regs, 1);
>  		break;
>  

FWIW, this patch doesn't fix the problem for me. Amerigo Wang's does:
http://lkml.org/lkml/2009/9/15/64

-- 
Jean Delvare
