Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZCSQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZCSQyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZCSQyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:54:07 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52359 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZCSQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:54:04 -0400
Date: Thu, 19 Mar 2009 22:25:17 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 6/6] sched: Fix sd_parent_degenerate for
	SD_POWERSAVINGS_BALANCE.
Message-ID: <20090319165517.GN2990@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092248.24787.38811.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090318092248.24787.38811.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:48]:

> Currently a sched_domain having a single group can be prevented from getting
> degenerated if it contains a SD_POWERSAVINGS_BALANCE flag. But since it has
> only one group, it won't have any scope for performing powersavings balance as
> it does not have a sibling group to pull from.
> 
> Apart from not provide any powersavings, it also fails to participate
> in normal load-balancing.
> 
> Fix this by allowing such a sched_domain to degenerate and pass on the
> responsibility of performing the POWERSAVINGS_BALANCE to it's parent domain.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 651550c..0e7882a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6970,6 +6970,20 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
>  				SD_SHARE_PKG_RESOURCES);
>  		if (nr_node_ids == 1)
>  			pflags &= ~SD_SERIALIZE;
> +
> +		/*
> +		 * If the only flag that is preventing us from degenerating
> +		 * a domain with a single group is SD_POWERSAVINGS_BALANCE
> +		 * check if it can be transferred to the new parent,
> +		 * and degenerate this domain. With a single
> +		 * group, it anyway can't contribute to power-aware load
> +		 * balancing.
> +		 */
> +		if (pflags & SD_POWERSAVINGS_BALANCE && parent->parent) {
> +			pflags &= ~SD_POWERSAVINGS_BALANCE;
> +			parent->parent->flags |=
> +				sd_power_saving_flags(parent->level);
> +		}
>  	}
>  	if (~cflags & pflags)
>  		return 0;
> 

Nice concise patch that meets the objective.

So you are not able to add SD_POWERSAVINGS_BALANCE to the list of
flags needing more than 1 group because you need to pass the flag to
parent (if exist) while the rest of the flags are just cleared since
they are irrelevant.

Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

