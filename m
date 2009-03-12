Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZCLAfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZCLAfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZCLAfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:35:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:18935 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZCLAfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EDvRsqVpUEerhPcLWMHa/KAeEjNxgMrm/l+RM952+ZUlyWJzTAPeCmUim5l1mg0n38
         vHXH+8bB4yjJswxgefUko81MhAUabqzgMEMl69qQb7TIGZdRkSLsSjUT3P8p5AmGUBzm
         OjR3ikMKyHeUHmGLYdKiS49+XPPkoVyBQA+dM=
MIME-Version: 1.0
In-Reply-To: <20090311170207.1795cad9.akpm@linux-foundation.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	 <20090311150302.0ae76cf1.akpm@linux-foundation.org>
	 <20090311170207.1795cad9.akpm@linux-foundation.org>
Date: Thu, 12 Mar 2009 09:35:05 +0900
Message-ID: <28c262360903111735s2b0c43a3pd48fcf8d55416ae3@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may 
	get wrongly discarded
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@surriel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 9:02 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Mar 2009 15:03:02 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> > The problem is that the pages are not marked dirty.  Anything that creates data
>> > in an MMU-based ramfs will cause the pages holding that data will cause the
>> > set_page_dirty() aop to be called.
>> >
>> > For the NOMMU-based mmap, set_page_dirty() may be called by write(), but it
>> > won't be called by page-writing faults on writable mmaps, and it isn't called
>> > by ramfs_nommu_expand_for_mapping() when a file is being truncated from nothing
>> > to allocate a contiguous run.
>> >
>> > The solution is to mark the pages dirty at the point of allocation by
>> > the truncation code.
>>
>> Page reclaim shouldn't be even attempting to reclaim or write back
>> ramfs pagecache pages - reclaim can't possibly do anything with these
>> pages!
>>
>> Arguably those pages shouldn't be on the LRU at all, but we haven't
>> done that yet.
>>
>> Now, my problem is that I can't 100% be sure that we _ever_ implemented
>> this properly.  I _think_ we did, in which case we later broke it.  If
>> we've always been (stupidly) trying to pageout these pages then OK, I
>> guess your patch is a suitable 2.6.29 stopgap.
>
> OK, I can't find any code anywhere in which we excluded ramfs pages
> from consideration by page reclaim.  How dumb.


The ramfs  considers it in just CONFIG_UNEVICTABLE_LRU case
It that case, ramfs_get_inode calls mapping_set_unevictable.
So,  page reclaim can exclude ramfs pages by page_evictable.
It's problem .


> So I guess that for now the proposed patch is suitable.  Longer-term we
> should bale early in shrink_page_list(), or not add these pages to the
> LRU at all.

In future, we have to improve this.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim
