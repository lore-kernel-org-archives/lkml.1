Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZBDJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZBDJh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBDJhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:37:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46554 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZBDJhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:37:14 -0500
Date: Wed, 4 Feb 2009 18:36:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Swamy Gowda" <swamy@virident.com>
Cc: <linux-kernel@vger.kernel.org>, cl@linux-foundation.org,
       Brice.Goglin@inria.fr
Subject: Re: Need to take mmap_sem lock in move_pages.
Message-Id: <20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 01:02:35 -0800
"Swamy Gowda" <swamy@virident.com> wrote:

> Hi,
> 
>  
> 
> I believe that migrate_pages related race conditions were fixed as part
> of rcu_read_lock in unmap_and_move. But it seems we are still taking the
> mmap_sem lock in do_move_pages function, is this really required? If it
> is so why it is not needed in hot remove path? 
> 

Hmm , CC: to Christoph and Brice.

My understanding is following.

 1. do_move_page_to_node_array() at el. needs mmap_sem (read-side) because it
    scans page table and vma. While we have to scan vmas to find pages for
    migration, it needs mmap_sem.

    So, this part,
    == do_move_page_to_node_array()
 903         err = 0;
 904         if (!list_empty(&pagelist))
 905                 err = migrate_pages(&pagelist, new_page_node,
 906                                 (unsigned long)pm);
 907 
 908         up_read(&mm->mmap_sem);
   ==
   can be
   ==
 903         err = 0;
 904         up_read(&mm->mmap_sem);
 905         if (!list_empty(&pagelist))
 906                 err = migrate_pages(&pagelist, new_page_node,
 907                                 (unsigned long)pm);
 908 
    ==
   ?

   But, by above move of semaphore, reliability of  sys_migrate_page() goes down.
   Assume 2 threads. Thread1 calls sys_move_pages(), thread2 does page fault,
   touches pte under migraton.
   ==
       Thread 1                    Thread2                 

       up_read(&mm->mmap_sem)
                                    page fault => map new page.
       end of migration.
    ==

    What a user expects is move all pages within [start, end) moves to nodes specified.
    And, if the page doesn't exist, "err = -ENOENT" is set to status buffer.

    But, in above case, the page exists but not in place the user expected.
    So, there are trade offs.

    Pros.
     up_read(&mmap_sem) before migration will reduce period of lock.
    Cons.
     sys_migrate_pages() at el. are not atomic anymore and return code is not
     reliable.

 2. memory hotplug's migrate_page() finds the page by physical memory's memmap.
    NO scans to any mm_struct or vmas. So, not necessary to take mmap_sem.
    (The logic is same as to vmscan.c's logic)
    It also moves pages which is not mapped.

Thanks,
-Kame


