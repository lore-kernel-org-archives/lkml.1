Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXIHTia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXIHTia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXIHTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:38:22 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:37338 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156AbXIHTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:38:22 -0400
Message-ID: <46E2FA3F.7050000@gmail.com>
Date: Sat, 08 Sep 2007 22:38:39 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@insightbb.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-hotplug-devel@lists.sourceforge.net
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
References: <46E2D712.1010402@gmail.com> <20070908182928.5AEAA402B15@smtp03.mtu.ru>
In-Reply-To: <20070908182928.5AEAA402B15@smtp03.mtu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Anssi Hannula wrote:
> 
>> Hi!
>>
>> There seem to be changes in sysfs input structure between 2.6.22 and
>> 2.6.23-rc5 which cause some breakage.
>>
[...]
>> There is no longer:
>> /sys/class/input/eventX => /sys/class/input/inputX/eventX
>> instead there is:
>> /sys/class/inputX/input:eventX => /sys/class/input/eventX
>> Notice the added "input:". I don't know if any software depends on this,
>> though.
>>
>> However, the change that broke id_path of udev is that
>> /sys/class/input/event5/device is now a symlink to the inputX directory
>> instead of being the same as the device symlink in inputX directory,
>> i.e. to ../../../devices/platform/pcspkr in this case.
>>
>> Udev id_path uses that directory to construct the ID_PATH variable.
>> Should the sysfs structure be reverted or should udev be adapted to
>> handle traversing /device symlink twice? I think the former, as there
>> should be considerably more time to adapt udev for coming changes in
>> sysfs.
>>
> 
> I am using 2.6.23-rc5 in current cooker

Same kernel here, but on an older system (MDV2007.1). I tested with a 
path_id from a recent udev as well, though, but the problem was there as 
well.

> and I did not notice any breakage; 
> could you please show example of wrong path? E.g. I have
> 
> {pts/0}% LC_ALL=C ll /dev/input/by-path
> total 0
> lrwxrwxrwx 1 root root 9 Sep  2 15:00
> platform-i8042-serio-0-event-kbd -> ../event0
> lrwxrwxrwx 1 root root 9 Sep  2 15:00
> platform-i8042-serio-1-event-mouse -> ../event1
> lrwxrwxrwx 1 root root 9 Sep  2 15:00
> platform-i8042-serio-1-mouse -> ../mouse0
> 
> and it looks pretty sane for me.

I don't have anything under /dev/input/by-path as the lookup in path_id 
fails.

> Oh, and I do not have CONFIG_SYSFS_DEPRECATED which probably explains why it
> works for me :)

Probably.

> {pts/0}% LC_ALL=C ll /sys/class/input/input2/
> total 0
> drwxr-xr-x 2 root root    0 Sep  8 22:25 capabilities/
> drwxr-xr-x 3 root root    0 Sep  8 22:22 event2/
> drwxr-xr-x 2 root root    0 Sep  8 22:25 id/
> -r--r--r-- 1 root root 4096 Sep  8 22:25 modalias
> -r--r--r-- 1 root root 4096 Sep  8 22:25 name
> -r--r--r-- 1 root root 4096 Sep  8 22:25 phys
> drwxr-xr-x 2 root root    0 Sep  8 22:25 power/
> lrwxrwxrwx 1 root root    0 Sep  8 22:25
> subsystem -> ../../../../class/input/
> -rw-r--r-- 1 root root 4096 Sep  8 22:25 uevent
> -r--r--r-- 1 root root 4096 Sep  8 22:25 uniq

What does this print as devpath for you:
$ udevinfo -q all --name=input/event0

For me on 2.6.23rc5 it prints:
P: /class/input/event0
and on 2.6.22:
P: /class/input/input0/event0

Both are detected as "old sysfs layout" by path_id, but only on 2.6.22 
is there a /device symlink pointing to the expected location.

I suspect it prints something like /devices/xyz for you, right?
That seems to be detected as "new sysfs layout" by path_id and handled 
differently.

> this implies that SYSFS_DEPRECATED may be broken w.r.t. udev; OTOH it *is*
> deprecated, is not it?

Indeed, at least regarding input subsystem, for which there was a recent 
switchover [1] from class_device.

[1] 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9657d75c5f0f7d0a9cb507521d3ad1436aea28c9

-- 
Anssi Hannula
