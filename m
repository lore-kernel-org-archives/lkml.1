Return-Path: <linux-kernel-owner+w=401wt.eu-S1764253AbXJTQpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764253AbXJTQpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXJTQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:45:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:45860 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbXJTQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BNUtHm4I2USrY0XIc3PstijvAyUL+srsr+OpwPGJucxiTPlqLBfuJSypaBuHfvqDrBhvy4oNXZruQLj4JNz8g9iy54L6sqSRaPHkiC/efLEJlkz/90W5SdFJJN3CEz5NanQcrrbQ8smRX3oinRu+u3SBm8ALjfjEcgdgJBVusuQ=
Message-ID: <b647ffbd0710200945p2bb87d7fk1110bdcf56f6218d@mail.gmail.com>
Date: Sat, 20 Oct 2007 18:45:12 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [patch 1/8] Add rt_nr_running accounting
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071019184336.195447315@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.195447315@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/2007, Steven Rostedt <rostedt@goodmis.org> wrote:
> [ ... ]
> Index: linux-test.git/kernel/sched.c
> ===================================================================
> --- linux-test.git.orig/kernel/sched.c  2007-10-19 12:32:39.000000000 -0400
> +++ linux-test.git/kernel/sched.c       2007-10-19 12:33:09.000000000 -0400
> @@ -300,6 +300,8 @@ struct rq {
>          */
>         unsigned long nr_uninterruptible;
>
> +       unsigned long rt_nr_running;

could it be a part of the 'struct rt_rq' instead?

>
> +static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
> +{
> +       if (rt_task(p))
> +               rq->rt_nr_running++;
> +}
> +
> +static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
> +{
> +       if (rt_task(p)) {
> +               WARN_ON(!rq->rt_nr_running);
> +               rq->rt_nr_running--;
> +       }
> +}
> +
>  static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
>  {
>         struct rt_prio_array *array = &rq->rt.active;
>
>         list_add_tail(&p->run_list, array->queue + p->prio);
>         __set_bit(p->prio, array->bitmap);
> +
> +       inc_rt_tasks(p, rq);

why do you need the rt_task(p) check in {inc,dec}_rt_tasks() ?

{enqueue,dequeue}_task_rt() seem to be the only callers and they will
crash (or corrupt memory) anyway in the case of ! rt_task(p) (sure,
this case would mean something is broken somewhere wrt sched_class
handling).


-- 
Best regards,
Dmitry Adamushko
