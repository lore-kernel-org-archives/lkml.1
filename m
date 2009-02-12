Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbZBLTAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbZBLTAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbZBLTAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:00:07 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53481 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbZBLTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:00:06 -0500
Date: Fri, 13 Feb 2009 03:56:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 64-bit
Message-ID: <20090212185640.GA6111@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-mm@vger.kernel.org
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 06:51:13PM +0100, Giuseppe CAVALLARO wrote:
> I think, this fix is necessary for all the architectures want to
> perform DMA into kmalloc caches and need a guaranteed alignment
> larger than the alignment of a 64-bit integer.
> An example is sh architecture where ARCH_KMALLOC_MINALIGN is L1_CACHE_BYTES.
> 
> As side effect, these kind of objects cannot be visible
> within the /proc/slab_allocators file.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index ddc41f3..031d785 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2262,7 +2262,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  		ralign = align;
>  	}
>  	/* disable debug if necessary */
> -	if (ralign > __alignof__(unsigned long long))
> +	if (ralign > ARCH_KMALLOC_MINALIGN)
>  		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>  	/*
>  	 * 4) Store it.

No, this change in itself is not sufficient. The redzone marker placement
as well as that of the user store need to know about the minalign as well
before slab debug can work correctly.

I last looked at this when introducing ARCH_SLAB_MINALIGN:

http://article.gmane.org/gmane.linux.kernel/262528

But it would need some rework for the current slab code.

Note that the ARCH_KMALLOC_MINALIGN value has no meaning here, as this
relates to slab caches in general, of which kmalloc just happens to have
a few. This is also why the rest of the kmem_cache_create() code
references ARCH_SLAB_MINALIGN in the first place. But that in itself is
irrelevant since for the kmalloc slab caches, ARCH_KMALLOC_MINALIGN is
already passed in as the align value for kmem_cache_create(), so ralign
is already set to L1_CACHE_BYTES immediately before that check.

What exactly are you having problems with that made you come up with this
patch? It would be helpful to know precisely what your issues are, as
this change in itself is only related to slab debug, and not general
operation.
