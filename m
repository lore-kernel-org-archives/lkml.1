Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZIVKKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZIVKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZIVKKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:10:44 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:35707 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZIVKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:10:44 -0400
Date: Tue, 22 Sep 2009 15:40:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] fix error handling in load_module()
Message-ID: <20090922101046.GA8316@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org> <4AB79091.1050004@kernel.org> <200909221435.22512.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200909221435.22512.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell <rusty@rustcorp.com.au> [2009-09-22 14:35:21]:

> On Tue, 22 Sep 2009 12:11:21 am Tejun Heo wrote:
> > Hello, Andrew.
> > 
> > Andrew Morton wrote:
> > > My reverse engineering of the secret, undocumented percpu_modfree()
> > > indicates that its mad inventor intended that percpu_modfree(NULL) be a
> > > valid thing to do.
> > > 
> > > It calls free_percpu(), all implementations of which appear to secretly
> > > support free_percpu(NULL).
> > 
> > Eh... unfortunately, the original percpu_modfree() implementation
> > didn't seem to support it.
> 
> OK, I'll Andrew's fix for Tejun, and after his (spot-on!) comment about
> percpu_modfree never taking NULL, I've fixed the one caller to match
> the other two:
> 
> Subject: module: don't call percpu_modfree on NULL pointer.
> 
> The general one handles NULL, the static obsolescent
> (CONFIG_HAVE_LEGACY_PER_CPU_AREA) one in module.c doesn't; Eric's
> commit 720eba31 assumed it did, and various frobbings since then kept
> that assumption.
> 
> All other callers in module.c all protect it with an if; this effectively
> does the same as free_init is only goto if we fail percpu_modalloc().

Thanks, the patch fixes the issue.

> Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Américo Wang <xiyou.wangcong@gmail.com>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2522,8 +2522,8 @@ static noinline struct module *load_modu
>   free_unload:
>  	module_unload_free(mod);
>  #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> +	percpu_modfree(mod->refptr);
>   free_init:
> -	percpu_modfree(mod->refptr);
>  #endif
>  	module_free(mod, mod->module_init);
>   free_core:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
			
			Kamalesh
