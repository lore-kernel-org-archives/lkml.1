Return-Path: <linux-kernel-owner+w=401wt.eu-S1767744AbXEDJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767744AbXEDJGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767753AbXEDJGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:06:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:39955 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767742AbXEDJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FXuwBFXSw5RYaQiLZ1iECswBy+Wnmd/qtff7GplUUSZlyQ+kms6rsNmW+Cr8DX0hNyya6fFh8rMzuugUJIysyrchdgcGOVhcjZDXSy5IkpFerlZnCH3VVTY8OAG4Zh6A0xEgXAkEr+8uv0u6b9kRVdI0qPO+fqfO49tQ347APCQ=
Message-ID: <a781481a0705040206jee1c4a7s9822960a7a18d56f@mail.gmail.com>
Date: Fri, 4 May 2007 14:36:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, herbert@gondor.apana.org.au,
       linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
In-Reply-To: <1178030823.5883.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178030823.5883.54.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> Add LZO1X compression/decompression support to jffs2.
>
> LZO's interface doesn't entirely match that required by jffs2 so a
> buffer and memcpy is unavoidable.
>
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
> ---
> [...]
> +++ b/fs/jffs2/compr_lzo.c
> [...]
> +static void *lzo_mem;
> +static void *lzo_compress_buf;
> +static DEFINE_MUTEX(deflate_mutex);
> +
> +static void free_workspace(void)
> +{
> +       vfree(lzo_mem);
> +       vfree(lzo_compress_buf);
> +}
> +
> +static int __init alloc_workspace(void)
> +{
> +       lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> +       lzo_compress_buf = vmalloc(lzo1x_worst_compress(PAGE_SIZE));
> +
> +       if (!lzo_mem || !lzo_compress_buf) {
> +               printk(KERN_WARNING "Failed to allocate lzo deflate workspace\n");
> +               free_workspace();
> +               return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static int jffs2_lzo_compress(unsigned char *data_in, unsigned char *cpage_out,
> +                             uint32_t *sourcelen, uint32_t *dstlen, void *model)
> +{
> +       unsigned long compress_size;
> +       int ret;
> +
> +       mutex_lock(&deflate_mutex);
> +       ret = lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress_size, lzo_mem);
> +       mutex_unlock(&deflate_mutex);

Considering we do have to memcpy() the entire compressed result to the
destination output buffer later anyway (note that
fs/jffs2/compr_zlib.c doesn't need to do that), do we really gain much
by avoiding vmalloc() and vfree() in jffs2_lzo_compress() itself and
keeping the workspace buffers pre-allocated? I ask because I always
found these global static workspace buffers ugly, and all the
associated code + mutex could go away if we make them local to
jffs2_lzo_compress() -- as long as it doesn't hurt performance
terribly, of course.

Thanks,
Satyam
