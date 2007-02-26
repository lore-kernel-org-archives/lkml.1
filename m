Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXBZRDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXBZRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030338AbXBZRDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:03:09 -0500
Received: from email13.mywebmailserver.com ([199.231.136.143]:3819 "EHLO
	email13.mywebmailserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030332AbXBZRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:03:08 -0500
Message-ID: <45E312C1.5050802@kuchera.com>
Date: Mon, 26 Feb 2007 12:02:57 -0500
From: Rob Prowel <prowel@kuchera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070104 Red Hat/1.0.7-0.6.fc5 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Stuart MacDonald <stuartm@connecttech.com>
CC: linux-kernel@vger.kernel.org, rmk+lkml@arm.linux.org.uk
Subject: Re: questions about 8250 uart support for adhoc boards
References: <000001c75853$3e9599f0$294b82ce@stuartm>
In-Reply-To: <000001c75853$3e9599f0$294b82ce@stuartm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2007 17:02:57.0739 (UTC) FILETIME=[F6CDB9B0:01C759C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart MacDonald wrote:
>> I use the options below:
>>
>> CONFIG_SERIAL_8250=y
>> CONFIG_SERIAL_8250_CONSOLE=y
>> CONFIG_SERIAL_8250_PCI=y
>> CONFIG_SERIAL_8250_NR_UARTS=32
>>     
>
> This makes the internal table be 32 ports big. The first four ports
> end up configured for legacy/standard com ports, the rest are
> unconfigured. You should be able to see them as unknowns with
> setserial.
>
>   
I can see them as unknowns with setserial but cannot set any parameters 
for them until a subsequent driver is loaded, like (fourport).

> All _FOURPORT does is specifically config ports 4-7 in the table to
> have specific address/irqs for the FourPort board. What you do with
> setserial is then change that config info to match your board.
>
> You shouldn't need to do this, and I quickly reviewed 2.6.20.1 and it
> looks like you don't. 
>   
But I DO HAVE TO to make any configuration changes without getting 
(invalid parameter) errors from setserial.

>> Then I can only access ttyS0 through ttyS3 sith setserial.  
>> Only after I add
>> CONFIG_SERIAL_8250_FOURPORT=y am I actually able to do 
>> anything with the 
>> additional ports.  I would otherwise get the evil setserial: invalid 
>> parameter error.
>>     
>
> Very odd. You get this error when doing "setserial /dev/ttySxx", no
> configuration? If so, that would imply that the table wasn't made big
> enough, and the unconfigured ports haven't been registered with the
> serial core.
>
>   
I can read the ports as unknown/unconfigured.  I just cannot modify them 
until the fourport driver has been loaded.



> If you can't get your board working, we have similar boards that do.
>
>   
your website address didn't work when I tried it...


See below for a (script) dump of that demonstrates the behavior I 
describe.  Additional ports are not configurable until a driver such as 
fourport is loaded.  This is in 2.6.20.1 and 2.6.17 (those versions I 
have tested).

# for i in 0 1 2 3 4 5 6 7; do setserial /dev/ttyS$i; done
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS1, UART: 16550A, Port: 0x02f8, IRQ: 3
/dev/ttyS2, UART: unknown, Port: 0x03e8, IRQ: 4
/dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3
/dev/ttyS4, UART: unknown, Port: 0x0000, IRQ: 0
/dev/ttyS5, UART: unknown, Port: 0x0000, IRQ: 0
/dev/ttyS6, UART: unknown, Port: 0x0000, IRQ: 0
/dev/ttyS7, UART: unknown, Port: 0x0000, IRQ: 0

# cat /etc/rc.local
#! /bin/sh

SS=/bin/setserial
IRQ="irq 12"
AC="autoconfig ^fourport"

`$SS /dev/ttyS4 port 0x120 $IRQ $AC`
`$SS /dev/ttyS5 port 0x128 $IRQ $AC`
`$SS /dev/ttyS6 port 0x130 $IRQ $AC`
`$SS /dev/ttyS7 port 0x138 $IRQ $AC`

# sh /etc/rc.local
Cannot set serial info: Invalid argument
Cannot set serial info: Invalid argument
Cannot set serial info: Invalid argument
Cannot set serial info: Invalid argument

# modprobe 8250_fourport
# for i in 0 1 2 3 4 5 6 7; do setserial /dev/ttyS$i; done
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS1, UART: 16550A, Port: 0x02f8, IRQ: 3
/dev/ttyS2, UART: unknown, Port: 0x02b8, IRQ: 5, Flags: Fourport
/dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3
/dev/ttyS4, UART: 16850, Port: 0x0120, IRQ: 12
/dev/ttyS5, UART: 16850, Port: 0x0128, IRQ: 12
/dev/ttyS6, UART: 16850, Port: 0x0130, IRQ: 12
/dev/ttyS7, UART: 16850, Port: 0x0138, IRQ: 12

# grep 8250 .config
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=8
CONFIG_SERIAL_8250_RUNTIME_UARTS=8
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
# Non-8250 serial port support


