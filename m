Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYBPMnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYBPMnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 07:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYBPMmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 07:42:53 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:53525 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYBPMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 07:42:51 -0500
Date: Sat, 16 Feb 2008 13:42:48 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, buytenh@wantstofly.org,
       mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
Message-ID: <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Not all architectures implement futex_atomic_cmpxchg_inatomic().  The default
> implementation returns -ENOSYS, which is currently not handled inside of the
> futex guts.
> 
> Futex PI calls and robust list exits with a held futex result in an endless
> loop in the futex code on architectures which have no support.
> 
> Fixing up every place where futex_atomic_cmpxchg_inatomic() is called would
> add a fair amount of extra if/else constructs to the already complex code.  It
> is also not possible to disable the robust feature before user space tries to
> register robust lists.
> 
> Compile time disabling is not a good idea either, as there are already
> architectures with runtime detection of futex_atomic_cmpxchg_inatomic support.
> 
> Detect the functionality at runtime instead by calling
> cmpxchg_futex_value_locked() with a NULL pointer from the futex initialization
> code.  This is guaranteed to fail, but the call of
> futex_atomic_cmpxchg_inatomic() happens with pagefaults disabled.
> 
> On architectures, which use the asm-generic implementation or have a runtime
> CPU feature detection, a -ENOSYS return value disables the PI/robust features.
> 
> On architectures with a working implementation the call returns -EFAULT and
> the PI/robust features are enabled.
> 
> The relevant syscalls return -ENOSYS and the robust list exit code is blocked,
> when the detection fails.
> 
> Fixes http://lkml.org/lkml/2008/2/11/149
> Originally reported by: Lennart Buytenhek

[...]

>  static int __init init(void)
>  {
> +	u32 curval;
>  	int i;
> 
> +	/*
> +	 * This will fail and we want it. Some arch implementations do
> +	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
> +	 * functionality. We want to know that before we call in any
> +	 * of the complex code paths. Also we want to prevent
> +	 * registration of robust lists in that case. NULL is
> +	 * guaranteed to fault and we get -EFAULT on functional
> +	 * implementation, the non functional ones will return
> +	 * -ENOSYS.
> +	 */
> +	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
> +	if (curval == -EFAULT)
> +		futex_cmpxchg_enabled = 1;
> +

Why should that fail? You're accessing a kernel space address here and no
user space address.
Indeed it does fail with an Oops on s390 since we enable low address
protection in the kernel so we get an exception if something within the
kernel writes to the first 512 bytes of the kernel address space.
Otherwise it would have silently passed the test...
