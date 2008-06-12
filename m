Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYFLNPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYFLNPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbYFLNPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:15:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37366 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFLNPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:15:19 -0400
Date: Thu, 12 Jun 2008 08:15:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] mm/shmem.c: ret can be used uninitialized
Message-ID: <20080612131513.GA8453@us.ibm.com>
References: <20080611193729.GD13365@us.ibm.com> <20080611182405.7516069d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611182405.7516069d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 11 Jun 2008 14:37:29 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > >From 6c4eb2ce2849308c4a745ec1f93001e5064a469c Mon Sep 17 00:00:00 2001
> > From: Serge Hallyn <serge@us.ibm.com>
> > Date: Wed, 11 Jun 2008 11:20:28 -0500
> > Subject: [PATCH -mm] mm/shmem.c: ret can be used uninitialized
> > 
> > Make sure ret is defined before check at line 1408.
> > 
> > Signed-off-by: Serge Hallyn <serge@us.ibm.com>
> > ---
> >  mm/shmem.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index ad24be7..b326ff2 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1365,7 +1365,7 @@ repeat:
> >  		}
> >  
> >  		if (!filepage) {
> > -			int ret;
> > +			int ret = 0;
> >  
> >  			spin_unlock(&info->lock);
> >  			filepage = shmem_alloc_page(gfp, info, idx);
> 
> Well yes.  But it adds more text and uncommentedly adds an unnecessary
> initialisation.
> 
> With a wee bit of thought we can _reduce_ the amount of text and not
> add unnecessary stuff?
> 
> --- a/mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-fix-2
> +++ a/mm/shmem.c
> @@ -1396,7 +1396,8 @@ repeat:
>  				swap = *entry;
>  				shmem_swp_unmap(entry);
>  			}
> -			if (error || swap.val)
> +			ret = error || swap.val;
> +			if (ret)
>  				mem_cgroup_uncharge_cache_page(filepage);
>  			else
>  				ret = add_to_page_cache_lru(filepage, mapping,
> @@ -1405,7 +1406,7 @@ repeat:
>  			 * At add_to_page_cache_lru() failure, uncharge will
>  			 * be done automatically.
>  			 */
> -			if (error || swap.val || ret) {
> +			if (ret) {
>  				spin_unlock(&info->lock);
>  				page_cache_release(filepage);
>  				shmem_unacct_blocks(info->flags, 1);
> _

Neat.

-serge
