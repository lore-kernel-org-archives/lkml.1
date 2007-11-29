Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbXK2U7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbXK2U7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932358AbXK2U7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:59:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:4851 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbXK2U7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=G7V/xo6wONz7rkgnACpWEa84o4L8PMcePW4hCmzJu+hpyTPXXzi9mvgQwNBDFEInd2AwMjsOXBkoFOKAETGHDilkiAJVx7KwSct+hFJR63JRDoIQNNIYFxV1eZRBQmzDcfN9351cNXly6g5HcEP/asFa3JZ8LEVKcjoSjDABiIc=
Date: Thu, 29 Nov 2007 23:58:52 +0300
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 09/11] x86 ia32 ptrace arch merge
Message-ID: <20071129205852.GA1726@martell.zuzino.mipt.ru>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120041.8621A26F989@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129120041.8621A26F989@magilla.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 04:00:41AM -0800, Roland McGrath wrote:
> This moves the sys32_ptrace code into arch/x86/kernel/ptrace.c,
> verbatim except for a few hard-coded sizes replaced with sizeof.
> Here this code can use the shared local functions in this file.

> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c

> +asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
> +{
> +	struct task_struct *child;
> +	struct pt_regs *childregs;
> +	void __user *datap = compat_ptr(data);
> +	int ret;
> +	__u32 val;
> +
> +	switch (request) {
> +	case PTRACE_PEEKDATA:
> +	case PTRACE_PEEKTEXT:
> +		ret = 0;

Dead write.

> +		if (access_process_vm(child, addr, &val, sizeof(u32), 0) !=
> +		    sizeof(u32))
> +			ret = -EIO;
> +		else
> +			ret = put_user(val, (unsigned int __user *)datap);
> +		break;

> +	case PTRACE_GETFPREGS:
> +		ret = -EIO;
> +		if (!access_ok(VERIFY_READ, compat_ptr(data),
> +			       sizeof(struct user_i387_struct)))
> +			break;
> +		save_i387_ia32(child, datap, childregs, 1);
> +		ret = 0;
> +			break;

More indentation than needed.

> +	case PTRACE_GETFPXREGS: {
> +		struct user32_fxsr_struct __user *u = datap;
> +
> +		init_fpu(child);
> +		ret = -EIO;
> +		if (!access_ok(VERIFY_WRITE, u, sizeof(*u)))
> +			break;
> +			ret = -EFAULT;

Absent { }. :^)

> +		if (__copy_to_user(u, &child->thread.i387.fxsave, sizeof(*u)))
> +			break;
> +		ret = __put_user(childregs->cs, &u->fcs);
> +		ret |= __put_user(child->thread.ds, &u->fos);
> +		break;
> +	}
