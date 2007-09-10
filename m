Return-Path: <linux-kernel-owner+w=401wt.eu-S965436AbXIJW3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbXIJW3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXIJW2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:28:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:15790 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXIJW2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VP522nYu0QxUOlKRZzxJCLPFZdnxmPmAy+2S5MmZrt/VWOYSIlBTSPgoaJvKDTzzKpbKed5wsJky5r+IG0oY3zx2u0ZkkQFREaBcc0Ma8h/z4fihNG5vNJaLcvE55kBCaVecZCN5otHimCMGX0maaDhnu+0WxQkAz5LzEikB7Ug=
Message-ID: <b647ffbd0709101528i7440a0f9m9837065a43e4a720@mail.gmail.com>
Date: Tue, 11 Sep 2007 00:28:51 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070910174649.GA16222@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
	 <20070910102259.dc45a481.akpm@linux-foundation.org>
	 <20070910174649.GA16222@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2007, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> On Mon, Sep 10, 2007 at 10:22:59AM -0700, Andrew Morton wrote:
> > objection ;)  "cpuctlr" isn't memorable.  Kernel code is write-rarely,
> > read-often.  "cpu_controller", please.  The extra typing is worth it ;)
>
> Ok! Here's the modified patch (against 2.6.23-rc4-mm1).
>
> [ ... ]
>
> +/* change task's runqueue when it moves between groups */
> +static void sched_move_task(struct container_subsys *ss, struct container *cont,
> +                       struct container *old_cont, struct task_struct *tsk)
> +{
> +       int on_rq;
> +       unsigned long flags;
> +       struct rq *rq;
> +
> +       rq = task_rq_lock(tsk, &flags);
> +

I guess, update_rq_clock(rq) should be placed here.

humm... do you really need deactivate/activate_task() here? 'rq' and
p->se.load.weight stay unchanged so enqueue/dequeue_task() would do a
job, no?
Although, I might be missing (definitely, as this part is not
completely clear to me yet) something important at this late hour :)


> +       on_rq = tsk->se.on_rq;
> +       if (on_rq)
> +               deactivate_task(rq, tsk, 0);
> +
> +       if (unlikely(rq->curr == tsk) && tsk->sched_class == &fair_sched_class)
> +               tsk->sched_class->put_prev_task(rq, tsk);
> +
> +       set_task_cfs_rq(tsk);
> +
> +       if (on_rq)
> +                activate_task(rq, tsk, 0);
> +
> +       if (unlikely(rq->curr == tsk) && tsk->sched_class == &fair_sched_class)
> +               tsk->sched_class->set_curr_task(rq);
> +
> +       task_rq_unlock(rq, &flags);
> +}
> +


-- 
Best regards,
Dmitry Adamushko
