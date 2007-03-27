Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXC0JYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXC0JYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXC0JYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:24:05 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58115 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXC0JYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:24:04 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20070327005150.9177ae02.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 27 Mar 2007 00:51:50 -0800)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
	<20070326234957.6b287dda.akpm@linux-foundation.org>
	<E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
	<20070327001834.04dc375e.akpm@linux-foundation.org>
	<E1HW72O-0003ZB-00@dorka.pomaz.szeredi.hu> <20070327005150.9177ae02.akpm@linux-foundation.org>
Message-Id: <E1HW7tS-0003em-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 11:23:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > But Peter Staubach says a RH custumer has files written thorugh mmap,
> > > > which are not being backed up.
> > > 
> > > Yes, I expect the backup problem is the major real-world hurt arising from
> > > this bug.
> > > 
> > > But I expect we could adequately plug that problem at munmap()-time.  Or,
> > > better, do_wp_page().  As I said - half-assed.
> > > 
> > > It's a question if whether the backup problem is the only thing which is hurting
> > > in the real-world, or if people have other problems.
> > > 
> > > (In fact, what's wrong with doing it in do_wp_page()?
> > 
> > It's rather more expensive, than just toggling a bit.
> 
> It shouldn't be, especially for filesystems which have one-second timestamp
> granularity.
> 
> Filesystems which have s_time_gran=1 might hurt a bit, but no more than
> they will with write().
> 
> Actually, no - we'd only update the mctime once per page per writeback
> period (30 seconds by default) so the load will be small.

Why?  For each faulted page the times will be updated, no?

Maybe it's acceptable, I don't really know the cost of
file_update_time().

Tried this patch, and it seems to work.  It will even randomly update
the time for tmpfs files (on initial fault, and on swapins).

Miklos

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2007-03-27 11:04:40.000000000 +0200
+++ linux/mm/memory.c	2007-03-27 11:08:19.000000000 +0200
@@ -1664,6 +1664,8 @@ gotten:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 		set_page_dirty_balance(dirty_page);
 		put_page(dirty_page);
 	}
@@ -2316,6 +2318,8 @@ retry:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 		set_page_dirty_balance(dirty_page);
 		put_page(dirty_page);
 	}
