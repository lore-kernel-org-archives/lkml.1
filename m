Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYE0UEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYE0UEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbYE0UEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:04:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757626AbYE0UEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:04:32 -0400
Date: Tue, 27 May 2008 13:04:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, viro@ZenIV.linux.org.uk,
       adobriyan@gmail.com, hannes@saeurebad.de
Subject: Re: [PATCH] ERR_PTR: warn when ERR_PTR parameter is valid argument
Message-Id: <20080527130413.14dca0cf.akpm@linux-foundation.org>
In-Reply-To: <1211475019-5596-2-git-send-email-marcin.slusarz@gmail.com>
References: <1211475019-5596-1-git-send-email-marcin.slusarz@gmail.com>
	<1211475019-5596-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 18:50:19 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Check at runtime whether error argument of ERR_PTR is valid.
> It can catch bugs which possibly lead to oops or panic earlier.
> 
> Currently there are > 600 calls of ERR_PTR with non-constant argument.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Johannes Weiner <hannes@saeurebad.de>
> ---
>  include/linux/err.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index 4773ed3..f7e098e 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/compiler.h>
>  
> +#include <asm/bug.h>
>  #include <asm/errno.h>
>  
>  /*
> @@ -22,6 +23,7 @@
>  
>  static inline void *__ERR_PTR(long error)
>  {
> +	WARN_ON(!VALID_ERR_PTR_ARG(error));
>  	return (void *) error;
>  }

It would be regrettable to add source-level complexity and runtime cost
to detect this particular bug.  I think it would be better to do this
via static source-code checking if at all possible.

Is there _any_ legitimate use of non-negative EFOO?  There might be
some baroque bits of code which are using non-negative constants in a
non-buggy fashion, but I bet they could be reworked to use negative
constants.

In which case I'd have thought that a script which

a) extracts all the EFOO identifiers from include/*/errno.h and

b) greps the tree for non-negative uses of those

would have 100% coverage?

We might need to touch up some code sites to avoid triggering false
positives and make that script's life a bit easier, but that's fine.
