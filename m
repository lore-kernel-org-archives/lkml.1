Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYARCON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYARCON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbYARCN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:13:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbYARCNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:13:54 -0500
Message-ID: <479008E5.1070706@zytor.com>
Date: Thu, 17 Jan 2008 21:03:17 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: akpm@linux-foundation.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: [mm patch] i915: fix invalid opcode exception on cpus without
 clflush
References: <20080117235203.GB21681@phobos.i.cabal.ca>
In-Reply-To: <20080117235203.GB21681@phobos.i.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> i915_flush_ttm was unconditionally executing a clflush instruction
> to (obviously) flush the cache. Instead, check if the cpu supports
> clflush, and if not, fall back to calling wbinvd to flush the entire
> cache.
> 
> Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
> 
> --- a/drivers/char/drm/i915_buffer.c
> +++ b/drivers/char/drm/i915_buffer.c
> @@ -286,7 +286,18 @@ void i915_flush_ttm(struct drm_ttm *ttm)
>  		return;
>  
>  	DRM_MEMORYBARRIER();
> +
> +#ifdef CONFIG_X86_32
> +	/* Hopefully nobody has built an x86-64 processor without clflush */
> +	if (!cpu_has_clflush) {
> +		wbinvd();
> +		DRM_MEMORYBARRIER();
> +		return;
> +	}
> +#endif
> +
>  	for (i = ttm->num_pages - 1; i >= 0; i--)
>  		drm_cache_flush_page(drm_ttm_get_page(ttm, i));
> +
>  	DRM_MEMORYBARRIER();
>  }

The #ifdef is bogus.  If it's required, it should go into 
asm-x86/required_features.h and then cpu_has_clflush is static; 
otherwise it's just plain wrong.

	-hpa

