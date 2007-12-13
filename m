Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXLMLB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXLMLB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXLMLBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:01:47 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:53196 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXLMLBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dTT/3eYxbjO2eG2iBgHstenj+fq8B8vwgX9gkbZdQLpbu7fL6Jt6FEyt201CWN1BY0ZfEvbkwWv9xbunEUhN8KpvCDYbDw+0You33PBNX6p3mcsZy1GKR4BdVmtfxJaLfvlO1K2YPFzNSWbZZh/i9OXquhWdWmZnRpCXqI93z/s=
Message-ID: <3efb10970712130301g6473f300o8da023de1008ee1a@mail.gmail.com>
Date: Thu, 13 Dec 2007 12:01:44 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] Revert lazy irq disable for simple irqs
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
X-Google-Sender-Auth: 9d5d1f030b684909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
> was implemented, and the simple irq handler had a masking set to it.
>
> Remy Bohmer discovered that some devices in the ARM architecture
> would trigger the mask, but never unmask it. His patch to do the
> unmasking was questioned by Russell King about masking simple irqs
> to begin with. Looking further, it was discovered that the problems
> Remy was seeing was due to improper use of the simple handler by
> devices, and he later submitted patches to fix those. But the issue
> that was uncovered was that the simple handler should never mask.
>
> This patch reverts the masking in the simple handler.
>
Acked-by: Remy Bohmer <linux@bohmer.net>




> ---
>  kernel/irq/chip.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> Index: linux-compile.git/kernel/irq/chip.c
> ===================================================================
> --- linux-compile.git.orig/kernel/irq/chip.c    2007-10-19 12:37:51.000000000 -0400
> +++ linux-compile.git/kernel/irq/chip.c 2007-12-12 15:03:43.000000000 -0500
> @@ -297,18 +297,13 @@ handle_simple_irq(unsigned int irq, stru
>
>         if (unlikely(desc->status & IRQ_INPROGRESS))
>                 goto out_unlock;
> +       desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
>         kstat_cpu(cpu).irqs[irq]++;
>
>         action = desc->action;
> -       if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> -               if (desc->chip->mask)
> -                       desc->chip->mask(irq);
> -               desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
> -               desc->status |= IRQ_PENDING;
> +       if (unlikely(!action || (desc->status & IRQ_DISABLED)))
>                 goto out_unlock;
> -       }
>
> -       desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
>         desc->status |= IRQ_INPROGRESS;
>         spin_unlock(&desc->lock);
>
>
>
