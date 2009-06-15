Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZFOHgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZFOHgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFOHgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:36:44 -0400
Received: from rosi.naasa.net ([212.8.0.13]:43699 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZFOHgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:36:43 -0400
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [2.6.30] Kernel bug with dock driver
Date: Mon, 15 Jun 2009 09:36:39 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906142100.48621.jplatte@naasa.net> <20090615020226.GA30720@khazad-dum.debian.net>
In-Reply-To: <20090615020226.GA30720@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906150936.41983.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday, 15. June 2009 schrieb Henrique de Moraes Holschuh:
> Do it in single user mode with udev helpers *killed*, but just release

Today I tried to reproduce the bug in runlevel 2 (Debian based system) without 
success, even after a suspend to disk. In the past this was one method to 
trigger bugs with the bay.

> the lever, _don't_ pull the drive off the bay, unless you do verify that
> the bay LED went off.
>
> ***NEVER*** remove an Ultrabay device with the Ultrabay LED still lit,
> especially if it is a PATA device.

I did this accidentally some times before and the bay is still working. But 
I'll try to not to do it again :)

> If the bug cannot be reproduced in that condition, it is happening
> because userspace is trapping the lever release event (as it should),
> and doing something the kernel doesn't like with it (which is a bug
> in the kernel in any case).  That might help you track down a better
> way to reproduce the issue.

Userspace scripts are written by me (based on some information from 
thinkwiki). 
The udev rule looks like this:
ATTR{type}=="ata_bay", ATTR{docked}=="1", KERNEL=="dock.*", ACTION=="change", 
SUBSYSTEM=="platform", RUN+="/usr/local/sbin/ultrabay_open"

and ultrabay_open contains the following lines of shell code:
#!/bin/bash
ULTRABAY_SYSDIR='/sys/class/scsi_device/1:0:0:0/device'
shopt -s nullglob

if [ -d $ULTRABAY_SYSDIR ]; then
        sync
        echo 1 > $ULTRABAY_SYSDIR/delete
        logger "removed $ULTRABAY_SYSDIR"
fi
sync
# Turn off power to the UltraBay:
if [ -f /sys/devices/platform/dock.2/undock ]; then
        echo 1 > /sys/devices/platform/dock.2/undock
        logger "/sys/devices/platform/dock.2/undock"
else
        echo eject > /proc/acpi/ibm/bay
fi
# Tell the user we're OK
logger "/proc/acpi/ibm/beep"
echo 12 > /proc/acpi/ibm/beep

What I discovered today after modifying ultrabay_open was that in some cases 
the script is called again directly after inserting a drive to the bay. But 
only, if the execution of this script takes some more time (I added a sleep 2 
after the second sync to be able to see which command might trigger the bug).

So maybe yesterday this script was called twice and the kernel does not like 
to undock a device while it is in the process of being undocked? How should I 
modify the udev rule to prevent another execution each time a drive is 
inserted into the bay?

regards,
Jörg

