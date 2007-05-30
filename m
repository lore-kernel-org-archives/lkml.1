Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbXE3T7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbXE3T7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXE3T7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:59:22 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:44928 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXE3T7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:59:21 -0400
Date: Wed, 30 May 2007 12:58:11 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
In-reply-to: <20070530115717.77e05153.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@suse.de>,
       David Gibson <david@gibson.dropbear.id.au>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <465DD753.5040208@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200705291844.00308.yinghai.lu@sun.com>
 <20070530115717.77e05153.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 29 May 2007 18:43:59 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> [PATCH 4/5] serial: convert early_uart to earlycon for 8250
>>
>> Beacuse SERIAL_PORT_DFNS is removed from include/asm-i386/serial.h and
>> include/asm-x86_64/serial.h. the serial8250_ports need to be probed late
>> in serial initializing stage. the console_init=>serial8250_console_init=>
>> register_console=>serial8250_console_setup will return -ENDEV, and console
>> ttyS0 can not be enabled at that time.
>> need to wait till uart_add_one_port in drivers/serial/serial_core.c to call
>> register_console to get console ttyS0. that is too late.
>>
>> Make early_uart to use early_param, so uart console can be used earlier.
>> Make it to be bootconsole with CON_BOOT flag, so can use console handover
>> feature. and it will switch to corresponding normal serial console
>> automatically.
>>
>> new command line will be:
>> 	console=uart8250,io,0x3f8,9600n8
>> 	console=uart8250,mmio,0xff5e0000,115200n8
>> or
>> 	earlycon=uart8250,io,0x3f8,9600n8
>> 	earlycon=uart8250,mmio,0xff5e0000,115200n8
>>
>> it will print in very early stage:
>> 	Early serial console at I/O port 0x3f8 (options '9600n8')
>> 	console [uart0] enabled
>> later for console it will print:
>> 	console handover: boot [uart0] -> real [ttyS0]
>>
>>
>>  Documentation/kernel-parameters.txt |   11 +++
>>  arch/ia64/kernel/setup.c            |    4 -
>>  drivers/serial/8250.c               |   28 ++-------
>>  drivers/serial/8250_early.c         |  104 ++++++++++++++----------------------
>>  drivers/serial/Kconfig              |   10 +++
>>  include/asm-i386/fixmap.h           |    2 
>>  include/asm-i386/io.h               |   13 ++++
>>  include/asm-ia64/io.h               |    4 +
>>  include/asm-x86_64/fixmap.h         |    4 +
>>  include/asm-x86_64/io.h             |   13 ++++
>>  include/linux/console.h             |    2 
>>  include/linux/serial.h              |    6 --
>>  include/linux/serial_8250.h         |    3 +
>>  init/main.c                         |    5 +
>>  kernel/printk.c                     |   22 +++++++
>>  15 files changed, 133 insertions(+), 98 deletions(-)
> 
> This is a lot of tricky stuff in areas which I'm not very familar with. 
> Need help, am not getting it.
> 
>> @@ -143,12 +140,7 @@ static int __init parse_options(struct early_uart_device *device, char *options)
>>  	if (!strncmp(options, "mmio,", 5)) {
>>  		port->iotype = UPIO_MEM;
>>  		port->mapbase = simple_strtoul(options + 5, &options, 0);
>> -		port->membase = ioremap(port->mapbase, mapsize);
>> -		if (!port->membase) {
>> -			printk(KERN_ERR "%s: Couldn't ioremap 0x%lx\n",
>> -				__FUNCTION__, port->mapbase);
>> -			return -ENOMEM;
>> -		}
>> +		port->membase = fix_ioremap(FIX_EARLYCON_MEM_BASE, port->mapbase);
> 
> A number of useful-looking warnigns such as the above got removed.  How come?
earycon, when you can not get fix_ioremap work, you can not get anything from boot.
> 
>>  		mmio = 1;
>>  	} else if (!strncmp(options, "io,", 3)) {
>>  		port->iotype = UPIO_PORT;
>> @@ -175,9 +167,16 @@ static int __init parse_options(struct early_uart_device *device, char *options)
>>  	return 0;
>>  }
>>  
>> -static int __init early_uart_setup(struct console *console, char *options)
>> +static struct console early_serial8250_console __initdata = {
>> +	.name	= "uart",
>> +	.write	= early_serial8250_write,
>> +	.flags	= CON_PRINTBUFFER,
> 
> Should this have CON_BOOT set as well?
> 
> See
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch,
> which is now in mainline.
> 

I put that into setup_early_serial8250_console.

-int __init early_serial_console_init(char *cmdline)
+static int __init setup_early_serial8250_console(char *cmdline)
  {
         char *options;
         int err;

-       options = strstr(cmdline, "console=uart,");
+       options = strstr(cmdline, "uart8250,");
         if (!options)
-               return -ENODEV;
+               return 0;

         options = strchr(cmdline, ',') + 1;
-       if ((err = early_uart_setup(NULL, options)) < 0)
+       if ((err = early_serial8250_setup(options)) < 0)
                 return err;
-       return early_uart_console_init();
+
+       early_serial8250_console.flags |= CON_BOOT;
+       register_console(&early_serial8250_console);
+
+       return 0;
  }

we may use
 >> +	.flags	= CON_PRINTBUFFER | CAN_BOOT;

instead that line.


>> +	.index	= -1,
>> +};
>> +
>> +static int __init early_serial8250_setup(char *options)
>>  {
>> -	struct early_uart_device *device = &early_device;
>> +	struct early_serial8250_device *device = &early_device;
>>  	int err;
>>  
>>  	if (device->port.membase || device->port.iobase)
>> @@ -190,61 +189,40 @@ static int __init early_uart_setup(struct console *console, char *options)
>>  	return 0;
>>  }
>>  
>> -static struct console early_uart_console __initdata = {
>> -	.name	= "uart",
>> -	.write	= early_uart_write,
>> -	.setup	= early_uart_setup,
>> -	.flags	= CON_PRINTBUFFER,
>> -	.index	= -1,
>> -};
> 
> hm, that didn't have CON_BOOT.
> 
>> +static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
> 
> I don't suppose it'd help much if I were to complain about the coding style
> (no space after the * or after the function name, please).
> 
>> +{
>> +	void __iomem * vaddr;
>> +	set_fixmap_nocache(idx, phys & PAGE_MASK);
>> +	vaddr = (void __iomem *)__fix_to_virt(idx);
>> +	vaddr += phys & ~PAGE_MASK;
>> +
>> +	return vaddr;
>> +}
> 
> Probably this was a bit too large for inlining.

current only one calling, later will use that for usb debug cable.

> 
>>  /* Use early IO mappings for DMI because it's initialized early */
>>  #define dmi_ioremap bt_ioremap
>>  #define dmi_iounmap bt_iounmap
>> diff --git a/include/asm-ia64/io.h b/include/asm-ia64/io.h
>> index eb17a86..e29eaf8 100644
>> --- a/include/asm-ia64/io.h
>> +++ b/include/asm-ia64/io.h
>> @@ -423,6 +423,10 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
>>  extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
>>  extern void iounmap (volatile void __iomem *addr);
>>  
>> +/* for console=uart8250,mmio,0xffe5000,9600n8 */
>> +#define FIX_EARLYCON_MEM_BASE 1
>> +#define fix_ioremap(idx, phys) ioremap(phys, 64)
>> +
>>  /* Use normal IO mappings for DMI */
>>  #define dmi_ioremap ioremap
>>  #define dmi_iounmap(x,l) iounmap(x)
> 
> So we touch ia64 as well?
> 
>>  
>> +int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
>> +{
>> +	struct console_cmdline *c;
>> +	int i;
>> +
>> +	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
>> +		if (strcmp(console_cmdline[i].name, name) == 0 &&
>> +			  console_cmdline[i].index == idx) {
>> +				c = &console_cmdline[i];
>> +				memcpy(c->name, name_new, sizeof(c->name));
>> +				c->name[sizeof(c->name) - 1] = 0;
>> +				c->options = options;
>> +				c->index = idx_new;
>> +				return i;
>> +		}
>> +	/* not found */
>> +	return -1;
>> +}
> 
> Shouldn't this be __init?
> 
> serial8250_find_port_for_earlycon() had its __init removed.  Why?
with __init, the compiler will cry about .init.text and .text missection.

YH
