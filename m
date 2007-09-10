Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXIJClQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXIJClQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXIJClB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:41:01 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:65100 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXIJClA (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:41:00 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
To: Kay Sievers <kay.sievers@vrfy.org>, anssi.hannula@gmail.com,
       linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2007 06:40:57 +0400
References: <46E2D712.1010402@gmail.com> <3ae72650709091603o57c976d1q8a1b5492ef041186@mail.gmail.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070910024057.D7D91411ABE@smtp03.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:

> On 9/8/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
>> There seem to be changes in sysfs input structure between 2.6.22 and
>> 2.6.23-rc5 which cause some breakage.
>>
>> With 2.6.22:
>>
>> > # LC_ALL=C ls -l /sys/class/input/input4
>> > total 0
>> > drwxr-xr-x 2 root root    0 Sep  8 12:51 capabilities/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:48 device ->
>> > ../../../devices/platform/pcspkr/
>> > drwxr-xr-x 2 root root    0 Sep  8 12:51 event4/
>> > drwxr-xr-x 2 root root    0 Sep  8 12:51 id/
>> > -r--r--r-- 1 root root 4096 Sep  8 19:48 modalias
>> > -r--r--r-- 1 root root 4096 Sep  8 19:48 name
>> > -r--r--r-- 1 root root 4096 Sep  8 19:48 phys
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:48 subsystem ->
>> > ../../../class/input/
>> > --w------- 1 root root 4096 Sep  8 19:48 uevent
>> > -r--r--r-- 1 root root 4096 Sep  8 19:48 uniq
>>
>> > # ls -l /sys/class/input/event4
>> > lrwxrwxrwx 1 root root 0 Sep  8 19:48 /sys/class/input/event4 ->
>> > ../../class/input/input4/event4/
>> > # ls -l /sys/class/input/event4/
>> > total 0
>> > -r--r--r-- 1 root root 4096 Sep  8 19:58 dev
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:58 device ->
>> > ../../../../devices/platform/pcspkr/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:58 subsystem ->
>> > ../../../../class/input/
>> > --w------- 1 root root 4096 Sep  8 19:58 uevent
>>
>> With 2.6.23-rc5:
>>
>> > # ls -l /sys/class/input/input5
>> > total 0
>> > drwxr-xr-x 2 root root    0 Sep  8 19:47 capabilities/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 device ->
>> > ../../../devices/platform/pcspkr/
>> > drwxr-xr-x 2 root root    0 Sep  8 19:47 id/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:47 input:event5 ->
>> > ../../../class/input/event5/
>> > -r--r--r-- 1 root root 4096 Sep  8 19:03 modalias
>> > -r--r--r-- 1 root root 4096 Sep  8 19:03 name
>> > -r--r--r-- 1 root root 4096 Sep  8 19:47 phys
>> > drwxr-xr-x 2 root root    0 Sep  8 19:47 power/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem ->
>> > ../../../class/input/
>> > -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
>> > -r--r--r-- 1 root root 4096 Sep  8 19:47 uniq
>>
>> > # ls -l /sys/class/input/event5
>> > total 0
>> > -r--r--r-- 1 root root 4096 Sep  8 19:03 dev
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 device ->
>> > ../../../class/input/input5/
>> > drwxr-xr-x 2 root root    0 Sep  8 19:48 power/
>> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem ->
>> > ../../../class/input/
>> > -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
>>
>> There are a few changes.
>>
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
> 
> Udev's path_id script is too dumb to follow the "device" link of
> stacked class devices in the CONFIG_SYSFS_DEPRECATED=y layout. Does
> this change fix it for you?
>  
http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff_plain;h=b1ac36ff5e3756cefc79967a26280056da31bf6f
> 

This just delays the issue until we have 3 levels of indirection :)

