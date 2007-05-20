Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbXETGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbXETGp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXETGpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:45:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243AbXETGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:45:15 -0400
Date: Sat, 19 May 2007 23:41:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] check d_path() error in print-fatal-signals
Message-Id: <20070519234138.a800e0fb.akpm@linux-foundation.org>
In-Reply-To: <20070520055639.GA4485@APFDCB5C>
References: <20070520055639.GA4485@APFDCB5C>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 14:56:39 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> d_path() returns -ENAMETOOLONG if buffer length is not enough.
> But there is no error handling for it in print_vma() which calls
> d_path() with not enough buffer (We can easily make segfault program
> which has longer path than 128bytes).
> 
> This patch allocates enough buffer for d_path() dynamically.
> audit_log_d_path() is doing sililar thing. So I just stole from it.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  kernel/signal.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Index: 2.6-mm/kernel/signal.c
> ===================================================================
> --- 2.6-mm.orig/kernel/signal.c
> +++ 2.6-mm/kernel/signal.c
> @@ -740,15 +740,23 @@ static int print_vma(struct vm_area_stru
>  	 * special [heap] marker for the heap:
>  	 */
>  	if (file) {
> -#define SIZE 128
> -		char tmp[SIZE], *str;
> -
> -		str = d_path(file->f_dentry, file->f_vfsmnt, tmp, SIZE);
> -		while (str[0] && (str[0] == ' '))
> -			str++;
> +		char *p, *path;
>  
> +		/* We will allow 11 spaces for ' (deleted)' to be appended */
> +		path = kmalloc(PATH_MAX + 11, GFP_KERNEL);
> +		if (!path)
> +			p = "<no memory>";
> +		else {
> +			p = d_path(file->f_dentry, file->f_vfsmnt, path,
> +				   PATH_MAX + 11);
> +			if (IS_ERR(p))
> +				p = "<too long>";
> +			else
> +				p = strstrip(p);
> +		}
>  		pad_len_spaces(len);
> -		printk("%s", str);
> +		printk("%s", p);
> +		kfree(path);
>  	} else {
>  		const char *name = arch_vma_name(vma);
>  		if (!name) {

Thanks.

This bug exists only in -mm kernels, and is introduced by the -mm-only
debugging patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch.

I think I'll just drop that patch - I don't think it is proving useful to
anyone.

