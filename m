Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYCNR4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYCNR4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYCNR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:56:25 -0400
Received: from gw.goop.org ([64.81.55.164]:35642 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYCNR4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:56:24 -0400
Message-ID: <47DABBCE.5010803@goop.org>
Date: Fri, 14 Mar 2008 10:54:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: per cpun+ spin locks coexistence?
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
In-Reply-To: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> Help me out this one - in fs/file.c, there is a function free_fdtable_rcu():
>
> void free_fdtable_rcu(struct rcu_head *rcu)
> {
>        struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
>        struct fdtable_defer *fddef;
>
>        BUG_ON(!fdt);
>
>        if (fdt->max_fds <= NR_OPEN_DEFAULT) {
>                /*
>                 * This fdtable is embedded in the files structure and that
>                 * structure itself is getting destroyed.
>                 */
>                kmem_cache_free(files_cachep,
>                                container_of(fdt, struct files_struct,
> fdtab));
>                return;
>        }
>        if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
>                kfree(fdt->fd);
>                kfree(fdt->open_fds);
>                kfree(fdt);
>        } else {
>                fddef = &get_cpu_var(fdtable_defer_list);
>                spin_lock(&fddef->lock);
>                fdt->next = fddef->next;
>                fddef->next = fdt;
>                /* vmallocs are handled from the workqueue context */
>                schedule_work(&fddef->wq);
>                spin_unlock(&fddef->lock);
>                put_cpu_var(fdtable_defer_list);
>        }
> }
>
> Notice above that get_cpu_var() is followed by spin_lock().   Does this
> make sense?   get_cpu_var() will return a variable that is only
> accessible by the current CPU - guaranteed it will not be touch (read or
> write) by another CPU, right? 

No, not true.  percpu is for stuff which is generally only touched by 
one CPU, but there's nothing stopping other processors from accessing it 
with per_cpu(var, cpu).

Besides, the lock isn't locking the percpu list head, but the thing on 
the head of the list, presumably to prevent races with the workqueue.  
(Though the list structure is nonstandard, so its not completely clear.)

    J
