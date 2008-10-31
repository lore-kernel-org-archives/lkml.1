Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYJaQKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYJaQKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYJaQK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:10:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:49604 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYJaQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:10:28 -0400
Message-ID: <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
Date: Fri, 31 Oct 2008 17:10:26 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
Cc: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <490B2659.9010304@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490B2659.9010304@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 16:38, Michael Tokarev <mjt@tls.msk.ru> wrote:
> To make a long story short: is there a way to force kernel
> to re-validate a replaced usb-connected hard drive (or a
> flash) *automatically*?
>
> Because right now, the kernel does not see that the drive
> has been replaced, and uses *some* old cached values, which
> results in random data corruption here and there, and other
> similar odd things.
>
> For example, I've an USB flash reader (Carry Computer Eng.,
> Co., Ltd 6-in-1 Card Reader, but that's not really relevant).
> Among other things it has a compact flash slot.  And I've
> 2 differently-size CF cards.
>
> So I turn the machine on, insert one CF card, mount it, do
> something with its vfat filesystem, umount it and remove
> it.  Next I insert another card, and when trying to mount
> it, the kernel says:
>
> FAT: invalid media value (0x1e)
> VFS: Can't find a valid FAT filesystem on dev sdb1.
>
> When trying to run cfdisk for example, it complains that
> "partition 0 ends after end of the drive" (or something
> similar).
>
> Sometimes the mount succeeds, but there are all sorts of
> errors here in there, the filesystem is messed up, whith
> parts of the files "from" just-removed card, and parts
> from the new card.
>
> And sure enough, when I, forgetting the issue, trying
> to WRITE something to the card, it becomes almost 100%
> messy...
>
> What helps is to run, for example,
>
>  blockdev --rereadpt /dev/sdb
>
> manually, after replacing the card.
>
> The first thing I was thinking of when saw the whole mess
> is: there must be some process like hald/udev/whatever
> messy subsystem du jur, which holds the device node open
> and prevents the kernel from re-reading the drive by its
> own as it correctly did in the past.  Nope, I've shut down
> everything, and the same happens when only shell process
> running INSTEAD of init (booting with init=/bin/sh option).
>
> So at some point the kernel stopped noticing the drive
> change in this configuration some time ago.  I can't say
> when exactly, since I didn't use the card reader for over
> a year, and certainly didn't try it with more than one
> card in a row for even longer time.   It worked in the
> past, that's for sure.  And it definitely does not work
> (resulting in the above mess) with 2.6.25, 2.6.26 and 2.6.27.

Maybe your card reader is broken. I can not reproduce this with any of
the many readers I have. Usually a media change results in media
revalidation with the next access to the device. You can easily
reproduce that:

Insert the media, and force a validation:
  $ touch /dev/sdb

Start logging of the kernel uevents to the console:
  $ udevadm monitor --kernel &

Access the device:
  $ touch /dev/sdb

Nothing should happen, as the reader/kernel knows it is still valid.

Now remove the media and insert it immediately again.

Access the device:
  $ touch /dev/sdb
  UEVENT[1225468868.803950] change
/devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host8/target8:0:0/8:0:0:0
(scsi)

and you see the reader told to kernel (scsi unit attention) to
revalidate the device.

These events happen only when the device is accessed. That's why
distros poll removable devices for media changes.

Every access to removable media is guarded by this revalidation check.
If you don't see these events, you should not trust this reader, and
at least never change the media while it is connected.

Kay
