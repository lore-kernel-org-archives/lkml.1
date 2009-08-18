Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZHRSAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZHRSAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbZHRSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:00:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50744 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453AbZHRSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:00:33 -0400
Subject: Re: [patch 1/3] flex_array: fix get function for elements in base
 starting at non-zero
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 09:03:06 -0700
Message-Id: <1250611386.7335.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> If all array elements fit into the base structure and data is copied
> using flex_array_put() starting at a non-zero index, flex_array_get()
> will fail to return the data.
> 
> This fixes the bug by only checking for NULL parts when all elements do
> not fit in the base structure when flex_array_get() is used.  Otherwise,
> fa_element_to_part_nr() will always be 0 since there are no parts
> structures needed and such element may never have been put.  Thus, it
> will remain NULL due to the kzalloc() of the base.
> 
> Additionally, flex_array_put() now only checks for a NULL part when all
> elements do not fit in the base structure.  This is otherwise unnecessary
> since the base structure is guaranteed to exist (or we would have already
> hit a NULL pointer).
> 
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  lib/flex_array.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/flex_array.c b/lib/flex_array.c
> --- a/lib/flex_array.c
> +++ b/lib/flex_array.c
> @@ -198,10 +198,11 @@ int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags
>  		return -ENOSPC;
>  	if (elements_fit_in_base(fa))
>  		part = (struct flex_array_part *)&fa->parts[0];
> -	else
> +	else {
>  		part = __fa_get_part(fa, part_nr, flags);
> -	if (!part)
> -		return -ENOMEM;
> +		if (!part)
> +			return -ENOMEM;
> +	}
>  	dst = &part->elements[index_inside_part(fa, element_nr)];
>  	memcpy(dst, src, fa->element_size);
>  	return 0;
> @@ -257,11 +258,12 @@ void *flex_array_get(struct flex_array *fa, int element_nr)
> 
>  	if (element_nr >= fa->total_nr_elements)
>  		return NULL;
> -	if (!fa->parts[part_nr])
> -		return NULL;
>  	if (elements_fit_in_base(fa))
>  		part = (struct flex_array_part *)&fa->parts[0];
> -	else
> +	else {
>  		part = fa->parts[part_nr];
> +		if (!part)
> +			return NULL;
> +	}
>  	return &part->elements[index_inside_part(fa, element_nr)];
>  }

This is fine with me, and fixes the bug you describe.

-- 

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

