Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYIJUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYIJUtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIJUt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:49:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60263 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYIJUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:49:26 -0400
Subject: Re: [RFC v4][PATCH 5/9] Memory managemnet (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <48C824A2.8050708@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-6-git-send-email-orenl@cs.columbia.edu>
	 <1221075083.6781.34.camel@nimitz>  <48C824A2.8050708@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 13:49:17 -0700
Message-Id: <1221079757.6781.54.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 15:48 -0400, Oren Laadan wrote:
> Dave Hansen wrote:
> > On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> >> +/**
> >> + * cr_vma_read_pages_vaddrs - read addresses of pages to page-array chain
> >> + * @ctx - restart context
> >> + * @npages - number of pages
> >> + */
> >> +static int cr_vma_read_pages_vaddrs(struct cr_ctx *ctx, int npages)
> >> +{
> >> +	struct cr_pgarr *pgarr;
> >> +	int nr, ret;
> >> +
> >> +	while (npages) {
> >> +		pgarr = cr_pgarr_prep(ctx);
> >> +		if (!pgarr)
> >> +			return -ENOMEM;
> >> +		nr = min(npages, (int) pgarr->nr_free);
> >> +		ret = cr_kread(ctx, pgarr->vaddrs, nr * sizeof(unsigned long));
> >> +		if (ret < 0)
> >> +			return ret;
> >> +		pgarr->nr_free -= nr;
> >> +		pgarr->nr_used += nr;
> >> +		npages -= nr;
> >> +	}
> >> +	return 0;
> >> +}
> > 
> > cr_pgarr_prep() can return a partially full pgarr, right?  Won't the
> > cr_kread() always start at the beginning of the pgarr->vaddrs[] array?
> > Seems to me like it will clobber things from the last call.
> 
> Note that 'nr' is either equal to ->nr_free - in which case we consume
> the entire 'pgarr' vaddr array such that the next call to cr_pgarr_prep()
> will get a fresh one, or is smaller than ->nr_free - in which case that
> is the last iteration of the loop anyhow, so it won't be clobbered.
> 
> Also, after we return - our caller, cr_vma_read_pages(), resets the state
> of the page-array chain by calling cr_pgarr_reset().

Man, that's awfully subtle for something which is so simple.

I think it is a waste of memory to have to hold *all* of the vaddrs in
memory at once.  Is there a real requirement for that somehow?  The code
would look a lot simpler use less memory if it was done (for instance)
using a single 'struct pgaddr' at a time.  There are an awful lot of HPC
apps that have nearly all physical memory in the machine allocated and
mapped into a single VMA.  This approach could be quite painful there.

I know it's being done this way because that's what the dump format
looks like.  Would you consider changing the dump format to have blocks
of pages and vaddrs together?  That should also parallelize a bit more
naturally.

Anyway, this either needs a big fat comment or something that is
self-describing like this:

+       while (npages) {
+               pgarr = alloc_fresh_pgarr(...)
+               if (!pgarr)
+                       return -ENOMEM;
+               nr = min(npages, (int) pgarr->nr_free);
+               ret = cr_kread(ctx, pgarr->vaddrs, nr * sizeof(unsigned long));
+               if (ret < 0)
+                       return ret;
+               pgarr->nr_free -= nr;
+               pgarr->nr_used += nr;
+               npages -= nr;
		add_pgarr_to_ctx(ctx, pgarr);
+       }
+       return 0;

When someone is looking at that, it is painfully obvious that they're
not writing over anyone else's vaddrs since the pgarr is fresh.  

-- Dave

