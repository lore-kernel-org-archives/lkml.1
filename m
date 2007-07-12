Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbXGLSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbXGLSyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbXGLSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:53:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607AbXGLSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:53:54 -0400
Date: Thu, 12 Jul 2007 11:47:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Mark Mason <mason@broadcom.com>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-duart.c: SB1250 DUART serial support
Message-Id: <20070712114712.de5d6c9d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 18:39:00 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  This is a driver for the SB1250 DUART, a dual serial port implementation 
> included in the Broadcom family of SOCs descending from the SiByte SB1250 
> MIPS64 chip multiprocessor.  It is a new implementation replacing the 
> old-fashioned driver currently present in the linux-mips.org tree.  It 
> supports all the usual features one would expect from a(n asynchronous) 
> serial driver, including modem line control (as far as hardware supports 
> it -- there is edge detection logic missing from the DCD and RI lines and 
> the driver does not implement polling of these lines at the moment), the 
> serial console, BREAK transmission and reception, including the magic 
> SysRq.  The receive FIFO threshold is not maintained though.
> 
> ...
>
> +
> +#if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
> +#include <asm/sibyte/bcm1480_regs.h>
> +#include <asm/sibyte/bcm1480_int.h>
> +
> +#define SBD_CHANREGS(line)	A_BCM1480_DUART_CHANREG((line), 0)
> +#define SBD_CTRLREGS(line)	A_BCM1480_DUART_CTRLREG((line), 0)
> +#define SBD_INT(line)		(K_BCM1480_INT_UART_0 + (line))
> +
> +#elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
> +#include <asm/sibyte/sb1250_regs.h>
> +#include <asm/sibyte/sb1250_int.h>
> +
> +#define SBD_CHANREGS(line)	A_DUART_CHANREG((line), 0)
> +#define SBD_CTRLREGS(line)	A_DUART_CTRLREG(0)
> +#define SBD_INT(line)		(K_INT_UART_0 + (line))
> +
> +#else
> +#error invalid SB1250 UART configuration
> +
> +#endif

If the #error can trigger, the Kconfig is broken, yes?  (No action is
required though - it's always good to have checks)

> +#define to_sport(uport) container_of(uport, struct sbd_port, port)

That didn't need to be implemented as a macro.

> +#define __unused __attribute__((__unused__))

Please use the generic implementations here.  `grep unused
include/linux/compiler*.h'.

> +/*
> + * In bug 1956, we get glitches that can mess up uart registers.  This
> + * "read-mode-reg after any register access" is an accepted workaround.
> + */

<looks in bugzilla.kernel.org>

<wonders how a uart driver can fix an smbfs bug>

Perhaps a reference to where that bug number came from?

> +static void __war_sbd1956(struct sbd_port *sport)
> +{
> +	__read_sbdchn(sport, R_DUART_MODE_REG_1);
> +	__read_sbdchn(sport, R_DUART_MODE_REG_2);
> +}
>
> ...
>
> +static struct uart_ops sbd_ops = {

I suppose if we made this const, something would blow up.




There is no power management support in this driver.
