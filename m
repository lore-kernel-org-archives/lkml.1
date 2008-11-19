Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYKSBd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYKSBd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYKSBdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:33:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33195 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYKSBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:33:49 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 20:33:49 EST
X-IronPort-AV: E=McAfee;i="5300,2777,5438"; a="13282005"
Message-ID: <49236AB3.4040708@qualcomm.com>
Date: Tue, 18 Nov 2008 17:24:03 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix regression when failed to generate sched
 domains
References: <49225A5B.6080103@cn.fujitsu.com>
In-Reply-To: <49225A5B.6080103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> When cpuset failed to generate sched domains due to kmalloc()
> failure, the scheduler should fallback to the single partition
> 'fallback_doms' and rebuild sched domains, but now it only
> destroys but not rebuilds sched domains.
> 
> The regression is introduced by:
> 
> commit dfb512ec4834116124da61d6c1ee10fd0aa32bd6
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Fri Aug 29 13:11:41 2008 -0700
> 
>     sched: arch_reinit_sched_domains() must destroy domains to force rebuild
> 
> After the above commit, partition_sched_domains(0, NULL, NULL) will
> only destroy sched domains and partition_sched_domains(1, NULL, NULL)
> will create the default sched domain.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks good to me. Thanx for the fix.

Max



> ---
> 
> Should I also CC stable for 2.6.27.xx ?
> 
> ---
>  kernel/cpuset.c |   12 ++++++++----
>  kernel/sched.c  |   13 +++++++------
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3e00526..81fc679 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -587,7 +587,6 @@ static int generate_sched_domains(cpumask_t **domains,
>  	int ndoms;		/* number of sched domains in result */
>  	int nslot;		/* next empty doms[] cpumask_t slot */
>  
> -	ndoms = 0;
>  	doms = NULL;
>  	dattr = NULL;
>  	csa = NULL;
> @@ -674,10 +673,8 @@ restart:
>  	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
>  	 */
>  	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
> -	if (!doms) {
> -		ndoms = 0;
> +	if (!doms)
>  		goto done;
> -	}
>  
>  	/*
>  	 * The rest of the code, including the scheduler, can deal with
> @@ -732,6 +729,13 @@ restart:
>  done:
>  	kfree(csa);
>  
> +	/*
> +	 * Fallback to the default domain if kmalloc() failed.
> +	 * See comments in partition_sched_domains().
> +	 */
> +	if (doms == NULL)
> +		ndoms = 1;
> +
>  	*domains    = doms;
>  	*attributes = dattr;
>  	return ndoms;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c94baf2..9b1e793 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7789,13 +7789,14 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
>   *
>   * The passed in 'doms_new' should be kmalloc'd. This routine takes
>   * ownership of it and will kfree it when done with it. If the caller
> - * failed the kmalloc call, then it can pass in doms_new == NULL,
> - * and partition_sched_domains() will fallback to the single partition
> - * 'fallback_doms', it also forces the domains to be rebuilt.
> + * failed the kmalloc call, then it can pass in doms_new == NULL &&
> + * ndoms_new == 1, and partition_sched_domains() will fallback to
> + * the single partition 'fallback_doms', it also forces the domains
> + * to be rebuilt.
>   *
> - * If doms_new==NULL it will be replaced with cpu_online_map.
> - * ndoms_new==0 is a special case for destroying existing domains.
> - * It will not create the default domain.
> + * If doms_new == NULL it will be replaced with cpu_online_map.
> + * ndoms_new == 0 is a special case for destroying existing domains,
> + * and it will not create the default domain.
>   *
>   * Call with hotplug lock held
>   */

