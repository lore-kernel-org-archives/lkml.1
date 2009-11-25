Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZKYJv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZKYJv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbZKYJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:51:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:49377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZKYJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:51:55 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259132226.20897.22.camel@marge.simson.net>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
	 <1259082449.15249.90.camel@marge.simson.net>
	 <1259084140.4531.1710.camel@laptop>  <1259085280.4531.1730.camel@laptop>
	 <1259086901.15249.121.camel@marge.simson.net>
	 <1259087245.4531.1767.camel@laptop>
	 <1259132226.20897.22.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 10:51:59 +0100
Message-ID: <1259142719.4027.228.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 07:57 +0100, Mike Galbraith wrote:

>         update_curr(cfs_rq);
> +
> +       if (is_same_group(se, pse)) {
> +               se->vruntime = pse->vruntime;
> +
> +               /*
> +                * If we're not sharing a runqueue, redo the child's vruntime
> +                * offset after accounting for any yet to be booked vruntime.
> +                */
> +               if (this_cpu != task_cpu(p)) {
> +                       struct cfs_rq *old_cfs_rq = cfs_rq_of(pse);
> +                       u64 now = cpu_rq(this_cpu)->clock;
> +                       unsigned long delta_exec = now - pse->exec_start;
> +
> +                       delta_exec = calc_delta_fair(delta_exec, se);
> +                       se->vruntime += delta_exec;
> +                       se->vruntime -= old_cfs_rq->min_vruntime -
> +                                               cfs_rq->min_vruntime;
> +               }
> +       }
> +
>         place_entity(cfs_rq, se, 1); 

/me got his head in a twist..

 - is_same_group() assumes both things are on the same cpu and will
   fail (for the group configs) when this is not so.

 - if we're not on the same cpu, update_curr() will have updated current
   on the target cpu, but the parent vruntime will still be stale.

 - when all is said and done, place_entity(.initial=1) will do:
    ->vruntime = max(min_vruntime + debit, ->vruntime)
   which ought to place a new task far enough ahead in any case...



