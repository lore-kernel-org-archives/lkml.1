Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYCPQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYCPQad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYCPQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:30:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:60027 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYCPQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jKV1ipnN6j6bDqJEPxKAV/p1DThpzItCxlGljfZj/Iq00YZuR4xmB4f2x9C+ZKYs7waQSuQCzp+X9bRGS5dI3oNfa/SzjaKqqZ8/8J9VgoWV3OjDOWH20C6kZGjxSTiqVoEDaoYADQMSSADR76dqmQfD7GEzjGS52lxikSqnveI=
Message-ID: <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>
Date: Mon, 17 Mar 2008 00:30:23 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: per cpun+ spin locks coexistence?
Cc: LKML <linux-kernel@vger.kernel.org>, "Tejun Heo" <htejun@gmail.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>
In-Reply-To: <47DABBCE.5010803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
	 <47DABBCE.5010803@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the answer.   But I still don't get it.

On Sat, Mar 15, 2008 at 1:54 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> Peter Teoh wrote:
>  > Help me out this one - in fs/file.c, there is a function free_fdtable_rcu():
>  >
>  > void free_fdtable_rcu(struct rcu_head *rcu)
>  > {
>  >        struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
>  >        struct fdtable_defer *fddef;
>  >
>  >        BUG_ON(!fdt);
>  >
>  >        if (fdt->max_fds <= NR_OPEN_DEFAULT) {
>  >                /*
>  >                 * This fdtable is embedded in the files structure and that
>  >                 * structure itself is getting destroyed.
>  >                 */
>  >                kmem_cache_free(files_cachep,
>  >                                container_of(fdt, struct files_struct,
>  > fdtab));
>  >                return;
>  >        }
>  >        if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
>  >                kfree(fdt->fd);
>  >                kfree(fdt->open_fds);
>  >                kfree(fdt);
>  >        } else {
>  >                fddef = &get_cpu_var(fdtable_defer_list);
>  >                spin_lock(&fddef->lock);
>  >                fdt->next = fddef->next;
>  >                fddef->next = fdt;
>  >                /* vmallocs are handled from the workqueue context */
>  >                schedule_work(&fddef->wq);
>  >                spin_unlock(&fddef->lock);
>  >                put_cpu_var(fdtable_defer_list);
>  >        }
>  > }
>  >
>  > Notice above that get_cpu_var() is followed by spin_lock().   Does this
>  > make sense?   get_cpu_var() will return a variable that is only
>  > accessible by the current CPU - guaranteed it will not be touch (read or
>  > write) by another CPU, right?
>
>  No, not true.  percpu is for stuff which is generally only touched by
>  one CPU, but there's nothing stopping other processors from accessing it
>  with per_cpu(var, cpu).

get_cpu_var() above, will return a ptr specific for a particular CPU
only, is correct?

#define get_cpu_var(var) (*({                           \
        extern int simple_identifier_##var(void);       \
        preempt_disable();                              \
        &__get_cpu_var(var); }))

SMP:

#define __get_cpu_var(var) \
        (*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))

#define SHIFT_PERCPU_PTR(__p, __offset) RELOC_HIDE((__p), (__offset))

and RELOC_HIDE() i don't understand.   So from what u said,
per_cpu_var() returns uniquely for each CPU, but __get_cpu_var() may
not be unique among the different CPU - is that correct?

When cpuA and cpuB call get_cpu_var(), the returned ptr is specific
only for cpuA and cpuB, right?   So yes, as u said, different cpu can
call get_cpu_var(), but the returned ptr will be unique to each cpu,
therefore it is guaranteed that another CPU will not get hold of the
returned results of get_cpu_var(), right?   So why spin_lock() comes
after get_cpu_var()?

>
>  Besides, the lock isn't locking the percpu list head, but the thing on
>  the head of the list, presumably to prevent races with the workqueue.

I think I have something much deeper to learn.   Can u point me to
some resources to read more about this?
I don't understand the difference betw locking the percpu list head,
and locking things on the head of the list.   For me, spin_lock() is
always to apply on ANY global variable - so that another cpu will
block when access to it is attempted - whether it is items on a list,
ot head of the list etc.

>  (Though the list structure is nonstandard, so its not completely clear.)
>
>     J

Thank you in advance for the all the help rendered, :=).

-- 
Regards,
Peter Teoh
