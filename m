Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYJaCJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYJaCJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYJaCJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:09:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58584 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYJaCJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:09:29 -0400
Date: Fri, 31 Oct 2008 03:09:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Helge Deller <deller@gmx.de>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 2.6.28-rc2: USB/INPUT: slab error in cache_alloc_debugcheck_after():
 double free?
In-Reply-To: <200810310011.08618.deller@gmx.de>
Message-ID: <alpine.LRH.1.10.0810310305000.7585@twin.jikos.cz>
References: <200810310011.08618.deller@gmx.de>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Helge Deller wrote:

> After sucessful bootup (without any USB devices attached)
> I get this when I insert a USB keyboard:
> ---------------
> usb 1-1: new low speed USB device using ohci_hcd and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> input: SILITEK USB Keyboard and Mouse as /class/input/input0
> Slab corruption: size-4096 start=8dd9b000, len=4096
> 000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> generic-usb 0004:047B:0002.0001: input,hidraw0: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:00:0e.2-1/input0

Looks like something goes wrong somewhere around hid_connect() -- 
hidinput_connect() is called, then slab complains about corruption, and 
then the rest of the code in hid_connect() is executed, priting the 
'generic-usb ...' message.

I can't reproduce it here myself with CONFIG_DEBUG_SLAB=y. Could you 
please send me your config?

It is also quite strange that stacktrace is missing here for some 
reason.

> On 2.6.28-rc1 I saw e.g. this:
> --------------------
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> usb 1-1: new low speed USB device using ohci_hcd and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> input: Logitech N48 as /class/input/input0
> generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID v1.00 Mouse 
> [Logitech N48] on usb-0000:00:0e.2-1/inpu0
> usb 1-1: New USB device found, idVendor=046d, idProduct=c001
> usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-1: Product: N48
> usb 1-1: Manufacturer: Logitech
> usb 1-2: new low speed USB device using ohci_hcd and address 3
> usb 1-2: configuration #1 chosen from 1 choice
> slab error in cache_alloc_debugcheck_after(): cache `size-512': double free, or memory outside object was oven
> Backtrace:
>    [<101a5724>] cache_alloc_debugcheck_after+0xd8/0x200
>    [<101a5cac>] kmem_cache_alloc+0x1a0/0x1e8
>    [<1042e294>] hid_register_report+0x60/0xc4
>    [<1042e5f8>] hid_add_field+0x40/0x1a4
>    [<1042ec40>] hid_parser_main+0x94/0xc4

This looks rather incomplete, backtrace starting at hid_parser_main is 
odd.

Also, this seems to happen for different slab cache than the previous 
corrutpion.

-- 
Jiri Kosina
SUSE Labs

