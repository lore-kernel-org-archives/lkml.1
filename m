Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYGPMIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYGPMIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYGPMIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:08:34 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:54597 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGPMId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:08:33 -0400
Message-Id: <487DAD86.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 16 Jul 2008 06:12:54 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <torvalds@linux-foundation.org>, "Max Krasnyansky" <maxk@qualcomm.com>,
       <pj@sgi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and
	redo sched domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
In-Reply-To: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 15, 2008 at  7:43 AM, in message
<1216122229-4865-1-git-send-email-maxk@qualcomm.com>, Max Krasnyansky
<maxk@qualcomm.com> wrote: 

> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 47ceac9..5166080 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -922,6 +922,13 @@ static int find_lowest_rq(struct task_struct *task)
>  		return -1; /* No targets found */
>  
>  	/*
> +	 * Only consider CPUs that are usable for migration.
> +	 * I guess we might want to change cpupri_find() to ignore those
> +	 * in the first place.
> +	 */ 
> +	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
> +
> +	/*
>  	 * At this point we have built a mask of cpus representing the
>  	 * lowest priority tasks in the system.  Now we want to elect
>  	 * the best one based on our affinity and topology.

Hi Max,
  Its still early in the morning, and I havent had my coffee yet, so what I am about to
say may be totally bogus ;)

..but, I am not sure we need to do this mask here.  If the hotcpu_notifiier is still
running (and it appears that it is) the runqueue that is taken offline will be removed
from cpupri as well.

Or perhaps I am misunderstanding the intention of "active" verses "online".  If I
understand correctly, active and online mean more or less the same thing, but
splitting it out like this allows us  to skip rebuilding the domains on every hotplug.
Is that correct?

Assuming that the above is true, and assuming that the hotcpu_notifier is
still invoked when the online status changes, cpupri will be properly updated
to exclude the offline core.  That will save an extra cpus_and (which the big-iron
guys will be happy about ;)

Regards,
-Greg


