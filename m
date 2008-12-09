Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYLIVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYLIVlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYLIVlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:41:01 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:7312 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbYLIVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hPE1Tpd09Tar5EYjmWk6Ge5EPZIyi2Sx6frjl7M48Vf+bopSCbSpxQGux9cXqiSJnG
         s04hpFFqYST/Y94WYIumYMEuDBWhwdrK+svghoqSvDZpATzNllbvOc2gIcsM1ZpimE8E
         MMx7Rl6hYonNsEwb69vXqTcSifjUQyf9cJcuI=
Message-ID: <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
Date: Wed, 10 Dec 2008 07:40:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       "Jake Edge" <jake@lwn.net>, "Eugene Teo" <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Manfred Spraul" <manfred@colorfullife.com>,
       "Clement Calmels" <cboulte@gmail.com>,
       "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Pierre Peiffer" <peifferp@gmail.com>
In-Reply-To: <20081203194906.GV8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203193901.715896543@mini.kroah.org>
	 <20081203194725.GA8950@kroah.com> <20081203194906.GV8950@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 5:49 AM, Greg KH <gregkh@suse.de> wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>
Revert.

This caused problems in the F10 kernel with idr, the drm device alloc
went all wierd,
it might be a drm bug but changing this code triggers it and so it
isn't really "stable"

Dave.

> ------------------
> From: Manfred Spraul <manfred@colorfullife.com>
>
> commit 6ff2d39b91aec3dcae951afa982059e3dd9b49dc upstream.
>
> 2nd part of the fixes needed for
> http://bugzilla.kernel.org/show_bug.cgi?id=11796.
>
> When the idr tree is either grown or shrunk, then the update to the number
> of layers and the top pointer were not atomic.  This race caused crashes.
>
> The attached patch fixes that by replicating the layers counter in each
> layer, thus idr_find doesn't need idp->layers anymore.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Cc: Clement Calmels <cboulte@gmail.com>
> Cc: Nadia Derbey <Nadia.Derbey@bull.net>
> Cc: Pierre Peiffer <peifferp@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  include/linux/idr.h |    3 ++-
>  lib/idr.c           |   14 ++++++++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -52,13 +52,14 @@ struct idr_layer {
>        unsigned long            bitmap; /* A zero bit means "space here" */
>        struct idr_layer        *ary[1<<IDR_BITS];
>        int                      count;  /* When zero, we can release it */
> +       int                      layer;  /* distance from leaf */
>        struct rcu_head          rcu_head;
>  };
>
>  struct idr {
>        struct idr_layer *top;
>        struct idr_layer *id_free;
> -       int               layers;
> +       int               layers; /* only valid without concurrent changes */
>        int               id_free_cnt;
>        spinlock_t        lock;
>  };
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -185,6 +185,7 @@ static int sub_alloc(struct idr *idp, in
>                        new = get_from_free_list(idp);
>                        if (!new)
>                                return -1;
> +                       new->layer = l-1;
>                        rcu_assign_pointer(p->ary[m], new);
>                        p->count++;
>                }
> @@ -210,6 +211,7 @@ build_up:
>        if (unlikely(!p)) {
>                if (!(p = get_from_free_list(idp)))
>                        return -1;
> +               p->layer = 0;
>                layers = 1;
>        }
>        /*
> @@ -237,6 +239,7 @@ build_up:
>                }
>                new->ary[0] = p;
>                new->count = 1;
> +               new->layer = layers-1;
>                if (p->bitmap == IDR_FULL)
>                        __set_bit(0, &new->bitmap);
>                p = new;
> @@ -493,17 +496,21 @@ void *idr_find(struct idr *idp, int id)
>        int n;
>        struct idr_layer *p;
>
> -       n = idp->layers * IDR_BITS;
>        p = rcu_dereference(idp->top);
> +       if (!p)
> +               return NULL;
> +       n = (p->layer+1) * IDR_BITS;
>
>        /* Mask off upper bits we don't use for the search. */
>        id &= MAX_ID_MASK;
>
>        if (id >= (1 << n))
>                return NULL;
> +       BUG_ON(n == 0);
>
>        while (n > 0 && p) {
>                n -= IDR_BITS;
> +               BUG_ON(n != p->layer*IDR_BITS);
>                p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
>        }
>        return((void *)p);
> @@ -582,8 +589,11 @@ void *idr_replace(struct idr *idp, void
>        int n;
>        struct idr_layer *p, *old_p;
>
> -       n = idp->layers * IDR_BITS;
>        p = idp->top;
> +       if (!p)
> +               return ERR_PTR(-EINVAL);
> +
> +       n = (p->layer+1) * IDR_BITS;
>
>        id &= MAX_ID_MASK;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
