Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXFMU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXFMU4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXFMU4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:56:10 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:53974 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXFMU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=troK5Abs5kyIgL98wIhCxNBl2NFtkDSkVk0xEbr90CXxDAw/KzT+jehmG5Q6fYqBKZ2npbdhcGK0Uvsd+/OsN/d1ixUNA1GdspBNHi6Mm9I5Mk+F//ssAMzS23S5VN6feJfoGnFot56+1iyrxv1Mg4vKLmIGu/tJI9t6n/t2uEo=
Message-ID: <b647ffbd0706131356q344af13as3744c151b4a4f680@mail.gmail.com>
Date: Wed, 13 Jun 2007 22:56:06 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 5/6] core changes for group fairness
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070611155608.GE2109@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611154724.GA32435@in.ibm.com>
	 <20070611155608.GE2109@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> This patch introduces the core changes in CFS required to accomplish
> group fairness at higher levels. It also modifies load balance interface
> between classes a bit, so that move_tasks (which is centric to load
> balance) can be reused to balance between runqueues of various types
> (struct rq in case of SCHED_RT tasks, struct lrq in case of
> SCHED_NORMAL/BATCH tasks).

a few things that catched my eye, please see below:


> +static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +                     unsigned long max_nr_move, unsigned long max_load_move,
> +                     struct sched_domain *sd, enum idle_type idle,
> +                     int *all_pinned, unsigned long *load_moved,
> +                     int this_best_prio, int best_prio, int best_prio_seen,
> +                     void *iterator_arg,
> +                     struct task_struct *(*iterator_start)(void *arg),
> +                     struct task_struct *(*iterator_next)(void *arg));

IMHO, it looks a bit frightening :) maybe it would be possible to
create a structure that combines some relevant argumens .. at least,
the last 3 ones.


> -static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
>                       unsigned long max_nr_move, unsigned long max_load_move,
>                       struct sched_domain *sd, enum idle_type idle,
> -                     int *all_pinned)
> +                     int *all_pinned, unsigned long *load_moved,
> +                     int this_best_prio, int best_prio, int best_prio_seen,
> +                     void *iterator_arg,
> +                     struct task_struct *(*iterator_start)(void *arg),
> +                     struct task_struct *(*iterator_next)(void *arg))

I think, there is a possible problem here. If I'm not complete wrong,
this function (move_tasks() in the current mainline) can move more
'load' than specified by the 'max_load_move'..

as a result, e.g. in the following code :

> +static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +                     unsigned long max_nr_move, unsigned long max_load_move,
> +                     struct sched_domain *sd, enum idle_type idle,
> +                     int *all_pinned)
> +{
> +       struct sched_class *class = sched_class_highest;
> +       unsigned long load_moved, total_nr_moved = 0, nr_moved;
> +
> +       do {
> +               nr_moved = class->load_balance(this_rq, this_cpu, busiest,
> +                                       max_nr_move, max_load_move, sd, idle,
> +                                       all_pinned, &load_moved);
> +               total_nr_moved += nr_moved;
> +               max_nr_move -= nr_moved;
> +               max_load_move -= load_moved;

can become negative.. and as it's 'unsigned' --> a huge positive number..

> +               class = class->next;
> +       } while (class && max_nr_move && max_load_move);

'(long)max_load_move > 0'      ?

the same is applicable to a few other similar cases below :

> +static int
> +load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +                       unsigned long max_nr_move, unsigned long max_load_move,
> +                       struct sched_domain *sd, enum idle_type idle,
> +                       int *all_pinned, unsigned long *total_load_moved)
> +{
> +       struct lrq *busy_lrq;
> +       unsigned long load_moved, total_nr_moved = 0, nr_moved, rem_load_move;
> +
> +       rem_load_move = max_load_move;
> +
> +       for_each_leaf_lrq(busiest, busy_lrq) {
> +               struct lrq *this_lrq;
> +               long imbalance;
> +               unsigned long maxload;
> +               int this_best_prio, best_prio, best_prio_seen = 0;
> +
                    ..........
> +
> +               nr_moved = balance_tasks(this_rq, this_cpu, busiest,
> +                               max_nr_move, maxload, sd, idle, all_pinned,
> +                               &load_moved, this_best_prio, best_prio,
> +                               best_prio_seen,
> +                               /* pass busy_lrq argument into
> +                                * load_balance_[start|next]_fair iterators
> +                                */
> +                               busy_lrq,
> +                               load_balance_start_fair,
> +                               load_balance_next_fair);
> +
> +               total_nr_moved += nr_moved;
> +               max_nr_move -= nr_moved;
> +               rem_load_move -= load_moved;

here


> +
> +               /* todo: break if rem_load_move is < load_per_task */
> +               if (!max_nr_move || !rem_load_move)

'(long)rem_load_move <= 0'

and I think somewhere else in the code.


> --
> Regards,
> vatsa
>

-- 
Best regards,
Dmitry Adamushko
