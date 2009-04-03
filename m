Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbZDCKzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbZDCKzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763146AbZDCKya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:54:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35389 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164AbZDCKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pqc8HhutkWynYuscvkz89X6hD5GFyYLnHLoi1Iqlk/hjecJkesORJj7w44To2SpA0R
         dpd8izLOgiaCTPyv1oUxCv2vHFs6LpmXekFpulMHiiHMnEd7endK2AoJ3njaONaitHA4
         meKsS7rIQqliIJQP9P/L5Nqekctg/PcgOjsx0=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238705969.10479.8.camel@nigel-laptop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
	 <1238629202.9027.111.camel@nigel-laptop>
	 <1238675410.13249.42.camel@andreas-desktop>
	 <1238705969.10479.8.camel@nigel-laptop>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 12:54:20 +0200
Message-Id: <1238756060.11839.19.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 07:59 +1100, Nigel Cunningham wrote:

> static int toi_compress_write_page(unsigned long index,
>                 struct page *buffer_page, unsigned int buf_size)
> {
>         int ret, cpu = smp_processor_id();
>         struct cpu_context *ctx = &per_cpu(contexts, cpu);
> 
>         if (!ctx->transform)
>                 return next_driver->write_page(index, buffer_page, buf_size);
> 
>         ctx->buffer_start = kmap(buffer_page);
> 
>         ctx->len = buf_size;

The LZO compressor can produce more bytes than it consumes but here the
output buffer is the same size as the input.
This macro in linux/lzo.h defines how big the buffer needs to be:
#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)

If there are multiple threads perhaps they clobber each other's output
buffers?

>         ret = crypto_comp_compress(ctx->transform,
>                         ctx->buffer_start, buf_size,
>                         ctx->page_buffer, &ctx->len);
> 
>         kunmap(buffer_page);
> 
>         if (ret) {
>                 printk(KERN_INFO "Compression failed.\n");
>                 return ret;
>         }
> 
>         mutex_lock(&stats_lock);
>         toi_compress_bytes_in += buf_size;
>         toi_compress_bytes_out += ctx->len;
>         mutex_unlock(&stats_lock);
> 
>         if (ctx->len < buf_size) /* some compression */
>                 return next_driver->write_page(index,
>                                 virt_to_page(ctx->page_buffer),
>                                 ctx->len);
>         else
>                 return next_driver->write_page(index, buffer_page, buf_size);
> }


