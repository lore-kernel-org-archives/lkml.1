Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYFJCP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYFJCP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYFJCPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:15:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:58347 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYFJCPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KUN1RXlBfDxjBXpM0pPTmlF8Tq5NmLCSNy5btROQkQOSAqAUg8mGsA6mAEzh+WuRBc
         B7/Ri5KhWm8nV2Llh1TZQV73zKKxqld6ISzagHJBUvqHaiNdAXsfe0tC5fVkodbW0tP8
         WJOjme3ZQH4rNlZW8REst6KeagSz11A4keuHs=
Message-ID: <386072610806091915t6a8d7315l52659930771d0f24@mail.gmail.com>
Date: Tue, 10 Jun 2008 10:15:43 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin arch updates for 2.6.26-RC5
In-Reply-To: <386072610806070126n37cdd3c8w6c07cd091667e0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610806070126n37cdd3c8w6c07cd091667e0e@mail.gmail.com>
X-Google-Sender-Auth: 5afa7890e6ac6d59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 4:26 PM, Bryan Wu <cooloney@kernel.org> wrote:
> Hi Linus,
>
> Please pull from 'for-linus' branch of
>
> master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus
>
> to receive the following updates:


Hi Linus,

Could you please pull this changes?
Graf's patch fixed the build error regression:
http://bugzilla.kernel.org/show_bug.cgi?id=10873

Thanks a lot
-Bryan

>
>  arch/blackfin/kernel/traps.c                      |    8 ++---
>  arch/blackfin/mach-bf527/boards/ezkit.c           |    9 +----
>  arch/blackfin/mach-bf533/boards/ezkit.c           |    6 +---
>  arch/blackfin/mach-bf533/boards/stamp.c           |   10 ++----
>  arch/blackfin/mach-bf537/boards/stamp.c           |    9 +----
>  arch/blackfin/mach-bf548/boards/ezkit.c           |   10 ++----
>  arch/blackfin/mach-bf561/boards/ezkit.c           |    9 ++---
>  drivers/serial/bfin_5xx.c                         |   40 +++++---------------
>  include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    6 +++
>  include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    6 +++
>  include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    6 +++
>  include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    6 +++
>  include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    6 +++
>  13 files changed, 57 insertions(+), 74 deletions(-)
>
> Graf Yang (1):
>      Blackfin serial driver: fix up tty core set_ldisc API change breakage bug
>
> Mike Frysinger (2):
>      Blackfin arch: fixup warnings with the new cplb saved values
>      Blackfin arch: protect only the SPI bus controller with CONFIG_SPI_BFIN
>
> Sonic Zhang (1):
>      Blackfin Serial Driver: Clean up BF54x macro in blackfin UART driver.
>
> diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
> index 7bfbd95..f061f51 100644
> --- a/arch/blackfin/kernel/traps.c
> +++ b/arch/blackfin/kernel/traps.c
> @@ -67,7 +67,7 @@ void __init trap_init(void)
>        CSYNC();
>  }
>
> -void *saved_icplb_fault_addr, *saved_dcplb_fault_addr;
> +unsigned long saved_icplb_fault_addr, saved_dcplb_fault_addr;
>
>  int kstack_depth_to_print = 48;
>
> @@ -366,7 +366,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
>                info.si_code = ILL_CPLB_MULHIT;
>                sig = SIGSEGV;
>  #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
> -               if (saved_dcplb_fault_addr < (void *)FIXED_CODE_START)
> +               if (saved_dcplb_fault_addr < FIXED_CODE_START)
>                        printk(KERN_NOTICE "NULL pointer access\n");
>                else
>  #endif
> @@ -421,7 +421,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
>                info.si_code = ILL_CPLB_MULHIT;
>                sig = SIGSEGV;
>  #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
> -               if (saved_icplb_fault_addr < (void *)FIXED_CODE_START)
> +               if (saved_icplb_fault_addr < FIXED_CODE_START)
>                        printk(KERN_NOTICE "Jump to NULL address\n");
>                else
>  #endif
> @@ -939,8 +939,6 @@ void panic_cplb_error(int cplb_panic, struct pt_regs *fp)
>
>        oops_in_progress = 1;
>
> -       printk(KERN_EMERG "DCPLB_FAULT_ADDR=%p\n", saved_dcplb_fault_addr);
> -       printk(KERN_EMERG "ICPLB_FAULT_ADDR=%p\n", saved_icplb_fault_addr);
>        dump_bfin_process(fp);
>        dump_bfin_mem(fp);
>        show_regs(fp);
> diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c
> b/arch/blackfin/mach-bf527/boards/ezkit.c
> index fa4f4e8..5958eec 100644
> --- a/arch/blackfin/mach-bf527/boards/ezkit.c
> +++ b/arch/blackfin/mach-bf527/boards/ezkit.c
> @@ -451,9 +451,6 @@ static struct platform_device net2272_bfin_device = {
>  };
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -/* all SPI peripherals info goes here */
> -
>  #if defined(CONFIG_MTD_M25P80) \
>        || defined(CONFIG_MTD_M25P80_MODULE)
>  static struct mtd_partition bfin_spi_flash_partitions[] = {
> @@ -676,6 +673,7 @@ static struct spi_board_info bfin_spi_board_info[]
> __initdata = {
>  #endif
>  };
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI controller data */
>  static struct bfin5xx_spi_master bfin_spi0_info = {
>        .num_chipselect = 8,
> @@ -1018,10 +1016,7 @@ static int __init stamp_init(void)
>  #endif
>
>        platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -       spi_register_board_info(bfin_spi_board_info,
> -                               ARRAY_SIZE(bfin_spi_board_info));
> -#endif
> +       spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
>
>  #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
>        irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
> diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c
> b/arch/blackfin/mach-bf533/boards/ezkit.c
> index 9d28415..079389c 100644
> --- a/arch/blackfin/mach-bf533/boards/ezkit.c
> +++ b/arch/blackfin/mach-bf533/boards/ezkit.c
> @@ -87,9 +87,6 @@ static struct platform_device smc91x_device = {
>  };
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -/* all SPI peripherals info goes here */
> -
>  #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
>  static struct mtd_partition bfin_spi_flash_partitions[] = {
>        {
> @@ -189,6 +186,7 @@ static struct spi_board_info bfin_spi_board_info[]
> __initdata = {
>  #endif
>  };
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI (0) */
>  static struct resource bfin_spi0_resource[] = {
>        [0] = {
> @@ -425,9 +423,7 @@ static int __init ezkit_init(void)
>  {
>        printk(KERN_INFO "%s(): registering device resources\n", __func__);
>        platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>        spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
> -#endif
>
>  #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
>        irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
> diff --git a/arch/blackfin/mach-bf533/boards/stamp.c
> b/arch/blackfin/mach-bf533/boards/stamp.c
> index ec05b23..13ae495 100644
> --- a/arch/blackfin/mach-bf533/boards/stamp.c
> +++ b/arch/blackfin/mach-bf533/boards/stamp.c
> @@ -161,9 +161,6 @@ static struct platform_device stamp_flash_device = {
>  };
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -/* all SPI peripherals info goes here */
> -
>  #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
>  static struct mtd_partition bfin_spi_flash_partitions[] = {
>        {
> @@ -320,6 +317,7 @@ static struct spi_board_info bfin_spi_board_info[]
> __initdata = {
>  #endif
>  };
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI (0) */
>  static struct resource bfin_spi0_resource[] = {
>        [0] = {
> @@ -626,10 +624,8 @@ static int __init stamp_init(void)
>        SSYNC();
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -       spi_register_board_info(bfin_spi_board_info,
> -                               ARRAY_SIZE(bfin_spi_board_info));
> -#endif
> +       spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
> +
>  #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
>        irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
>  #endif
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
> b/arch/blackfin/mach-bf537/boards/stamp.c
> index 9a756d1..671f9d6 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -400,9 +400,6 @@ static struct platform_device stamp_flash_device = {
>  };
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -/* all SPI peripherals info goes here */
> -
>  #if defined(CONFIG_MTD_M25P80) \
>        || defined(CONFIG_MTD_M25P80_MODULE)
>  static struct mtd_partition bfin_spi_flash_partitions[] = {
> @@ -629,6 +626,7 @@ static struct spi_board_info bfin_spi_board_info[]
> __initdata = {
>  #endif
>  };
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI controller data */
>  static struct bfin5xx_spi_master bfin_spi0_info = {
>        .num_chipselect = 8,
> @@ -939,10 +937,7 @@ static int __init stamp_init(void)
>  #endif
>
>        platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -       spi_register_board_info(bfin_spi_board_info,
> -                               ARRAY_SIZE(bfin_spi_board_info));
> -#endif
> +       spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
>
>  #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
>        irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
> diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
> b/arch/blackfin/mach-bf548/boards/ezkit.c
> index d1682bb..af7c211 100644
> --- a/arch/blackfin/mach-bf548/boards/ezkit.c
> +++ b/arch/blackfin/mach-bf548/boards/ezkit.c
> @@ -412,8 +412,6 @@ static struct platform_device ezkit_flash_device = {
>  };
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -/* all SPI peripherals info goes here */
>  #if defined(CONFIG_MTD_M25P80) \
>        || defined(CONFIG_MTD_M25P80_MODULE)
>  /* SPI flash chip (m25p16) */
> @@ -481,7 +479,7 @@ static struct bfin5xx_spi_chip spidev_chip_info = {
>  };
>  #endif
>
> -static struct spi_board_info bf54x_spi_board_info[] __initdata = {
> +static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  #if defined(CONFIG_MTD_M25P80) \
>        || defined(CONFIG_MTD_M25P80_MODULE)
>        {
> @@ -527,6 +525,7 @@ static struct spi_board_info
> bf54x_spi_board_info[] __initdata = {
>  #endif
>  };
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI (0) */
>  static struct resource bfin_spi0_resource[] = {
>        [0] = {
> @@ -800,10 +799,7 @@ static int __init ezkit_init(void)
>
>        platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -       spi_register_board_info(bf54x_spi_board_info,
> -                       ARRAY_SIZE(bf54x_spi_board_info));
> -#endif
> +       spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
>
>        return 0;
>  }
> diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c
> b/arch/blackfin/mach-bf561/boards/ezkit.c
> index 61d8f76..bc6fede 100644
> --- a/arch/blackfin/mach-bf561/boards/ezkit.c
> +++ b/arch/blackfin/mach-bf561/boards/ezkit.c
> @@ -280,7 +280,6 @@ static struct platform_device ezkit_flash_device = {
>  };
>  #endif
>
> -#ifdef CONFIG_SPI_BFIN
>  #if defined(CONFIG_SND_BLACKFIN_AD1836) \
>        || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
>  static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
> @@ -295,8 +294,8 @@ static struct bfin5xx_spi_chip spidev_chip_info = {
>        .bits_per_word = 8,
>  };
>  #endif
> -#endif
>
> +#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
>  /* SPI (0) */
>  static struct resource bfin_spi0_resource[] = {
>        [0] = {
> @@ -327,6 +326,7 @@ static struct platform_device bfin_spi0_device = {
>                .platform_data = &bfin_spi0_info, /* Passed to driver */
>        },
>  };
> +#endif
>
>  static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  #if defined(CONFIG_SND_BLACKFIN_AD1836) \
> @@ -537,10 +537,7 @@ static int __init ezkit_init(void)
>        SSYNC();
>  #endif
>
> -#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
> -       spi_register_board_info(bfin_spi_board_info,
> -                               ARRAY_SIZE(bfin_spi_board_info));
> -#endif
> +       spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
>
>  #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
>        irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index d6b4ead..f20952c 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -530,11 +530,7 @@ static unsigned int bfin_serial_get_mctrl(struct
> uart_port *port)
>        if (uart->cts_pin < 0)
>                return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
>
> -# ifdef BF54x
> -       if (UART_GET_MSR(uart) & CTS)
> -# else
> -       if (gpio_get_value(uart->cts_pin))
> -# endif
> +       if (UART_GET_CTS(uart))
>                return TIOCM_DSR | TIOCM_CAR;
>        else
>  #endif
> @@ -549,17 +545,9 @@ static void bfin_serial_set_mctrl(struct
> uart_port *port, unsigned int mctrl)
>                return;
>
>        if (mctrl & TIOCM_RTS)
> -# ifdef BF54x
> -               UART_PUT_MCR(uart, UART_GET_MCR(uart) & ~MRTS);
> -# else
> -               gpio_set_value(uart->rts_pin, 0);
> -# endif
> +               UART_CLEAR_RTS(uart);
>        else
> -# ifdef BF54x
> -               UART_PUT_MCR(uart, UART_GET_MCR(uart) | MRTS);
> -# else
> -               gpio_set_value(uart->rts_pin, 1);
> -# endif
> +               UART_SET_RTS(uart);
>  #endif
>  }
>
> @@ -752,11 +740,7 @@ bfin_serial_set_termios(struct uart_port *port,
> struct ktermios *termios,
>
>        /* Disable UART */
>        ier = UART_GET_IER(uart);
> -#ifdef CONFIG_BF54x
> -       UART_CLEAR_IER(uart, 0xF);
> -#else
> -       UART_PUT_IER(uart, 0);
> -#endif
> +       UART_DISABLE_INTS(uart);
>
>        /* Set DLAB in LCR to Access DLL and DLH */
>        UART_SET_DLAB(uart);
> @@ -771,11 +755,7 @@ bfin_serial_set_termios(struct uart_port *port,
> struct ktermios *termios,
>        UART_PUT_LCR(uart, lcr);
>
>        /* Enable UART */
> -#ifdef CONFIG_BF54x
> -       UART_SET_IER(uart, ier);
> -#else
> -       UART_PUT_IER(uart, ier);
> -#endif
> +       UART_ENABLE_INTS(uart, ier);
>
>        val = UART_GET_GCTL(uart);
>        val |= UCEN;
> @@ -833,15 +813,15 @@ bfin_serial_verify_port(struct uart_port *port,
> struct serial_struct *ser)
>  * Enable the IrDA function if tty->ldisc.num is N_IRDA.
>  * In other cases, disable IrDA function.
>  */
> -static void bfin_set_ldisc(struct tty_struct *tty)
> +static void bfin_serial_set_ldisc(struct uart_port *port)
>  {
> -       int line = tty->index;
> +       int line = port->line;
>        unsigned short val;
>
> -       if (line >= tty->driver->num)
> +       if (line >= port->info->tty->driver->num)
>                return;
>
> -       switch (tty->ldisc.num) {
> +       switch (port->info->tty->ldisc.num) {
>        case N_IRDA:
>                val = UART_GET_GCTL(&bfin_serial_ports[line]);
>                val |= (IREN | RPOLC);
> @@ -866,6 +846,7 @@ static struct uart_ops bfin_serial_pops = {
>        .startup        = bfin_serial_startup,
>        .shutdown       = bfin_serial_shutdown,
>        .set_termios    = bfin_serial_set_termios,
> +       .set_ldisc      = bfin_serial_set_ldisc,
>        .type           = bfin_serial_type,
>        .release_port   = bfin_serial_release_port,
>        .request_port   = bfin_serial_request_port,
> @@ -1206,7 +1187,6 @@ static int __init bfin_serial_init(void)
>
>        ret = uart_register_driver(&bfin_serial_reg);
>        if (ret == 0) {
> -               bfin_serial_reg.tty_driver->set_ldisc = bfin_set_ldisc;
>                ret = platform_driver_register(&bfin_serial_driver);
>                if (ret) {
>                        pr_debug("uart register failed\n");
> diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
> b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
> index 26e3c80..96bd09e 100644
> --- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
> +++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
> @@ -53,6 +53,12 @@
>  #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
>  #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
>
> +#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
> +#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
> +#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
> +#define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
> +#define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
> +
>  #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
>  # define CONFIG_SERIAL_BFIN_CTSRTS
>
> diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
> b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
> index d016603..e924569 100644
> --- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
> +++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
> @@ -53,6 +53,12 @@
>  #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
>  #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
>
> +#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
> +#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
> +#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
> +#define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
> +#define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
> +
>  #ifdef CONFIG_BFIN_UART0_CTSRTS
>  # define CONFIG_SERIAL_BFIN_CTSRTS
>  # ifndef CONFIG_UART0_CTS_PIN
> diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
> b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
> index f79d1a0..41d7b64 100644
> --- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
> +++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
> @@ -53,6 +53,12 @@
>  #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
>  #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
>
> +#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
> +#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
> +#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
> +#define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
> +#define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
> +
>  #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
>  # define CONFIG_SERIAL_BFIN_CTSRTS
>
> diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
> b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
> index 5eb46a7..59b4ad4 100644
> --- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
> +++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
> @@ -57,6 +57,12 @@
>  #define UART_SET_DLAB(uart)     /* MMRs not muxed on BF54x */
>  #define UART_CLEAR_DLAB(uart)   /* MMRs not muxed on BF54x */
>
> +#define UART_GET_CTS(x) (UART_GET_MSR(x) & CTS)
> +#define UART_SET_RTS(x) (UART_PUT_MCR(x, UART_GET_MCR(x) | MRTS))
> +#define UART_CLEAR_RTS(x) (UART_PUT_MCR(x, UART_GET_MCR(x) & ~MRTS))
> +#define UART_ENABLE_INTS(x, v) UART_SET_IER(x, v)
> +#define UART_DISABLE_INTS(x) UART_CLEAR_IER(x, 0xF)
> +
>  #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
>  # define CONFIG_SERIAL_BFIN_CTSRTS
>
> diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
> b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
> index 7a96287..30d90b5 100644
> --- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
> +++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
> @@ -53,6 +53,12 @@
>  #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
>  #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
> UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
>
> +#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
> +#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
> +#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
> +#define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
> +#define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
> +
>  #ifdef CONFIG_BFIN_UART0_CTSRTS
>  # define CONFIG_SERIAL_BFIN_CTSRTS
>  # ifndef CONFIG_UART0_CTS_PIN
>
