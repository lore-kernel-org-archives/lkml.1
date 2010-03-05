Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0CEQX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:23:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754901Ab0CEQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:23:26 -0500
Date: Fri, 5 Mar 2010 11:23:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <linux-input@vger.kernel.org>, <linux-hotplug@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Problems with remote-wakeup settings
Message-ID: <Pine.LNX.4.44L0.1003051020380.1677-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way we implement remote wakeup has got some problems.

Here's a brief summary of the way it currently works.  Each dev->power
structure contains two bitflags: can_wakeup and should_wakeup.

	The can_wakeup flag indicates whether the device is _capable_
	of issuing wakeup requests; it is supposed to be set by the
	driver.

	The should_wakeup flag indicates whether the device should be
	_allowed_ to issue wakeup requests.  This is a policy decision
	which generally should be left up to userspace, through the
	/sys/devices/.../power/wakeup sysfs attribute.

There are various routines defined in include/linux/pm_wakeup.h for
manipulating these flags.  In particular, device_may_wakeup() tells
whether or not the device's wakeup facility should be enabled by the
driver's suspend routine when a system sleep starts.  It returns true
only when both flags are set.

(Wakeup settings during runtime suspend are a different matter; I'm not
going to discuss them here.)


The first problem is that device_initialize() calls 
device_init_wakeup(), setting both flags to 0.  This is simply a 
mistake.  For one thing, the bits should have been initialized to 0 
when the device structure was kzalloc'ed.  For another, it means that 
drivers can't usefully set the can_wakeup flag before doing either 
device_initialize() or device_register().


The next problem has to do with the sysfs interface.  The power/wakeup 
attribute file is implemented to contain either "enabled" or "disabled" 
(according to the should_wakeup flag) if can_wakeup is set, and to be 
empty if can_wakeup is clear.  Userspace can write "enabled" or 
"disabled" to the file to set or clear the should_wakeup flag.

This is bad, because it means the should_wakeup setting is invisible 
when can_wakeup is off.  Userspace certainly will want to affect the 
should_wakeup flag at times when can_wakeup is off (for example, before 
the device has finished binding to its driver).


The third problem concerns the initial or default should_wakeup
setting.  There isn't any coherent thought about what value the flag 
should have before userspace takes control of it.

In many cases setting a default value isn't feasible.  Only the driver
is in a position to know whether or not the device should be allowed to
issue wakeup requests, but by the time the driver binds to the device,
the power/wakeup attribute has already been exposed through sysfs.  
Any change the driver makes might therefore overwrite the user's
preference.  Hence drivers should not be allowed to change the
should_wakeup flag.  Unfortunately many drivers do exactly that, as
can be seen by searching for "device_set_wakeup_enable" or
"device_init_wakeup".

In principle, the decision about setting should_wakeup ought to be left
entirely up to userspace.  In practice, userspace doesn't do a very
good job of carrying out this decision.  Programs like udev or hal
ought to impose useful settings, but as far as I know, they do not.

And then what about systems that don't have udev?  Presumably embedded
systems can be trusted to set up the wakeup flags appropriately for
their own needs.  Is there a significant number of other systems
without udev?  And even if there isn't, the necessary changes to udev
would take a while to percolate out.

So we have a situation where the kernel is defining policy which should
be set by userspace, and doing so in a way which would often override
the user's settings.  Clearly this isn't good.  The only sane approach
I can think of is for the kernel never to change should_wakeup --
always leave it set to 0 until userspace changes it.  (There could be a
few exceptions for devices which everyone always expects to be
wakeup-enabled, such as power buttons and keyboards.)  But then of
course we would have the problem that in today's distributions,
userspace never does change it.

The lack of a proper design for all this has already started to cause 
problems.  There are bug reports about systems failing to suspend 
because some device, enabled for remote wakeup when it shouldn't be,
sends a wakeup request as soon as it gets suspended.  One example of 
such a bug report is

	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/515109

What do people think?

Alan Stern

