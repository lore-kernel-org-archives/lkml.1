Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZA0VtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZA0VtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZA0VtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:49:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbZA0VtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:49:05 -0500
Date: Tue, 27 Jan 2009 13:48:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: adrian@newgolddream.dyndns.info, lkmladrian@gmail.com,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, lg@denx.de, hannes@cmpxchg.org
Subject: Re: [PATCH] dma: fix up broken comparison in
 dma_alloc_from_coherent
Message-Id: <20090127134831.3dd04182.akpm@linux-foundation.org>
In-Reply-To: <20090121081118.GA14537@linux-sh.org>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
	<1232488507.6794.8.camel@localhost.localdomain>
	<20090121033951.GB14094@linux-sh.org>
	<20090121081118.GA14537@linux-sh.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 17:11:19 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> @@ -118,31 +118,32 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  	mem = dev->dma_mem;
>  	if (!mem)
>  		return 0;
> -	if (unlikely(size > mem->size))
> - 		return 0;
> +
> +	*ret = NULL;
> +
> +	if (unlikely(size > (mem->size << PAGE_SHIFT)))
> +		goto err;

Looks a bit broken on 64-bit.

`size' is ssize_t (long).

`mem->size' is `int'.

The left shift can overflow and cause badnesses.

> +	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
> +	*ret = mem->virt_base + (pageno << PAGE_SHIFT);

Ditto.


Maybe it's a can't-happen (why?), but...
