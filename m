Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0CBUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:42:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab0CBUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:42:26 -0500
Date: Tue, 2 Mar 2010 12:42:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf: plug a memory leak situation on dump_seek()
Message-Id: <20100302124206.4e0a42b4.akpm@linux-foundation.org>
In-Reply-To: <322581998527c77c89d6fb91b8cbe02b5637c6dc.1267156293.git.andre.goddard@gmail.com>
References: <322581998527c77c89d6fb91b8cbe02b5637c6dc.1267156293.git.andre.goddard@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 00:54:40 -0300
Andr__ Goddard Rosa <andre.goddard@gmail.com> wrote:

> Signed-off-by: Andr__ Goddard Rosa <andre.goddard@gmail.com>
> ---
>  fs/binfmt_elf.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index fd5b2ea..13b0845 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1096,6 +1096,8 @@ static int dump_write(struct file *file, const void *addr, int nr)
>  
>  static int dump_seek(struct file *file, loff_t off)
>  {
> +	int ret = 1;
> +
>  	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
>  		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
>  			return 0;
> @@ -1107,13 +1109,15 @@ static int dump_seek(struct file *file, loff_t off)
>  			unsigned long n = off;
>  			if (n > PAGE_SIZE)
>  				n = PAGE_SIZE;
> -			if (!dump_write(file, buf, n))
> -				return 0;
> +			if (!dump_write(file, buf, n)) {
> +				ret = 0;
> +				break;
> +			}
>  			off -= n;
>  		}
>  		free_page((unsigned long)buf);
>  	}
> -	return 1;
> +	return ret;
>  }

Please don't send unchangelogged patches.

Explain the leak.

Explain the user impact (ie: how it is triggered).

Explain how the patch fixes it.

Thanks.
