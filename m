Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZBYRJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZBYRJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZBYRJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:09:45 -0500
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:35623 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753639AbZBYRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:09:45 -0500
Date: Wed, 25 Feb 2009 12:09:02 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aoe: error printed 1 too early
Message-ID: <20090225170901.GA26634@coraid.com>
References: <49A549EE.7020202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A549EE.7020202@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:38:54PM +0100, Roel Kluin wrote:
> with while (i-- > 0); i reaches -1 after the loop, so the test below is printed
> one too early: 0 still means success.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> index cc25057..eeea477 100644
> --- a/drivers/block/aoe/aoedev.c
> +++ b/drivers/block/aoe/aoedev.c
> @@ -173,7 +173,7 @@ skbfree(struct sk_buff *skb)
>  		return;
>  	while (atomic_read(&skb_shinfo(skb)->dataref) != 1 && i-- > 0)
>  		msleep(Sms);
> -	if (i <= 0) {
> +	if (i < 0) {
>  		printk(KERN_ERR
>  			"aoe: %s holds ref: %s\n",
>  			skb->dev ? skb->dev->name : "netif",
> 

You are talking about the case where, when entering the loop on the
"last chance" iteration, the states are,

  atomic_read(&skb_shinfo(skb)->dataref == 1
  i == 0

... in which case, the skb can and should be used but is not used
because after the value of i is tested it becomes -1.

Right?

Sounds like a good catch.  Did you find it because you saw the "cannot
free skb" message?

-- 
  Ed Cashin <ecashin@coraid.com>
