Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYARLgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYARLgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbYARLgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:36:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53816 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbYARLgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:36:14 -0500
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-reply-to: <1200655438.5920.21.camel@twins> (message from Peter Zijlstra on
	Fri, 18 Jan 2008 12:23:58 +0100)
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
	files
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <12006091211208-git-send-email-salikhmetov@gmail.com>
	 <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu> <1200651337.5920.9.camel@twins>
	 <E1JFobo-00009i-Dk@pomaz-ex.szeredi.hu> <1200654050.5920.14.camel@twins>
	 <E1JFpDg-0000F6-12@pomaz-ex.szeredi.hu> <1200655438.5920.21.camel@twins>
Message-Id: <E1JFpW4-0000Hc-Sp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 12:36:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Possibly, I didn't see a quick way to break that iteration.
> >From a quick glance at prio_tree.c the iterator isn't valid anymore
> after releasing i_mmap_lock. Fixing that would be,.. 'fun'.

Maybe i_mmap_lock isn't needed at all, since msync holds mmap_sem,
which protects the prio tree as well, no?

> I also realized I forgot to copy/paste the prio_tree_iter declaration
> and ought to make all these functions static.
> 
> But for a quick draft it conveys the idea pretty well, I guess :-)

Yes :)

There could also be nasty performance corner cases, like having a huge
file mapped thousands of times, and having only a couple of pages
dirtied between MS_ASYNC invocations.  Then most of that page table
walking would be just unnecessary overhead.

There's something to be said for walking only the dirty pages, and
doing page_mkclean on them, even if in some cases that would be
slower.

But I have a strong feeling of deja vu, and last time it ended with
Andrew not liking the whole thing...

Miklos
