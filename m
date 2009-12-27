Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbZL0Vtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbZL0Vtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZL0Vty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:49:54 -0500
Received: from www84.your-server.de ([213.133.104.84]:42674 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZL0Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:49:54 -0500
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227210314.ABA04B17C3@basil.firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210314.ABA04B17C3@basil.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:49:49 +0100
Message-ID: <1261950589.25298.32.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> In some upcoming code it's useful to peek into a FIFO without
> permanentely removing data. This patch implements a new 
> kfifo_out_peek() to do this. 
> 

Yes this function can be useful. I will implement it in the macro
version of the kfifo.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/kfifo.h |    3 +++
>  kernel/kfifo.c        |   21 +++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> Index: linux/include/linux/kfifo.h
> ===================================================================
> --- linux.orig/include/linux/kfifo.h
> +++ linux/include/linux/kfifo.h
> @@ -114,6 +114,9 @@ extern unsigned int kfifo_in(struct kfif
>  				const void *from, unsigned int len);
>  extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
>  				void *to, unsigned int len);
> +extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
> +				void *to, unsigned int len, unsigned offset);
> +
>  
>  /**
>   * kfifo_reset - removes the entire FIFO contents
> Index: linux/kernel/kfifo.c
> ===================================================================
> --- linux.orig/kernel/kfifo.c
> +++ linux/kernel/kfifo.c
> @@ -301,6 +301,27 @@ unsigned int kfifo_out(struct kfifo *fif
>  }
>  EXPORT_SYMBOL(kfifo_out);
>  
> +/**
> + * kfifo_out_peek - copy some data from the FIFO, but do not remove it
> + * @fifo: the fifo to be used.
> + * @to: where the data must be copied.
> + * @len: the size of the destination buffer.
> + * @offset: offset into the fifo
> + *
> + * This function copies at most @len bytes at @offset from the FIFO
> + * into the @to buffer and returns the number of copied bytes.
> + * The data is not removed from the FIFO.
> + */
> +unsigned int kfifo_out_peek(struct kfifo *fifo, void *to, unsigned int len,
> +			    unsigned offset)
> +{
> +	len = min(kfifo_len(fifo), len + offset);
> +
> +	__kfifo_out_data(fifo, to, len, offset);
> +	return len;
> +}
> +EXPORT_SYMBOL(kfifo_out_peek);
> +
>  unsigned int __kfifo_out_generic(struct kfifo *fifo,
>  	void *to, unsigned int len, unsigned int recsize,
>  	unsigned int *total)


