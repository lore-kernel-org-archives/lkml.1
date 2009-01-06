Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZAFRUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZAFRUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZAFRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:19:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57310 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754203AbZAFRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:19:49 -0500
Message-ID: <496392B0.5080700@sgi.com>
Date: Tue, 06 Jan 2009 09:19:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix double kfree
References: <496326BA.60605@cn.fujitsu.com>
In-Reply-To: <496326BA.60605@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Impact: fix double kfree in failure path
> 
> It's not the responsibility of init_rootdomain() to free root_domain
> allocated by alloc_rootdomain().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 545c6fc..2bad712 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6970,7 +6970,7 @@ static int init_rootdomain(struct root_domain *rd, bool bootmem)
>  	}
>  
>  	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
> -		goto free_rd;
> +		goto out;
>  	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
>  		goto free_span;
>  	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
> @@ -6986,8 +6986,7 @@ free_online:
>  	free_cpumask_var(rd->online);
>  free_span:
>  	free_cpumask_var(rd->span);
> -free_rd:
> -	kfree(rd);
> +out:
>  	return -ENOMEM;
>  }
>  

Thanks Li!

Another thing I noticed but didn't deal with is:

static int init_rootdomain(struct root_domain *rd, bool bootmem)
{
        memset(rd, 0, sizeof(*rd));

        if (bootmem) {
                alloc_bootmem_cpumask_var(&def_root_domain.span);
                alloc_bootmem_cpumask_var(&def_root_domain.online);
                alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
                cpupri_init(&rd->cpupri, true);
                return 0;
        }
        if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
		...

Note that under the if (bootmem) case, it specifies the addresses
directly instead of using (&rd->span) as the other alloc's do.

Not a big deal, just an inconsistency.

Thanks,
Mike

