Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZBDBKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZBDBKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZBDBKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:10:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:19626 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZBDBKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mx9UWK1HExgl2Akd0gRF7ed2/Om0ZWrhdjwcd1gPzCNmxlaiGoo+BQjCpKurxhrSnB
         AXvPnEyyEwC3js9IrLTVQhgpKXkfWWAqp4wnJlpl7EI3U4F2Fm6cSSMu6LeaPPk7Nnpg
         agOVqxp6/JHDxFRC4UvaglcvntZh3cqPs3Mlo=
MIME-Version: 1.0
In-Reply-To: <20090203235814.GA22380@kroah.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com>
	 <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
	 <20090203235814.GA22380@kroah.com>
Date: Wed, 4 Feb 2009 09:10:20 +0800
Message-ID: <a8e1da0902031710u2ebd69b0r4de5916fab2d3cba@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove wgreathouse@smva.com in cc-list because this mail will be
rejected by the smva.com email server.

On Wed, Feb 4, 2009 at 7:58 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Feb 02, 2009 at 09:43:04AM +0800, Dave Young wrote:
>> On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
>> > On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
>> >>
>> >> In case with "nousb" booting, serial drivers will trigger kernel oops.
>> >
>> > They will?  What is the oops message?
>>
>> Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
>> will manage to copy the oops message later.
>>
>> >
>> >> Here add usb_disabled() check in usb_serial_init and usb_serial_register
>> >
>> > This is odd, is it something new?  Why is usb-serial the only driver
>> > that needs such a thing?
>>
>> No, it is not new thing.  usb serial drivers normally call
>> usb_serial_register first, then usb_register, usb_register will fail
>> due to "nousb" checking, but usb_serial_register no.
>
> But as usb_register will fail, shouldn't they properly back out and no
> oopses happen?  This sounds like a simple fix to the drivers that are
> failing here, not changing the usb-serial core.

Hi greg

I think all usb serial drivers which call usb_serial_register will
oops, so IMHO usb core should be fixed.

I think maybe you missed my another reply, copy the content here again.

---
hand copy part of the oops message:

BUG: unable to handle kernel NULL pointer dereference at 00000001
IP: [<c0527636>] kset_find_obj+0x3b/0x5c
*pde = 00000000
Oops: 0000 [#1] SMP

[snip...]

EIP is at kset_find_obj+0x3b/0x5c
EAX:00000001

[snip...]

Call Trace:
driver_register
destruct_tty_driver
usb_serial_bus_register
usb_serial_register
aircable_init
_stext
aircable_init
restore_nocheck_notrace
pci_arch_init

[snip...]

Actually, after the usb_serial_init failed, the usb_serial_bus_type
will be unregistered.

So when  serial dirvers call usb_serial_register (then
usb_serial_bus_register, and then driver_register),  due to the bus
kset already unregistered kernel will oops.
---

>
> And this should only be an issue if you build your drivers into the
> kernel, right?

Yes.

>
> thanks,
>
> greg k-h
>



-- 
Regards
dave
