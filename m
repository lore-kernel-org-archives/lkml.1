Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbXILQZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbXILQZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXILQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:25:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:42416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbXILQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OvBRYUE2oA4oQVx7QHGbLGd7TfmbUceBmtGvE0gmcLGqQ1zyupS0xyvPpG2dEZfpaUdvQOOS0x9m/P6GnFUh0gE5XsytX5Wq1PgruUwHjpkFD4Z/uc34kqso5N1P+wLHJIL/rn541MPBdA22SmkvQ8P1x9CqnjafZhDfP3m4edc=
Message-ID: <b647ffbd0709120925i690ecb11i975149037fc72979@mail.gmail.com>
Date: Wed, 12 Sep 2007 18:25:37 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Ingo Molnar" <mingo@elte.hu>, dhaval@linux.vnet.ibm.com,
       menage@google.com
In-Reply-To: <20070912114202.GA30385@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
	 <20070910102259.dc45a481.akpm@linux-foundation.org>
	 <20070910174649.GA16222@linux.vnet.ibm.com>
	 <b647ffbd0709101528i7440a0f9m9837065a43e4a720@mail.gmail.com>
	 <20070911044145.GC16222@linux.vnet.ibm.com>
	 <b647ffbd0709110253y7d9564c4j88aa134330e2a292@mail.gmail.com>
	 <20070912114202.GA30385@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

please find a few more minor comments below.

> [ ... ]
> +
> +/* destroy runqueue etc associated with a task group */
> +static void sched_destroy_group(struct container_subsys *ss,
> +                                       struct container *cont)
> +{
> +       struct task_grp *tg = container_tg(cont);
> +       struct cfs_rq *cfs_rq;
> +       struct sched_entity *se;
> +       int i;
> +
> +       for_each_possible_cpu(i) {
> +               cfs_rq = tg->cfs_rq[i];
> +               list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
> +       }
> +
> +       /* wait for possible concurrent references to cfs_rqs complete */
> +       synchronize_sched();
> +
> +       /* now it should be safe to free those cfs_rqs */
> +       for_each_possible_cpu(i) {
> +               cfs_rq = tg->cfs_rq[i];
> +               kfree(cfs_rq);
> +
> +               se = tg->se[i];
> +               kfree(se);
> +       }
> +
> +       kfree(tg);
> +}

kfree(tg->cfs_rq) && kfree(tg->se) ?


> +
> +/* change task's runqueue when it moves between groups */
> +static void sched_move_task(struct container_subsys *ss, struct container *cont,
> +                       struct container *old_cont, struct task_struct *tsk)
> +{
> +       int on_rq, running;
> +       unsigned long flags;
> +       struct rq *rq;
> +
> +       rq = task_rq_lock(tsk, &flags);
> +
> +       if (tsk->sched_class != &fair_sched_class)
> +               goto done;

this check should be redundant now with sched_can_attach() in place.


> +static void set_se_shares(struct sched_entity *se, unsigned long shares)
> +{
> +       struct cfs_rq *cfs_rq = se->cfs_rq;
> +       struct rq *rq = cfs_rq->rq;
> +       int on_rq;
> +
> +       spin_lock_irq(&rq->lock);
> +
> +       on_rq = se->on_rq;
> +       if (on_rq)
> +               __dequeue_entity(cfs_rq, se);
> +
> +       se->load.weight = shares;
> +       se->load.inv_weight = div64_64((1ULL<<32), shares);

A bit of nit-picking... are you sure, there is no need in non '__'
versions of dequeue/enqueu() here (at least, for the sake of
update_curr())? Although, I don't have -mm at hand at this very moment
and original -rc4 (that I have at hand) doesn't already have
'se->load' at all... so will look later.

>
> --
> Regards,
> vatsa
>


-- 
Best regards,
Dmitry Adamushko
