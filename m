Return-Path: <linux-kernel-owner+w=401wt.eu-S936911AbXGQVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911AbXGQVEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXGQVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:03:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52310
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763632AbXGQVDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:03:35 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Documentation for sysfs, hotplug, and firmware loading.
Date: Tue, 17 Jul 2007 17:03:31 -0400
User-Agent: KMail/1.9.6
Cc: "Greg KH" <greg@kroah.com>, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, Rod Whitby <rod@whitby.id.au>,
       Russell King <rmk@arm.linux.org.uk>, khc@pm.waw.pl, david@lang.hm
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_j6SnGZq4lIYQRnZ"
Message-Id: <200707171703.31340.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_j6SnGZq4lIYQRnZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here's some sysfs/hotplug/firmware loading documentation I wrote.  I finally 
tracked down the netlink bits to finish it up, so I can send it out to the 
world.

What's wrong with it? :)

Note, I still need to actually confirm that /sbin/hotplug can be called from 
initramfs by a statically linked device to load firmware before init gets 
spawned.  It should work, and was explicitly discussed as a design goal a 
year or two back, but it might need a bugfix patch to actually, you know, 
_work_.

(P.S.  I'd cc Kay Sievers on this, but he's still spam-blocking my email.  
Thanks to Kay for answer lots of questions about this at OLS, and to Fank 
Sorenson who wrote a netlink implementation of mdev back in 2005 that I dug 
up to figure out how that part works.)
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_j6SnGZq4lIYQRnZ
Content-Type: text/plain;
  charset="utf-8";
  name="sysfs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sysfs.txt"

hotplug and firmware loading with sysfs.
========================================

The 2.6.x Linux kernels export a device tree through sysfs, which is a
synthetic filesystem generally mounted at "/sys".  Among other things,
this filesystem tells userspace what hardware is available, so userspace tools
(such as udev or mdev) can dynamically populate a "/dev" directory with device
nodes representing the currently available hardware.

Notification when hardware is inserted or removed is provided by the
hotplug mechanism.  Linux provides two hotplug interfaces: /sbin/hotplug and
netlink.

The combination of sysfs and hotplug obsoleted the older "devfs", which was
removed from the 2.6.16 kernel.

Device nodes:
=============

Sysfs exports major and minor numbers for device nodes with which to populate
/dev via mknod(2).  These major and minor numbers are found in files named
"dev", which contain two colon separated ascii decimal numbers followed by
exactly one newline.  I.E.

  $ cat /sys/class/mem/zero/dev
  1:5

Note that the name of the directory containing a dev entry is usually the
traditional name for the device node.  (The above entry is for "/dev/zero".)

Entires for block devices are found at the following locations:

  /sys/block/*/dev
  /sys/block/*/*/dev

Entries for char devices are found at the following locations:

  /sys/bus/*/devices/*/dev
  /sys/class/*/*/dev

A very simple bash script to populate /dev from /sys (without addressing
ownership or permissions of the resulting /dev nodes) might look like:

  #!/bin/bash

  # Populate block devices

  for i in /sys/block/*/dev /sys/block/*/*/dev
  do
    if [ -f $i ]
    then
      MAJOR=$(sed 's/:.*//' < $i)
      MINOR=$(sed 's/.*://' < $i)
      DEVNAME=$(echo $i | sed -e 's@/dev@@' -e 's@.*/@@')
      mknod /dev/$DEVNAME b $MAJOR $MINOR
    fi
  done

  # Populate char devices

  for i in /sys/bus/*/devices/*/dev /sys/class/*/*/dev
  do
    if [ -f $i ]
    then
      MAJOR=$(sed 's/:.*//' < $i)
      MINOR=$(sed 's/.*://' < $i)
      DEVNAME=$(echo $i | sed -e 's@/dev@@' -e 's@.*/@@')
      mknod /dev/$DEVNAME c $MAJOR $MINOR
    fi
  done

Hotplug:
========

The hotplug mechanism asynchronously notifies userspace when hardware is
inserted, removed, or undergoes a similar significant state change.  Linux
provides two interfaces to hotplug; the kernel can spawn a usermode helper
process, or it can send a message to an existing daemon listening to a netlink
socket.

-- Usermode helper

The usermode helper hotplug mechanism spawns a new process to handle each
hotplug event.  Each such helper process belongs to the root user (UID 0) and
is a child of the init task (PID 1).  The kernel spawns one process per hotplug
event, supplying environment variables to each new process describing that
particular hotplug event.  By default the kernel spawns instances of
"/sbin/hotplug", but this default can be changed by writing a new path into
"/proc/sys/kernel/hotplug" (assuming /proc is mounted).

A simple bash script to record variables from hotplug events might look like:

  #!/bin/bash

  env >> /filename

It's possible to disable the usermode helper hotplug mechanism (by writing an
empty string into /proc/sys/kernel/hotplug), but there's little reason to
do this since a usermode helper won't be spawned if /sbin/hotplug doesn't
exist, and negative dentries will record the fact it doesn't exist after
the first lookup attempt.

-- Netlink

A daemon listening to the netlink socket receives a packet of data for each
hotplug event, containing the same information a usermode helper would receive
in environment variables.

The netlink packet contains a set of null terminated text lines.
Each line but the first contains a KEYWORD=VALUE pair defining a hotplug
event variable.  The first line of the netlink packet combines the $ACTION
and $DEVPATH values, separated by an @ (at sign).

Here's a C program to print hotplug nelink events to stdout:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/poll.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <linux/types.h>
#include <linux/netlink.h>

void die(char *s)
{
	write(2,s,strlen(s));
	exit(1);
}

int main(int argc, char *argv[])
{
	struct sockaddr_nl nls;
	struct pollfd pfd;
	char buf[512];

	// Open hotplug event netlink socket

	memset(&nls,0,sizeof(struct sockaddr_nl));
	nls.nl_family = AF_NETLINK;
	nls.nl_pid = getpid();
	nls.nl_groups = -1;

	pfd.events = POLLIN;
	pfd.fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
	if (pfd.fd==-1)
		die("Not root\n");

	// Listen to netlink socket

	if (bind(pfd.fd, (void *)&nls, sizeof(struct sockaddr_nl)))
		die("Bind failed\n");
	while (-1!=poll(&pfd, 1, -1)) {
		int i, len = recv(pfd.fd, buf, sizeof(buf), MSG_DONTWAIT);
		if (len == -1) //die("recv\n");

		// Print the data to stdout.
		i = 0;
		while (i<len) {
			printf("%s\n", buf+i);
			i += strlen(buf+i)+1;
		}
	}
	die("poll\n");

	// Dear gcc: shut up.
	return 0;
}

Hotplug event variables:
========================

Every hotplug event should provide at least the following variables:

  ACTION
    The current hotplug action: "add" to add the device...
    [QUESTION: Full list of actions?]

  DEVPATH
    Path under /sys at which this device's sysfs directory can be found.
    If $DEVPATH begins with /block/ the event refers to a block device,
    otherwise it refers to a char device.

  SUBSYSTEM
    If this is "block", it's a block device.  Anything else is a char device.

The following variables are also provided for some devices:

  MAJOR and MINOR
    If these are present, a device node can be created in /dev for this device.
    Some devices (such as network cards) don't generate a /dev node.

    [QUESTION: Any way to get the default name?]

  DRIVER
    If present, a suggested driver (module) for handling this device.  No
    relation to whether or not a driver is currently handling the device.

  INTERFACE and IFINDEX
    When SUBSYSTEM=net, these variables indicate the name of the interface
    and a unique integer for the interface.  (Note that "INTERFACE=eth0" could
    be paired with "IFINDEX=2" because eth0 isn't guaranteed to come before lo
    and the count doesn't start at 0.)

  FIRMWARE
    The system is requesting firmware for the device.  See "Firmware loading"
    below.

Injecting events into hotplug via "uevent":
===========================================

Events can be injected into the hotplug mechanism through sysfs via the
"uevent" files.  Each directory in sysfs containing a "dev" file should also
contain a "uevent" file.

Note that in newer kernel versions, "uevent" is readable.  Reading from uevent
provides the set of "extra" variables associated with this event.

Firmware loading
================

If the hotplug variable FIRMWARE is set, the kernel is requesting firmware
for a device (identified by $DEVPATH).  To provide the firmware to the kernel,
do the following:

  echo 1 > /sys/$DEVPATH/loading
  cat /path/to/$FIRMWARE > /sys/$DEVPATH/data
  echo 0 > /sys/$DEVPATH/loading

Note that "echo -1 > /sys/$DEVPATH/loading" will cancel the firmware load
and return an error to the kernel, and /sys/class/firmware/timeout contains a
timeout (in seconds) for firmware loads.

See Documentation/firmware_class for more information.

Loading firmware for statically linked devices
==============================================

An advantage of the usermode helper hotplug mechanism is that if initramfs
contains an executable /sbin/hotplug, it can be called even before the kernel
runs init.  This allows /sbin/hotplug to supply firmware (out of initramfs) to
statically linked device drivers.  (The netlink mechanism requires a daemon to
listen to a socket, and such a daemon cannot be spawned before init runs.)

For licensing reasons, binary-only firmware should not be linked into the
kernel image, but instead placed in an externally supplied initramfs which
can be passed to the Linux kernel through the old initrd mechanism.
See Documentation/filesystems/ramfs-rootfs-initramfs.txt for details.

stable_api_nonsense:
====================

Note: Sysfs exports a lot of kernel internal state, and the maintainers of
sysfs do not believe that exposing information to userspace for use by
userspace programs constitues an "API" that must be "stable".  The sysfs
infrastructure is maintained by the author of
Documentation/stable_api_nonsense.txt, who seems to believe it applies to
userspace as well.  Therefore, at best only a subset of the information in
sysfs can be considered stable from version to version.

The information documented here should remain stable.  Some other parts of
sysfs are documented under Documentation/API, although that directory comes
with a warning that anything documented there can go away after two years.
Any other information exported by sysfs should be considered debugging info
at best, and probably shouldn't have been exported at all since it's not a
"stable API" intended for use by actual programs.

--Boundary-00=_j6SnGZq4lIYQRnZ--
