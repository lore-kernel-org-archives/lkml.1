Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbZGVURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbZGVURT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZGVURS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:17:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZGVURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:17:18 -0400
Date: Wed, 22 Jul 2009 13:16:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
       mingo@elte.hu, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] vmalloc.c: fix lose num_physpages checking
Message-Id: <20090722131606.4359bee1.akpm@linux-foundation.org>
In-Reply-To: <1247191604.2572.3.camel@myhost>
References: <1247191604.2572.3.camel@myhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 10:06:44 +0800
"Figo.zhang" <figo1802@gmail.com> wrote:

> __get_vm_area_node() lose size (physpages limit) checking, it be called by
> __get_vm_area() that some drivers called it directly.
> 
> Signed-off-by: Figo.zhang  <figo1802@gmail.com>
> --- 
> mm/vmalloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f8189a4..99f3aea 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1144,7 +1144,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
>  	}
>  
>  	size = PAGE_ALIGN(size);
> -	if (unlikely(!size))
> +	if (unlikely(!size || (size >> PAGE_SHIFT) > num_physpages))
>  		return NULL;
>  
>  	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);

I question whether those num_physpages checks in vmalloc.c are useful.

a) the caller is doing something crazy

b) if the caller passed in size=num_physpages-1 then that test will
   succeed, but the vmalloc is surely going to fail.

c) a request for >num_physpages of vmalloc space should fail later
   on in the vmalloc code, making this test redundant.

d) the cheerily undocumented __get_vm_area() and
   __get_vm_area_node() don't actually allocate physical pages for the
   area, and those functions cannot assume that the caller will be fully
   populating the area with physical pages, so checking that there are
   enough physical pages to fill the area doesn't make sense.

No?
