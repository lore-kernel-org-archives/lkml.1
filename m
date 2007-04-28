Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXD1Qfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXD1Qfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965931AbXD1Qfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:35:34 -0400
Received: from waste.org ([66.93.16.53]:57579 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbXD1Qfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:35:33 -0400
Date: Sat, 28 Apr 2007 11:22:52 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] deflate inflate_dynamic too
Message-ID: <20070428162252.GZ11115@waste.org>
References: <4632AF57.1070102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632AF57.1070102@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:20:07PM -0700, Jeremy Fitzhardinge wrote:
> inflate_dynamic() has piggy stack usage too, so heap allocate it too.
> I'm not sure it actually gets used, but it shows up large in "make
> checkstack".

Might as well drop the PKZIP bit while we're at it. No one's ever
built a zimage with PKZIP.

> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> 
> ---
>  lib/inflate.c |   63 ++++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 42 insertions(+), 21 deletions(-)
> 
> ===================================================================
> --- a/lib/inflate.c
> +++ b/lib/inflate.c
> @@ -798,15 +798,18 @@ STATIC int noinline INIT inflate_dynamic
>    unsigned nb;          /* number of bit length codes */
>    unsigned nl;          /* number of literal/length codes */
>    unsigned nd;          /* number of distance codes */
> -#ifdef PKZIP_BUG_WORKAROUND
> -  unsigned ll[288+32];  /* literal/length and distance code lengths */
> -#else
> -  unsigned ll[286+30];  /* literal/length and distance code lengths */
> -#endif
> +  unsigned *ll;         /* literal/length and distance code lengths */
>    register ulg b;       /* bit buffer */
>    register unsigned k;  /* number of bits in bit buffer */
> +  int ret;
>  
>  DEBG("<dyn");
> +
> +#ifdef PKZIP_BUG_WORKAROUND
> +  ll = malloc(sizeof(*ll) * (288+32));  /* literal/length and distance code lengths */
> +#else
> +  ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
> +#endif
>  
>    /* make local bit buffer */
>    b = bb;
> @@ -828,7 +831,10 @@ DEBG("<dyn");
>  #else
>    if (nl > 286 || nd > 30)
>  #endif
> -    return 1;                   /* bad lengths */
> +  {
> +    ret = 1;             /* bad lengths */
> +    goto out;
> +  }
>  
>  DEBG("dyn1 ");
>  
> @@ -850,7 +856,8 @@ DEBG("dyn2 ");
>    {
>      if (i == 1)
>        huft_free(tl);
> -    return i;                   /* incomplete code set */
> +    ret = i;                   /* incomplete code set */
> +    goto out;
>    }
>  
>  DEBG("dyn3 ");
> @@ -872,8 +879,10 @@ DEBG("dyn3 ");
>        NEEDBITS(2)
>        j = 3 + ((unsigned)b & 3);
>        DUMPBITS(2)
> -      if ((unsigned)i + j > n)
> -        return 1;
> +      if ((unsigned)i + j > n) {
> +        ret = 1;
> +	goto out;

Heh. Anti-tab damage.

-- 
Mathematics is the supreme nostalgia of our time.
