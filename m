Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYEVQER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYEVQER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYEVQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:04:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:40136 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYEVQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HG+vbWNdDydcaOin/oRdlA2qpKQ6tiSJ1hLsolVmfFoINcJKFfPtKSt24LlCXOXM2cSm3meSGXXstwRfPALcE4ws2UEngvxUQegPmHKRPOmTr6PQPxF1135NnqfaI93KocQTmCTCcaZgqEFxZBEk23ffwoXt/FFkbxl3eDW1o9g=
Date: Thu, 22 May 2008 18:03:27 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       tom@opengridcomputing.com
Subject: Re: [PATCH 1/6] ERR_PTR: if errno value is known at compile time,
	make sure it's valid
Message-ID: <20080522160323.GB8447@joi>
References: <20080513201813.GA5869@joi> <1211147818-16056-2-git-send-email-marcin.slusarz@gmail.com> <20080519063852.GA4707@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519063852.GA4707@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:38:52AM +0400, Alexey Dobriyan wrote:
> On Sun, May 18, 2008 at 11:56:53PM +0200, Marcin Slusarz wrote:
> > ERR_PTR is easy to call with wrong argument (positive errno),
> > and this error lead to catastrophic event - oops or kernel panic
> > (dereference of invalid pointer).
> > 
> > As most of error handling code paths are rarely tested, this kind of
> > bug can be hidden for years.
> > 
> > (Currently there are > 1400 calls of ERR_PTR with constant argument.)
> 
> > --- a/include/linux/err.h
> > +++ b/include/linux/err.h
> > @@ -19,11 +19,13 @@
> >  
> >  #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
> >  
> > -static inline void *ERR_PTR(long error)
> > +static inline void *__ERR_PTR(long error)
> >  {
> >  	return (void *) error;
> >  }
> >  
> > +#define ERR_PTR(error) (BUILD_BUG_ON(__builtin_constant_p(error) && !IS_ERR_VALUE(error)), __ERR_PTR(error))
> 
> This needs comment that this construct must be a macro, otherwise gcc
> does something stupid and doesn't break the build (at least in the case
> below).
Thanks, added to new version.

> BTW, I used grep(1) to find it.

http://lkml.org/lkml/2008/5/11/159

> 
> [PATCH] xprtrdma: fix ERR_PTR(E typo
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -661,7 +661,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
>  
>  	cma_xprt = rdma_create_xprt(serv, 1);
>  	if (!cma_xprt)
> -		return ERR_PTR(ENOMEM);
> +		return ERR_PTR(-ENOMEM);
>  	xprt = &cma_xprt->sc_xprt;
>  
>  	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);
> 
