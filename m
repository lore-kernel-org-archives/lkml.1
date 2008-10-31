Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYJaSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYJaSwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYJaSwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:52:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:44894 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYJaSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:52:05 -0400
Message-ID: <ac3eb2510810311149w5a0e7479xef5bb36a1b4869d0@mail.gmail.com>
Date: Fri, 31 Oct 2008 19:49:59 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
Cc: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <490B42CD.7040108@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490B2659.9010304@msgid.tls.msk.ru>
	 <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
	 <490B42CD.7040108@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 18:39, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Kay Sievers wrote:
>>
>> On Fri, Oct 31, 2008 at 16:38, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>>
>>> To make a long story short: is there a way to force kernel
>>> to re-validate a replaced usb-connected hard drive (or a
>>> flash) *automatically*?
>
>> Insert the media, and force a validation:
>>  $ touch /dev/sdb
>
> With a newly inserted flash (removed some irrelevant stuff):
>
> DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8
> DEVTYPE=partition SUBSYSTEM=block MINOR=17 ACTION=add MAJOR=8
> DEVTYPE=scsi_device SUBSYSTEM=scsi DRIVER=sd SDEV_MEDIA_CHANGE=1
> ACTION=change
> DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8
>
>> Access the device:
>>  $ touch /dev/sdb
>>
>> Nothing should happen, as the reader/kernel knows it is still valid.
>
> Yes nothing happens.
>
>> Now remove the media and insert it immediately again.
>>
>> Access the device:
>>  $ touch /dev/sdb
>>  UEVENT[1225468868.803950] change
>>
>> /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host8/target8:0:0/8:0:0:0
>> (scsi)
>
>> and you see the reader told to kernel (scsi unit attention) to
>> revalidate the device.
>
> Ok. So in my case, nothing happens here just like
> if it were not removed/inserted.
>
> I replaced the card with another one, and nothing
> happened as well.
>
> Only when touch'ing after REMOVING the flash, I see:
>
> DEVTYPE=scsi_device SUBSYSTEM=scsi DRIVER=sd SDEV_MEDIA_CHANGE=1
> ACTION=change DEVTYPE=partition SUBSYSTEM=block MINOR=17 ACTION=remove
> MAJOR=8
> DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8
>
>> Every access to removable media is guarded by this revalidation check.
>> If you don't see these events, you should not trust this reader, and
>> at least never change the media while it is connected.
>
> Ok.  So.. 3 questions.
>
> 1) how it worked before (i yet to find which kernel worked)?
>  I can only guess that some older kernel never cached the
>  "validity".

The kernel does not cache, it's the device itself that reports a media
change, and the kernel asks every removable device before it is
accessing it.

> 2) 'doze notices the insertions/removals just fine.  Again I
>  can only guess that it constantly pools for changes.

It polls the device every few secomds, just like HAL does on most
Linux desktop installations. But in your case, when the reader does
not report the change correctly, even that might go wrong, just like
without polling.

> 3), and the most important one.  I think there should be a
>  way to stop "caching" of the media information, i.e. to force
>  revalidation events on EVERY access, for certain hardware at
>  least.

That's how it already is. We just rely on the device to tell us. There
is no way to revalidate anything otherwise.

> Because corruption in such cases is much worse than
>  any positive effects of caching etc... Maybe some unusual_devs.h
>  way or somesuch?..

I can't think of a way to make that working, there is no cache in the
kernel, only a state in the device. You would need to checksum the
device to find out that it isn't the same media, even that might not
work, and it's definitely nothing you want to do.

You could trace with usbmon, or something and investigate the scsi
packets if the scsi unit attention really does not signify a media
change, which is what I expect.

> Now I see the device is somewhat(?) broken.  But as I said before
> in another email, it's a great device (as in, two epochs connected
> to each other), and it'd be sad to lose it.  A nostalgie, sort of.. ;)

If it works otherwise, use it, but I wouldn't change media while it is
connected.

> Ok, maybe actually polling for devices sometimes makes sense... ;)
> And there can be a workaround, using a tiny daemon that constantly
> accesses the device, in order to catch removals...  'hwell.

That would still not work with your device, if you change the media
during the polling interval, which is usually between 2 and 16
seconds. If the device does not report any change, like it seem in
your case, you can not do anything. Polling helps only to reflect the
current state of a device while it is not accessed, to get the state
of the device into the kernel. Like on a desktop, where you want to
auto-mount card reader/cdrom media on insertion.

Kay
