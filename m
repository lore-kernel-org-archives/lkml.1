Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbZANJAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbZANJAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZANI7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:59:12 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48423 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961AbZANI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:59:10 -0500
Message-ID: <496DA95B.6070401@s5r6.in-berlin.de>
Date: Wed, 14 Jan 2009 09:59:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Manfred Spraul <manfred@colorfullife.com>, krh@redhat.com, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	<49686465.70501@s5r6.in-berlin.de>	<20090110011557.9d94e111.akpm@linux-foundation.org>	<496872E0.9030007@s5r6.in-berlin.de>	<1231773620.6365.21.camel@gaara.bos.redhat.com>	<496B9FC7.3090108@colorfullife.com>	<1231792712.6365.31.camel@gaara.bos.redhat.com>	<496BAD1C.5060201@colorfullife.com>	<20090113144802.39dc4c23.akpm@linux-foundation.org>	<84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com> <20090114001745.9575ab02.akpm@linux-foundation.org>
In-Reply-To: <20090114001745.9575ab02.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This problem was introduced by
> 
> commit cf481c20c476ad2c0febdace9ce23f5a4db19582
...
> which was first released in 2.6.27.
> 
> There are no known codesites which trigger this bug in 2.6.27 or 2.6.28. 
> The post-2.6.28 firewire changes are the only known triggerer.

(They became post-2.6.29 changes since I missed my chance by two days or
so.)

> There might of course be not-yet-discovered triggerers in 2.6.27 and
> 2.6.28, and there might be out-of-tree triggerers which are added to those
> kernel versions.  I'll let the -stable guys decide whether they want to
> backport this fix.

I vote for the cf481c20c breakage be fixed in 2.6.27.y and 2.6.28.y.
Either by your patch or by something equivalent.

*Every* call to idr_remove_all() will add unclean idr_layers to the
pool.  There may be more actual occurrences of this than what was found
so far because
  - the results may be kernel panics without traces, or with traces that
    don't point to an idr problem so clearly,
  - one or another kernel debugging build option prevents this bug from
    happening.  A kernel developer who does most of his tests with debug
    options enabled won't notice.

...
> diff -puN lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache lib/idr.c
> --- a/lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache
> +++ a/lib/idr.c
> @@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
>  {
>  	while (idp->id_free_cnt < IDR_FREE_MAX) {
>  		struct idr_layer *new;
> -		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
> +		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
>  		if (new == NULL)
>  			return (0);
>  		move_to_free_list(idp, new);
...

I wonder if it would be more robust --- or even necessary --- to instead
add proper initialization code to get_from_free_list().

As far as David and I tested the new idr using code in firewire, we
called idr_remove_all() *and* idr_destroy() before any subsequent
idr_get_new().  But in practice, idr_get_new() may of course also happen
between idr_remove_all() and idr_destroy().

And then this fix won't be sufficient, would it?
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
