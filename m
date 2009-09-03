Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZICGbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZICGbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZICGbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:31:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61945 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbZICGbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Wlwm9blh76YUonxcHkuCqdYJbUkLqGMUDF5RKVAYCDLExdCt0QuaLFoTALKL+8+FuO
         QV/GKYHU0zyxssz2/I/RxqHxpFRFtwyJMhMMcU7w4v2I3NiseOwXzQ34FJkZzT9+zS9h
         OiUOOVwvoEkLXmni6foXjP+lDjJEAFeQhnXO4=
MIME-Version: 1.0
In-Reply-To: <4A9F1620.2080105@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>
	 <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com>
	 <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>
	 <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>
	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
Date: Thu, 3 Sep 2009 09:31:01 +0300
X-Google-Sender-Auth: 5d410398edb6096a
Message-ID: <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 4:04 AM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Zdenek Kabelac a écrit :
>>
>> Well I'm not noticing any ill behavior - also note - rcu_barrier() is
>> there before the cache is destroyed.
>> But as I said - it's just my shot into the dark - which seems to work for me...
>>
>
> Reading again your traces, I do believe there are two bugs in slub
>
> Maybe not explaining your problem, but worth to fix !
>
> Thank you
>
> [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
>
> When SLAB_POISON is used and slab_pad_check() finds an overwrite of the
> slab padding, we call restore_bytes() on the whole slab, not only
> on the padding.
>
> kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close()
> and *before* sysfs_slab_remove() or risk rcu_free_slab()
> being called after kmem_cache is deleted (kfreed).
>
> rmmod nf_conntrack can crash the machine because it has to
> kmem_cache_destroy() a SLAB_DESTROY_BY_RCU enabled cache.
>
> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/mm/slub.c b/mm/slub.c
> index b9f1491..0ac839f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -646,7 +646,7 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
>        slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
>        print_section("Padding", end - remainder, remainder);
>
> -       restore_bytes(s, "slab padding", POISON_INUSE, start, end);
> +       restore_bytes(s, "slab padding", POISON_INUSE, end - remainder, end);

OK, makes sense.

>        return 0;
>  }
>
> @@ -2594,8 +2594,6 @@ static inline int kmem_cache_close(struct kmem_cache *s)
>  */
>  void kmem_cache_destroy(struct kmem_cache *s)
>  {
> -       if (s->flags & SLAB_DESTROY_BY_RCU)
> -               rcu_barrier();
>        down_write(&slub_lock);
>        s->refcount--;
>        if (!s->refcount) {
> @@ -2606,6 +2604,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
>                                "still has objects.\n", s->name, __func__);
>                        dump_stack();
>                }
> +               if (s->flags & SLAB_DESTROY_BY_RCU)
> +                       rcu_barrier();
>                sysfs_slab_remove(s);
>        } else
>                up_write(&slub_lock);

The rcu_barrier() call was added by this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7ed9f7e5db58c6e8c2b4b738a75d5dcd8e17aad5

I guess we should CC Paul as well.
