Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYD2Sp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYD2Sp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYD2Spr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:45:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757003AbYD2Spq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:45:46 -0400
Date: Tue, 29 Apr 2008 11:44:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, Nadia.Derbey@bull.net
Subject: Re: [PATCH 01/10] Fix idr_remove()
Message-Id: <20080429114425.ea0e2f62.akpm@linux-foundation.org>
In-Reply-To: <20080429143728.563232000@bull.net>
References: <20080429143304.741001000@bull.net>
	<20080429143728.563232000@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:33:05 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 01/10]
> 
> This patch fixes idr_remove(): the return inside the loop makes us free only
> a single layer.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  lib/idr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.25-mm1/lib/idr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-25 15:29:00.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-04-25 15:48:34.000000000 +0200
> @@ -385,8 +385,8 @@ void idr_remove(struct idr *idp, int id)
>  	while (idp->id_free_cnt >= IDR_FREE_MAX) {
>  		p = alloc_layer(idp);
>  		kmem_cache_free(idr_layer_cache, p);
> -		return;
>  	}
> +	return;
>  }
>  EXPORT_SYMBOL(idr_remove);

erk, ancient bug.

I _think_ the implications of this are that an idr tree will grow fatter
than it needs to be, but there is no permanent leak: idr_destroy() will
still free everything, yes?

And a consequence of the fix is that idr manipulations will now result in
more allocs and frees, but the amount of memory which a tree uses will be
less?

