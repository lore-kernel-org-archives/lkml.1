Return-Path: <linux-kernel-owner+w=401wt.eu-S1763725AbZD3OMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763725AbZD3OMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbZD3OMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:12:07 -0400
Received: from ru.mvista.com ([213.79.90.228]:4179 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932123AbZD3OMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:12:06 -0400
Date: Thu, 30 Apr 2009 18:10:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430141013.GA17480@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com> <20090430103528.GA6900@wotan.suse.de> <1241087884.19252.5.camel@penberg-laptop> <20090430210004.05a61841.sfr@canb.auug.org.au> <20090430111825.GC6900@wotan.suse.de> <1241090429.19252.7.camel@penberg-laptop> <20090430130542.GF6900@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090430130542.GF6900@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:05:42PM +0200, Nick Piggin wrote:
[...]
> ---
> SLQB: fix dumb early allocation cache
> 
> The dumb early allocation cache had a bug where it could allow allocation
> to go past the end of a page, which could cause crashes or random memory
> corruption. Fix this and simplify the logic.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  mm/slqb.c |   19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/mm/slqb.c
> ===================================================================
> --- linux-2.6.orig/mm/slqb.c
> +++ linux-2.6/mm/slqb.c
> @@ -2185,8 +2185,11 @@ static void *kmem_cache_dyn_array_alloc(
>  {
>  	size_t size = sizeof(void *) * ids;
>  
> +	BUG_ON(!size);
> +
>  	if (unlikely(!slab_is_available())) {
>  		static void *nextmem;
> +		static size_t nextleft;
>  		void *ret;
>  
>  		/*
> @@ -2194,16 +2197,16 @@ static void *kmem_cache_dyn_array_alloc(
>  		 * never get freed by definition so we can do it rather
>  		 * simply.
>  		 */
> -		if (!nextmem) {
> -			nextmem = alloc_pages_exact(size, GFP_KERNEL);
> -			if (!nextmem)
> -				return NULL;
> +		if (size > nextleft) {
> +                        nextmem = alloc_pages_exact(size, GFP_KERNEL);
> +                        if (!nextmem)
> +                                return NULL;

Cosmetic issue: spaces instead of tabs are used on these
three lines.

> +			nextleft = roundup(size, PAGE_SIZE);
>  		}
> +
>  		ret = nextmem;
> -		nextmem = (void *)((unsigned long)ret + size);
> -		if ((unsigned long)ret >> PAGE_SHIFT !=
> -				(unsigned long)nextmem >> PAGE_SHIFT)
> -			nextmem = NULL;
> +		nextleft -= size;
> +		nextmem += size;
>  		memset(ret, 0, size);
>  		return ret;
>  	} else {

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
