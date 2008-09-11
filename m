Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYIKWo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYIKWo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 18:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYIKWov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 18:44:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYIKWou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:44:50 -0400
Message-ID: <48C99F29.2030007@zytor.com>
Date: Thu, 11 Sep 2008 15:43:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update3] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu>
In-Reply-To: <200809090641.m896fscX028849@hitchhiker.org.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> From: Alain Knaff <alain@knaff.lu>
> 
> This is an updated version of my bzip2/lzma patch
> 
> It is based on an idea by Christian Ludwig, includes support for
> compressing the kernel with bzip2 or lzma rather than gzip. Both
> compressors give smaller sizes than gzip.  Lzma's decompresses faster
> than bzip2.
> 
> It also supports ramdisks and initramfs' compressed using these two
> compressors.
> 
> The functionality has been successfully used for a couple of years by
> the udpcast project
> 
> This version applies to "tip" kernel 2.6.27-rc5
> 
> Changes since last version (update2):
> 
> - Removed NEW_CODE #ifdef : non-Intel architectures will be patched
>   eventually anyways
> - Replaced IN_MEMORY #ifdefs by (less efficient) runtime checks
> 
> Signed-off-by: Alain Knaff <alain@knaff.lu>

Looks a lot better now.  See the following, though:

> -#define OF(args)	args
>  #define STATIC		static
> +#define NEW_CODE

Should be deleted, right?

>  
> -	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
> +	phdrs = (void *) malloc(sizeof(*phdrs) * ehdr.e_phnum);
>  	if (!phdrs)

malloc() returns a void pointer already...

> +
> +#ifdef CONFIG_RD_BZIP2
> +	/*
> +	 * If it matches the bzip magic numbers, return -1
> +	 */
> +	if (buf[0] == 0x42 && (buf[1] == 0x5a)) {
> +		printk(KERN_NOTICE
> +		       "RAMDISK: Bzipped image found at block %d\n",
> +		       start_block);
> +		*uncompressor = bunzip2;
>  		nblocks = 0;
>  		goto done;
>  	}
> +#endif
> +
> +#ifdef CONFIG_RD_LZMA
> +	/*
> +	 * If it matches the bzip magic numbers, return -1
                              ^^^^
                              ????
> +	 */
> +	if (buf[0] == 0x5d && (buf[1] == 0x00)) {
> +		printk(KERN_NOTICE
> +		       "RAMDISK: Lzma image found at block %d\n",
> +		       start_block);



> -#define OF(args)  args
> +#ifdef CONFIG_RD_BZIP2
> +#include <linux/decompress_bunzip2.h>
> +#endif
> +#ifdef CONFIG_RD_LZMA
> +#include <linux/decompress_unlzma.h>
>  #endif

There is no reason to include header files conditionally.

It might be worthwhile to create a proper subdirectory rather than using 
an underscored namespace (also, in general, dashes are preferred in 
filenames.)


> +#ifndef always_inline
> +#  if defined(__GNUC__) && (__GNUC__ > 3 || __GNUC__ == 3 && __GNUC_MINOR__ > 0)
> +#    define always_inline __attribute__((always_inline)) inline
> +#  else
> +#    define always_inline inline
> +#  endif
> +#endif

Any reason to not just use <linux/compiler.h> here?

> +#ifdef CONFIG_FEATURE_LZMA_FAST
> +#  define speed_inline always_inline
> +#else
> +#  define speed_inline
> +#endif

Should this be always_inline or just plain inline?

	-hpa
