Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZF3Dkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZF3Dkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZF3DkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:40:22 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58241 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZF3DkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=x0NK8782mvQr1w9QgLEXZ/+z53OSQ+IbG/vD0fLBsKSWa9qZaKzMOdRwgzUiCCdghF
         N3NRzvu9wahvlMxk04+RdsbRGTsPl8q41hzbJBp0DDGj8JXlbxUEMMxEGp3V/bGNlIva
         u+ZOEXDBSUQiPbyVMps0JyeYThPKm/Dd+bQWs=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Tue, 30 Jun 2009 05:40:18 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org, Dave Airlie <airlied@linux.ie>
References: <200906280821.58631.info@gnebu.es> <200906281622.10072.info@gnebu.es> <ac3eb2510906280728s1d80c417w64ce6985e9ed8f64@mail.gmail.com>
In-Reply-To: <ac3eb2510906280728s1d80c417w64ce6985e9ed8f64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300540.18916.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 16:28:44 Kay Sievers wrote:
> If there isn't something else running which acts on uevents that
> trigger drm events, which I wouldn't expect, it seems like a drm
> kernel problem.

Ok, thanks for looking at it. I'll sum up the problem for DRM people:

The problem started after upgrading to 2.6.30. At some point, udevd starts to 
use a lot of CPU time. It happens randomly, but it seems easier to trigger 
when running something graphics intensive (glxgears, gtkperf, tuxracer..).

Killing udevd and starting it with the --debug switch throws up this when the 
problem starts:

[22652] event_queue_insert: seq 168515 queued, 'change' 'drm'
[22657] udev_device_new_from_syspath: device 0x2040320 has devpath 
'/devices/pci0000:00/0000:00:02.0/drm/card0'
[22657] udev_device_read_db: device 0x2040320 filled with db symlink data 
'/dev/dri/card0'
[22657] udev_rules_apply_to_event: LINK 'char/226:0' /lib/udev/rules.d/50-
udev-default.rules:5
[22657] udev_rules_apply_to_event: NAME 'dri/card0' /lib/udev/rules.d/50-udev-
default.rules:38
[22657] udev_rules_apply_to_event: GROUP 91 /lib/udev/rules.d/50-udev-
default.rules:42
[22657] udev_device_new_from_syspath: device 0x2040790 has devpath 
'/devices/pci0000:00/0000:00:02.0'
[22657] udev_device_new_from_syspath: device 0x2040a80 has devpath 
'/devices/pci0000:00'
[22657] udev_rules_apply_to_event: RUN 
'socket:@/org/freedesktop/hal/udev_event' /etc/udev/rules.d/90-hal.rules:2
[22657] udev_device_update_db: create db link (dri/card0 char/226:0)
[22657] udev_node_add: creating device node '/dev/dri/card0', devnum=226:0, 
mode=0660, uid=0, gid=91
[22657] udev_node_mknod: preserve file '/dev/dri/card0', because it has correct 
dev_t
[22657] update_link: '/dev/char/226:0' with target '/dev/dri/card0' has the 
highest priority 0, create it
[22657] node_symlink: preserve already existing symlink '/dev/char/226:0' to 
'../dri/card0'
[22657] udev_monitor_send_device: passed 230 bytes to monitor 0x2040320
[22657] udev_monitor_send_device: passed -1 bytes to monitor 0x2036150
[22657] event_fork: seq 168515 exit with 0
[22652] event_fork: seq 168515 forked, pid [22657], 'change' 'drm', 0 seconds 
old
[22652] udev_done: seq 168515 cleanup, pid [22657], status 0, 0 seconds old

It goes on in an infinite loop.

Then using "udevadm monitor" I also get a loop of these two messages:

KERNEL[1246192153.094553] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.096463] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)

Killing udevd stops the UDEV messages (and CPU usage goes down), but the 
KERNEL messages continue.

My system is a Dell Studio desktop with Intel graphics (G45). I'm using a 
standard distro kernel (Arch LInux). The problem occurs both with EXA and with 
UXA+KMS, and in both 32 bit and 64 bit systems.

Thanks,
Alberto.

