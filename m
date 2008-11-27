Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYK0OIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYK0OIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYK0OH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:07:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:25062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYK0OH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=H96v+oGLx77924YM7s9oW6Mvky4OTLskrQ6nuYmoRxVUPXBFgxs6MkAM8NpS2meesM
         FmMXiBnLYJt78Yti5fkNy8iwMkB7YvsTe1I7dhfeNqQzB0f78yTv4GWEzTz7RHddslzC
         qjydNwPgsJjZ94CVpUXhi1EdOT3a48Tk1QFtE=
Message-ID: <7c86c4470811270607p2fa1faf9tdcf34f900f9ee230@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:07:55 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811271454120.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <alpine.LFD.2.00.0811271454120.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thu, Nov 27, 2008 at 3:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, eranian@googlemail.com wrote:
>
>> +asmlinkage long sys_pfm_write(int fd, int uflags,
>> +                           int type,
>> +                           void __user *ureq,
>> +                           size_t sz)
>
>> +asmlinkage long sys_pfm_read(int fd, int uflags,
>> +                          int type,
>> +                          void __user *ureq,
>> +                          size_t sz)
>
> After looking at both I did a diff of the two functions:
>
> --- r.c 2008-11-27 14:27:54.000000000 +0100
> +++ w.c 2008-11-27 14:27:52.000000000 +0100
> @@ -36,10 +36,12 @@
>        ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
>        if (ret)
>                goto skip;
> -
>        switch(type) {
> +       case PFM_RW_PMC:
> +               ret = __pfm_write_pmcs(ctx, req, count);
> +               break;
>        case PFM_RW_PMD:
> -               ret = __pfm_read_pmds(ctx, req, count);
> +               ret = __pfm_write_pmds(ctx, req, count);
>                break;
>        default:
>                PFM_DBG("invalid type=%d", type);
> @@ -48,12 +50,13 @@
>  skip:
>        spin_unlock_irqrestore(&ctx->lock, flags);
>
> -       if (copy_to_user(ureq, req, sz))
> -               ret = -EFAULT;
> -
> +       /*
> +        * This function may be on the critical path.
> +        * We want to avoid the branch if unecessary.
> +        */
>        if (fptr)
>                kfree(fptr);
>  error:
>        pfm_release_ctx_from_fd(&cookie);
>        return ret;
>  }
>
> Both read and write are multiplexing syscalls already and 90% of the
> code is the same.
>
>        case PFM_RD_PMC:
>        case PFM_RD_PMD:
>        case PFM_WR_PMC:
>        case PFM_WR_PMD:
>
> would make them the same and safe a syscall and duplicated code.
>
I am fine with that (BTW, there is no PFM_RD_PMC).

What about we call it pfm_rw_regs() ?
