Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYF3RDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYF3RDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYF3RCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:02:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53331 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYF3RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ravsl0L+4cQ7vRAbAl3GvG4PAAW+gHIhszCtcybDi4QJLQTjs6AZ8un8EbrX1PJLlT
         lJdfYSVdUloqX5bLSqYXRcc7asWsa/IH4ZkF7JKykOgmCL3RTtjRGhzd8bD8anTfMUUh
         l1aBVBhSuXtb9rn9tEwyeJHtEkdbRzjpK4f8U=
Message-ID: <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>
Date: Mon, 30 Jun 2008 19:02:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] core kernel fixes
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
In-Reply-To: <20080630153200.GA22360@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080630153200.GA22360@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 5:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index a76a5e1..85b18d7 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -68,6 +68,7 @@ static int fill_pool(void)
>  {
>        gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
>        struct debug_obj *new;
> +       unsigned long flags;
>
>        if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
>                return obj_pool_free;
> @@ -81,10 +82,10 @@ static int fill_pool(void)
>                if (!new)
>                        return obj_pool_free;
>
> -               spin_lock(&pool_lock);
> +               spin_lock_irqsave(&pool_lock, flags);
>                hlist_add_head(&new->node, &obj_pool);
>                obj_pool_free++;
> -               spin_unlock(&pool_lock);
> +               spin_unlock_irqrestore(&pool_lock, flags);
>        }
>        return obj_pool_free;
>  }
> @@ -110,16 +111,13 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
>  }
>
>  /*
> - * Allocate a new object. If the pool is empty and no refill possible,
> - * switch off the debugger.
> + * Allocate a new object. If the pool is empty, switch off the debugger.
>  */
>  static struct debug_obj *
>  alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
>  {
>        struct debug_obj *obj = NULL;
> -       int retry = 0;
>
> -repeat:
>        spin_lock(&pool_lock);
>        if (obj_pool.first) {
>                obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
> @@ -141,9 +139,6 @@ repeat:
>        }
>        spin_unlock(&pool_lock);
>
> -       if (fill_pool() && !obj && !retry++)
> -               goto repeat;
> -
>        return obj;
>  }
>
> @@ -261,6 +256,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
>        struct debug_obj *obj;
>        unsigned long flags;
>
> +       fill_pool();
> +
>        db = get_bucket((unsigned long) addr);
>
>        spin_lock_irqsave(&db->lock, flags);
> --

Hm. I have to wonder where this patch came from.

This was my (faulty) patch: http://lkml.org/lkml/2008/6/14/193
and Daniel J Blueman followed up with this: http://lkml.org/lkml/2008/6/15/27

..but this one looks different from both. I am guessing the last bits
were added (or removed?) by Thomas?

I am wondering if the final patch was tested with the reproducible
test case (if so, by whom?) and whether should be credited to Daniel
(or Thomas?) instead...

?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
