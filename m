Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbYKRG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbYKRG5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 01:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYKRG5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 01:57:10 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:38397 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYKRG5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 01:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=M4861XurwLcP+N2fWGb+dIMeTwZOBFX31yX7jLotrfb20hLmUUH+M/W8jTKhYXP+cf
         Kkr1S9/sSe9pj64w5q1aIpySJp9g08DGFhp/BPFTSn8gvQc9LWR3iytLeFM7uYacCwE/
         LiVTFfrL2J0fMShUdgaF9vj/Jcc0x10IFp5WE=
Message-ID: <84144f020811172257k2c749bc3g98c3596ebb603cd2@mail.gmail.com>
Date: Tue, 18 Nov 2008 08:57:07 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/1] mm: introduce kvmalloc()/kvfree()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, "Dave Airlie" <airlied@gmail.com>,
       "Paul Menage" <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>, "Jan Kara" <jack@suse.cz>,
       "Jes Sorensen" <jes@sgi.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <492162E4.9080902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492162E4.9080902@cn.fujitsu.com>
X-Google-Sender-Auth: f3914e83b6d16527
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 2:26 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> @@ -163,6 +165,38 @@ char *strndup_user(const char __user *s, long n)
>  }
>  EXPORT_SYMBOL(strndup_user);
>
> +/**
> + * kvmalloc - allocate memory by kmalloc() or vmalloc()
> + *
> + * if @size <= PAGE_SIZE, memory is allocated by kmalloc(),
> + * otherwise by vmalloc().
> + *
> + * NOTICE: Generally, you should use kmalloc() or vmalloc() directly.
> + * kvmalloc() is provided for some special condition.

You might as well explicitly state what those special conditions are here.

> + */
> +void *kvmalloc(unsigned long size, gfp_t flags)
> +{
> +       if (size <= PAGE_SIZE)
> +               return kmalloc(size, flags & ~__GFP_HIGH);
> +       else
> +               return __vmalloc(size, flags | __GFP_HIGHMEM, PAGE_KERNEL);
> +}
> +EXPORT_SYMBOL(kvmalloc);
> +
> +/**
> + * kvfree - free the memory by kfree(), or vfree() if it is vmalloc addr
> + */
> +void kvfree(void *ptr)
> +{
> +       BUG_ON(in_interrupt());

I wonder if this should be a WARN_ON() to let the machine limp along
for a while if it can. At least in the kfree() case people can catch
the oops trace more easily that way.

> +
> +       if (is_vmalloc_addr(ptr))
> +               vfree(ptr);
> +       else
> +               kfree(ptr);
> +}
> +EXPORT_SYMBOL(kvfree);
> +
>  #ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
>  void arch_pick_mmap_layout(struct mm_struct *mm)
>  {
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
