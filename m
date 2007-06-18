Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbXFRKSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbXFRKSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXFRKSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:18:40 -0400
Received: from 42.242.232.72.static.reverse.layeredtech.com ([72.232.242.42]:37998
	"EHLO secure.poehali.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbXFRKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:18:39 -0400
Date: Mon, 18 Jun 2007 13:21:21 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Fix break handling
Message-ID: <20070618132121.2d00a907@newbox>
In-Reply-To: <20070605132336.3b8a9a4e@dhcp-255-175.norway.atmel.com>
References: <11806398911702-git-send-email-hskinnemoen@atmel.com>
	<20070605140720.4bdf887a@newbox>
	<20070605132336.3b8a9a4e@dhcp-255-175.norway.atmel.com>
Organization: Promwad
X-Mailer: Sylpheed-Claws 1.9.100cvs93 (GTK+ 2.8.7; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Assp-Whitelisted: Yes
X-Assp-Envelope-From: ivan.kuten@promwad.com
X-Assp-Intended-For: hskinnemoen@atmel.com andrew@sanpeople.com
	rmk@arm.linux.org.uk nicolas.ferre@rfo.atmel.com patrice.vilchez@rfo.atmel.com
	linux-kernel@vger.kernel.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - secure.poehali.org
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - promwad.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 13:23:36 +0200
Haavard Skinnemoen wrote:

> On Tue, 5 Jun 2007 14:07:20 +0300
> Ivan Kuten <ivan.kuten@promwad.com> wrote:
> 
> > I tried to test your patch on AT91RM9200 with Magic SysRq sequence, unfortunately without 
> > success - SysRq still does not work. You mention "break count increments" where do you check it ? I have 
> > cat /proc/tty/driver/atmel_serial 
> > serinfo:1.0 driver revision:
> > 0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:8554 rx:623 fe:25 RTS|CTS|DTR|DSR|CD|RI
> > 1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI
> > 2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI
> > 3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:0 rx:0 DSR|CD|RI
> > 4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 CTS|DSR|CD|RI
> > 
> > no any break counter.
> 
> Andrew Victor pointed out that the RM9200 DBGU doesn't support break at
> all, and the data sheet seems to agree. The break counter seems to show
> up after the first break has been received and you're probably not
> receiving any.
> 
> Is it possible for you to try a different USART as console?
> 
> Haavard

Hi Haavard,

I tried /dev/ttyAT3, break appeared but not the way I expected, after: stty -F /dev/ttyAT3 brkint 
I get:

cat /proc/tty/driver/atmel_serial 
serinfo:1.0 driver revision:
0: uart:ATMEL_SERIAL mmio:0xFEFFF200 irq:1 tx:0 rx:0 CTS|DSR|CD|RI
1: uart:ATMEL_SERIAL mmio:0xFFFC0000 irq:6 tx:0 rx:0 CTS|DSR|CD|RI             
2: uart:ATMEL_SERIAL mmio:0xFFFC4000 irq:7 tx:0 rx:0 RI                        
3: uart:ATMEL_SERIAL mmio:0xFFFC8000 irq:8 tx:1530 rx:115 brk:1 RTS|DTR|DSR|CD|RI
4: uart:ATMEL_SERIAL mmio:0xFFFCC000 irq:9 tx:0 rx:0 DSR|CD|RI  

brk is 1 not depending on how many breaks was sent. May be I missunderstood "break" meaning?
I use from minicom: Main Functions : send break.........F . 

I inserted printk:

/*                                                                                                                                         
 * Control the transmission of a break signal                                                                                              
 */                                                                                                                                        
static void atmel_break_ctl(struct uart_port *port, int break_state)                                                                       
{                                                                                                                                          
        printk(KERN_EMERG "atmel_break_ctl break_state %d", break_state);                                                                  
        if (break_state != 0)                                                                                                              
                UART_PUT_CR(port, ATMEL_US_STTBRK);     /* start break */                                                                  
        else                                                                                                                               
                UART_PUT_CR(port, ATMEL_US_STPBRK);     /* stop break */                                                                   
}                                                                                                                                          

it's also not shown.

BR,
Ivan
