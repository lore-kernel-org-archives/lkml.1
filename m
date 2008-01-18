Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbYARXM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbYARXM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYARXMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:12:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:14331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbYARXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=h0FXp86KwuEhskOhKXHBVm3h1ucn5/r/SsC6wZ1nZmSUs69JiW9ygUyP+iCqwUpXLS3tycnjhvuR2TiXST3NZkVYREkvkn3Pz3pOv235L0g+Iyb6lUtnwtoLyJgBSFBoOsIvvfLpjk7Dkul5N0CdY/YB90uWs5jd99H3F5GmtL4=
Message-ID: <47913261.5000708@gmail.com>
Date: Sat, 19 Jan 2008 08:12:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190725.24271.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au>
In-Reply-To: <200801190727.36567.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Just a trivial example.
> ---
>  drivers/lguest/lguest_device.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -r 00ab7672f658 drivers/lguest/lguest_device.c
> --- a/drivers/lguest/lguest_device.c	Thu Jan 17 16:54:00 2008 +1100
> +++ b/drivers/lguest/lguest_device.c	Thu Jan 17 16:59:46 2008 +1100
> @@ -179,9 +179,8 @@ static void lg_notify(struct virtqueue *
>  	hcall(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT, 0, 0);
>  }
>  
> -static irqreturn_t lguest_interrupt(int irq, void *_vq)
> +static irqreturn_t lguest_interrupt(int irq, struct virtqueue *vq)
>  {
> -	struct virtqueue *vq = _vq;
>  	struct lguest_device_desc *desc = to_lgdev(vq->vdev)->desc;
>  
>  	if (unlikely(desc->config_change)) {

Type safety is good but I doubt this would be worth the complexity.  It
has some benefits but there's much larger benefit in keeping things in
straight C.  People know that functions take fixed types and are also
familiar with the convention of passing void * for callback arguments.
IMHO, staying in line with those common knowledges easily trumps having
type checking on interrupt handler.

Also, how often do we see a bug where things go wrong because interrupt
handler is given the wrong type of argument?  Even when such bug
happens, I doubt it can escape the developer's workstation if he/she is
paying any attention to testing.

Thanks.

-- 
tejun
