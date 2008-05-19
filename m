Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYESFn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYESFn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYESFnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:43:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYESFnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jYpSFgJK40xqVoI8WTwmf0YBq+cTTalTvCV4QQKt4sdaKVmciHoo6AKUgB4a0Wg+aPLEXoFGEWoIvG+uaJ+NoB3RHRANa+Zcl6/kHQUDaIw8PQA0y/hWRaFOTISXu5rdfjTbf/NEhIlhFn5JO4P9X0nWHsJVdexymgM2F9BKvCQ=
Date: Mon, 19 May 2008 10:38:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       tom@opengridcomputing.com
Subject: Re: [PATCH 1/6] ERR_PTR: if errno value is known at compile time,
	make sure it's valid
Message-ID: <20080519063852.GA4707@martell.zuzino.mipt.ru>
References: <20080513201813.GA5869@joi> <1211147818-16056-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211147818-16056-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 11:56:53PM +0200, Marcin Slusarz wrote:
> ERR_PTR is easy to call with wrong argument (positive errno),
> and this error lead to catastrophic event - oops or kernel panic
> (dereference of invalid pointer).
> 
> As most of error handling code paths are rarely tested, this kind of
> bug can be hidden for years.
> 
> (Currently there are > 1400 calls of ERR_PTR with constant argument.)

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
> +#define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && !IS_ERR_VALUE(error)), __ERR_PTR(error))

This needs comment that this construct must be a macro, otherwise gcc
does something stupid and doesn't break the build (at least in the case
below). BTW, I used grep(1) to find it.


[PATCH] xprtrdma: fix ERR_PTR(E typo

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -661,7 +661,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 
 	cma_xprt = rdma_create_xprt(serv, 1);
 	if (!cma_xprt)
-		return ERR_PTR(ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	xprt = &cma_xprt->sc_xprt;
 
 	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);

