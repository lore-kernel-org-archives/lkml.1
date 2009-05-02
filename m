Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZEBTlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZEBTlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZEBTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:40:51 -0400
Received: from [212.69.161.110] ([212.69.161.110]:49200 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZEBTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:40:50 -0400
Date: Sat, 2 May 2009 21:39:54 +0200
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
Message-ID: <20090502193954.GH6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <20090501015956.ef663e9b.akpm@linux-foundation.org> <20090502152620.GA6466@racke> <20090502105823.bf27bf22.akpm@linux-foundation.org> <20090502181311.GG6466@racke> <20090502112609.67637bc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502112609.67637bc6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 11:26:09AM -0700, Andrew Morton wrote:
> You appear to believe that I understood the relevance of all the above
> text.  I didn't ;)
> 
> Let's start again.
> 
> Why can't I do
> 
> struct foo {
> 	int x;
> 	struct lc_element lc;
> 	..
> };
> 
> and then use the lru library code to handle my foo objects?


to do so, you'd
struct lru_cache *foo_cache =
	lc_alloc("dummy", 42, sizeof(struct foo), NULL);

that would alloc 
sizeof(struct lru_cache)
+ 42 * sizeof(struct hlist_head)
+ 42 * sizeof(struct foo);

the number of elements in the cache is fixed for its lifetime,
only the reference counts, position on the lru lists,
and tracked "house numbers" change.

the lru code sometimes addresses the lc_element part of the object
just via their index in this memory area, which is useful to initialize
the elements from some on-disk recorded state.

it does so by assuming a struct lc_element
every sizeof(struct foo) bytes
after the initial 42 hlist slots.

there, that was it.

to make this generic, appart from adding some paranoia
like a BUG_ON(sizeof(foo) < sizeof(lc_element)), and possibly
rounding any "odd" element_size parameter to get proper alignment,
it would need to pass in offset_of(struct foo, lc),
so it could do 

#define lc_e_base(lc) \
        ((char *)((lc)->slot + (lc)->nr_elements))

static inline struct lc_element *
lc_element_by_index(struct lru_cache *lc, unsigned int i)
{
        BUG_ON(i >= lc->nr_elements);
        return (struct lc_element *) (lc_e_base(lc)
			+ i * lc->element_size
			+     lc->offset_of);
}

lc->offset_of is what is currently missing from the code.
lc_element_by_index() is what currently is badly named lc_entry().

a real lc_entry would then become
#define lc_entry(ptr, type, member) \
        container_of(ptr, type, member)

so what now is
-struct foo *bar = (struct foo *) lc_entry(foo_cache, 7);

would become
+struct lc_element *e = lc_element_by_index(foo_cache, 7);
+struct foo *bar = lc_entry(e, struct foo, lc);

does that make sense?

any suggestions to split up the one vmalloc into several allocations?
kmalloc?  a bunch of zero order pages?
or are we reinventing the wheel?
(probably we do, anyways; but is that particular wheel already in kernel?)

	Lars
