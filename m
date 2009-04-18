Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZDRUBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZDRUBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZDRUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:00:51 -0400
Received: from mail-bw0-f160.google.com ([209.85.218.160]:39860 "EHLO
	mail-bw0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZDRUAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20090418192314.GA22107@suse.de>
References: <20090416172803.GB16618@elte.hu> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> 
	<20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> 
	<20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> 
	<49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> 
	<49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 18 Apr 2009 22:00:33 +0200
Message-ID: <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com>
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
To: Greg KH <gregkh@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 21:23, Greg KH <gregkh@suse.de> wrote:
> On Sat, Apr 18, 2009 at 12:19:21PM -0700, Yinghai Lu wrote:
>> Linus Torvalds wrote:

>> > Can we not make the rule be that the name should just be set before?

I guess, that's what they do already, otherwise they could not use dev_name().

>> pci_bus_add_device will call device_add.
>>
>> actually in device_add
>>
>>         /* first, register with generic layer. */
>>         error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
>>         if (error)
>>                 goto Error;
>>
>> will get one new name for that kobj, old name is freed.
>>
>> Will try to make kobject_add more smart to reuse the old one.
>
> I don't understand the problem here, how are you going to change the
> kobject core?  Is this just because you aren't getting a name for the
> resource?  If so, why would the driver core care about this?

Seems a bit odd what we do when registering a device.

Usually one sets the name with dev_set_name() which will name the
kobject. When one later registers the device, we reallocate the same
name, so the pointer changes. I guess the problem here is that the pci
code remembers the name pointer after it was set, but it will not be
the same after the device is live.

We should probably make device_add() pass a NULL as the name, and
kobject_add() in that case use the name that is properly set already.

Thanks,
Kay
