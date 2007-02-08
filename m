Return-Path: <linux-kernel-owner+w=401wt.eu-S965722AbXBHJix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965722AbXBHJix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965725AbXBHJix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:38:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965722AbXBHJiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:38:52 -0500
Date: Thu, 8 Feb 2007 01:38:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cong WANG" <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stelian Pop <stelian@popies.net>
Subject: Re: [PATCH] kfifo: overflow of unsigned integer
Message-Id: <20070208013845.542ad7b0.akpm@linux-foundation.org>
In-Reply-To: <2375c9f90702080107v7088f835h7cdf5373d36d3c14@mail.gmail.com>
References: <2375c9f90702080107v7088f835h7cdf5373d36d3c14@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 17:07:28 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:

> Kfifo is a ring-buffer in kernel which can be used as a lock-free way
> for concurrent read/write when there are only one producer and one
> consumer. Details of its design can be found in kernel/kfifo.c and
> include/linux/kfifo.h.
> 
> You will find that the 'in' and 'out' fields of 'struct kfifo' are
> both represented as 'unsigned int' and in most cases 'in' is larger
> than 'out' and their difference will NOT be  over 'size'.
> 
> Now the problem is that 'in' will be *smaller* than 'out' when 'in'
> overflows and 'out' doesn't (Yes, this may occur quietly.). This is
> NOT what we expect, though it may not cause any serious problems if we
> carefully use kfifo*() functions. And this is really a bug.

You seem to be saying that it's not a bug, but it's a bug.

Exactly what goes wrong?

> This bug
> affects the kernel since version 2.6.10. I have tested this patch on
> x86 machines.
> 
> Signed-off-by: WANG Cong  <xiyou.wangcong@gmail.com>
> 
> ---
> 
> --- kernel/kfifo.c.orig	2007-02-07 19:42:51.000000000 +0800
> +++ kernel/kfifo.c	2007-02-07 19:43:31.000000000 +0800
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/kfifo.h>
> +#include <linux/compiler.h>
> 
>  /**
>   * kfifo_init - allocates a new FIFO using a preallocated buffer
> @@ -120,6 +121,12 @@ unsigned int __kfifo_put(struct kfifo *f
>  {
>  	unsigned int l;
> 
> +	/*If only fifo->in overflows, let both overflow!*/
> +	if (unlikely(fifo->in < fifo->out)) {
> +		fifo->out += fifo->size;
> +		fifo->in  += fifo->size;
> +	}
> +

hm.   That would indicate that there's a problem elsewhere in the logic.

