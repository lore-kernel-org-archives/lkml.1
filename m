Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbXGXQ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbXGXQ2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXGXQ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:28:34 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49792 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXGXQ2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:28:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=NpVvfAnHxrasyWZvIAPdl2O5tfFPXGo+KfeADrfD3FeTjJ7qZBGn1SGfwmwZCX/lap546tfvKh7Jllhj7mdkhOe0lKM/KX/dTqfNmKLbsjSc+XevovpLxGd0IMV0+roU;
Message-ID: <46A628AC.3060900@simon.arlott.org.uk>
Date: Tue, 24 Jul 2007 17:28:28 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was: sysfs/udev
 broken in latest git?)
References: <46A59EAA.9030105@simon.arlott.org.uk>	<20070724072540.GA835@suse.de>	<20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>	<20070724084654.GB13152@suse.de>	<3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com> <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/07 13:54, Cornelia Huck wrote:
> On Tue, 24 Jul 2007 11:20:02 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
>> It looks fine to me. "device" links must never point to anything else
>> than a bus device.
> 
> Hm, but then
> 1. The patch sneaks this check in (the old code only checked for
>    dev->parent)
> 2. The code is rather inconsistent now, since none of the other code
>    paths check for dev->parent->bus...

Removing the dev->parent->bus check fixes it:

[   40.043981] serio: i8042 KBD port at 0x60,0x64 irq 1
[   40.044653] mice: PS/2 mouse device common for all mice
[   40.044792] dev->parent && !dev->parent->bus:
[   40.044794]  dev->kobj->k_name=event0
[   40.044796]  dev->kobj->name=event0
[   40.044798]  dev->parent->kobj->k_name=input0
[   40.044800]  dev->parent->kobj->name=input0

[   40.044948] dev->parent && !dev->parent->bus:
[   40.044951]  dev->kobj->k_name=event1
[   40.044952]  dev->kobj->name=event1
[   40.044954]  dev->parent->kobj->k_name=input1
[   40.044956]  dev->parent->kobj->name=input1

[   40.045075] dev->parent && !dev->parent->bus:
[   40.045077]  dev->kobj->k_name=event2
[   40.045079]  dev->kobj->name=event2
[   40.045080]  dev->parent->kobj->k_name=input2
[   40.045082]  dev->parent->kobj->name=input2

[   40.067204] input: AT Translated Set 2 keyboard as /class/input/input3
[   40.067368] dev->parent && !dev->parent->bus:
[   40.067370]  dev->kobj->k_name=event3
[   40.067372]  dev->kobj->name=event3
[   40.067373]  dev->parent->kobj->k_name=input3
[   40.067375]  dev->parent->kobj->name=input3

[   40.067713] i2c /dev entries driver
[   40.068190] dev->parent && !dev->parent->bus:
[   40.068193]  dev->kobj->k_name=i2c-0
[   40.068195]  dev->kobj->name=i2c-0
[   40.068196]  dev->parent->kobj->k_name=i2c-0
[   40.068198]  dev->parent->kobj->name=i2c-0

[   40.068386] dev->parent && !dev->parent->bus:
[   40.068389]  dev->kobj->k_name=i2c-9191
[   40.068391]  dev->kobj->name=i2c-9191
[   40.068392]  dev->parent->kobj->k_name=platform
[   40.068394]  dev->parent->kobj->name=platform

[   40.068892] dev->parent && !dev->parent->bus:
[   40.068895]  dev->kobj->k_name=i2c-1
[   40.068896]  dev->kobj->name=i2c-1
[   40.068898]  dev->parent->kobj->k_name=i2c-1
[   40.068899]  dev->parent->kobj->name=i2c-1

[   40.085201] input: Logitech USB-PS/2 Optical Mouse as /class/input/input4
[   40.085362] dev->parent && !dev->parent->bus:
[   40.085365]  dev->kobj->k_name=mouse0
[   40.085367]  dev->kobj->name=mouse0
[   40.085368]  dev->parent->kobj->k_name=input4
[   40.085370]  dev->parent->kobj->name=input4

[   40.085528] dev->parent && !dev->parent->bus:
[   40.085530]  dev->kobj->k_name=event4
[   40.085532]  dev->kobj->name=event4
[   40.085534]  dev->parent->kobj->k_name=input4
[   40.085535]  dev->parent->kobj->name=input4

-- 
Simon Arlott
