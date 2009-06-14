Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZFNLSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZFNLSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZFNLSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:18:43 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55529 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZFNLSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=XXsahmkAXcE0d5X0Lj3cXEDqLhWhz/eIIKJRdefNim9d3XSdcTv+sCHYpP2DiHjn47
         4W/RvQRSP0tf3DPjKLPHv39r4DzJ51cVxeZ1+TwcpgZlwFQXivofHaw5HnfDYqx5IqgU
         ccij8VK8F07hDiHjil8vupYjhDZYf5XbzRxqk=
From: Florian Fainelli <florian@openwrt.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Date: Sun, 14 Jun 2009 13:18:36 +0200
User-Agent: KMail/1.9.9
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
References: <200906041622.47591.florian@openwrt.org> <200906111028.41222.florian@openwrt.org> <20090611093022.GA14510@alpha.franken.de>
In-Reply-To: <20090611093022.GA14510@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906141318.38376.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 11 June 2009 11:30:22 Thomas Bogendoerfer, vous avez écrit :
> On Thu, Jun 11, 2009 at 10:28:39AM +0200, Florian Fainelli wrote:
> > Le Friday 05 June 2009 00:20:20 Thomas Bogendoerfer, vous avez écrit :
> > > On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> > > > We discussed that in private, there are a couple of things
> > > > to fix in order to get 8250 working properly with TI AR7 HW.
> > > > If you can still merge that bit, this would ease future work, thanks
> > > > !
> > >
> > > I still have a tree here, which works without any changes to the 8250
> > > serial driver on a TNETD7300 device.
> >
> > Could you show me how you register the 8250 driver ? Without the
> > 8250-specific
>
> static struct plat_serial8250_port uart0_data = {
>         .mapbase = AR7_REGS_UART0,
>         .irq = AR7_IRQ_UART0,
>         .regshift = 2,
>         .iotype = UPIO_MEM,
>         .flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP,
> };
>
>         uart_port[0].type = PORT_16550A;
>         uart_port[0].line = 0;
>         uart_port[0].irq = AR7_IRQ_UART0;
>         uart_port[0].uartclk = ar7_bus_freq() / 2;
>         uart_port[0].iotype = UPIO_MEM;
>         uart_port[0].mapbase = AR7_REGS_UART0 + 3;
>         uart_port[0].membase = ioremap(uart_port[0].mapbase, 256);
>         uart_port[0].regshift = 2;
>         res = early_serial_setup(&uart_port[0]);
>         if (res)
>                 return res;
>
>
> the +3 comes from the fact, that this machine is configured to run big
> endian.
>
> Here is the boot log:
>
> Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
> serial8250: ttyS0 at MMIO 0x8610e03 (irq = 15) is a 16550A
> console handover: boot [early0] -> real [ttyS0]
> serial8250: ttyS1 at MMIO 0x8610f00 (irq = 19) is a 16550A
> loop: module loaded
> Fixed MDIO Bus: probed
>
>
> ttyS1 uses the wrong address, but there is nothing connected to
> that port on the box.
>
> Do you see the problem on TNETD7200 devices as well ?

I no longer have TNETD7200 devices to test on unfortunately.

What I just found is that TNETD7300GDU revision 5 does not have this bug, 
while TNETD7300GDU revision 4 has. This seems to confirm the HW bug 
hypothesis. Let's just clean the serial console registration and we will keep 
in OpenWrt the 8250 workaround for older TNETD7300 revisions.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
