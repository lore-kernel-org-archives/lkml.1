Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZJLWqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZJLWqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZJLWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:46:16 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52308 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558AbZJLWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lYVGLkX3WaXLYdoEWZ8NqI6d7/s2B90S3Mx+88dhZTBYGY75H5bcFHH6Rz+3Iy+Vhw
         Elz2sLzCi3fyPDLOzrd1pZshNLzanB4adIdEgQggHg4qjEwrQ9z2gO/LqsKf7ExUAsPA
         xJLaFXYcYtcr5F43+bnVIRGqGrAaUgm3SAnvc=
Date: Tue, 13 Oct 2009 00:45:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 1/6 RFC] arch/blackfin/kernel/process.c: Remove the BKL
	from sys_execve
Message-ID: <20091012224532.GB4711@nowhere>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:33:21AM +0200, John Kacur wrote:
> From b9b41b5a546ed0202c099f0d973da4df9aea314a Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Mon, 12 Oct 2009 22:44:40 +0200
> Subject: [PATCH] arch/blackfin/kernel/process.c: Remove the BKL from sys_execve
> 
> This looks like a cut-and-paste job.
> For example, compare this function to sys_execve in
> arch/x86/kernel/process_64.c
> 
> and it is almost line by line the same, except the one in x86 nolonger has the
> big kernel lock. All of the functions called between the lock are generic
> and not specific to blackfin - thus, I believe it is safe to remove the
> bkl here.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  arch/blackfin/kernel/process.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 430ae39..7d9c975 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -215,22 +215,18 @@ copy_thread(unsigned long clone_flags,
>  /*
>   * sys_execve() executes a new program.
>   */
> -
>  asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
>  {
>  	int error;
>  	char *filename;
>  	struct pt_regs *regs = (struct pt_regs *)((&name) + 6);
>  
> -	lock_kernel();
>  	filename = getname(name);
>  	error = PTR_ERR(filename);
>  	if (IS_ERR(filename))
> -		goto out;
> +		return error;
>  	error = do_execve(filename, argv, envp, regs);
>  	putname(filename);
> - out:
> -	unlock_kernel();
>  	return error;
>  }
>  
> -- 
> 1.6.0.6
> 
> 


Yeah, there seem to be nothing to protect there.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

