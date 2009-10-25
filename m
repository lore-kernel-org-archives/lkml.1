Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZJYIBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZJYIBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZJYIBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:01:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:58141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZJYIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:01:34 -0400
Subject: Re: [PATCH 2/3] sched: Add aggressive load balancing for certain
 situations
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091024130432.0c46ef27@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 09:01:26 +0100
Message-Id: <1256457686.7356.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 13:04 -0700, Arjan van de Ven wrote:
> Subject: sched: Add aggressive load balancing for certain situations
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The scheduler, in it's "find idlest group" function currently has an unconditional
> threshold for an imbalance, before it will consider moving a task.
> 
> However, there are situations where this is undesireable, and we want to opt in to a
> more aggressive load balancing algorithm to minimize latencies.
> 
> This patch adds the infrastructure for this and also adds two cases for which
> we select the aggressive approach
> 1) From interrupt context. Events that happen in irq context are very likely,
>    as a heuristic, to show latency sensitive behavior
> 2) When doing a wake_up() and the scheduler domain we're investigating has the
>    flag set that opts in to load balancing during wake_up()
>    (for example the SMT/HT domain)
> 
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 4e777b4..fe9b95b 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1246,7 +1246,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>   */
>  static struct sched_group *
>  find_idlest_group(struct sched_domain *sd, struct task_struct *p,
> -		  int this_cpu, int load_idx)
> +		  int this_cpu, int load_idx, int agressive)
>  {

can't we fold that into load_idx? like -1 or something?

