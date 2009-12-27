Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbZL0Vqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbZL0Vqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZL0Vqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:46:53 -0500
Received: from www84.your-server.de ([213.133.104.84]:38405 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZL0Vqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:46:52 -0500
Subject: Re: [PATCH] [2/6] kfifo: Make kfifo_in atomic
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227210312.A60FCB17C3@basil.firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210312.A60FCB17C3@basil.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:46:45 +0100
Message-ID: <1261950405.25298.30.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> Right now kfifo_in allows copying in less than the input
> amount. This is unfortunately not a good idea on any
> record oriented users: if the size of the kfifo is not
> a multiple of the record (and that can easily happen due
> to the power-of-two requirement) then when the FIFO fills
> up partial records could be put in. Such a condition would
> be fatal for any record consumer who would get permanently
> desynchronized. In fact I doubt unless the input 
> is a totally boundary less data stream I doubt anything
> could handle this.
> 
> Change kfifo_in() to always put in everything or nothing.
> 
> The return value is now always 0 or the full length.
> 

That is why had written the macro version of kfifo. This provide an type
save kfifo implementation where struct records never will be splitted.
Have a look at the sample code in
http://patchwork.kernel.org/patch/69093/

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  kernel/kfifo.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: linux/kernel/kfifo.c
> ===================================================================
> --- linux.orig/kernel/kfifo.c
> +++ linux/kernel/kfifo.c
> @@ -228,9 +228,8 @@ EXPORT_SYMBOL(__kfifo_in_n);
>   * @from: the data to be added.
>   * @len: the length of the data to be added.
>   *
> - * This function copies at most @len bytes from the @from buffer into
> - * the FIFO depending on the free space, and returns the number of
> - * bytes copied.
> + * This function copies @len bytes from the @from buffer into
> + * the FIFO and returns 0 if there is not enough space.
>   *
>   * Note that with only one concurrent reader and one concurrent
>   * writer, you don't need extra locking to use these functions.
> @@ -238,8 +237,8 @@ EXPORT_SYMBOL(__kfifo_in_n);
>  unsigned int kfifo_in(struct kfifo *fifo, const void *from,
>  				unsigned int len)
>  {
> -	len = min(kfifo_avail(fifo), len);
> -
> +	if (kfifo_avail(fifo) < len)
> +		return 0;
>  	__kfifo_in_data(fifo, from, len, 0);
>  	__kfifo_add_in(fifo, len);
>  	return len;


