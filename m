Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZANMoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZANMoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZANMoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:44:03 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:55803 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbZANMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:44:00 -0500
Message-ID: <496DDDFC.7030301@arcor.de>
Date: Wed, 14 Jan 2009 13:43:40 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de> <200901091440.15888.vlobanov@speakeasy.net> <496904E4.2000701@arcor.de> <200901131119.54994.vlobanov@speakeasy.net>
In-Reply-To: <200901131119.54994.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vadim Lobanov schrieb:
> On Saturday 10 January 2009 12:28:20 Thomas Dahlmann wrote:
>   
>> UOC has to be enabled. This controller switches the UDC PHY to port 4
>> and owns the mentioned
>> PAD_EN and APU bits. These bits live in the memory mapped register space
>> of UOC. I use a
>> company intern tools to look at memory spaces of PCI devices. Lets
>> forget these bits so far as I am
>> pretty sure that enabling UOC fixes the problem.
>>     
>
> I've managed to get at some values that look suspiciously like the UOC 
> register space, and they seem to be OK.
>
> Here is the full description of what I did, so that google can slurp this 
> information up for others to use in the future. First things first, the AMD 
> Geode CS5536 Companion Device Data Book is a necessary resource, and tells us 
> where the the UOC-related MSR lives, how big the UOC register space is, and 
> what all the bits mean.
>
> Armed with this data, we first grab the UOC MSR:
>
> [root@hurricane ~]# modprobe msr
> [root@hurricane ~]# rdmsr 0x5120000B
> aefa06000
>
> We note the UOC base address value, which, according to the data book, is in 
> bits 31:8 of the MSR. Using this information and a few more looks into the 
> data book, we get the following kernel code:
>
> #define UOC_REGISTERS_ADDR 0xEFA06000
> #define UOC_REGISTERS_SIZE 0x0100
>
> struct uoc_registers {
> 	u32 cap;
> 	u32 mux;
> 	u32 reserved;
> 	u32 ctl;
> } __attribute__((packed));
>
> static void observe_uoc_registers(void)
> {
> 	struct uoc_registers __iomem *uoc;
>
> 	if (!request_mem_region(UOC_REGISTERS_ADDR,
> 				UOC_REGISTERS_SIZE,
> 				"amd5536uoc")) {
> 		printk(KERN_INFO "amd5536uoc mem region already used\n");
> 		goto finish;
> 	}
> 	uoc = ioremap_nocache(UOC_REGISTERS_ADDR,
> 			      UOC_REGISTERS_SIZE);
> 	if (uoc == NULL) {
> 		printk(KERN_INFO "amd5536uoc io memory cannot be mapped\n");
> 		goto release;
> 	}
> 	printk(KERN_INFO "amd5536uoc cap=0x%08X\n", readl(&uoc->cap));
> 	printk(KERN_INFO "amd5536uoc mux=0x%08X\n", readl(&uoc->mux));
> 	printk(KERN_INFO "amd5536uoc ctl=0x%08X\n", readl(&uoc->ctl));
> 	iounmap(uoc);
> release:
> 	release_mem_region(UOC_REGISTERS_ADDR,
> 			   UOC_REGISTERS_SIZE);
> finish:
> 	printk(KERN_INFO "amd5536uoc observation finished\n");
> }
>
> Put a call to observe_uoc_registers() at the top of udc_pci_probe(), rebuild, 
> modprobe the amd5536udc driver, and observe the data. Namely, the values that 
> came back, as well as their interpreted meanings according to the data book, 
> are:
>
> cap=0x000083EA
> 	The host power control bits affect USB_PWR_EN1 for ports 1-3.
> 	The host power control bits affect USB_PWR_EN2 for port 4.
> 	Port power enabled with output of 1 on USB_PWR_EN1 and USB_PWR_EN2.
> 	No overcurrent reporting.
> 	Automatic pull-up (APU) is enabled.
>
> mux=0x00000003
> 	The muxed port is assigned to the device controller.
>
> ctl=0x00000083
> 	The muxed port is assigned to the device controller.
> 	The comparator circuitry for VBUS detection (PADEN) is enabled.
>
> The mystery deepens. :)
>
> -- Vadim Lobanov
>
>   
Beside reading the MSR register for UOC_REGISTERS_ADDR
it should be possible to use BAR0 of UOC PCI config
space (if UOC enabled in BIOS).

The UOC registers look good to me too except for bit VBUSVLD
(bit 8 in UOCMUX). This bit should get set when cable is
connected. Maybe VBUS pin is not connected. In this case the
internal pull up will not get connected. For testing the pull up can
be connected manually by clearing APU in UOCCAP and
setting PUEN in UOCMUX.

There is one remaining bit which could prevent the physical USB
connection. It is bit SD (soft disconnect) in UDC DEVCTL
register (bit 10). This bit has to be cleared. This is done by
usb_gadget_register_driver() in amd5536udc.c. This function is
called by gadget driver like g_zero when gagdet driver loads.
Maybe you want add a printk() there to check that the bit was
cleared. Furthermore it could help to enable DEBUG and
#define UDC_VERBOSE in amd5536udc.c to have a closer
look at what UDC driver is doing.

But if SD bit is cleared (and UOC bits seem OK as you showed)
then only hardware can be the root cause of the issue. If host
detects a USB connection it will automatically send a
GET_DESCRIPTOR message to UDC. You would see kernel
messages on host side, at least messages indicating that device
is not responding.

I found a Hurricane LX800 manual at

http://www.lippert-at.de/fileadmin/lippert-at/products/EPIC/Hurricane-LX800/TME-EPIC-HURLX-R1V4.pdf

saying that there is no type B device port and device port is port 3.
Do you have a different one?

Chapter 3.8, page 19:
4 standard USB 2.0 host ports are provided at the I/O panel
of the Hurricane LX800. . . Port 3 can be used as USB device
port. This feature must be enabled in BIOS
under Motherboard Device Configuration -> PCI Configuration.
UDC must be enabled; Port 3 assignment should be set to device.

Thomas




