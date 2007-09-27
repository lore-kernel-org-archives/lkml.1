Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXI0XyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXI0XyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbXI0Xx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:53:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609AbXI0Xx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:53:59 -0400
Date: Thu, 27 Sep 2007 16:53:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML - Correctly handle skb allocation failures
Message-Id: <20070927165340.fd5dc2d0.akpm@linux-foundation.org>
In-Reply-To: <20070927170126.GA6542@c2.user-mode-linux.org>
References: <20070927170126.GA6542@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 13:01:26 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> +static int update_drop_skb(int max)
> +{
> +	struct sk_buff *new;
> +	int err = 0;
> +
> +	spin_lock(&drop_lock);
> +
> +	if (max <= drop_max)
> +		goto out;
> +
> +	err = -ENOMEM;
> +	new = dev_alloc_skb(max);
> +	if (new == NULL)
> +		goto out;
> +
> +	skb_put(new, max);
> +
> +	kfree_skb(drop_skb);
> +	drop_skb = new;
> +	drop_max = max;
> +	err = 0;
> +out:
> +	spin_unlock(&drop_lock);
> +
> +	return err;
> +}
> +
>  static int uml_net_rx(struct net_device *dev)
>  {
>  	struct uml_net_private *lp = dev->priv;
> @@ -43,6 +82,9 @@ static int uml_net_rx(struct net_device 
>  	/* If we can't allocate memory, try again next round. */
>  	skb = dev_alloc_skb(lp->max_packet);
>  	if (skb == NULL) {
> +		drop_skb->dev = dev;
> +		/* Read a packet into drop_skb and don't do anything with it. */
> +		(*lp->read)(lp->fd, drop_skb, lp);
>  		lp->stats.rx_dropped++;
>  		return 0;

Still wanna know why it is safe for uml_net_rx to be playing with
drop_skb when update_drop_skb() could be concurrently reallocating
and freeing it.
