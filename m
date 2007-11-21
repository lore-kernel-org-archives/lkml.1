Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbXKUEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbXKUEQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXKUEQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:16:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXKUEQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:16:08 -0500
Message-ID: <4743B0F4.8000302@redhat.com>
Date: Tue, 20 Nov 2007 23:15:48 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix optimized search
References: <20071121021057.GA24815@goodmis.org> <20071121030838.16020.59975.stgit@novell1.haskins.net>
In-Reply-To: <20071121030838.16020.59975.stgit@novell1.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> I spied a few more issues from http://lkml.org/lkml/2007/11/20/590.
> 
> Patch is below..

Thanks, but I have one update...

> 
> Regards,
> -Greg
> 
> -----------------
> 
> Include cpu 0 in the search, and eliminate the redundant cpu_set since
> the bit should already be set in the mask.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched_rt.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 28feeff..fbf4fb1 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -297,7 +297,7 @@ static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
>  static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
>  {
>  	int       lowest_prio = -1;
> -	int       lowest_cpu  = 0;
> +	int       lowest_cpu  = -1;
>  	int       count       = 0;
>  	int       cpu;
>  
> @@ -319,7 +319,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
>  			 * and the count==1 will cause the algorithm
>  			 * to use the first bit found.
>  			 */
> -			if (lowest_cpu) {
> +			if (lowest_cpu != -1) {
>  				cpus_clear(*lowest_mask);
>  				cpu_set(rq->cpu, *lowest_mask);
>  			}
> @@ -335,7 +335,6 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
>  				lowest_cpu = cpu;
>  				count = 0;
>  			}
> -			cpu_set(rq->cpu, *lowest_mask);
>  			count++;
>  		} else
>  			cpu_clear(cpu, *lowest_mask);
> @@ -346,7 +345,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
>  	 * runqueues that were of higher prio than
>  	 * the lowest_prio.
>  	 */
> -	if (lowest_cpu) {
> +	if (lowest_cpu != -1) {

We can change this to

   if (lowest_cpu > 0) {

because if lowest_cpu == 0, we don't need to bother with clearing any bits.

I'll apply this next.

Thanks.

-- Steve

>  		/*
>  		 * Perhaps we could add another cpumask op to
>  		 * zero out bits. Like cpu_zero_bits(cpumask, nrbits);
> 

