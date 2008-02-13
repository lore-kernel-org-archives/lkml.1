Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbYBMWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbYBMWHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbYBMWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:04:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764258AbYBMWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:04:09 -0500
Date: Wed, 13 Feb 2008 14:02:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>, David Brownell <david-b@pacbell.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Message-Id: <20080213140258.78380f5d.akpm@linux-foundation.org>
In-Reply-To: <200710181551.24912.florian.fainelli@telecomint.eu>
References: <200710181551.24912.florian.fainelli@telecomint.eu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 15:51:24 +0200
Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> This patch adds the generic GPIO support to the x86
> architecture. We do the same as for MIPS, we let
> the machine override the gpio callbacks and provide
> defaults one in mach-generic.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
> ---
>  arch/i386/Kconfig                   |    4 ++++
>  include/asm-x86/gpio.h              |    6 ++++++
>  include/asm-x86/mach-generic/gpio.h |   15 +++++++++++++++
>  3 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-x86/gpio.h
>  create mode 100644 include/asm-x86/mach-generic/gpio.h
> ---
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index bf9aafa..501fd6d 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -79,6 +79,10 @@ config GENERIC_BUG
>  	default y
>  	depends on BUG
>  
> +config GENERIC_GPIO
> +	bool
> +	default n
> +
>  config GENERIC_HWEIGHT
>  	bool
>  	default y
> diff --git a/include/asm-x86/gpio.h b/include/asm-x86/gpio.h
> new file mode 100644
> index 0000000..ff87fca
> --- /dev/null
> +++ b/include/asm-x86/gpio.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_I386_GPIO_H
> +#define _ASM_I386_GPIO_H
> +
> +#include <gpio.h>
> +
> +#endif /* _ASM_I386_GPIO_H */
> diff --git a/include/asm-x86/mach-generic/gpio.h b/include/asm-x86/mach-generic/gpio.h
> new file mode 100644
> index 0000000..5305dcb
> --- /dev/null
> +++ b/include/asm-x86/mach-generic/gpio.h
> @@ -0,0 +1,15 @@
> +#ifndef __ASM_MACH_GENERIC_GPIO_H
> +#define __ASM_MACH_GENERIC_GPIO_H
> +
> +int gpio_request(unsigned gpio, const char *label);
> +void gpio_free(unsigned gpio);
> +int gpio_direction_input(unsigned gpio);
> +int gpio_direction_output(unsigned gpio, int value);
> +int gpio_get_value(unsigned gpio);
> +void gpio_set_value(unsigned gpio, int value);
> +int gpio_to_irq(unsigned gpio);
> +int irq_to_gpio(unsigned irq);
> +
> +#include <asm-generic/gpio.h>           /* cansleep wrappers */
> +
> +#endif /* __ASM_MACH_GENERIC_GPIO_H */

There's a new driver in git-dvb which does a plain old

#include <asm/gpio.h>

and it explodes on i386 allmodconfig with:

In file included from drivers/media/video/mt9m001.c:20:
include/asm/gpio.h:4:18: error: gpio.h: No such file or directory

I don't even know how this was supposed to work.  What does "#include
<gpio.h>" give us?  Is the kbuild system supposed to have added
-Iinclude/asm/mach-generic?  It obviously didn't.

Someone please fix.

It would be more modern to have a <linux/gpio.h> which takes care of
cruddy details, but it's getting too late for that.
