Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZGWOPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZGWOPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZGWOPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:15:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44320 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZGWOPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:15:51 -0400
Subject: Re: [RFC][PATCH] flexible array implementation v3
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: vda.linux@googlemail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       akpm@linux-foundation.org
In-Reply-To: <20090723104450.e0d421ca.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090722175345.7154C2F2@kernel>
	 <20090723104450.e0d421ca.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 07:05:48 -0700
Message-Id: <1248357948.24021.692.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 10:44 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Jul 2009 10:53:45 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > Changes from v2:
> > - renamed some of the index functions
> > - added preallocation function
> > - added flex_array_free_parts() for use with
> >   statically allocated bases
> > - killed append() function
> > 
> > Changes from v1:
> > - to vs too typo
> > - added __check_part_and_nr() and gave it a warning
> > - fixed off-by-one check on __nr_part_ptrs()
> > - added FLEX_ARRAY_INIT() macro
> > - some kerneldoc comments about the capacity
> >   with various sized objects
> > - comments to note lack of locking semantice
> 
> Seems nice, thank you. but a nitpick..
> 
> +struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
> +{
> +	struct flex_array *ret;
> +	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
> +
> +	/* max_size will end up 0 if element_size > PAGE_SIZE */
> +	if (total > max_size)
> +		return NULL;
> 
> Can't we store "total" somewhere and do error check ?
> 
> And some magic value as following can't be defined for 'total' ?
> 
> #define FLEX_ARRAY_MAX_ELEMENTS		(-1) // Use maximum flex array.

This would all be reasonable to add.  The only reason I haven't at this
point is that it simplifies things to not have it.  When bounds
checking, for instance, we just check against the data structure's
bounds, which we have to do anyway.  There's also no need to worry about
resizing since the maximum size is already fixed.

> > +/**
> > + * flex_array_get - pull data back out of the array
> > + * @element_nr:	index of the element to fetch from the array
> > + *
> > + * Returns a pointer to the data at index @element_nr.  Note
> > + * that this is a copy of the data that was passed in.  If you
> > + * are using this to store pointers, you'll get back &ptr.
> > + *
> > + * Locking must be provided by the caller.
> > + */
> > +void *flex_array_get(struct flex_array *fa, int element_nr)
> > +{
> > +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> > +	struct flex_array_part *part;
> > +	int offset;
> > +
> > +	if (__check_part_nr(fa, part_nr))
> > +		return NULL;
> return -EINVAL, here ?
> (Can't we compared with stored "total" ?)

Heh.  The radix_tree.c code just BUG_ON()s when you pass it bad indexes.
I guess the ranges that might be dealt with here are significantly
smaller.  

> > +	if (!fa->parts[part_nr])
> > +		return NULL;
> > +
> 
> The caller can't know whether
>  - there are no entry or
>  - NULL(0) is stored at the array.
> 
> Then, he has to check gotten value is valid or not by himself.

I think you may be reading this bit wrong.  Either that, or I badly
miscoded it. :)  The flex_array_get() code should returns NULL in cases
of error or the *address* of the data element.  It will actually return
an address pointing into the second-level page.

NULL's two meaning here are:
1. No element was ever put() here and thus there's no data page
2. Your index was out of bounds

(1) is a little fuzzy here.  It of course doesn't absolutely guarantee
that no put() was done since we just use the data page's existence to
tell.  This is certainly no worse than a normal C array would be,
though.

> Can't we return -ENOENT here(especially when prealloc() is called) ?
> But ah, anyway, all-zero elements in allocated array exists ;(
> and the user can get value from an entry never be put.
> 
> If we can fill the first 4bytes of _unused_ index by some magic code like this
> #define FLEX_ARRAY_UNUSED_MAGIC		(0xa5a5a5a5)
> (if maintaining bitmap/status of usage is nonsense)
> and flex_array_get() can return -ENOENT, the users will feel easy.
> 
> Overprotection ;) ?

I intentionally didn't use kzalloc() for the data pages.  I figured that
users will either initialize it themselves or pass in __GFP_ZERO.  I've
added a comment to clarify this.  

-- Dave

