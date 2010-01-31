Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828Ab0AaD1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0AaD1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 22:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694Ab0AaD1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 22:27:47 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51592 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751632Ab0AaD1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 22:27:46 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn\, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<1264783166.29532.5302.camel@localhost.localdomain>
	<87iqakifm8.fsf@troilus.org>
	<1264860663.29532.7887.camel@localhost.localdomain>
Date: Sat, 30 Jan 2010 22:27:42 -0500
In-Reply-To: <1264860663.29532.7887.camel@localhost.localdomain> (Bastien
	Nocera's message of "Sat, 30 Jan 2010 14:11:03 +0000")
Message-ID: <87636jhs29.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien Nocera writes:

> On Fri, 2010-01-29 at 19:46 -0500, Michael Poole wrote:
>> > [1]: Comments on the patch at
>> > http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
>> > appreciated
>> 
>> This patch does not work for me.  Before, the first time after each
>> boot
>> that I tried to connect to an Apple Magic Mouse, it failed with -14
>> (EFAULT).  With this patch, it fails with -22 (EINVAL) instead.  The
>> -EFAULT *was* due to hidp_parse()'s copy_from_user().  I have not
>> looked
>> yet to see where the -EINVAL is coming from -- would that help?  (Both
>> with and without your patch, the second attempt to connect works.) 
>
> I don't get -EFAULT anymore (it was failing to copy the rd_data from
> user-space), but I do get -EINVALs now. I haven't investigated it
> though. My guess is that the hid parser fails.
>
> Could you compare the sizes of the data gathered in user-space?

It looks like something else is overwriting parts of the hidp_session
structure; I hope to find out what that is tomorrow.  Based on a
printk() in hidp_sock_ioctl(), user space consistently passes a 99-byte
HID report descriptor.  I added another printk() to hidp_parse() to
characterize things:
  printk("hidp_parse(%p): %u@%p\n", hid, req->rd_size, req->rd_data);

With your patch, the first time I connect to the mouse:
[  244.109619] hidp_parse(ffff880138f90000): 0@0000002800000000
[  244.109694] magicmouse 0005:05AC:030D.0001: magicmouse hid parse
  failed
[  244.109708] magicmouse: probe of 0005:05AC:030D.0001 failed with
  error -22

With your patch, the second time:
[  258.840542] hidp_parse(ffff880134e14000): 99@ffff88008fd8f880
[  258.841415] input: Apple Wireless Mouse as
  /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/bluetooth/hci0/hci0:12/input11

Without your patch, the first time:
[  157.569000] hidp_parse(ffff8801313cc000): 11859@ffffffff811397c0
[  157.569018] magicmouse 0005:05AC:030D.0001: magicmouse hid parse
  failed
[  157.569031] magicmouse: probe of 0005:05AC:030D.0001 failed with
  error -14

Without your patch, the second time:
[  178.983956] hidp_parse(ffff88012e660000): 99@00007f40d7d44880
[  178.984977] input: Apple Wireless Mouse as
  /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/bluetooth/hci0/hci0:12/input11

Michael Poole
