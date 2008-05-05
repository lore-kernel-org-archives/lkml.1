Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYEEOgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYEEOgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYEEOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:36:40 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:42821 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbYEEOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:36:38 -0400
Message-ID: <fa686aa40805050736m70e084d5n98f5c86262a6edcf@mail.gmail.com>
Date: Mon, 5 May 2008 08:36:37 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 18/56] microblaze_v2: early_printk support
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
X-Google-Sender-Auth: 6dc14a7d6d9d63d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 5:41 AM,  <monstr@seznam.cz> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
>
>  Signed-off-by: Michal Simek <monstr@monstr.eu>

I'm not opposed to this as is, but longer term will you be getting the
base address out of the device tree instead of from
CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS?

Cheers,
g.

>  ---
>   arch/microblaze/kernel/early_printk.c |  115 +++++++++++++++++++++++++++++++++
>   1 files changed, 115 insertions(+), 0 deletions(-)
>   create mode 100644 arch/microblaze/kernel/early_printk.c
>
>  diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
>  new file mode 100644
>  index 0000000..0f533ff
>  --- /dev/null
>  +++ b/arch/microblaze/kernel/early_printk.c
>  @@ -0,0 +1,115 @@
>  +/*
>  + * arch/microblaze/kernel/early_printk.c
>  + *
>  + * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
>  + * Copyright (C) 2003-2006 Yasushi SHOJI <yashi@atmark-techno.com>
>  + *
>  + * Early printk support for Microblaze.
>  + *
>  + * Once we got some system without uart light, we need to refactor.
>  + */
>  +
>  +#include <linux/console.h>
>  +#include <linux/kernel.h>
>  +#include <linux/init.h>
>  +#include <linux/string.h>
>  +#include <linux/tty.h>
>  +#include <asm/io.h>
>  +#include <asm/processor.h>
>  +#include <asm/fcntl.h>
>  +#include <asm/setup.h>
>  +
>  +#ifdef CONFIG_EARLY_PRINTK
>  +#define BASE_ADDR ((unsigned char *)CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS)
>  +
>  +#define RX_FIFO        BASE_ADDR
>  +#define TX_FIFO        ((unsigned long *)(BASE_ADDR + 4))
>  +#define STATUS ((unsigned long *)(BASE_ADDR + 8))
>  +#define CONTROL        ((unsigned long *)(BASE_ADDR + 12))
>  +
>  +static void early_printk_putc(char c)
>  +{
>  +       while (ioread32(STATUS) & (1<<3));
>  +       iowrite32((c & 0xff), TX_FIFO);
>  +}
>  +
>  +static void early_printk_write(struct console *unused,
>  +                                       const char *s, unsigned n)
>  +{
>  +       while (*s && n-- > 0) {
>  +               early_printk_putc(*s);
>  +               if (*s == '\n')
>  +                       early_printk_putc('\r');
>  +               s++;
>  +       }
>  +}
>  +
>  +static struct console early_serial_console = {
>  +       .name = "earlyser",
>  +       .write = early_printk_write,
>  +       .flags = CON_PRINTBUFFER,
>  +       .index = -1,
>  +};
>  +
>  +/* Direct interface for emergencies */
>  +static struct console *early_console = &early_serial_console;
>  +static int early_console_initialized;
>  +
>  +void early_printk(const char *fmt, ...)
>  +{
>  +       char buf[512];
>  +       int n;
>  +       va_list ap;
>  +
>  +       if (early_console_initialized) {
>  +               va_start(ap, fmt);
>  +               n = vscnprintf(buf, 512, fmt, ap);
>  +               early_console->write(early_console, buf, n);
>  +               va_end(ap);
>  +       }
>  +}
>  +
>  +static int __initdata keep_early;
>  +
>  +int __init setup_early_printk(char *opt)
>  +{
>  +       char *space;
>  +       char buf[256];
>  +
>  +       if (early_console_initialized)
>  +               return 1;
>  +
>  +       strlcpy(buf, opt, sizeof(buf));
>  +       space = strchr(buf, ' ');
>  +       if (space)
>  +               *space = 0;
>  +
>  +       if (strstr(buf, "keep"))
>  +               keep_early = 1;
>  +
>  +       early_console = &early_serial_console;
>  +       early_console_initialized = 1;
>  +       register_console(early_console);
>  +       return 0;
>  +}
>  +#if 0
>  +static void __init disable_early_printk(void)
>  +{
>  +       if (!early_console_initialized || !early_console)
>  +               return;
>  +       if (!keep_early) {
>  +               printk(KERN_INFO "disabling early console\n");
>  +               unregister_console(early_console);
>  +               early_console_initialized = 0;
>  +       } else
>  +               printk(KERN_INFO "keeping early console\n");
>  +}
>  +#endif
>  +
>  +__setup("earlyprintk=", setup_early_printk);
>  +
>  +#else
>  +void early_printk(const char *fmt, ...)
>  +{
>  +}
>  +#endif
>  --
>  1.5.4.GIT
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
