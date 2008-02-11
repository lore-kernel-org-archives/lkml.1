Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbYBKT6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbYBKT6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbYBKT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:58:23 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57237 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173AbYBKT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:58:21 -0500
Date: Mon, 11 Feb 2008 08:46:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [2/6] uaccess: add probe_kernel_write()
Message-Id: <20080211084627.d67b4347.randy.dunlap@oracle.com>
In-Reply-To: <20080210200540.GA24677@elte.hu>
References: <20080210071326.GB3851@elte.hu>
	<47AF483E.2060202@web.de>
	<alpine.LFD.1.00.0802101102300.2896@woody.linux-foundation.org>
	<20080210200540.GA24677@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 21:05:40 +0100 Ingo Molnar wrote:

> Subject: uaccess: add probe_kernel_write()
> From: Ingo Molnar <mingo@elte.hu>
> 
> add probe_kernel_read() and probe_kernel_write().
> 
> Uninlined and restricted to kernel range memory only, as suggested
> by Linus.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/uaccess.h |   22 ++++++++++++++++++++++
>  mm/Makefile             |    2 +-
>  mm/maccess.c            |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 1 deletion(-)
> 
> Index: linux-kgdb.q/include/linux/uaccess.h
> ===================================================================
> --- linux-kgdb.q.orig/include/linux/uaccess.h
> +++ linux-kgdb.q/include/linux/uaccess.h
> @@ -84,4 +84,26 @@ static inline unsigned long __copy_from_
>  		ret;					\
>  	})
>  
> +/*
> + * probe_kernel_read(): safely attempt to read from a location

Please insert a hyphen/dash/'-' between function name and its
short description on the line above and on other similar lines.

Documentation/kernel-doc-nano-HOWTO.txt .

> + * @dst: pointer to the buffer that shall take the data
> + * @src: address to read from
> + * @size: size of the data chunk
> + *
> + * Safely read from address @src to the buffer at @dst.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +extern long probe_kernel_read(void *dst, void *src, size_t size);
> +
> +/*
> + * probe_kernel_write(): safely attempt to write to a location
> + * @dst: address to write to
> + * @src: pointer to the data that shall be written
> + * @size: size of the data chunk
> + *
> + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +extern long probe_kernel_write(void *dst, void *src, size_t size);
> +
>  #endif		/* __LINUX_UACCESS_H__ */

> Index: linux-kgdb.q/mm/maccess.c
> ===================================================================
> --- /dev/null
> +++ linux-kgdb.q/mm/maccess.c
> @@ -0,0 +1,46 @@
> +/*
> + * Access kernel memory without faulting.
> + */
> +#include <linux/uaccess.h>
> +#include <linux/mm.h>
> +
> +/**
> + * probe_kernel_read(): safely attempt to read from a location
> + * @dst: pointer to the buffer that shall take the data
> + * @src: address to read from
> + * @size: size of the data chunk
> + *
> + * Safely read from address @src to the buffer at @dst.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +long probe_kernel_read(void *dst, void *src, size_t size)
> +{
> +	long ret;
> +
> +	pagefault_disable();
> +	ret = __copy_from_user_inatomic(dst,
> +			(__force const void __user *)src, size);
> +	pagefault_enable();
> +
> +	return ret ? -EFAULT : 0;
> +}
> +
> +/**
> + * probe_kernel_write(): safely attempt to write to a location
> + * @dst: address to write to
> + * @src: pointer to the data that shall be written
> + * @size: size of the data chunk
> + *
> + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +long probe_kernel_write(void *dst, void *src, size_t size)
> +{
> +	long ret;
> +
> +	pagefault_disable();
> +	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
> +	pagefault_enable();
> +
> +	return ret ? -EFAULT : 0;
> +}

---
~Randy
