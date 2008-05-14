Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbYENUAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbYENUAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763921AbYENT7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:59:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50399 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763122AbYENT7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:59:32 -0400
Date: Wed, 14 May 2008 12:59:25 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
Message-ID: <20080514195925.GA8994@tpepper-t42p.dolavim.us>
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113737.562143000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07 May at 13:36:00 +0200 Nadia.Derbey@bull.net said:
> [PATCH 07/09]
> 
> This patch introduces the free_layer() routine: it is the one that actually
> frees memory after a grace period has elapsed.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  lib/idr.c |   59 ++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 44 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6.25-mm1/lib/idr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 18:06:43.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-05-07 09:07:31.000000000 +0200
> @@ -424,15 +455,13 @@ void idr_remove_all(struct idr *idp)
> 
>  		id += 1 << n;
>  		while (n < fls(id)) {
> -			if (p) {
> -				memset(p, 0, sizeof *p);
> -				move_to_free_list(idp, p);
> -			}
> +			if (p)
> +				free_layer(p);
>  			n += IDR_BITS;
>  			p = *--paa;
>  		}
>  	}
> -	idp->top = NULL;
> +	rcu_assign_pointer(idp->top, NULL);
>  	idp->layers = 0;
>  }
>  EXPORT_SYMBOL(idr_remove_all);

Does idr_remove_all() need an rcu_dereference() in the loop preceeding the
above, where it does:

                while (n > IDR_BITS && p) {
                        n -= IDR_BITS;
                        *paa++ = p;
     ---->              p = p->ary[(id >> n) & IDR_MASK];
                }

idr_replace() also has that loop without rcu_derefernce, but I _think_
I see why that one should be ok.  At least there the comment is clear
that locking at a higher level should be happening.  And then
idr_remove_all() is almost unused and it looks like it is only in
serialized places.

Otherwise, thanks for redoing...This patch set was much easier to digest
and looks reasonable to me.

I've been having some machine issues, but hope to give this patch set a run
still on a 128way machine and mainline to provide some additional
datapoints.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
