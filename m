Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYK0APw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYK0APw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYK0APm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:15:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYK0APl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:15:41 -0500
Date: Wed, 26 Nov 2008 16:15:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARN_ON out of range error in ERR_PTR?
Message-Id: <20081126161503.6211f140.akpm@linux-foundation.org>
In-Reply-To: <492D6FB8.80401@panasas.com>
References: <492D6FB8.80401@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 17:48:08 +0200
Benny Halevy <bhalevy@panasas.com> wrote:

> Andrew,
> 
> After hitting a bug where an nfs error -10021 wasn't handled
> correctly since IS_ERR returned false on its ERR_PTR value

That sounds like an error in NFS.  Did it get fixed?

> I realized that adding a BUG_ON to make sure the mapped error
> is in the valid range would have caught this.
> 
> Since ERR_PTR is not called on the critical path
> (unlike IS_ERR) but rather on the error handling path I believe
> we can tolerate the extra cost.
> 
> The reason this is just a WARN_ON and not BUG_ON is to make
> fixing it easier, although I do consider calling ERR_PTR on an
> out of range error a pretty dangerous bug as the error might go
> unnoticed.
> 
> How about committing the following patch to -mm?
> 
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  include/linux/err.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index ec87f31..81df84f 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -2,7 +2,7 @@
>  #define _LINUX_ERR_H
>  
>  #include <linux/compiler.h>
> -
> +#include <asm/bug.h>
>  #include <asm/errno.h>
>  
>  /*
> @@ -21,6 +21,7 @@
>  
>  static inline void *ERR_PTR(long error)
>  {
> +	WARN_ON(error && !IS_ERR_VALUE(error));
>  	return (void *) error;
>  }

We have over 2000 ERR_PTR callsites, and WARN_ON() is a big fat porky
thing, so this change would add quite a lot of kernel text&data.

If this problem does occur again, I expect that the kernel will
reliably dereference a small negative address and we'll get an oops,
which will give us the same information as that WARN_ON would have
done, no?



