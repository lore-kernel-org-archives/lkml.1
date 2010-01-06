Return-Path: <linux-kernel-owner+w=401wt.eu-S932477Ab0AFRdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0AFRdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466Ab0AFRdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:33:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44702 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab0AFRdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:33:01 -0500
Date: Wed, 6 Jan 2010 10:32:59 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100106173258.GJ9882@parisc-linux.org>
References: <20100106172112.GA17163@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172112.GA17163@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 06:21:12PM +0100, Christoph Hellwig wrote:
> Add a generic implementation of the old select syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.

Don't we want an ifdef around compat_sys_old_select() like the one
around sys_old_select()?

> Index: linux-2.6/fs/select.c
> ===================================================================
> --- linux-2.6.orig/fs/select.c	2009-12-17 09:39:54.792277244 +0100
> +++ linux-2.6/fs/select.c	2009-12-26 13:39:31.501255812 +0100
> @@ -691,6 +691,23 @@ SYSCALL_DEFINE6(pselect6, int, n, fd_set
>  }
>  #endif /* HAVE_SET_RESTORE_SIGMASK */
>  
> +#ifdef __ARCH_WANT_SYS_OLD_SELECT
> +struct sel_arg_struct {
> +	unsigned long n;
> +	fd_set __user *inp, *outp, *exp;
> +	struct timeval __user *tvp;
> +};
> +
> +SYSCALL_DEFINE1(old_select, struct sel_arg_struct __user *, arg)
> +{
> +	struct sel_arg_struct a;
> +
> +	if (copy_from_user(&a, arg, sizeof(a)))
> +		return -EFAULT;
> +	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
> +}
> +#endif
> +
>  struct poll_list {
>  	struct poll_list *next;
>  	int len;
> Index: linux-2.6/fs/compat.c
> ===================================================================
> --- linux-2.6.orig/fs/compat.c	2009-12-26 13:43:52.431003939 +0100
> +++ linux-2.6/fs/compat.c	2009-12-26 13:49:24.179256485 +0100
> @@ -1795,6 +1795,24 @@ asmlinkage long compat_sys_select(int n,
>  	return ret;
>  }
>  
> +struct compat_sel_arg_struct {
> +	compat_ulong_t n;
> +	compat_ulong_t inp;
> +	compat_ulong_t outp;
> +	compat_ulong_t exp;
> +	compat_ulong_t tvp;
> +};
> +
> +asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)
> +{
> +	struct compat_sel_arg_struct a;
> +
> +	if (copy_from_user(&a, arg, sizeof(a)))
> +		return -EFAULT;
> +	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
> +				 compat_ptr(a.exp), compat_ptr(a.tvp));
> +}
> +
>  #ifdef HAVE_SET_RESTORE_SIGMASK
>  static long do_compat_pselect(int n, compat_ulong_t __user *inp,
>  	compat_ulong_t __user *outp, compat_ulong_t __user *exp,

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
