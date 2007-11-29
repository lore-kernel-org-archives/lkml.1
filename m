Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbXK2RfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbXK2RfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759713AbXK2RfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:35:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbXK2Re7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:34:59 -0500
Message-ID: <474EF824.3020806@redhat.com>
Date: Thu, 29 Nov 2007 12:34:28 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain>
In-Reply-To: <20071129004222.E49AD26F8E7@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2007 07:42 PM, Roland McGrath wrote:
> --- a/arch/x86/ia32/ptrace32.c
> +++ b/arch/x86/ia32/ptrace32.c
> @@ -48,19 +48,27 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
>  		if (val && (val & 3) != 3)
>  			return -EIO;
>  		child->thread.fsindex = val & 0xffff;
> +		if (child == current)
> +			loadsegment(fs, child->thread.fsindex);
>  		break;
>  	case offsetof(struct user32, regs.gs):
>  		if (val && (val & 3) != 3)
>  			return -EIO;
>  		child->thread.gsindex = val & 0xffff;
> +		if (child == current)
> +			load_gs_index(child->thread.gsindex);
>  		break;
>  	case offsetof(struct user32, regs.ds):
>  		if (val && (val & 3) != 3)
>  			return -EIO;
>  		child->thread.ds = val & 0xffff;
> +		if (child == current)
> +			loadsegment(ds, child->thread.ds);
>  		break;
>  	case offsetof(struct user32, regs.es):
>  		child->thread.es = val & 0xffff;
> +		if (child == current)
> +			loadsegment(es, child->thread.ds);

                                        child->thread.es ??

> @@ -129,15 +137,23 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
>  	switch (regno) {
>  	case offsetof(struct user32, regs.fs):
>  		*val = child->thread.fsindex;
> +		if (child == current)
> +			asm("movl %%fs,%0" : "=r" (*val));
>  		break;
>  	case offsetof(struct user32, regs.gs):
>  		*val = child->thread.gsindex;
> +		if (child == current)
> +			asm("movl %%gs,%0" : "=r" (*val));

Won't this return the kernel's GS instead of the user's?
