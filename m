Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbYG3ILE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbYG3ILE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYG3IKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:10:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYG3IKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:10:45 -0400
Date: Wed, 30 Jul 2008 01:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Make ioctl.h compatible with userland
Message-Id: <20080730011035.a7d84e55.akpm@linux-foundation.org>
In-Reply-To: <20080728063957.J72435@saturn.araneidae.co.uk>
References: <20080728063957.J72435@saturn.araneidae.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 06:48:52 +0000 (GMT) Michael Abbott <michael@araneidae.co.uk> wrote:

> The attached patch seems to already exist in a number of branches -- it 
> keeps popping up on Google for me, and is certainly already in Debian -- 
> but is strangely absent from mainstream.
> 
> The problem appears to be that the patched file ends up as part of the 
> target toolchain, but unfortunately the gcc constant folding doesn't 
> appear to eliminate the __invalid_size_argument_for_IOC value early 
> enough.  Certainly compiling C++ programs which use _IO... macros as 
> constants fails without this patch.

Could be that `-O0' is associated with the problems.

Plus compilers other than gcc can legitimately use this header.

> No doubt this has been pushed upstream before: this problem seems to date 
> from the very early days of 2.6 ... but here it is again.  It makes sense 
> to do it.
> 
> 
> commit 0df6f37b4e4534f219b5e40cb49ffd9311eb6195
> Author: Michael Abbott <michael.abbott@diamond.ac.uk>
> Date:   Mon Jul 28 07:32:05 2008 +0100
> 
>     Add long established but strangely absent patch to allow ioctl.h to
>     work smoothly with userspace program optimisations.
> 
> diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
> index 8641813..15828b2 100644
> --- a/include/asm-generic/ioctl.h
> +++ b/include/asm-generic/ioctl.h
> @@ -68,12 +68,16 @@
>  	 ((nr)   << _IOC_NRSHIFT) | \
>  	 ((size) << _IOC_SIZESHIFT))
>  
> +#ifdef __KERNEL__
>  /* provoke compile error for invalid uses of size argument */
>  extern unsigned int __invalid_size_argument_for_IOC;
>  #define _IOC_TYPECHECK(t) \
>  	((sizeof(t) == sizeof(t[1]) && \
>  	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>  	  sizeof(t) : __invalid_size_argument_for_IOC)
> +#else
> +#define _IOC_TYPECHECK(t) (sizeof(t))
> +#endif
>  
>  /* used to create numbers */
>  #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)

Gee.

But yes, the patch looks reasonable.

We could also replace that open-coded assertion with the shiny new
BUILD_BUG_ON(), which would a) be cleaner and b) fix the problem which
you describe.  I expect that would be quite safe, but obviously doesn't
have all the testing which the above patch has, so shrug.


