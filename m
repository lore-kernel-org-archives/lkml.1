Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbZABHsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbZABHsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZABHs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:48:27 -0500
Received: from rtr.ca ([76.10.145.34]:48307 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZABHs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:48:26 -0500
Message-ID: <495DC6C8.7070501@rtr.ca>
Date: Fri, 02 Jan 2009 02:48:24 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de>
In-Reply-To: <20090102072436.GA3444@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
>> Mark Lord wrote:
>>> I'm trying to use 2.6.28 for the first time on an x86_64 box here
>>> with devices controlled by libusb.  The devices work on the first
>>> access, but then fail on all subsequent accesses.  Unplugging/replugging
>>> causes them to work again for a single subsequent access.
>>> This is with two completely different USB gadgets:
>>> a VFD alphanumeric display, and an FTDI serial device in bitbang mode.
>>> Did something break in 2.6.28 for libusb devices ??
>> ..
>>
>> Mmm.. broken only for 64-bit userspace, it seems.
>>
>> I've recompiled the same app against 32-bit libs,
>> and it works just fine on that 64-bit system,
>> as well as on 32-bit systems.
>>
>> But not when compiled for pure 64-bit operation on a 64-bit system.
>>
>> Looks tricky .. must be a change somewhere that assumes
>> a pointer/long is 32-bits or something.
> 
> Which version of libusb, a new one was just released a few weeks ago
> that fixes a lot of problems reported in the older libusb versions, and
> made things much faster to boot.  You might want to check it out.
..

I might look at that someday, but in the meanwhile we have broken
userspace in 2.6.28, and that needs to be sorted out first.

I'm still poking around, but haven't spotted anything obvious
from working kernel 2.6.27.xx to failing kernel 2.6.28.

One minor nit did show up, though.  The patch below
seems to make more sense than the code does without it.

Signed-off-by: Mark Lord <mlord@pobox.com>


--- old/drivers/usb/core/devio.c	2008-12-24 18:26:37.000000000 -0500
+++ linux/drivers/usb/core/devio.c	2009-01-02 02:44:57.000000000 -0500
@@ -1318,7 +1318,7 @@
 	if (__get_user(uptr, &uurb->buffer))
 		return -EFAULT;
 	kurb->buffer = compat_ptr(uptr);
-	if (__get_user(uptr, &uurb->buffer))
+	if (__get_user(uptr, &uurb->usercontext))
 		return -EFAULT;
 	kurb->usercontext = compat_ptr(uptr);
 
