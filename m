Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbYEOOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbYEOOn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEOOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:43:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40289 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbYEOOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:43:17 -0400
Date: Thu, 15 May 2008 20:22:15 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, npiggin@suse.de, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched: Improve readability in update_cpu_load() code
Message-ID: <20080515145215.GD14823@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080515130459.GA9650@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515130459.GA9650@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:34:59PM +0530, Gautham R Shenoy wrote:
> Author: Gautham R Shenoy <ego@in.ibm.com>
> Date:   Thu May 15 17:55:49 2008 +0530
> 
>     sched: Improve readability in update_cpu_load() code
>     
>     Currently the cpu_load[i] is calculated as:
>     	this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
>     
>     However, since scale = 2^i, this can be simplified as:
>     	this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);
>     
>     Makes it easier to read.
>     Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2d7d8f1..e1a6985 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2921,7 +2921,7 @@ static void update_cpu_load(struct rq *this_rq)
>  		 */
>  		if (new_load > old_load)
>  			new_load += scale-1;
> -		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
> +		this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);

This wont work when new_load < old_load ..

For ex: I tried this prog:

#include <stdio.h>

main()
{
	unsigned long old_load = 100, new_load = 90, this_load, this_load1;
	int i = 1, scale = 2 << i;

	this_load = (old_load*(scale-1) + new_load) >> i;
	this_load1 = old_load + ((new_load - old_load) >> i);

	printf ("this_load = %u, this_load1 = %u \n", this_load, this_load1);
}

This is what I get:

$ ./a.out
this_load = 195, this_load1 = 2147483743
$

	

-- 
Regards,
vatsa
