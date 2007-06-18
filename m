Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbXFRKes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbXFRKes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbXFRKem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:34:42 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4201 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXFRKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:34:41 -0400
Date: Mon, 18 Jun 2007 11:33:54 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ivan Kuten <ivan.kuten@promwad.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Fix break handling
Message-ID: <20070618103353.GB10387@flint.arm.linux.org.uk>
References: <11806398911702-git-send-email-hskinnemoen@atmel.com> <20070605140720.4bdf887a@newbox> <20070605132336.3b8a9a4e@dhcp-255-175.norway.atmel.com> <20070618132121.2d00a907@newbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618132121.2d00a907@newbox>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:21:21PM +0300, Ivan Kuten wrote:
> Hi Haavard,
> 
> I tried /dev/ttyAT3, break appeared but not the way I expected, after:
> stty -F /dev/ttyAT3 brkint I get:
> 
> cat /proc/tty/driver/atmel_serial 
> serinfo:1.0 driver revision:
> 0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:0 rx:0 CTS|DSR|CD|RI
> 1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI             
> 2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI                        
> 3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:1530 rx:115 brk:1 RTS|DTR|DSR|CD|RI
> 4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 DSR|CD|RI  
> 
> brk is 1 not depending on how many breaks was sent. May be I missunderstood
> "break" meaning?
> I use from minicom: Main Functions : send break.........F . 

Note that if you want to use magic sysrq on ttyAT3, you need the kernel
console on ttyAT3.  Since you successfully received one break event on
ttyAT3, the next character should have caused a sysrq event.

> I inserted printk:
> 
> /*
>  * Control the transmission of a break signal
                 ^^^^^^^^^^^^
So if you're looking at the reception paths, this clearly isn't it...

>  */
> static void atmel_break_ctl(struct uart_port *port, int break_state)                                                                       
> {                                                                                                                                          
>         printk(KERN_EMERG "atmel_break_ctl break_state %d", break_state);                                                                  
>         if (break_state != 0)                                                                                                              
>                 UART_PUT_CR(port, ATMEL_US_STTBRK);     /* start break */                                                                  
>         else                                                                                                                               
>                 UART_PUT_CR(port, ATMEL_US_STPBRK);     /* stop break */                                                                   
> }                                                                                                                                          
> 
> it's also not shown.

... and that explains why.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
