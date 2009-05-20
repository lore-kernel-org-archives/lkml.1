Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZETH7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZETH7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZETH7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:59:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:59800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZETH7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:59:45 -0400
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200905191356.37071.mark.langsdorf@amd.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
	 <200905071000.14038.mark.langsdorf@amd.com>
	 <200905081203.55484.mark.langsdorf@amd.com>
	 <200905191356.37071.mark.langsdorf@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 09:59:46 +0200
Message-Id: <1242806386.26820.549.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 13:56 -0500, Mark Langsdorf wrote:
> @@ -1947,6 +1947,11 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>         return delta < (s64)sysctl_sched_migration_cost;
>  }
>  
> +void set_task_delay(struct task_struct *p, unsigned int delay)
> +{
> +       p->se.vruntime += delay;
> +}
> +EXPORT_SYMBOL(set_task_delay);

That's broken, you cannot assume that a task is SCHED_OTHER like that.

Furthermore, you cannot simply change vruntime of any odd task, this
only works for current. Also, you really need to call schedule() after
doing this for it to have any immediate effect.

Also, if you mean delay to be ns, you need to scale it. Furthermore, I
would really really want to export this as GPL only (ok, preferably not
at all).

That said, I still thoroughly dislike this whole approach.


/*
 * Dumb broken yield like interface -- use at your own peril and know
 * RT people will hate you.
 *
 * Like yield, except for SCHED_OTHER/BATCH, where it will give up @ns
 * time for the 'good' cause.
 */
void sched_delay_yield(unsigned long ns)
{
	struct task_struct *curr = current;

	if (curr->sched_class == &fair_sched_class) {
		struct sched_entity *se = &curr->se;
		__update_curr(cfs_rq_of(se), se, ns);
		schedule();
		/* XXX: task accounting ? */
	} else
		sched_yield();
}
EXPORT_SYMBOL_GPL(sched_delay_yield);
