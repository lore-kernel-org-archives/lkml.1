Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZGWSiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZGWSiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZGWSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:38:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50644 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752400AbZGWSiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:38:04 -0400
Date: Thu, 23 Jul 2009 14:38:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: [Security] Should open TTY device files pin minor numbers?
Message-ID: <Pine.LNX.4.44L0.0907231421390.3509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent work in the TTY core and in usb-serial has caused a change 
in behavior between 2.6.30 and 2.6.31-rc.  Namely, if a USB serial 
device is unplugged while a process holds the device file open, the 
minor number won't get reused until the process closes the file.

For example, if you run minicom over /dev/ttyUSB0, unplug the USB
device while minicom is running, and then plug it in again before
exiting minicom, it will reappear as /dev/ttyUSB1 instead of
/dev/ttyUSB0 (which will be gone).

Although this sort of behavior is very common in other subsystems,
users don't expect it of serial devices.  So I posted a patch to change
the behavior: usb-serial will release the device's minor number when
the disconnect occurs instead of waiting for all the open file
references to be closed.

There have been objections to this patch, based on security
considerations.  Reuse of the minor number means that there is a race.  
For a brief time after the device is removed, the device node will
remain in the file system.  If a new device appears during that time
and is assigned the same minor number, a process could open the new
device via the old node, subject only to the permissions checks meant 
for the old device.

Of course, this race is not new.  The same race is present even without
my patch, if the device is unplugged while the device file is not open.  
Maybe it's a little more likely to occur with the patch, since the
opportunity will be there whether the file is open or not.

So, should the patch be accepted?  I don't think it raises any undue 
risk, but other people might disagree.

And if the patch is not accepted then shouldn't the TTY drivers be
changed to avoid reusing minor numbers in all cases, even when the
device file isn't open?  Or at a minimum, shouldn't usb-serial do this?

Alan Stern

