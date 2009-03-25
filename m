Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbZCYTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbZCYTvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZCYTvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:51:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44449 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbZCYTva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wnTyQfq42Im215DVSETzz9DVxkSThrrU9zAxHJ+EDukDuIh/14i6WJoUPySB3/UPXR
         4vaRSSqalcOOvlI9MJmchXDOxs+jJtf/ZuxmnSIr572sNo3Qp8juKZWtZ+2iBetwPWcD
         +mJXLMmeZm+oFVwHbaUseYDbzHyHEHcaPcKdw=
MIME-Version: 1.0
In-Reply-To: <20090226131719.393515463@linutronix.de>
References: <20090226131336.423054348@linutronix.de>
	 <20090226131719.393515463@linutronix.de>
Date: Wed, 25 Mar 2009 20:51:27 +0100
X-Google-Sender-Auth: cd3ee1ecdb900e93
Message-ID: <10f740e80903251251x33cd3e05gcf03e41e0aaf6308@mail.gmail.com>
Subject: Re: [patch 1/4] genirq: make irqreturn_t an enum
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 14:28, Thomas Gleixner <tglx@linutronix.de> wrote:
> Impact: cleanup
>
> Remove the 2.4 compabiliy cruft

> --- linux-2.6-tip.orig/include/linux/irqreturn.h
> +++ linux-2.6-tip/include/linux/irqreturn.h
> @@ -1,25 +1,17 @@
> -/* irqreturn.h */
>  #ifndef _LINUX_IRQRETURN_H
>  #define _LINUX_IRQRETURN_H
>
> -/*
> - * For 2.4.x compatibility, 2.4.x can use
> - *
> - *     typedef void irqreturn_t;
> - *     #define IRQ_NONE
> - *     #define IRQ_HANDLED
> - *     #define IRQ_RETVAL(x)
> - *
> - * To mix old-style and new-style irq handler returns.
> - *
> - * IRQ_NONE means we didn't handle it.
> - * IRQ_HANDLED means that we did have a valid interrupt and handled it.
> - * IRQ_RETVAL(x) selects on the two depending on x being non-zero (for handled)
> +/**
> + * enum irqreturn
> + * @IRQ_NONE           interrupt was not from this device
> + * @IRQ_HANDLED                interrupt was handled by this device
>  */
> -typedef int irqreturn_t;
> +enum irqreturn {
> +       IRQ_NONE,
> +       IRQ_HANDLED,
> +};
>
> -#define IRQ_NONE       (0)
> -#define IRQ_HANDLED    (1)
> -#define IRQ_RETVAL(x)  ((x) != 0)
> +typedef enum irqreturn irqreturn_t;
> +#define IRQ_RETVAL(x)  ((x) != IRQ_NONE)

JFYI, this causes the following warning in linux-next on m68k:

| arch/m68k/kernel/ints.c:231: warning: assignment from incompatible
pointer type

(cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/271602/)

as struct irq_node in arch/m68k/include/asm/irq_mm.h still has a
`int (*handler)(int, void *);'.

I'll cook a patch, but there may be other users hidden somewhere in
arch-specific code...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
