Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXLZTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXLZTro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXLZTrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:47:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47290 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515AbXLZTrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:47:33 -0500
Date: Wed, 26 Dec 2007 20:47:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Julia Lawall <julia@diku.dk>
Cc: tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
Message-ID: <20071226194718.GB8844@elf.ucw.cz>
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Julia Lawall <julia@diku.dk>
> 
> In the patch cc154ac64aa8d3396b187f64cef01ce67f433324, Al Viro observed
> that the proper way to compute the distance between two structure fields is
> to use offsetof() or a cast to a pointer to character.  The same change can
> be applied to a few more files.
> 
> The change was made using the following semantic patch
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r@
> type T;
> T s;
> type T1, T2;
> identifier fld1, fld2;
> typedef uint8_t;
> typedef u8;
> @@
> 
> (
>   (char *)&s.fld1 - (char *)&s.fld2
> |
>   (uint8_t *)&s.fld1 - (uint8_t *)&s.fld2
> |
>   (u8 *)&s.fld1 - (u8 *)&s.fld2
> |
> - (T1)&s.fld1 - (T2)&s.fld2
> + offsetof(T,fld1) - offsetof(T,fld2)
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> 
> diff -u -p a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
> --- a/arch/x86/kernel/vm86_32.c	2007-10-22 11:25:00.000000000 +0200
> +++ b/arch/x86/kernel/vm86_32.c	2007-12-26 16:27:15.000000000 +0100
> @@ -215,7 +215,9 @@ asmlinkage int sys_vm86old(struct pt_reg
>  	ret = -EFAULT;
>  	if (tmp)
>  		goto out;
> -	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
> +	memset(&info.vm86plus, 0,
> +	       offsetof(struct kernel_vm86_struct, regs32) -
> +	       offsetof(struct kernel_vm86_struct, vm86plus));

I do not think this makes it more readable... (int) -> (char *) would
make it portable and readable, AFAICT.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
