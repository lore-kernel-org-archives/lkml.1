Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZBDJlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZBDJlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZBDJln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:41:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50346 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZBDJlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:41:42 -0500
Date: Wed, 4 Feb 2009 18:40:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Swamy Gowda" <swamy@virident.com>, <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org, Brice.Goglin@inria.fr
Subject: Re: Need to take mmap_sem lock in move_pages.
Message-Id: <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
	<20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 18:36:00 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 4 Feb 2009 01:02:35 -0800
> "Swamy Gowda" <swamy@virident.com> wrote:
> 
> > Hi,
> > 
> >  
> > 
> > I believe that migrate_pages related race conditions were fixed as part
> > of rcu_read_lock in unmap_and_move. But it seems we are still taking the
> > mmap_sem lock in do_move_pages function, is this really required? If it
> > is so why it is not needed in hot remove path? 
> > 
> 
> Hmm , CC: to Christoph and Brice.
> 
> My understanding is following.
> 
>  1. do_move_page_to_node_array() at el. needs mmap_sem (read-side) because it
>     scans page table and vma. While we have to scan vmas to find pages for
>     migration, it needs mmap_sem.
> 
>     So, this part,
>     == do_move_page_to_node_array()
>  903         err = 0;
>  904         if (!list_empty(&pagelist))
>  905                 err = migrate_pages(&pagelist, new_page_node,
>  906                                 (unsigned long)pm);
>  907 
>  908         up_read(&mm->mmap_sem);
>    ==
>    can be
>    ==
>  903         err = 0;
>  904         up_read(&mm->mmap_sem);
>  905         if (!list_empty(&pagelist))
>  906                 err = migrate_pages(&pagelist, new_page_node,
>  907                                 (unsigned long)pm);
>  908 
>     ==
>    ?
> 
>    But, by above move of semaphore, reliability of  sys_migrate_page() goes down.
>    Assume 2 threads. Thread1 calls sys_move_pages(), thread2 does page fault,
>    touches pte under migraton.
>    ==
>        Thread 1                    Thread2                 
> 
>        up_read(&mm->mmap_sem)
>                                     page fault => map new page.
>        end of migration.
>     ==
> 

      please ignore following ;( Sigh..
      Maybe up_read() can be moved before do_migrate_pages(), I think.

Sorry.
-kame

