Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461Ab0A0MSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0A0MSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098Ab0A0MSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:18:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab0A0MSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:18:22 -0500
Date: Wed, 27 Jan 2010 04:16:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
In-Reply-To: <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
Message-ID: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain> <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Chris Wilson wrote:
>  
> +	gfp = i915_gem_object_get_page_gfp_mask(obj);
> +	i915_gem_object_set_page_gfp_mask(obj, gfp | __GFP_NORETRY | __GFP_NOWARN);
>  	ret = i915_gem_object_get_pages(obj);
> +	i915_gem_object_set_page_gfp_mask (obj, gfp);

This is just all still totally and utterly broken.

There is no possible reason why something like drm should _ever_ play with 
the mapping gfp-mask. The fact that you guys do means that something is 
seriously wrong.

Setting the mapping gfp mask like that is totally wrong. Yes, it looks 
like you take the 'struct_mutex' lock, but I don't think the page fault 
does that, does it? So the locking in no way protects other uses of that 
mapping gfp mask.

Guys, this is just not acceptable. Playing games like this with obvious 
crap code is not the way to fix any problems what-so-ever. Even if the 
code happens to work, just a quick look at it clearly says "oh, that's 
ugly".

Just pass in the GFP mask to i915_gem_object_get_pages() instead, and stop 
making up these sh*tty idiotic interfaces. 

The whole "mapping_set_gfp_mask()" function that you use is meant to 
INITIALIZE a mapping when it is created. It's simply not safe at run-time. 
It never was, and it never will be.

So get rid of that whole i915_gem_object_set_page_gfp_mask() function - 
any user is by definition pure and utter crap.

Now, if you want to pass the gfp mask to the allocator directly (and 
judging by the code, that's _exactly_ what you want to do), then you don't 
want to use the read_mapping_page() helper function. That is very much 
designed to take the mappign GFP.

You can do your own version, something like this:

  struct page *i915_gem_get_page(struct address_space *mapping, pgoff_t index)
  {
	for (;;) {
		int err; 
		struct page *page;

		page = find_get_page(mapping, index);
		if (page)
			return page;

		page = __page_cache_alloc(gfpmask | __GFP_ZERO);
		if (!page)
			return ERR_PTR(-ENOMEM);

		/* Zero-page is already uptodate */
		__SetPageUptodate(page);

		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
		if (err) {
			page_cache_release(page);
			if (err == -EEXIST)
				continue;
			return ERR_PTR(err);
		}

		return page;
	}
  }

and now you have a way to allocate cleared pages into that mapping with a 
GFP that you control.

We could even make it a generic helper function if we just did that whole 
"mapping->a_ops->readpage()" dance or whatever and add the required async 
waiting etc. But I think gem just basically wants a zero-initialized 
mapping, no?

THE ABOVE IS TOTALLY UNTESTED. I wrote it in the mail-reader. It hasn't 
seen a compiler, and I didn't actually check that gem really just wants 
pages that are initialized to zero (aka "simle_readpage"), so what the 
heck do I know. My point is that something like the above should work in 
the sense that it avoids the whole "play games with setting a global 
gfpmask" thing, and keeps the gfpmask local to the execution.

Oh, and if you actually use shmem/tmpfs and can swap your pages out, then 
you do need to do the whole readpage() thing. It gets more complex then 
(you can't just mark things up-to-date, you need to lock the page, check 
PageUptodate() and friends etc etc).

I didn't check where that 'mapping' thing gets initialized.

Another alternative would be to keep the current i915_gem logic, but pass 
the gfp down all the way to read_cache_page(), rather than take it from 
the mapping. Then we'd make the 'read_mapping_page()' function look up the 
gfp (so users of 'read_mapping_page()' would get the old behavior, but we 
could call read_cache_page() with a gfpmask that is different from the 
mapping->gfpmask).

			Linus
