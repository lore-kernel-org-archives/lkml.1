Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZBECSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZBECSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbZBECRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:17:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33499 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbZBECRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:17:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090204233543.GA26159@barrios-desktop>
References: <20090204171639.ECCE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090204233543.GA26159@barrios-desktop>
Message-Id: <20090205111507.803B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  5 Feb 2009 11:17:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and, I think current try_to_mlock_page() is correct. no need change.
> > Why?
> > 
> > 1. Generally, mmap_sem holding is necessary when vma->vm_flags accessed.
> >    that's vma's basic rule.
> > 2. However, try_to_unmap_one() doesn't held mamp_sem. but that's ok.
> >    it often get incorrect result. but caller consider incorrect value safe.
> > 3. try_to_mlock_page() need mmap_sem because it obey rule (1).
> > 4. in try_to_mlock_page(), if down_read_trylock() is failure, 
> >    we can't move the page to unevictable list. but that's ok.
> >    the page in evictable list is periodically try to reclaim. and
> >    be called try_to_unmap().
> >    try_to_unmap() (and its caller) also move the unevictable page to unevictable list.
> >    Therefore, in long term view, the page leak is not happend.
> 
> Thanks for clarification.
> In long term view, you're right.
> 
> but My concern is that munlock[all] pathes always hold down of mmap_sem. 
> After all, down_read_trylock always wil fail for such cases.
> 
> So, current task's mlocked pages only can be reclaimed 
> by background or direct reclaim path if the task don't exit.
> 
> I think it can increase reclaim overhead unnecessary 
> if there are lots of such tasks.
> 
> What's your opinion ?

I have 2 comment.

1. typical application never munlock()ed at all.
   and exit() path is already efficient.
   then, I don't like hacky apploach.
2. I think we should drop mmap_sem holding in munlock path in the future.
   at that time, this issue disappear automatically.
   it's clean way more.

What do you think it?


