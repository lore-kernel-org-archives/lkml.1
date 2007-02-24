Return-Path: <linux-kernel-owner+w=401wt.eu-S933555AbXBXUhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbXBXUhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 15:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbXBXUhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 15:37:52 -0500
Received: from inetc.connecttech.com ([64.7.140.42]:4296 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555AbXBXUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 15:37:51 -0500
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Rob Prowel'" <prowel@kuchera.com>, <linux-kernel@vger.kernel.org>,
       <rmk+lkml@arm.linux.org.uk>
Subject: RE: questions about 8250 uart support for adhoc boards
Date: Sat, 24 Feb 2007 15:34:54 -0500
Organization: Connect Tech Inc.
Message-ID: <000001c75853$3e9599f0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
Importance: Normal
In-Reply-To: <45DF531B.5090505@kuchera.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: On Behalf Of Rob Prowel
> Russell King wrote:
> > You don't even need to do that.  Just configure SERIAL_8250_NR_UARTS
> > and SERIAL_8250_RUNTIME_UARTS appropriately for your 
> system.  There's
> > absolutely no need to build any of the additional modules.
> >   
> Unfortunately what I'm seeing in 2.6.20.1 seems to differ 
> from this.  If 

PC104 is really an ISA bus. The ISA ports are stored in a table in the
8250 driver (instead of allocated dynamically like PCI ports); the
config option _NR_UARTS just tells the driver how large to make the
table.

> I use the options below:
> 
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=32

This makes the internal table be 32 ports big. The first four ports
end up configured for legacy/standard com ports, the rest are
unconfigured. You should be able to see them as unknowns with
setserial.

> CONFIG_SERIAL_8250_RUNTIME_UARTS=16
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_FOURPORT is not set

All _FOURPORT does is specifically config ports 4-7 in the table to
have specific address/irqs for the FourPort board. What you do with
setserial is then change that config info to match your board.

You shouldn't need to do this, and I quickly reviewed 2.6.20.1 and it
looks like you don't. As long as _NR_UARTS is big enough, thus making
the internal table big enough, you should be able to configure, with
setserial, any of the ports in the table, including the first four.

> Then I can only access ttyS0 through ttyS3 sith setserial.  
> Only after I add
> CONFIG_SERIAL_8250_FOURPORT=y am I actually able to do 
> anything with the 
> additional ports.  I would otherwise get the evil setserial: invalid 
> parameter error.

Very odd. You get this error when doing "setserial /dev/ttySxx", no
configuration? If so, that would imply that the table wasn't made big
enough, and the unconfigured ports haven't been registered with the
serial core.

> OK.  Fair enough.  My question then becomes, how does the driver deal 
> with this now? scan all applicable uarts when any relevant 
> interrupt is 
> detected (as identified in setserial)?

With our boards, the multiport is just a status register; it shows
which port has produced the interrupt, so the driver doesn't have to
loop through all the ports on the board looking for the correct one.
It doesn't actually enable/disable the sharing of the interrupt. The
setting of "irq 12" on multiple ports (from your original post) is
what enables the sharing, from the driver-side view. Maybe your
hardware is unusual and requires this ISR port to be set properly to
enable sharing; more likely is that the board itself has one or more
jumpers to set which interrupt it's using, and that's what enables the
sharing from the hardware-side view.

If I get some time tomorrow, I'll set up 2.6.20.1 and see what the
current options are doing.

If you can't get your board working, we have similar boards that do.

..Stu

-- 
We make multiport serial products.
http://www.connecttech.com/
(800) 426-8979

