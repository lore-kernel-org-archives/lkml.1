Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbXEOSKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbXEOSKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXEOSKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:10:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48935 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754948AbXEOSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:10:23 -0400
Date: Tue, 15 May 2007 11:10:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Badari Pulavarty <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: select(0, ..) is valid ?
In-Reply-To: <20070515104453.f901e91f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705151109021.31972@schroedinger.engr.sgi.com>
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
 <20070515104453.f901e91f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Andrew Morton wrote:

> I _think_ we can just do
> 
> --- a/fs/compat.c~a
> +++ a/fs/compat.c
> @@ -1566,9 +1566,13 @@ int compat_core_sys_select(int n, compat
>  	 */
>  	ret = -ENOMEM;
>  	size = FDS_BYTES(n);
> -	bits = kmalloc(6 * size, GFP_KERNEL);
> -	if (!bits)
> -		goto out_nofds;
> +	if (likely(size)) {
> +		bits = kmalloc(6 * size, GFP_KERNEL);
> +		if (!bits)
> +			goto out_nofds;
> +	} else {
> +		bits = NULL;
> +	}
>  	fds.in      = (unsigned long *)  bits;
>  	fds.out     = (unsigned long *) (bits +   size);
>  	fds.ex      = (unsigned long *) (bits + 2*size);
> _
> 
> I mean, if that oopses then I'd be very interested in finding out why.
> 
> But I'm starting to suspect that it would be better to permit kmalloc(0) in
> slub.  It depends on how many more of these things need fixing.
> 
> otoh, a kmalloc(0) could be a sign of some buggy/inefficient/weird code, so
> there's some value in forcing us to go look at all the callsites.
 
Hmmm... We could have kmalloc(0) return a pointer to the zero page? That 
would catch any writers?
