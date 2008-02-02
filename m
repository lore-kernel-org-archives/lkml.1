Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYBBLHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYBBLHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYBBLH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:07:29 -0500
Received: from vana.vc.cvut.cz ([147.32.240.58]:48968 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbYBBLH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:07:28 -0500
X-Greylist: delayed 882 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 06:07:27 EST
Date: Sat, 2 Feb 2008 12:07:19 +0100
From: Petr Vandrovec <petr@vandrovec.name>
To: linux-kernel@vger.kernel.org
Cc: linux-hotplug-devel@lists.sourceforge.net
Subject: udevd induced deadlock in loading kernel modules?
Message-ID: <20080202110719.GB14581@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  today my system hung during boot, while loading ftdi_sio & loop - I have two ftdi serial ports,
and apparently this tricked udevd to start two concurrent modprobes for them - so I ended up with
strance "ftdi_sio: gave up waiting for init of module usbserial." for each symbol it tried to
import, until I kill-9 process 3137 (see below).  After that loop got loaded, and second ftdi's
load finished as well.

Unfortunately I do not have stacktraces of hung modprobe processes.  Maybe next time, but it
does not look very reproducible.

Kernel is current git (2.6.24, ed50d6cbc394cd0966469d3e249353c9dd1d38b9), udev is Debian's 0.114-2,
and module-init-tools are Debian's 3.3-pre11-4.  Kernel is 64bit amd64 with almost all debugging
enabled, userspace is 32bit.
							Thanks,
								Petr Vandrovec

usbcore: registered new interface driver usbserial
/usr/src/git/libata-pv/drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
/usr/src/git/libata-pv/drivers/usb/serial/usb-serial.c: USB Serial Driver core
ftdi_sio: gave up waiting for init of module usbserial.
ftdi_sio: Unknown symbol usb_serial_port_softint
ftdi_sio: gave up waiting for init of module usbserial.
ftdi_sio: Unknown symbol usb_serial_disconnect
ftdi_sio: gave up waiting for init of module usbserial.
ftdi_sio: Unknown symbol usb_serial_probe
ftdi_sio: gave up waiting for init of module usbserial.
ftdi_sio: Unknown symbol usb_serial_register
ftdi_sio: gave up waiting for init of module usbserial.
ftdi_sio: Unknown symbol usb_serial_deregister
loop: module loaded
/usr/src/git/libata-pv/drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
ftdi_sio 4-2:1.0: FTDI USB Serial Device converter detected
/usr/src/git/libata-pv/drivers/usb/serial/ftdi_sio.c: Detected FT8U232AM
usb 4-2: FTDI USB Serial Device converter now attached to ttyUSB0
ftdi_sio 5-1:1.0: FTDI USB Serial Device converter detected
/usr/src/git/libata-pv/drivers/usb/serial/ftdi_sio.c: Detected FT8U232AM
usb 5-1: FTDI USB Serial Device converter now attached to ttyUSB1
usbcore: registered new interface driver ftdi_sio
/usr/src/git/libata-pv/drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
fuse init (API version 7.9)

 1042 tty1     Ss+    0:00 init boot
 1045 tty1     S+     0:00  \_ /bin/sh /etc/init.d/rc S
 3954 tty1     S+     0:00      \_ /bin/sh -e /etc/rcS.d/S20module-init-tools start
 3957 tty1     S+     0:00          \_ /bin/sh -e /etc/rcS.d/S20module-init-tools start
 3958 tty1     D+     0:00              \_ modprobe loop
 1048 tty1     S+     0:00 /bin/bash -i -m
 4074 tty1     R+     0:00  \_ ps axf
 1136 ?        S<s    0:01 udevd --daemon
 3096 ?        S<     0:00  \_ udevd --daemon
 3137 ?        S<     0:00  |   \_ /sbin/modprobe --use-blacklist usb:v0403p6001d0200dc00dsc00dp00icFFiscFFipFF
 3101 ?        S<     0:00  \_ udevd --daemon
 3138 ?        D<     0:00      \_ /sbin/modprobe --use-blacklist usb:v0403p6001d0200dc00dsc00dp00icFFiscFFipFF
 2612 ?        S<     0:00 /bin/sh -e /lib/udev/net.agent
 4069 ?        S<     0:00  \_ sleep 1
 2939 ?        S<     0:00 /bin/sh -e /lib/udev/net.agent
 4073 ?        S<     0:00  \_ sleep 1
