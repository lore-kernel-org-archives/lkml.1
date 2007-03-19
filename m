Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXCSS3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXCSS3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030512AbXCSS3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:29:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:47915 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030501AbXCSS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j/dwRsvK3uSMTNCFp3MDPjiMndcXtO75khvK/SPuwJNvFCKLqDWi+scDOKsc3fvKXyzAlS3q2olgr5JRUU+MYmOROS+lJVmKgfJaL+ZmYRAXRqLKeu4h4C5z/jwrNtf7aI5HNfWjPrTNpM5fFmMfhsrwn7shlgrs+vtfIT5Ow8U=
Message-ID: <9a8748490703191129h396211e9q59eeea9533d00c38@mail.gmail.com>
Date: Mon, 19 Mar 2007 19:29:37 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       fastboot@lists.osdl.org
Subject: Re: [PATCH] [REVIEW] Fix irqpoll on IA64 (timer interrupt != 0)
In-Reply-To: <20070319181336.GC12628@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319181336.GC12628@strauss.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Bernhard Walle <bwalle@suse.de> wrote:
> On IA64, the timer interrupt is not (always?) zero as it is on x86 platforms.
> Also, the timer interrupt is CPU-local. Two things need to be changed to make
> the irqpoll option make also working on IA64:
>
>   o Call note_interrupt() also on CPU-local interrupts in __do_IRQ().
>   o Set a variable timer_irq to the value of the timer interrupt
>     after the timer interrupt has been registered and assigned.
>
> That requires changes in Linux-generic files. The default of timer_irq is 0, so
> the patch doesn't break i386/x86_64. However, other platforms also may also
> have a timer interrupt non-equal to zero, so they can also use the new
> set_timer_interrupt() function.
>
> The patch is against 2.6.21-rc4. Please give me your input how to improve
> the way it's done if you don't like the way I did the change. irqpoll is
> required to work with kdump in some situations and that's why I discovered
> that kdump doesn't work on that platform (HP rx2660).
>

A few style comments below.

>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
>
> ---
>  arch/ia64/kernel/irq_ia64.c |    6 +++++-
>  arch/ia64/kernel/time.c     |    6 +++++-
>  include/asm-ia64/hw_irq.h   |    2 +-
>  include/linux/irq.h         |    3 +++
>  kernel/irq/handle.c         |    2 ++
>  kernel/irq/spurious.c       |   10 +++++++++-
>  6 files changed, 25 insertions(+), 4 deletions(-)
>
> Index: mainline-msi-init/arch/ia64/kernel/irq_ia64.c
> ===================================================================
> --- mainline-msi-init.orig/arch/ia64/kernel/irq_ia64.c
> +++ mainline-msi-init/arch/ia64/kernel/irq_ia64.c
> @@ -280,11 +280,12 @@ static struct irqaction resched_irqactio
>  };
>  #endif
>
> -void
> +int
>  register_percpu_irq (ia64_vector vec, struct irqaction *action)
>  {

Each and every function example in Documentation/CodingStyle has the
return type on the same line as the function name, so why not get
these in-line while you are modifying them anyway?

int register_percpu_irq (ia64_vector vec, struct irqaction *action)


> @@ -174,6 +175,13 @@ void note_interrupt(unsigned int irq, st
>         desc->irqs_unhandled = 0;
>  }
>
> +
> +void set_timer_interrupt(unsigned int irq)

Just one blank line between functions, as pr CodingStyle:
   "In source files, separate functions with one blank line.  ..."


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
