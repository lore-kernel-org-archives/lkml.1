Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197Ab0AFT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0AFT4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973Ab0AFT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:56:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0AFT4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:56:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] generic sys_ipc wrapper
Date: Wed, 6 Jan 2010 20:52:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
References: <20100106172152.GC17163@lst.de>
In-Reply-To: <20100106172152.GC17163@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001062052.11641.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18HSZSxcHAU0nftl2nGV5qU0PlXqJyiI1q2fRN
 pycwW3nR/gN26yWEOQ46oTjblS0tiYoBsopJ42XgJ1HDj7IbM1
 8AhcozttxNXBlv226dkpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010 18:21:52 Christoph Hellwig wrote:
> 
> Add a generic implementation of the ipc demultiplexer syscall.  Except for
> s390 and sparc64 all implementations of the sys_ipc are nearly identical.

Very nice patch, too bad we didn't already do that ages ago ;)

> +		switch (version) {
> +		default: {
> +			ulong raddr;
> +			ret = do_shmat(first, (char __user *)ptr,
> +				       second, &raddr);
> +			if (ret)
> +				return ret;
> +			return put_user(raddr, (ulong __user *) third);
> +		}
> +
> +#if defined(__i386__) || defined(__frv__) || defined(__mips__) ||\
> +    defined(__mn10300__)
> +		case 1:
> +			/* iBCS2 emulator entry point */
> +			if (!segment_eq(get_fs(), get_ds()))
> +				return -EINVAL;
> +			/*
> +			 * The "(ulong *) third" is valid _only_ because of
> +			 * the kernel segment thing.
> +			 */
> +			return do_shmat(first, (char __user *) ptr, second,
> +					(unsigned long *)third);
> +#endif
> +#if defined(__arm__) || defined(__sparc__)
> +		case 1:
> +			/* Of course, we don't support iBCS2! */
> +			return -EINVAL;
> +#endif
> +		}

This would not build on any of the architecture mentioned, because of
incorrect placement of curly braces, but as Al mentioned it should just
go away entirely.

> Index: linux-2.6/arch/powerpc/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/syscalls.h	2010-01-04 15:44:58.578028035 +0100
> +++ linux-2.6/arch/powerpc/include/asm/syscalls.h	2010-01-04 15:45:57.408253467 +0100
> @@ -35,8 +35,6 @@ asmlinkage long sys_pipe2(int __user *fi
>  asmlinkage long sys_rt_sigaction(int sig,
>  		const struct sigaction __user *act,
>  		struct sigaction __user *oact, size_t sigsetsize);
> -asmlinkage int sys_ipc(uint call, int first, unsigned long second,
> -		long third, void __user *ptr, long fifth);
>  asmlinkage long ppc64_personality(unsigned long personality);
>  asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
>  asmlinkage time_t sys64_time(time_t __user * tloc);

I did not see you add the prototype back into include/linux/syscalls.h,
which is required for building some architectures, including ppc64 with
SPU support.

	Arnd
