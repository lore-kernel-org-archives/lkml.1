Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXK0BFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXK0BFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXK0BFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:05:35 -0500
Received: from namei.org ([69.55.235.186]:51826 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706AbXK0BFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:05:34 -0500
Date: Tue, 27 Nov 2007 12:04:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       selinux@tycho.nsa.gov, alan@redhat.com, chrisw@redhat.com,
       hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3 -v2] mmap: round mmap hint address above mmap_min_addr
In-Reply-To: <1196120860.16779.14.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711271204241.17892@us.intercode.com.au>
References: <1196120860.16779.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Eric Paris wrote:

> If mmap_min_addr is set and a process attempts to mmap (not fixed) with
> a non-null hint address less than mmap_min_addr the mapping will fail
> the security checks.  Since this is just a hint address this patch will
> round such a hint address above mmap_min_addr.
> 
> gcj was found to try to be very frugal with vm usage and give hint
> addresses in the 8k-32k range.  Without this patch all such programs
> failed and with the patch they happily get a higher address.
> 
> This patch is wrappad in CONFIG_SECURITY since mmap_min_addr doesn't
> exist without it and there would be no security check possible no matter
> what.  So we should not bother compiling in this rounding if it is just a
> waste of time.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


> 
> ---
> 
>  include/linux/mm.h |   16 ++++++++++++++++
>  mm/mmap.c          |    3 +++
>  mm/nommu.c         |    3 +++
>  3 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 520238c..1b7b95c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -12,6 +12,7 @@
>  #include <linux/prio_tree.h>
>  #include <linux/debug_locks.h>
>  #include <linux/mm_types.h>
> +#include <linux/security.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -513,6 +514,21 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
>  }
>  
>  /*
> + * If a hint addr is less than mmap_min_addr change hint to be as
> + * low as possible but still greater than mmap_min_addr
> + */
> +static inline unsigned long round_hint_to_min(unsigned long hint)
> +{
> +#ifdef CONFIG_SECURITY
> +	hint &= PAGE_MASK;
> +	if (((void *)hint != NULL) &&
> +	    (hint < mmap_min_addr))
> +		return PAGE_ALIGN(mmap_min_addr);
> +#endif
> +	return hint;
> +}
> +
> +/*
>   * Some inline functions in vmstat.h depend on page_zone()
>   */
>  #include <linux/vmstat.h>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 938313c..f4cfc6a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -912,6 +912,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
>  	if (!len)
>  		return -EINVAL;
>  
> +	if (!(flags & MAP_FIXED))
> +		addr = round_hint_to_min(addr);
> +
>  	error = arch_mmap_check(addr, len, flags);
>  	if (error)
>  		return error;
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 35622c5..b989cb9 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -829,6 +829,9 @@ unsigned long do_mmap_pgoff(struct file *file,
>  	void *result;
>  	int ret;
>  
> +	if (!(flags & MAP_FIXED))
> +		addr = round_hint_to_min(addr);
> +
>  	/* decide whether we should attempt the mapping, and if so what sort of
>  	 * mapping */
>  	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
> 
> 

-- 
James Morris
<jmorris@namei.org>
