Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZEVB2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZEVB2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZEVB2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:28:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41690 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbZEVB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <20090521231452.676d4898@lxorguk.ukuu.org.uk>
References: <20090521095217.GU8633@ZenIV.linux.org.uk>
	 <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
	 <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	 <20090521231452.676d4898@lxorguk.ukuu.org.uk>
Date: Thu, 21 May 2009 21:28:36 -0400
Message-ID: <f73f7ab80905211828te5c49dcx863a18c8e428a59f@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
From: Kyle Moffett <kyle@moffetthome.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 6:14 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Not sure, if we already discussed that with a conclusion: this
>> "prevent access to a future device" interface needs to work at the pid
>> level, or would a uid/gid check be sufficient?
>
> As I said before neither pid or uid make any sense at all for a kernel
> level check beyond what already exists at user space level (ie chown),
> and what the usual user space gunk provides for device creation policy
> (udev)
>
>> Root can do all that stuff anyway, even with the locking in place.
>> Uid/gid file permissions need to be applied to the "lock file", so
>> specified non-root users can use that interface.
>
> It's actually sometimes important that root can ignore the lock
> files - eg to send a reset to a channel of a jammed device that is owned
> by a user and wedged.
>
>> Maybe it would be good enough, to check that the one that opened the
>> "lock file" has the same uid/gid as the on that tries to open the
>> device when it has shown up?
>
> My feeling too - there simply isn't any need for kernel infrastructure
> here. The only case the kernel must be involved is when you need
> exclusivity including telling the kernel to leave things alone, and even
> that usually only needs to be by specific handle and we normally borrow
> O_EXCL for it as it has no "traditional" meaning on device nodes.
>
> We do tty devices with lock files no reason it won't work for USB stuff
> too.

Hrm, I think this is missing the point.  Here's a practical example for you:

My Debian laptop has a Windows VM (using KVM, specifically) on it for
the occasional times when work forces me to use such software.  One of
the things I need the Windows VM for is a USB JTAG debug box that (for
stupid Windows driver reasons) shows up as an HID device.  The debug
box needs firmware loaded on it as soon as it is attached or it tends
to crash or behave unreliably; the firmware loading software is also
Windows-only.  There are also other random USB devices like encrypted
flash drives with windows-only software, software license tokens, etc.

My ideal solution is to be able to prevent Linux from automatically
binding to any devices attached off specific USB ports.  There's
simply no point in letting the usb-storage or usb-hid modules try to
scan those devices because I'm just going to immediately "unbind" them
and drive them with libusb *anyways*.

Basically I want one of my USB ports (which I plug into an external
hub) to always go to my Windows KVM, and another USB port (also with a
hub) to always go to my Fedora KVM.  There are a couple requirements
for this:

(1)  I need to be able to exclude any access *BEFORE* a device is connected.
(2)  This exclusion needs to apply to kernel drivers

One possible alternative (although I don't know if this would work for
the OP), is to make there be a global "prevent kernel drivers from
autobinding to  devices on his port" flag, and manage the rest with
lockfiles in userspace.

Cheers,
Kyle Moffett
