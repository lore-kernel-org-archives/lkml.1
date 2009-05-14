Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZENRl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZENRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZENRlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:41:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40075 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZENRlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:41:17 -0400
Date: Thu, 14 May 2009 13:40:09 -0400
From: Josef Bacik <josef@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Introduce check_readable_bytes()
Message-ID: <20090514173858.GA10059@dhcp231-156.rdu.redhat.com>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-2-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242317939-15392-2-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 06:19:00PM +0200, Vitaly Mayatskikh wrote:
> This routine acts almost as fault_in_pages_readable(), but returns
> accessible amount of bytes instead of plain OK/FAIL, so callers
> may know how many data can be proceeded without GPF.
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> ---
>  include/linux/pagemap.h |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 34da523..f931308 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -439,6 +439,41 @@ static inline int fault_in_pages_readable(const char __user *uaddr, int size)
>  	return ret;
>  }
>  
> +/*
> + * check_readable_bytes - check if given amount of bytes can be read
> + * at given address.
> + * @uaddr: address to check
> + * @size: size to check
> + *
> + * Returns 0 when @size is 0, -EFAULT when @uaddr points to
> + * unaccessible region, or count of accessible bytes.
> + */
> +static inline int check_readable_bytes(const char __user *uaddr, int size)
> +{
> +	volatile char c;
> +	int ret = 0;
> +	long page_begin = (unsigned long)uaddr & PAGE_MASK;
> +	long page_end = ((unsigned long)uaddr + size) & PAGE_MASK;
> +	long ptr = page_begin;
> +

Firstly page_begin/page_end/ptr should all be unsigned long.  Secondly page_end
should be uaddr+size-1.

> +	if (unlikely(size == 0))
> +		goto out;
> +
> +	while (!ret && ptr <= page_end) {
> +		ret = __get_user(c, (const char __user*)ptr);
> +		if (!ret)
> +			ptr += PAGE_SIZE;
> +	}
> +
> +	if (likely(!ret))
> +		ret = size;
> +	else
> +		ret = (ptr == page_begin) ?
> +			-EFAULT : (const char __user *)ptr - uaddr;

This isn't quite right either, we do some pointer math, and return that and its
casted as an int?  That seems like a bad idea in general.  Thanks,

Josef
