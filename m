Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYEOBjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYEOBjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbYEOBio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:38:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbYEOBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:38:43 -0400
Date: Wed, 14 May 2008 18:38:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: mtdchar.c silence sparse warning
Message-Id: <20080514183837.460ba848.akpm@linux-foundation.org>
In-Reply-To: <1210814530.6191.52.camel@brick>
References: <1210814530.6191.52.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 18:22:10 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> The copy_to_user was casting away the address space to get the offset
> of the length member.  Use offsetof() instead and add it to the void __user *argp.
> 
> drivers/mtd/mtdchar.c:527:23: warning: cast removes address space of expression
> drivers/mtd/mtdchar.c:527:23: warning: incorrect type in argument 1 (different address spaces)
> drivers/mtd/mtdchar.c:527:23:    expected void [noderef] <asn:1>*to
> drivers/mtd/mtdchar.c:527:23:    got unsigned int *<noident>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/mtd/mtdchar.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 5d3ac51..3522d4a 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -524,7 +524,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
>  		if (ops.oobretlen > 0xFFFFFFFFU)
>  			ret = -EOVERFLOW;
>  		retlen = ops.oobretlen;
> -		if (copy_to_user(&((struct mtd_oob_buf *)argp)->length,
> +		if (copy_to_user(argp + offsetof(struct mtd_oob_buf, length),
>  				 &retlen, sizeof(buf.length)))
>  			ret = -EFAULT;

Cleaner would be:

	struct mtd_oob_buf __user *user_mtd_oob_buf = argp;

	if (copy_to_user(&user_mtd_oob_buf->length, ...

?

(cleaner, faster and shorter would be put_user(), but that's off-topic).
