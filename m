Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYDRWsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYDRWsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYDRWsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:48:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbYDRWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:48:41 -0400
Date: Fri, 18 Apr 2008 15:48:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: fix optional arch functions and probe_kernel_*
Message-Id: <20080418154800.82f814e0.akpm@linux-foundation.org>
In-Reply-To: <200804181742.m3IHgsoG012669@hera.kernel.org>
References: <200804181742.m3IHgsoG012669@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:42:54 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -17,11 +17,14 @@
>  long probe_kernel_read(void *dst, void *src, size_t size)
>  {
>  	long ret;
> +	mm_segment_t old_fs = get_fs();
>  
> +	set_fs(KERNEL_DS);
>  	pagefault_disable();
>  	ret = __copy_from_user_inatomic(dst,
>  			(__force const void __user *)src, size);
>  	pagefault_enable();
> +	set_fs(old_fs);
>  
>  	return ret ? -EFAULT : 0;
>  }

Oh.  Well that rather invalidates my earlier comments.  It looks like this
change could have been folded, but I understand that this sometimes gets
wearisome and isn't terribly important if

a) the fix doesn't repair build breakage and

b) the fix doesn't fix runtime breakage and

c) the fix fixes code which the git-bisect user won't have enabled in
   config anyway.


Still.  Do we need the set_fs() in there?  __copy_from_user_inatomic() is a
"__" uaccess function and hence shouldn't be running access_ok()?

