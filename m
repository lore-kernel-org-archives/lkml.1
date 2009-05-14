Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbZENIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbZENIal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZENIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:30:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53117 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZENIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:30:31 -0400
Subject: Re: kernel BUG at mm/slqb.c:1411!
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090513173758.2f3d2a50.minchan.kim@barrios-desktop>
References: <20090513163826.7232.A69D9226@jp.fujitsu.com>
	 <20090513173758.2f3d2a50.minchan.kim@barrios-desktop>
Date: Thu, 14 May 2009 11:30:30 +0300
Message-Id: <1242289830.21646.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 17:37 +0900, Minchan Kim wrote:
> On Wed, 13 May 2009 16:42:37 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> Hmm. I don't know slqb well.
> So, It's just my guess. 
> 
> We surely increase l->nr_partial in  __slab_alloc_page.
> In between l->nr_partial++ and call __cache_list_get_page, Who is decrease l->nr_partial again.
> After all, __cache_list_get_page return NULL and hit the VM_BUG_ON.
> 
> Comment said :
> 
>         /* Protects nr_partial, nr_slabs, and partial */
>   spinlock_t    page_lock;
> 
> As comment is right, We have to hold the l->page_lock ?

Makes sense. Nick? Motohiro-san, can you try this patch please?

			Pekka

diff --git a/mm/slqb.c b/mm/slqb.c
index 5d0642f..29bb005 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1399,12 +1399,14 @@ static noinline void *__slab_alloc_page(struct kmem_cache *s,
 		page->list = l;
 
 		spin_lock(&n->list_lock);
+		spin_lock(&l->page_lock);
 		l->nr_slabs++;
 		l->nr_partial++;
 		list_add(&page->lru, &l->partial);
 		slqb_stat_inc(l, ALLOC);
 		slqb_stat_inc(l, ALLOC_SLAB_NEW);
 		object = __cache_list_get_page(s, l);
+		spin_unlock(&l->page_lock);
 		spin_unlock(&n->list_lock);
 #endif
 	}


