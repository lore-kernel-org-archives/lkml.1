Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0BLOgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:36:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60989 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0BLOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:36:50 -0500
Date: Fri, 12 Feb 2010 08:36:23 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Eric Paris <eparis@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Xiaotian Feng <xtfeng@gmail.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] idr: fix a critical misallocation bug, take#2
Message-ID: <20100212143623.GA10256@us.ibm.com>
References: <4B750037.5020608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B750037.5020608@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> This is retry of reverted 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
> which contained two bugs.
> 
> * pa[idp->layers] should be cleared even if it's not used by
>   sub_alloc() because it's used by mark idr_mark_full().
> 
> * The original condition check also assigned pa[l] to p which the new
>   code didn't do thus leaving p pointing at the wrong layer.
> 
> Both problems have been fixed and the idr code has received good
> amount testing using userland testing setup where simple bitmap
> allocator is run parallel to verify the result of idr allocation.
> 
> The bug this patch fixes is caused by sub_alloc() optimization path
> bypassing out-of-room condition check and restarting allocation loop
> with starting value higher than maximum allowed value.  For detailed
> description, please read commit message of 859ddf09.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Based-on-patch-from: Eric Paris <eparis@redhat.com>
> Reported-by: Eric Paris <eparis@redhat.com>
> Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Full LTP still running, but this passes semget05 which is what
crashed the last version.  So that's

Tested-by: Serge Hallyn <serue@us.ibm.com>

> ---
> Heh... Embarrassingly, it turns out Eric's original patch is correct
> and all I did was adding two mistakes. :-) I'm pretty sure this is the
> correct fix and have tested it quite extensively.  But, given the
> fragility of this thing, Andrew, can you please put it in your tree
> and push it after 2.6.33 merge window opens?  Greg, please don't put
> this into -stable until at least 2.6.33-rc2 seems okay.
> 
> Thank you.
> 
>  lib/idr.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index 1cac726..0dc7822 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
>  			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
> 
>  			/* if already at the top layer, we need to grow */
> -			if (!(p = pa[l])) {
> +			if (id >= 1 << (idp->layers * IDR_BITS)) {
>  				*starting_id = id;
>  				return IDR_NEED_TO_GROW;
>  			}
> +			p = pa[l];
> +			BUG_ON(!p);
> 
>  			/* If we need to go up one layer, continue the
>  			 * loop; otherwise, restart from the top.
