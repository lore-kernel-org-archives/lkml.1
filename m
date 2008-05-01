Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbYEAEca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbYEAEca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYEAEcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:32:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46366 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYEAEcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:32:11 -0400
Date: Wed, 30 Apr 2008 21:32:05 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 05/10] Introduce ridr_get_new_above()
Message-ID: <20080501043204.GD30274@tpepper-t42p.dolavim.us>
References: <20080429143304.741001000@bull.net> <20080429143730.096357000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143730.096357000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr at 16:33:09 +0200 Nadia.Derbey@bull.net said:
> [PATCH 05/10]
> 
> This patch introduces the ridr_get_new_above() routine, and some common code
> between the idr an ridr API's.

The ridr_get_new_above() is the first place we see something really
different compared to idr (an RCU addition).  This is a lot of patching
so far for what would be a small incremental change otherwise.

> Index: linux-2.6.25-mm1/include/linux/idr.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-04-29 13:08:00.000000000 +0200
> +++ linux-2.6.25-mm1/include/linux/idr.h	2008-04-29 14:08:47.000000000 +0200
> @@ -71,6 +71,27 @@ struct idr {
>  }
>  #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
> 
> +/* Actions to be taken after a call to _idr_sub_alloc */
> +#define IDR_DONE         -1
> +#define IDR_NEED_TO_GROW -2
> +#define IDR_NOMORE_SPACE -3
> +#define IDR_GO_TOP       -4
> +#define IDR_GO_UP        -5

This stuff is useful on its own in as much as it improves code
readability.  A lot of this patch (the "some common code between the
idr and ridr API's" part) could be a standalone patch distinct from the
ridr series and then be at the head of your stack.

> +			return action;
> +		case IDR_DONE:
> +			goto end_loop;
> +		case IDR_GO_UP:
> +			continue;
> +		case IDR_GO_TOP:
> +			goto restart;
> +		default:
> +			m = action;
>  			break;
> +		}
> +		BUG_ON(m < 0);

Why the added BUG_ON()?  These couple hunks are a bit muddled, so maybe I
missed something.  But I don't see anything different in how m or bm are
being manipulated such that m<0 is anymore likely after this patch.

> Index: linux-2.6.25-mm1/lib/ridr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 13:23:17.000000000 +0200
> +++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 14:03:35.000000000 +0200
> @@ -11,6 +11,23 @@
>  static struct kmem_cache *ridr_layer_cache;
> 
> 
> +static struct ridr_layer *get_from_free_list(struct ridr *idp)
> +{
> +	struct ridr_layer *q;
> +	struct idr_layer *p;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&idp->lock, flags);
> +	if ((q = idp->id_free)) {
> +		p = ridr_to_idr(q);
> +		idp->id_free = p->ary[0];
> +		idp->id_free_cnt--;
> +		p->ary[0] = NULL;
> +	}
> +	spin_unlock_irqrestore(&idp->lock, flags);
> +	return(q);
> +}
> +

idr's alloc_layer() in disguise?

> +static int sub_alloc(struct ridr *idp, int *starting_id,
> +			struct ridr_layer **rpa, struct idr_layer **pa)

...
More or less duplication
...

> +		 * Create the layer below if it is missing.
> +		 */
> +		if (!p->ary[m]) {
> +			new = get_from_free_list(idp);
> +			if (!new)
> +				return -1;
> +			rcu_assign_pointer(p->ary[m], new);
> +			p->count++;
> +		}
> +		pa[l] = p;
> +		rpa[l--] = idr_to_ridr(p);
> +		p = p->ary[m];
> +	}
> +
> +end_loop:
> +	pa[l] = p;
> +	rpa[l] = idr_to_ridr(p);
> +	return id;
> +}

Oh but wait..there's some RCU-ness tucked in there.

> +
> +static int ridr_get_empty_slot(struct ridr *idp, int starting_id,
> +			      struct ridr_layer **rpa, struct idr_layer **pa)
> +{
> +	struct ridr_layer *p, *rnew;
> +	int layers, v, id;
> +	unsigned long flags;
> +
> +	id = starting_id;
> +build_up:
> +	p = idp->top;
> +	layers = idp->layers;
> +	if (unlikely(!p)) {
> +		p = get_from_free_list(idp);
> +		if (!p)
> +			return -1;
> +		layers = 1;
> +	}
> +	/*
> +	 * Add a new layer to the top of the tree if the requested
> +	 * id is larger than the currently allocated space.
> +	 */
> +	while (layers < MAX_LEVEL - 1 && id >= (1 << (layers * IDR_BITS))) {
               ^^                   ^^
Dropped some parens.  Otherwise more duplication...

> +				rnew->idr.ary[0] = NULL;
> +				rnew->idr.bitmap = rnew->idr.count = 0;
> +				__move_to_free_list(idp, rnew);
> +			}
> +			spin_unlock_irqrestore(&idp->lock, flags);
> +			return -1;
> +		}
> +		_idr_set_new_slot(ridr_to_idr(rnew), ridr_to_idr(p));
> +		p = rnew;
> +	}
> +	rcu_assign_pointer(idp->top, p);
> +	idp->layers = layers;
> +	v = sub_alloc(idp, &id, rpa, pa);
> +	if (v == IDR_NEED_TO_GROW)
> +		goto build_up;
> +	return(v);
> +}

Some more RCU.

> +static int ridr_get_new_above_int(struct ridr *idp, void *ptr, int starting_id)
> +{
> +	struct ridr_layer *rpa[MAX_LEVEL];
> +	struct idr_layer *pa[MAX_LEVEL];
> +	int id;
> +
> +	id = ridr_get_empty_slot(idp, starting_id, rpa, pa);
> +	if (id >= 0) {
> +		/*
> +		 * Successfully found an empty slot.  Install the user
> +		 * pointer and mark the slot full.
> +		 */
> +		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
> +				(struct ridr_layer *)ptr);
> +		pa[0]->count++;
> +		_idr_mark_full(pa, id);
> +	}
> +
> +	return id;
> +}

And other line of RCU.

OK.  So at this point in patch 5/10 we've got 3 lines of new code and
hundreds of lines of duplicated code?

A while more looking through the rest of the patches for the rest of the
context and I might be able to actually think about the implications of
these three lines being where they are.

Locking changes are complicated enough without all this obfuscation!
I understand the desire to not break IDR, but...

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
