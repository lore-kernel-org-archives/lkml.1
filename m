Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbXCOKxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbXCOKxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXCOKxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:53:50 -0400
Received: from main.gmane.org ([80.91.229.2]:37541 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbXCOKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:53:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: Re: rsdl 30 on 2.6.20.2 breaks user space usb
Date: Thu, 15 Mar 2007 11:53:00 +0100
Message-ID: <etb8ie$kk3$1@sea.gmane.org>
References: <200703151054.29591.aj@leogic.com> <87mz2e7qib.fsf@depni.sinp.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ciphirelabs.net
User-Agent: KNode/0.10.4
Cc: linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Belyshev wrote:

> Andreas Jellinghaus <aj@leogic.com> writes:
> 
>> with plain 2.6.20.2 I get events / called from udev for /proc/bus/usb
>> devices. with rsdl 0.30 added to the kernel I no longer get called for
>> those devices (but I do get called for the new /dev/usbdev devices -
>> except that I can't use them).
>>
>> any idea why and what to do? might be related to a race condition.
> 
> sounds like http://bugzilla.kernel.org/show_bug.cgi?id=8166#c32

further debugging shows at least udev->openct is missing an event:
udev events on 2.6.20.2 (without rsdl):
( "$ACTION - $DEVICE - $DEVNAME - $PRODUCT - $$ - $PPID")
add - /proc/bus/usb/002/016 -  - 8e6/3438/100 - 6071 - 6065
add -  - /dev/usbdev2.16_ep02 -  - 6116 - 6113
add -  - /dev/usbdev2.16_ep82 -  - 6118 - 6114
add -  - /dev/usbdev2.16_ep81 -  - 6120 - 6115

udev events on 2.6.20.2 (with rsdl): 
( "$ACTION - $DEVICE - $DEVNAME - $PRODUCT - $$ - $PPID")
add -  - /dev/usbdev2.8_ep02 -  - 5287 - 5286
add -  - /dev/usbdev2.8_ep82 -  - 5290 - 5288
add -  - /dev/usbdev2.8_ep81 -  - 5291 - 5289

the /proc event is missing. in both cases /proc/ was mounted.

syslog with udev on debugging (only the /proc event from the kernel w/o
rsdl):

Mar 15 11:19:06 localhost udevd[2622]: udev_event_run: seq 2869 forked, pid
[6065], 'add' 'usb', 0 seconds old
Mar 15 11:19:06 localhost udevd-event[6065]: wait_for_sysfs:
file '/sys/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.5/2-1.5:1.0/bus'
appeared after 0 loops
Mar 15 11:19:06 localhost udevd-event[6065]:
run_program: '/lib/udev/openct_usb'
Mar 15 11:19:07 localhost udevd-event[6065]:
run_program: '/lib/udev/openct_usb' returned with status 0
Mar 15 11:19:07 localhost udevd-event[6065]: pass_env_to_socket: passed 338
bytes to socket '/org/freedesktop/hal/udev_event', 
Mar 15 11:19:07 localhost udevd-event[6065]: run_program: '/sbin/modprobe -Q
usb:v08E6p3438d0100dc00dsc00dp00ic0Bisc00ip00'
Mar 15 11:19:07 localhost udevd-event[6065]: run_program: '/sbin/modprobe'
returned with status 1
Mar 15 11:19:07 localhost udevd-event[6065]: pass_env_to_socket: passed -1
bytes to socket '/org/kernel/udev/monitor', 
Mar 15 11:19:07 localhost udevd-event[6065]: udev_event_run: seq 2869
finished
Mar 15 11:19:07 localhost udevd[2622]: udev_done: seq 2869, pid [6065] exit
with 1, 1 seconds old

there is something similar in syslog (on the rsdl kernel):
Mar 15 11:24:32 localhost udevd[2607]: udev_event_run: seq 2717 forked, pid
[5284], 'add' 'usb', 0 seconds old
Mar 15 11:24:32 localhost udevd-event[5284]: wait_for_sysfs:
file '/sys/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.5/2-1.5:1.0/bus'
appeared after 0 loops
Mar 15 11:24:32 localhost udevd-event[5284]: pass_env_to_socket: passed 338
bytes to socket '/org/freedesktop/hal/udev_event', 
Mar 15 11:24:32 localhost udevd-event[5284]: run_program: '/sbin/modprobe -Q
usb:v08E6p3438d0100dc00dsc00dp00ic0Bisc00ip00'
Mar 15 11:24:32 localhost udevd-event[5284]: run_program: '/sbin/modprobe'
returned with status 1
Mar 15 11:24:32 localhost udevd-event[5284]: pass_env_to_socket: passed -1
bytes to socket '/org/kernel/udev/monitor', 
Mar 15 11:24:32 localhost udevd-event[5284]: udev_event_run: seq 2717
finished
Mar 15 11:24:32 localhost udevd[2607]: udev_done: seq 2717, pid [5284] exit
with 1, 0 seconds old

so I guess it might be a udev bug, as it wait_for_sysfs in both cases,
but doesn't trigger openct if the kernel has rsdl. as the hardware is the
same and the openct rules for udev didn't change.

Thanks, I'm taking the issue to the hotplug mailing list.

Regards, Andreas

