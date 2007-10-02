Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXJBGnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXJBGnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJBGnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:43:06 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:60004 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXJBGnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:43:05 -0400
Date: Tue, 2 Oct 2007 08:43:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Magotari@gail.com
Subject: Re: [uml-devel] [PATCH 1/3] UML - Fix stub address calculations
In-Reply-To: <20071001212306.GA10113@c2.user-mode-linux.org>
Message-ID: <Pine.LNX.4.64.0710020841411.28398@anakin>
References: <20071001212306.GA10113@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Jeff Dike wrote:
> The Kconfig language seems not to allow calculation of hex constants,
> so I moved this to as-layout.h.  CONFIG_STUB_CODE, CONFIG_STUB_DATA,
> and CONFIG_STUB_START are now gone.  In their place are STUB_CODE,
> STUB_DATA, and STUB_START in as-layout.h.

Hmm, perhaps you can use _AC() (from <linux/const.h>) to defined the original
constants instead, so you don't need the #ifdefs?

> --- linux-2.6.22.orig/arch/um/include/as-layout.h	2007-09-27 11:47:22.000000000 -0400
> +++ linux-2.6.22/arch/um/include/as-layout.h	2007-10-01 16:41:26.000000000 -0400
> @@ -6,6 +6,28 @@
>  #ifndef __START_H__
>  #define __START_H__
>  
> +#include "uml-config.h"
> +#include "kern_constants.h"
> +
> +/*
> + * Assembly doesn't want any casting, but C does, so define these
> + * without casts here, and define new symbols with casts inside the C
> + * section.
> + */
> +#define ASM_STUB_CODE (UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
> +#define ASM_STUB_DATA (UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
> +#define ASM_STUB_START ASM_STUB_CODE
> +
> +/*
> + * This file is included by the assembly stubs, which just want the
> + * definitions above.
> + */
> +#ifndef __ASSEMBLY__
> +
> +#define STUB_CODE ((unsigned long) ASM_STUB_CODE)
> +#define STUB_DATA ((unsigned long) ASM_STUB_DATA)
> +#define STUB_START ((unsigned long) ASM_STUB_START)
> +
>  #include "sysdep/ptrace.h"
>  
>  struct cpu_task {
> @@ -32,3 +54,5 @@ extern int linux_main(int argc, char **a
>  extern void (*sig_info[])(int, struct uml_pt_regs *);
>  
>  #endif
> +
> +#endif

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
