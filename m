Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAJU2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAJU2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZAJU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:28:26 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:37265 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbZAJU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:28:24 -0500
Message-ID: <496904E4.2000701@arcor.de>
Date: Sat, 10 Jan 2009 21:28:20 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de> <200901081802.43625.vlobanov@speakeasy.net> <496737E1.1090607@arcor.de> <200901091440.15888.vlobanov@speakeasy.net>
In-Reply-To: <200901091440.15888.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vadim Lobanov schrieb:
> On Friday 09 January 2009 03:41:21 Thomas Dahlmann wrote:
>   
>> Vadim Lobanov schrieb:
>>     
>>> Alas, the hardware doesn't work. When I try plugging in the other end of
>>> the USB cable, absolutely nothing happens. Not even an interrupt:
>>> /proc/interrupts for the amd5536udc line stays at zero. Any thoughts on
>>> possible ways to tackle this / what could be going wrong / etc?
>>>       
>
> Just realized that I forgot to mention that I do also have g_zero sitting on 
> top of amd5536udc, so there should at least be a dummy USB device to 
> enumerate.
>
>   
Right, g_zero should enumerate. It also provides data sink/source and 
loopback functionality.
If you want to test data traffic then g_file_storage would be a good 
choice as it behaves as a mass storage
device.

Example:
dd bs=1M count=64 if=/dev/zero of=/tmp/image_file
modrobe g_file_storage file=/tmp/image_file
(create partition and file system from host side)

>> Is there any output in the kernel messages on the host side complaining
>> about that device is
>> not answering? If not than USB device port is probably not connected to
>> UDC PHY. Please
>> check in BIOS setup that port 4 is assigned to UDC.
>>     
>
> Nope, nothing at all shows up in the logs or the interrupt counts when the 
> cable is plugged, neither for the host drivers nor the device drivers. (The 
> quickest test I have is to hook the device up to itself - one A port and one B 
> port.)
>
> The BIOS is configured "correctly" if the manuals are to be trusted. Here are 
> the relevant settings
> 	OHCI: Enabled
> 	EHCI: Enabled
> 	UDC: Enabled
> 	UOC: Disabled
> 	Overcurrent reporting: Disabled
> 	Port 4 assignment: Device
>   
UOC has to be enabled. This controller switches the UDC PHY to port 4 
and owns the mentioned
PAD_EN and APU bits. These bits live in the memory mapped register space 
of UOC. I use a
company intern tools to look at memory spaces of PCI devices. Lets 
forget these bits so far as I am
pretty sure that enabling UOC fixes the problem.

Thomas
