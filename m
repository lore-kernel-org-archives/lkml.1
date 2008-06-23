Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYFWWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYFWWiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYFWWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:38:15 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30078 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752605AbYFWWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:38:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fm8HT4t2N+v8zwoVC0R82JBIxUSeUtN0KVqpH6vDTsiCKvGHi04ZnJ/JIeZ59uPFlCMh6ysdz7VEKR3bZSADPmzN4oGFBUFV3Ytmdi7ee2LTPB25F+EFxJ9E/yD+/vh5j4hU8UcZUg5lBNN7YGmY45UiqyRoep9AcYPWgb+GSPQ=  ;
X-YMail-OSG: F1yYuisVM1lM3mSjXmjEitA6cDccJj8w0.7q9CBcpMxMcoOaVyTfIJ3aVzqr40UaxL3DF1._tVI8OxW1WD280o77ISzmtKnj63jZfqBASWMWAdBjFW8MdzVpc_OGMMqbCg8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] USB: fix possible memory leak in pxa27x_udc
Date: Mon, 23 Jun 2008 15:38:12 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Daniel =?iso-8859-1?q?Marjam=E4ki?= <danielm77@spray.se>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20080622090813.GA11823@joi>
In-Reply-To: <20080622090813.GA11823@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231538.12199.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008, Marcin Slusarz wrote:

> --- a/drivers/usb/gadget/pxa27x_udc.c
> +++ b/drivers/usb/gadget/pxa27x_udc.c
> @@ -650,8 +650,11 @@ pxa_ep_alloc_request(struct usb_ep *_ep, gfp_t gfp_flags)
>  {
>  	struct pxa27x_request *req;
>  
> +	if (!_ep)
> +		return NULL;
> +

Correct enough as it goes, except that it *can't* be null by virtue
of how it's called.  See <include/linux/usb/gadget.h> for:

static inline struct usb_request *usb_ep_alloc_request(struct usb_ep *ep,
                                                       gfp_t gfp_flags)
{
        return ep->ops->alloc_request(ep, gfp_flags);
}

If it were null it couldn't get here.  A better fix would just
remove the null check here (and possibly elsewhere).

- Dave


>  	req = kzalloc(sizeof *req, gfp_flags);
> -	if (!req || !_ep)
> +	if (!req)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&req->queue);
> -- 
> 1.5.4.5
> 


