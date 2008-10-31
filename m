Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYJaRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYJaRjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYJaRj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:39:28 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:22347 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYJaRj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:39:27 -0400
Message-ID: <490B42CD.7040108@msgid.tls.msk.ru>
Date: Fri, 31 Oct 2008 20:39:25 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
In-Reply-To: <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, Oct 31, 2008 at 16:38, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> To make a long story short: is there a way to force kernel
>> to re-validate a replaced usb-connected hard drive (or a
>> flash) *automatically*?
[]
> Insert the media, and force a validation:
>   $ touch /dev/sdb

With a newly inserted flash (removed some irrelevant stuff):

DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8
DEVTYPE=partition SUBSYSTEM=block MINOR=17 ACTION=add MAJOR=8
DEVTYPE=scsi_device SUBSYSTEM=scsi DRIVER=sd SDEV_MEDIA_CHANGE=1 ACTION=change
DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8

> Access the device:
>   $ touch /dev/sdb
> 
> Nothing should happen, as the reader/kernel knows it is still valid.

Yes nothing happens.

> Now remove the media and insert it immediately again.
> 
> Access the device:
>   $ touch /dev/sdb
>   UEVENT[1225468868.803950] change
> /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host8/target8:0:0/8:0:0:0
> (scsi)

> and you see the reader told to kernel (scsi unit attention) to
> revalidate the device.

Ok. So in my case, nothing happens here just like
if it were not removed/inserted.

I replaced the card with another one, and nothing
happened as well.

Only when touch'ing after REMOVING the flash, I see:

DEVTYPE=scsi_device SUBSYSTEM=scsi DRIVER=sd SDEV_MEDIA_CHANGE=1 ACTION=change 
DEVTYPE=partition SUBSYSTEM=block MINOR=17 ACTION=remove MAJOR=8
DEVTYPE=disk SUBSYSTEM=block MINOR=16 ACTION=change MAJOR=8

> Every access to removable media is guarded by this revalidation check.
> If you don't see these events, you should not trust this reader, and
> at least never change the media while it is connected.

Ok.  So.. 3 questions.

1) how it worked before (i yet to find which kernel worked)?
   I can only guess that some older kernel never cached the
   "validity".

2) 'doze notices the insertions/removals just fine.  Again I
   can only guess that it constantly pools for changes.

3), and the most important one.  I think there should be a
   way to stop "caching" of the media information, i.e. to force
   revalidation events on EVERY access, for certain hardware at
   least.  Because corruption in such cases is much worse than
   any positive effects of caching etc... Maybe some unusual_devs.h
   way or somesuch?..

Now I see the device is somewhat(?) broken.  But as I said before
in another email, it's a great device (as in, two epochs connected
to each other), and it'd be sad to lose it.  A nostalgie, sort of.. ;)

Ok, maybe actually polling for devices sometimes makes sense... ;)
And there can be a workaround, using a tiny daemon that constantly
accesses the device, in order to catch removals...  'hwell.

/mjt
