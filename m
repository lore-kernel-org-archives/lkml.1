Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYFSICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYFSICS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYFSIB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:01:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38289 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYFSIB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:01:57 -0400
Date: Thu, 19 Jun 2008 17:00:59 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Message-Id: <20080619170059.60b42e73.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080618205540.11a1644b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
	<20080618184000.a855dfe0.kamezawa.hiroyu@jp.fujitsu.com>
	<20080618195009.37BF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080618205540.11a1644b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > -		unlock = putback_lru_page(newpage);
> > > +		putback_lru_page(newpage);
> > >  	} else
> > >  		newpage->mapping = NULL;
> > 
> > originally move_to_lru() called in unmap_and_move().
> > unevictable infrastructure patch move to this point for 
> > calling putback_lru_page() under page locked.
> > 
> > So, your patch remove page locked dependency.
> > move to unmap_and_move() again is better.
> > 
> > it become page lock holding time reducing.
> > 
> ok, will look into again.
> 

I agree with Kosaki-san.

And VM_BUG_ON(page_count(newpage) != 1) in unmap_and_move()
is not correct again, IMHO.
I got this BUG actually when testing this patch(with
migratin_entry_wait fix).

unmap_and_move()
	move_to_new_page()
		migrate_page()
		remove_migration_ptes()
		putback_lru_page()			(*1)
	  :
        if (!newpage->mapping)				(*2)
		VM_BUG_ON(page_count(newpage) != 1)

If a anonymous page(without mapping) is migrated successfully,
this page is moved back to lru by putback_lru_page()(*1),
and the page count becomes 1(pte only).

At the same time(between *1 and *2), if the process
that owns this page are freeing this page, the page count
becomes 0 and ->mapping becomes NULL by free_hot_cold_page(),
so this BUG is caused.

I've not seen this BUG on real HW yet(seen twice on fake-numa
hvm guest of Xen), but I think it can happen theoretically.


Thanks,
Daisuke Nishimura.
