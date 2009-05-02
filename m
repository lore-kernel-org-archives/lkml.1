Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZEBPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZEBPjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZEBPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:39:28 -0400
Received: from [212.69.161.110] ([212.69.161.110]:60912 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZEBPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:39:27 -0400
X-Greylist: delayed 730 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2009 11:39:27 EDT
Date: Sat, 2 May 2009 17:26:20 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
Message-ID: <20090502152620.GA6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <20090501015956.ef663e9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501015956.ef663e9b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:59:56AM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 13:26:38 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> 
> > The lru_cache is a fixed size cache of equal sized objects. It allows its
> > users to do arbitrary transactions in case an element in the cache needs to
> > be replaced. Its replacement policy is LRU.
> > 
> 
> None of this really looks drbd-specific.
> 
> Would it not be better to present this as a general library function? 
> lib/lru_cache.c?

yes. will do.

> I think I might have asked this before.  If I did, then thwap-to-you
> for not permanently answering it in the changelog ;)
> 
> >
> > ...
> >
> > +#define lc_e_base(lc)  ((char *)((lc)->slot + (lc)->nr_elements))
> > +#define lc_entry(lc, i) ((struct lc_element *) \
> > +		       (lc_e_base(lc) + (i)*(lc)->element_size))
> > +#define lc_index_of(lc, e) (((char *)(e) - lc_e_base(lc))/(lc)->element_size)
> 
> The macros reference their arguments multiple times and hence are
> inefficient and/or buggy and/or unpredictable when passed an expression
> with side-effects.
> 
> If possible this should be fixed by turning them into regular C
> functions.  Inlined C functions if that makes sense (it frequently
> doesn't).
> 
> A pleasing side-effect of this conversion is that for some reason
> developers are more likely to document C functions than they are macros
> (hint).
> 
> I don't understand what these macros are doing and can't be bothered
> reverse-engineering the code to work that out.  But all the typecasting
> looks fishy.

I have a half finished rewrite of that piece code anyways,
so I guess I'll have to finish it then.

basically it allocates one continguous memory block,
to avoid additional small allocations and pointer arrays.

in memory structure is

struct lru_cache {
        struct list_head active;
        struct list_head quiet;
        struct list_head free;
        size_t element_size;          <-- parameter to "lc_alloc"
        unsigned int  nr_elements;    <-- parameter to "lc_alloc"
        unsigned int  new_number;

        unsigned int used;
        unsigned long flags;
        unsigned long hits, misses, starving, dirty, changed;

        struct lc_element *changing_element; /* just for paranoia */

        const char *name;

        struct hlist_head slot[0];
        /* hash colision chains here, then element storage. */
};

so we have fixed size list heads,
size of a single such "element", to allow the user
to add small payload;
number of hash slots and "elements" following this header;
some counters;
hlist_slot[0];
}
following:
struct hlist_head[nr_elements];
array of element_size blobs[nr_elements];

these "blobs" start with the struct lru_element,
possibly followed by some user payload.

the "index" you are asking about later is
index into that "blob" array,
and is used primarily to initialize the state of this thing
from an on-disk representation (the "activity log", "AL"),
for crash recovery purposes.

the typecasting is necessary to get from the slot[0] to the "elements"
skipping the hash slots.
using "container of" or something like that would obscure the fact that,
as currently implemented, the "lru_element" _must_ be the first member
of any payload structure.  but see below.

> > +static inline void lc_init(struct lru_cache *lc,
<24 lines/>
> > +}
> 
> How's about you remove all `inline' keywords from the whole patchset
> and then go back and inline the functions where there is a demonstrable
> benefit?  This function won't be one of them!

will do.

> > +/**
> > + * lc_free: Frees memory allocated by lc_alloc.
> > + * @lc: The lru_cache object
> > + */
> > +void lc_free(struct lru_cache *lc)
> > +{
> > +	vfree(lc);
> > +}
> 
> vmalloc() is a last-resort thing.  It generates slower-to-access memory
> and can cause internal fragmentation of the vmalloc arena, leading to
> total machine failure.
> 
> Can it be avoided?  Often it _can_ be avoided, and the code falls back
> to vmalloc() if the more robust memory allocation schemes failed.

yes, it can be avoided.
it used to be a kmalloc. but the mentioned "single memory block"
implementation hit some kmalloc limit, and we have then been lazy,
going the simple "two-line-patch" way.

we'll go for separate, and independently kmalloc'ed,
	struct hlist_head *slot;
	struct lru_element *blob;
then, or maybe for "struct page *blob_pages;" instead.

> Please review all kerneldoc comments in the patchset - I won't commeent
> on them further.

will do.

> > + * @lc: The lru_cache object
> > + * @enr: element number
> > + */
> > +struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
> > +{
> > +	struct hlist_node *n;
> > +	struct lc_element *e;
> > +
> > +	BUG_ON(!lc);
> > +	hlist_for_each_entry(e, n, lc->slot + lc_hash_fn(lc, enr), colision) {
> > +		if (e->lc_number == enr)
> > +			return e;
> > +	}
> > +	return NULL;
> > +}
> > +
> >
> > ...
> >
> 
> 
> So I assume that the caller of this facility must provide the locking
> for its internals.  Is that documented somewhere?

in my half-finished rewrite ;)

Thanks,

	Lars
