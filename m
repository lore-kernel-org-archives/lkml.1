Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYFRHha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYFRHha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYFRHhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:37:18 -0400
Received: from correo.ikusi.com ([194.30.89.100]:28867 "EHLO correo.ikusi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYFRHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:37:17 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 03:37:17 EDT
Subject: Change console to another UART
From: oihana <munoz.o@ikusi.es>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080617223023.GH25911@cs181133002.pp.htv.fi>
References: <20080617223023.GH25911@cs181133002.pp.htv.fi>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Jun 2008 09:21:04 +0200
Message-Id: <1213773664.15059.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 18 Jun 2008 07:21:58.0620 (UTC) FILETIME=[FE9AC9C0:01C8D113]
X-TM-AS-Product-Ver: SMEX-7.0.0.1433-5.5.1027-15978.002
X-TM-AS-Result: No--4.835000-4.000000-31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I am working with a STi7109 and mb411. The STi7109 has 4 UARTs and they
are configured by default as follow....
- UART0 is reserved for SC0
- UART1 is reserved for SC1
- UART2 is reserved for console
- UART3 is reserved for KGDB

What I need is to have the Console in the UART1 because I need the UART2
free, and I have enough with one SC (SC0). 

I realized that if I change on my STWorkBench the Kernel Debug
configuration, from ttyAS0 to ttyAS1, the console comes out from the
other serial port, but it still uses the UART2. 

So I tried to change the configuration in the stasc.c
(kernel/src/drivers/serial/stasc.c).

- Original configuration for my chip and board:
struct asc_port asc_ports[ASC_NPORTS] = {
#if defined(CONFIG_CPU_SUBTYPE_STB7100)
        /* UART2 */ 
	
	{  
		.port	= {
			.membase	= (void *)0xb8032000,
			.mapbase	= 0xb8032000,
			.iotype		= SERIAL_IO_MEM,
			.irq		= 121,
			.ops		= &asc_uart_ops,
			.flags		= ASYNC_BOOT_AUTOCONF,
			.fifosize	= FIFO_SIZE,
			.line		= 0,
		},
		.pio_port	= 4, 
		.pio_pin	= {3, 2, 4, 5},
	} ,
			 
	
	/* UART3 */
	{   
		.port	= {
			.membase	= (void *)0xb8033000,
			.mapbase	= 0xb8033000,
			.iotype		= SERIAL_IO_MEM,
			.irq		= 120,
			.ops		= &asc_uart_ops,
			.flags		= ASYNC_BOOT_AUTOCONF,
			.fifosize	= FIFO_SIZE,
			.line		= 1,
		},
		.pio_port	= 5, 
		.pio_pin	= {0, 1, 2, 3},
	}
...
...


- My changes: I tried to change the order, to have in the first element
the UART3 and in the second the UART2, or to have UART1 and UART2....
and nothing seams to work. 

        /* UART1 */
	{   
		.port	= {
			.membase	= (void *)0xb8031000,
			.mapbase	= 0xb8031000,
			.iotype		= SERIAL_IO_MEM,
			.irq		= 122,
			.ops		= &asc_uart_ops,
			.flags		= ASYNC_BOOT_AUTOCONF,
			.fifosize	= FIFO_SIZE,
			.line		= 1,
		},
		.pio_port	= 1, 
		.pio_pin	= {0, 1, 4, 5},
	},
	
	/* UART2 */  
	{  
		.port	= {
			.membase	= (void *)0xb8032000,
			.mapbase	= 0xb8032000,
			.iotype		= SERIAL_IO_MEM,
			.irq		= 121,
			.ops		= &asc_uart_ops,
			.flags		= ASYNC_BOOT_AUTOCONF,
			.fifosize	= FIFO_SIZE,
			.line		= 0,
		},
		.pio_port	= 4, 
		.pio_pin	= {3, 2, 4, 5},
	} 

If the first element is the UART2, the kernel runs OK. So that I can go
into using the minicom or ssh. In the other hand, if the UART2 is the
second element, kernel seams if it was run (in the STWorkBench)... but
the ethernet ping to the board tells me "Destination Host Unreachable",
and I don't get any answer from the 3 serial points in which i
listen... 

Could someone help me please????????

Thanks, 

Oihana
