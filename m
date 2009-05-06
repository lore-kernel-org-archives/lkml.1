Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZEFGgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZEFGgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZEFGgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:36:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZEFGgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:36:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=i6IgoPB0FYdaGSGRj1ZyGnnIjr22nSu9mrHUFbeoNYQWms4DNQ84oEc3lCA/DZXzo
	6Lp+eKqbrF4atxE5Ylskw==
Date: Tue, 5 May 2009 23:36:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm] mm: init_per_zone_pages_min - get rid of sqrt
 call on small machines
In-Reply-To: <20090506061953.GA16057@lenovo>
Message-ID: <alpine.DEB.2.00.0905052334391.9824@chino.kir.corp.google.com>
References: <20090506061953.GA16057@lenovo>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Cyrill Gorcunov wrote:

> Index: linux-2.6.git/mm/page_alloc.c
> =====================================================================
> --- linux-2.6.git.orig/mm/page_alloc.c
> +++ linux-2.6.git/mm/page_alloc.c
> @@ -4610,11 +4610,15 @@ static int __init init_per_zone_pages_mi
>  
>  	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
>  
> -	min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
> -	if (min_free_kbytes < 128)
> +	/* for small values we may eliminate sqrt operation completely */
> +	if (lowmem_kbytes < 1024)
>  		min_free_kbytes = 128;
> -	if (min_free_kbytes > 65536)
> -		min_free_kbytes = 65536;
> +	else {
> +		min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
> +		if (min_free_kbytes > 65536)
> +			min_free_kbytes = 65536;
> +	}
> +
>  	setup_per_zone_pages_min();
>  	setup_per_zone_lowmem_reserve();
>  	setup_per_zone_inactive_ratio();

For a function that's called once, this just isn't worth it.  int_sqrt() 
isn't expensive enough to warrant the assault on the readability of the 
code.
