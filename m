Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYEQGyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYEQGyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 02:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYEQGyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 02:54:02 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41901 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYEQGyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 02:54:00 -0400
Date: Sat, 17 May 2008 08:54:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add Niagara2 RNG driver.
Message-ID: <20080517065437.GA8092@uranus.ravnborg.org>
References: <20080516.165354.213801515.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516.165354.213801515.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

Small nitpick..

> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index c8b7300..32b327b 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -7,6 +7,8 @@ rng-core-y := core.o
>  obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
>  obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
>  obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
> +obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
> +n2-rng-objs := n2-drv.o n2-asm.o

These days the preferred syntax is:

n2-rng-y := n2-drv.o n2-asm.o

Following this scheme in general allows us to easily
introduce:
n2-rng-$(CONFIG_FOO) += foo.o


I do not assume your n2-rng will need this,
but doing so in general is a win.

>  obj-$(CONFIG_HW_RANDOM_VIA) += via-rng.o
>  obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
> diff --git a/drivers/char/hw_random/n2-asm.S b/drivers/char/hw_random/n2-asm.S
> new file mode 100644
> index 0000000..c504e53
> --- /dev/null
> +++ b/drivers/char/hw_random/n2-asm.S
> @@ -0,0 +1,93 @@
> +/* n2-asm.S: Niagara2 RNG hypervisor call assembler.
> + *
> + * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
> + */
> +#include <asm/hypervisor.h>
> +#include "n2rng.h"
> +
> +	.text

I had expected:

	.section .text, "aw"

here??

(Maybe init.h should define a __TEXT macro)..

> +	.globl	sun4v_rng_get_diag_ctl
> +	.type	sun4v_rng_get_diag_ctl,#function
> +sun4v_rng_get_diag_ctl:
> +	mov	HV_FAST_RNG_GET_DIAG_CTL, %o5
> +	ta	HV_FAST_TRAP
> +	retl
> +	 nop
> +	.size	sun4v_rng_get_diag_ctl,.-sun4v_rng_get_diag_ctl

Any specific reason why you do not use:

ENTRY(sun4v_rng_get_diag_ctl)
     mov     HV_FAST_RNG_GET_DIAG_CTL, %o5
     ta      HV_FAST_TRAP
     retl
      nop
ENDPROC(sun4v_rng_get_diag_ctl)

I see these uses in other places and it
do the .globl, .type, .size and the label: stuff for you.

This is a general comment for all the 'functions' in this file.

Only browsed the rest - looked good.

	Sam
