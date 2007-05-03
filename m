Return-Path: <linux-kernel-owner+w=401wt.eu-S1031261AbXECMkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031261AbXECMkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031269AbXECMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:40:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5626 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031261AbXECMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=avn1anemQFNP5P1czCETacsbAADi55obcnXQgzp3GfVxAWH/RVkZKjxmJ+veGcz31NiBssRchHxwJrLuzWnegNp3IMgh3xShuXIj8gwNmIhPHPqm96UnPFb8WPRiG/ZKm5v87982SOL8qc1Y7eD3WfqxryGV/zeuHSnV1B9npe8=
Message-ID: <4639D821.9010308@gmail.com>
Date: Thu, 03 May 2007 14:40:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 1/1] Misc: add sensable phantom driver
References: <219403193181341921@karneval.cz> <20070502234956.cdfe31c2.akpm@linux-foundation.org>
In-Reply-To: <20070502234956.cdfe31c2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed,  2 May 2007 17:56:01 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> add sensable phantom driver
> 
> <googles>
> 
> Is that one of these? 
> http://www.est-kl.com/aufbau_general/index_hard_haptic.html?http://www.est-kl.com/hardware/haptic/sensable/phantom_omni.html

Omni is a small ieee1394 device. This is much bigger phantom premium pci
version:
http://www.sensable.com/haptic-phantom-premium-6dof.htm

> I don't think we've ever had a driver for a device like that before.  I
> wonder how you designed the userspace interface to it.

I used the userspace libs that worked on 2.4 linux and rewrote them a little
bit. However this is the old way, obsoleted I think, but it's still used in
our human-computer interaction lab.

The other one is through supported OpenHaptics suite, which was added in
this version -- that is the original Sensable (the device manufacturer)
product, but they provide 2.4 linux drivers only with it.

>> +static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
>> +	u_long arg)
> 
> Could we please use standard-looking types in this driver?  u32 and u64 and
> things?

Huh, wonders how this got there, thanks!

> However in this case, as it's an ioctl handler it should be "int" and
> "unsigned long".
> 
> Does this driver require compat handling?  (Seems not?)


>> +static int phantom_release(struct inode *inode, struct file *file)
>> +{
>> +	struct phantom_device *dev = file->private_data;
>> +
>> +	if (mutex_lock_interruptible(&dev->open_lock))
>> +		return -ERESTARTSYS;
>> +
>> +	dev->opened = 0;
>> +	phantom_status(dev, dev->status & ~PHB_RUNNING);
>> +
>> +	mutex_unlock(&dev->open_lock);
>> +
>> +	return 0;
>> +}
> 
> The mutex_lock_interruptible() is wrong, I think.  This function is called
> when we do the final close().  If the signal _is_ taken then it's game
> over: the device can no longer be opened.

Yes, starving at sys_close, I think so.

<fast searching in drivers/*>

Wouldn't this be a problem here too:
drivers/media/dvb/cinergyT2/cinergyT2.c
drivers/usb/misc/auerswald.c
at least that the device won't be stopped or something like that?

>> +/*
>> + * Init and deinit driver
>> + */
>> +
>> +static unsigned int __devinit phantom_get_free(void)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < PHANTOM_MAX_MINORS; i++)
>> +		if (phantom_devices[i] == 0)
>> +			break;
>> +
>> +	return i;
>> +}
> 
> This function assumes that the phantom_devices[] array will never have any
> holes in it.  But if phantom_remove() is called out-of-order, it _will_
> have holes.  Perhaps - I didn't look too hard.

I'm afraid I didn't get this. It goes through all phantom_devices and
returns first free index. If a hole is present it will return "i" which
corresponds to the hole, because phantom_devices[i] is 0. Note that it is
unsigned char array.


thanks for the clues,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
