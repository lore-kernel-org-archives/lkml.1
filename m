Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbZIQQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbZIQQgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZIQQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:36:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:56807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbZIQQgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:36:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,404,1249282800"; 
   d="scan'208";a="727862150"
Date: Thu, 17 Sep 2009 09:36:36 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: overwite pci bridge res regs to get big range
Message-ID: <20090917093636.01db2a74@jbarnes-g45>
In-Reply-To: <4AAD78C6.2010300@kernel.org>
References: <4AAD78C6.2010300@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Sep 2009 15:57:10 -0700
Yinghai Lu <yinghai@kernel.org> wrote:
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -299,8 +299,17 @@ static struct resource *find_free_bus_re
>  		r = bus->resource[i];
>  		if (r == &ioport_resource || r == &iomem_resource)
>  			continue;
> -		if (r && (r->flags & type_mask) == type
> && !r->parent)
> -			return r;
> +		if (r && (r->flags & type_mask) == type) {
> +			if (!r->parent)
> +				return r;
> +			/*
> +			 * if there is no child under that, we
> should release
> +			 * and use it. don't need to reset it,
> pbus_size_* will
> +			 * set it again
> +			 */
> +			if (!r->child && !release_resource(r))
> +				return r;
> +		}
>  	}
>  	return NULL;
>  }

This does seem like a good way of getting some extra bus space... We
should have all the child resources of a given bus by this point so it
seems like it would be safe.

You ok with this Linus?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
