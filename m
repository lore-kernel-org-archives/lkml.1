Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZFKJai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZFKJai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbZFKJaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:30:30 -0400
Received: from elvis.franken.de ([193.175.24.41]:48570 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbZFKJa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:30:29 -0400
Date: Thu, 11 Jun 2009 11:30:22 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Message-ID: <20090611093022.GA14510@alpha.franken.de>
References: <200906041622.47591.florian@openwrt.org> <20090604222020.GA14843@alpha.franken.de> <200906111028.41222.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200906111028.41222.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:28:39AM +0200, Florian Fainelli wrote:
> Le Friday 05 June 2009 00:20:20 Thomas Bogendoerfer, vous avez écrit :
> > On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> > > We discussed that in private, there are a couple of things
> > > to fix in order to get 8250 working properly with TI AR7 HW.
> > > If you can still merge that bit, this would ease future work, thanks !
> >
> > I still have a tree here, which works without any changes to the 8250
> > serial driver on a TNETD7300 device.
> 
> Could you show me how you register the 8250 driver ? Without the 8250-specific 

static struct plat_serial8250_port uart0_data = {
        .mapbase = AR7_REGS_UART0,
        .irq = AR7_IRQ_UART0,
        .regshift = 2,
        .iotype = UPIO_MEM,
        .flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP,
};

        uart_port[0].type = PORT_16550A;
        uart_port[0].line = 0;
        uart_port[0].irq = AR7_IRQ_UART0;
        uart_port[0].uartclk = ar7_bus_freq() / 2;
        uart_port[0].iotype = UPIO_MEM;
        uart_port[0].mapbase = AR7_REGS_UART0 + 3;
        uart_port[0].membase = ioremap(uart_port[0].mapbase, 256);
        uart_port[0].regshift = 2;
        res = early_serial_setup(&uart_port[0]);
        if (res)
                return res;


the +3 comes from the fact, that this machine is configured to run big
endian.

Here is the boot log:

Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x8610e03 (irq = 15) is a 16550A
console handover: boot [early0] -> real [ttyS0]
serial8250: ttyS1 at MMIO 0x8610f00 (irq = 19) is a 16550A
loop: module loaded
Fixed MDIO Bus: probed


ttyS1 uses the wrong address, but there is nothing connected to
that port on the box.

Do you see the problem on TNETD7200 devices as well ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
