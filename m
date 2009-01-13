Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZAMTUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZAMTUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZAMTT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:19:57 -0500
Received: from mail.impinj.com ([206.169.229.170]:46138 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbZAMTT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:19:56 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Tue, 13 Jan 2009 11:19:54 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <200901091440.15888.vlobanov@speakeasy.net> <496904E4.2000701@arcor.de>
In-Reply-To: <496904E4.2000701@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131119.54994.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 13 Jan 2009 19:19:55.0172 (UTC) FILETIME=[EA90BE40:01C975B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009 12:28:20 Thomas Dahlmann wrote:
> UOC has to be enabled. This controller switches the UDC PHY to port 4
> and owns the mentioned
> PAD_EN and APU bits. These bits live in the memory mapped register space
> of UOC. I use a
> company intern tools to look at memory spaces of PCI devices. Lets
> forget these bits so far as I am
> pretty sure that enabling UOC fixes the problem.

I've managed to get at some values that look suspiciously like the UOC 
register space, and they seem to be OK.

Here is the full description of what I did, so that google can slurp this 
information up for others to use in the future. First things first, the AMD 
Geode CS5536 Companion Device Data Book is a necessary resource, and tells us 
where the the UOC-related MSR lives, how big the UOC register space is, and 
what all the bits mean.

Armed with this data, we first grab the UOC MSR:

[root@hurricane ~]# modprobe msr
[root@hurricane ~]# rdmsr 0x5120000B
aefa06000

We note the UOC base address value, which, according to the data book, is in 
bits 31:8 of the MSR. Using this information and a few more looks into the 
data book, we get the following kernel code:

#define UOC_REGISTERS_ADDR 0xEFA06000
#define UOC_REGISTERS_SIZE 0x0100

struct uoc_registers {
	u32 cap;
	u32 mux;
	u32 reserved;
	u32 ctl;
} __attribute__((packed));

static void observe_uoc_registers(void)
{
	struct uoc_registers __iomem *uoc;

	if (!request_mem_region(UOC_REGISTERS_ADDR,
				UOC_REGISTERS_SIZE,
				"amd5536uoc")) {
		printk(KERN_INFO "amd5536uoc mem region already used\n");
		goto finish;
	}
	uoc = ioremap_nocache(UOC_REGISTERS_ADDR,
			      UOC_REGISTERS_SIZE);
	if (uoc == NULL) {
		printk(KERN_INFO "amd5536uoc io memory cannot be mapped\n");
		goto release;
	}
	printk(KERN_INFO "amd5536uoc cap=0x%08X\n", readl(&uoc->cap));
	printk(KERN_INFO "amd5536uoc mux=0x%08X\n", readl(&uoc->mux));
	printk(KERN_INFO "amd5536uoc ctl=0x%08X\n", readl(&uoc->ctl));
	iounmap(uoc);
release:
	release_mem_region(UOC_REGISTERS_ADDR,
			   UOC_REGISTERS_SIZE);
finish:
	printk(KERN_INFO "amd5536uoc observation finished\n");
}

Put a call to observe_uoc_registers() at the top of udc_pci_probe(), rebuild, 
modprobe the amd5536udc driver, and observe the data. Namely, the values that 
came back, as well as their interpreted meanings according to the data book, 
are:

cap=0x000083EA
	The host power control bits affect USB_PWR_EN1 for ports 1-3.
	The host power control bits affect USB_PWR_EN2 for port 4.
	Port power enabled with output of 1 on USB_PWR_EN1 and USB_PWR_EN2.
	No overcurrent reporting.
	Automatic pull-up (APU) is enabled.

mux=0x00000003
	The muxed port is assigned to the device controller.

ctl=0x00000083
	The muxed port is assigned to the device controller.
	The comparator circuitry for VBUS detection (PADEN) is enabled.

The mystery deepens. :)

-- Vadim Lobanov

