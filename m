Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXIHSiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXIHSiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXIHSiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:38:00 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64988 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbXIHSh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:37:59 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2007 14:37:58 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
To: Anssi Hannula <anssi.hannula@gmail.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@insightbb.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-hotplug-devel@lists.sourceforge.net
Date: Sat, 08 Sep 2007 22:29:27 +0400
References: <46E2D712.1010402@gmail.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070908182928.5AEAA402B15@smtp03.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anssi Hannula wrote:

> Hi!
> 
> There seem to be changes in sysfs input structure between 2.6.22 and
> 2.6.23-rc5 which cause some breakage.
> 

I'm running 2.6.23-rc5 in up-to-date cooker.

> With 2.6.22:
> 
>> # LC_ALL=C ls -l /sys/class/input/input4
>> total 0
>> drwxr-xr-x 2 root root    0 Sep  8 12:51 capabilities/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:48 device ->
>> ../../../devices/platform/pcspkr/
>> drwxr-xr-x 2 root root    0 Sep  8 12:51 event4/
>> drwxr-xr-x 2 root root    0 Sep  8 12:51 id/
>> -r--r--r-- 1 root root 4096 Sep  8 19:48 modalias
>> -r--r--r-- 1 root root 4096 Sep  8 19:48 name
>> -r--r--r-- 1 root root 4096 Sep  8 19:48 phys
>> lrwxrwxrwx 1 root root    0 Sep  8 19:48 subsystem ->
>> ../../../class/input/
>> --w------- 1 root root 4096 Sep  8 19:48 uevent
>> -r--r--r-- 1 root root 4096 Sep  8 19:48 uniq
> 
>> # ls -l /sys/class/input/event4
>> lrwxrwxrwx 1 root root 0 Sep  8 19:48 /sys/class/input/event4 ->
>> ../../class/input/input4/event4/
>> # ls -l /sys/class/input/event4/
>> total 0
>> -r--r--r-- 1 root root 4096 Sep  8 19:58 dev
>> lrwxrwxrwx 1 root root    0 Sep  8 19:58 device ->
>> ../../../../devices/platform/pcspkr/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:58 subsystem ->
>> ../../../../class/input/
>> --w------- 1 root root 4096 Sep  8 19:58 uevent
> 
> With 2.6.23-rc5:
> 
>> # ls -l /sys/class/input/input5
>> total 0
>> drwxr-xr-x 2 root root    0 Sep  8 19:47 capabilities/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:03 device ->
>> ../../../devices/platform/pcspkr/
>> drwxr-xr-x 2 root root    0 Sep  8 19:47 id/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:47 input:event5 ->
>> ../../../class/input/event5/

I do not have this

>> -r--r--r-- 1 root root 4096 Sep  8 19:03 modalias
>> -r--r--r-- 1 root root 4096 Sep  8 19:03 name
>> -r--r--r-- 1 root root 4096 Sep  8 19:47 phys
>> drwxr-xr-x 2 root root    0 Sep  8 19:47 power/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem ->
>> ../../../class/input/
>> -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
>> -r--r--r-- 1 root root 4096 Sep  8 19:47 uniq
> 
>> # ls -l /sys/class/input/event5
>> total 0
>> -r--r--r-- 1 root root 4096 Sep  8 19:03 dev
>> lrwxrwxrwx 1 root root    0 Sep  8 19:03 device ->
>> ../../../class/input/input5/
>> drwxr-xr-x 2 root root    0 Sep  8 19:48 power/
>> lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem ->
>> ../../../class/input/
>> -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
> 
> There are a few changes.
> 
> There is no longer:
> /sys/class/input/eventX => /sys/class/input/inputX/eventX
> instead there is:
> /sys/class/inputX/input:eventX => /sys/class/input/eventX
> Notice the added "input:". I don't know if any software depends on this,
> though.
> 
> However, the change that broke id_path of udev is that
> /sys/class/input/event5/device is now a symlink to the inputX directory
> instead of being the same as the device symlink in inputX directory,
> i.e. to ../../../devices/platform/pcspkr in this case.
> 
> Udev id_path uses that directory to construct the ID_PATH variable.
> Should the sysfs structure be reverted or should udev be adapted to
> handle traversing /device symlink twice? I think the former, as there
> should be considerably more time to adapt udev for coming changes in
> sysfs.
> 

I am using 2.6.23-rc5 in current cooker and I did not notice any breakage; 
could you please show example of wrong path? E.g. I have

{pts/0}% LC_ALL=C ll /dev/input/by-path
total 0
lrwxrwxrwx 1 root root 9 Sep  2 15:00
platform-i8042-serio-0-event-kbd -> ../event0
lrwxrwxrwx 1 root root 9 Sep  2 15:00
platform-i8042-serio-1-event-mouse -> ../event1
lrwxrwxrwx 1 root root 9 Sep  2 15:00
platform-i8042-serio-1-mouse -> ../mouse0

and it looks pretty sane for me.

Oh, and I do not have CONFIG_SYSFS_DEPRECATED which probably explains why it
works for me :)

{pts/0}% LC_ALL=C ll /sys/class/input/input2/
total 0
drwxr-xr-x 2 root root    0 Sep  8 22:25 capabilities/
drwxr-xr-x 3 root root    0 Sep  8 22:22 event2/
drwxr-xr-x 2 root root    0 Sep  8 22:25 id/
-r--r--r-- 1 root root 4096 Sep  8 22:25 modalias
-r--r--r-- 1 root root 4096 Sep  8 22:25 name
-r--r--r-- 1 root root 4096 Sep  8 22:25 phys
drwxr-xr-x 2 root root    0 Sep  8 22:25 power/
lrwxrwxrwx 1 root root    0 Sep  8 22:25
subsystem -> ../../../../class/input/
-rw-r--r-- 1 root root 4096 Sep  8 22:25 uevent
-r--r--r-- 1 root root 4096 Sep  8 22:25 uniq

this implies that SYSFS_DEPRECATED may be broken w.r.t. udev; OTOH it *is*
deprecated, is not it?

-andrey

