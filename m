Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJ0WCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJ0WCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYJ0WB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:01:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbYJ0WBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:01:55 -0400
Date: Mon, 27 Oct 2008 14:55:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: heiko.carstens@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
 schedule_on_each_cpu()
Message-Id: <20081027145509.ebffcf0e.akpm@linux-foundation.org>
In-Reply-To: <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	<2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	<20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 00:00:17 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Heiko,
> 
> > >> I think the following part of your patch:
> > >>
> > >>> diff --git a/mm/swap.c b/mm/swap.c
> > >>> index fee6b97..bc58c13 100644
> > >>> --- a/mm/swap.c
> > >>> +++ b/mm/swap.c
> > >>> @@ -278,7 +278,7 @@ void lru_add_drain(void)
> > >>>       put_cpu();
> > >>>  }
> > >>>
> > >>> -#ifdef CONFIG_NUMA
> > >>> +#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
> > >>>  static void lru_add_drain_per_cpu(struct work_struct *dummy)
> > >>>  {
> > >>>       lru_add_drain();
> > >>
> > >> causes this (allyesconfig on s390):
> > >
> > > hm,
> > >
> > > I don't think so.
> > >
> > > Actually, this patch has
> > >   mmap_sem -> lru_add_drain_all() dependency.
> > >
> > > but its dependency already exist in another place.
> > > example,
> > >
> > >  sys_move_pages()
> > >      do_move_pages()  <- down_read(mmap_sem)
> > >          migrate_prep()
> > >               lru_add_drain_all()

Can we fix that instead?

> ...
>
> It because following three circular locking dependency.
> 
> Some VM place has
>       mmap_sem -> kevent_wq via lru_add_drain_all()
> 
> net/core/dev.c::dev_ioctl()  has
>      rtnl_lock  ->  mmap_sem        (*) the ioctl has copy_from_user() and it can do page fault.
> 
> linkwatch_event has
>      kevent_wq -> rtnl_lock
> 
> 
> Actually, schedule_on_each_cpu() is very problematic function.
> it introduce the dependency of all worker on keventd_wq, 
> but we can't know what lock held by worker in kevend_wq because
> keventd_wq is widely used out of kernel drivers too.
> 
> So, the task of any lock held shouldn't wait on keventd_wq.
> Its task should use own special purpose work queue.
> 

Or we change the callers of lru_add_drain_all() to call it without
holding any locks.  I mean, what's the *point* in calling it with
mmap_sem held?  That won't stop threads from adding new pages into the
pagevecs.


>  #endif
> +
> +	vm_wq = create_workqueue("vm_work");
> +	BUG_ON(!vm_wq);
> +
>  }

Because it's pretty sad to add yet another kernel thread on each CPU
(thousands!) just because of some obscure theoretical deadlock in
page-migration and memory-hotplug.  Most people don't even use those.


