Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYELXim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYELXim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYELXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:38:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbYELXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:38:32 -0400
Date: Mon, 12 May 2008 16:38:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] let ERR_PTR BUILD_BUG_ON when we know its argument is
 not a valid errno
Message-Id: <20080512163830.04ef13fd.akpm@linux-foundation.org>
In-Reply-To: <20080511201209.GO19058@joi>
References: <20080511201209.GO19058@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 22:12:14 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Andrew Morton <akpm@osdl.org>
> ---
> allmodconfig compile tested (on x86_64)
> 
> should be applied after:
> net/sunrpc/xprtrdma: fix svc_rdma_create out of memory error path
> jfs: 0 is not valid errno value
> ---
>  include/linux/err.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -19,11 +19,13 @@
>  
>  #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>  
> -static inline void *ERR_PTR(long error)
> +static inline void *__ERR_PTR(long error)
>  {
>  	return (void *) error;
>  }
>  
> +#define ERR_PTR(error) (BUILD_BUG_ON(!IS_ERR_VALUE(error)), __ERR_PTR(error))
> +
>  static inline long PTR_ERR(const void *ptr)
>  {
>  	return (long) ptr;

Not sure about this one.  BUILD_BUG_ON only makes sense if the value is
a compile-time constant.  I think the code as you have it will take this:

	int e = foo();

	p = ERR_PTR(e);

and will attempt to evaluate sizeof() on a negative-sized array at
runtime.  The conmpile will laugh and throw that all away, but it's a
bit weird.

Plus I'd have thought that the amount of code which does ERR_PTR(-EFOO)
is fairly small, but perhaps that's wrong.

If I _am_ wrong then I do think it'd be saner to only do the
BUILD_BUG_ON() if __builtin_constant_p(error) evaluates true.  And even
then I do think we'd like to see a more lengthy justification of why
the kernel needs this check.  More lengthy than zero, anyway...

(If a compile-time check is needed then why not a runtime one also?)

Thanks.
