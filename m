Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZFRTp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZFRTp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZFRTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:45:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZFRTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:45:20 -0400
Date: Thu, 18 Jun 2009 15:45:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, gerg@uclinux.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] m68k: merge the mmu and non-mmu versions of checksum.h
Message-ID: <20090618194521.GA7464@infradead.org>
References: <200906170711.n5H7BFw9009030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906170711.n5H7BFw9009030@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 05:11:15PM +1000, Greg Ungerer wrote:
> +#ifdef CONFIG_MMU
>  /*
>   *	This is a version of ip_compute_csum() optimized for IP headers,
>   *	which always checksum on 4 octet boundaries.
> @@ -59,6 +61,9 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
>  		 : "memory");
>  	return (__force __sum16)~sum;
>  }
> +#else
> +__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
> +#endif

Any good reason this is inline for all mmu processors and out of line
for nommu, independent of the actual cpu variant?

>  static inline __sum16 csum_fold(__wsum sum)
>  {
>  	unsigned int tmp = (__force u32)sum;
> +#ifdef CONFIG_COLDFIRE
> +	tmp = (tmp & 0xffff) + (tmp >> 16);
> +	tmp = (tmp & 0xffff) + (tmp >> 16);
> +	return (__force __sum16)~tmp;
> +#else
>  	__asm__("swap %1\n\t"
>  		"addw %1, %0\n\t"
>  		"clrw %1\n\t"
> @@ -74,6 +84,7 @@ static inline __sum16 csum_fold(__wsum sum)
>  		: "=&d" (sum), "=&d" (tmp)
>  		: "0" (sum), "1" (tmp));
>  	return (__force __sum16)~sum;
> +#endif
>  }

I think this would be cleaner by having totally separate functions
for both cases, e.g.

#ifdef CONFIG_COLDFIRE
static inline __sum16 csum_fold(__wsum sum)
{
	unsigned int tmp = (__force u32)sum;

	tmp = (tmp & 0xffff) + (tmp >> 16);
	tmp = (tmp & 0xffff) + (tmp >> 16);

	return (__force __sum16)~tmp;
}
#else
...
#endif
