Return-Path: <linux-kernel-owner+w=401wt.eu-S1946017AbXBWRSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946017AbXBWRSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946018AbXBWRSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:18:11 -0500
Received: from email13.mywebmailserver.com ([199.231.136.143]:1640 "EHLO
	email13.mywebmailserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946017AbXBWRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:18:10 -0500
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 12:18:10 EST
Message-ID: <45DF1EEC.4040602@kuchera.com>
Date: Fri, 23 Feb 2007 12:05:48 -0500
From: Rob Prowel <prowel@kuchera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070104 Red Hat/1.0.7-0.6.fc5 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: questions about 8250 uart support for adhoc boards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2007 17:05:52.0472 (UTC) FILETIME=[DFB69D80:01C7576C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a PC104 embedded system and am trying to make a Diamond 
Emerald-mm-opto four port serial board work in a recent kernel version 
(>=2.6.17).  The vendor only validates the board against 2.6.11: a 
kernel nearly two years old and several serial kernel config parameters 
have changed in that time period.

the board uses two 16c2850 uarts and has four ports.  It supports 
interrupt sharing through an ISR bitmask.

since the recent 2.6.x kernels now break down the non-standard uart 
support into specific hardware groups I cannot figure out how to get the 
blasted thing to register/recognize with setserial.  the MULTIPORT 
option no longer exists in the kernel code so I had to explicitly 
compile in "fourport" support just so ttyS4 through ttyS7 would be 
accessible...and yes, you can assume that I've increased the available 
ports using 8250.nr_uarts=16

At least now, with fourport compiled into the kernel, I can use 
setserial to see the uarts and correctly identify them...but the shared 
interrupt vector doesn't seem to work.  I haven't even attempted yet to 
try stty or echoing data our to an o-scope.

Here is the setserial dialog

# for i in 0 1 2 3 4 5 6 7; do setserial /dev/ttyS$i; 
done                          
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS1, UART: 16550A, Port: 0x02f8, IRQ: 3
/dev/ttyS2, UART: unknown, Port: 0x03e8, IRQ: 4
/dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3
/dev/ttyS4, UART: unknown, Port: 0x01a0, IRQ: 2, Flags: Fourport
/dev/ttyS5, UART: unknown, Port: 0x01a8, IRQ: 2, Flags: Fourport
/dev/ttyS6, UART: unknown, Port: 0x01b0, IRQ: 2, Flags: Fourport
/dev/ttyS7, UART: unknown, Port: 0x01b8, IRQ: 2, Flags: Fourport

# sh /root/setserial
+ SS=/bin/setserial
++ /bin/setserial /dev/ttyS4 port 0x120 irq 12 autoconfig '^fourport'
++ /bin/setserial /dev/ttyS5 port 0x128 irq 12 autoconfig '^fourport'
++ /bin/setserial /dev/ttyS6 port 0x130 irq 12 autoconfig '^fourport'
++ /bin/setserial /dev/ttyS7 port 0x138 irq 12 autoconfig '^fourport'
++ /bin/setserial /dev/ttyS4 set_multiport port1 0x244 mask1 0x0f match1 0
Cannot get multiport config: Invalid argument

# for i in 0 1 2 3 4 5 6 7; do setserial /dev/ttyS$i; done             
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS1, UART: 16550A, Port: 0x02f8, IRQ: 3
/dev/ttyS2, UART: unknown, Port: 0x03e8, IRQ: 4
/dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3
/dev/ttyS4, UART: 16850, Port: 0x0120, IRQ: 12
/dev/ttyS5, UART: 16850, Port: 0x0128, IRQ: 12
/dev/ttyS6, UART: 16850, Port: 0x0130, IRQ: 12
/dev/ttyS7, UART: 16850, Port: 0x0138, IRQ: 12
-bash-3.1#

and the isadump shows that the ports are visible

# # dump uart registers
# isadump -f -y 0x120 32
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00: 00 10 01 00 00 60 00 00 00 10 01 00 00 60 00 00
10: 00 10 01 00 00 60 00 00 00 10 01 00 00 60 00 80

# # dump ISR at 0x244
# isadump -f -y 0x240 16
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00: ff ff ff ff 00 ff ff ff ff ff ff ff ff ff ff ff
-bash-3.1#



I would so much appreciate if someone intimately familiar with the 
serial drivers could enlighten me as to what is going on here.

I'm not registered on the kernel list so CC to my email address would be 
appreciated.


Thanks,
Rob Prowel
Kuchera Defense Systems



