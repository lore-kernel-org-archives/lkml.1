Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0CFEeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 23:34:11 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55562 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab0CFEeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 23:34:09 -0500
Date: Fri, 5 Mar 2010 23:34:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <linux-input@vger.kernel.org>, <linux-hotplug@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with remote-wakeup settings
In-Reply-To: <201003052259.30365.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003052316290.10381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Rafael J. Wysocki wrote:

> > So the problem is that subsystems can't usefully set the can_wakeup 
> > flag before doing either device_initialize() or device_register().  
> > This can be fixed easily by removing the call in device_initialize().
> 
> PCI depends on the flag being unset when pci_pm_init(dev) is called.
> 
> If that's still valid after removing the call in device_initialize(), I'm fine
> with the removal.

It should still be valid.  After all, there's nothing else to set the
flag except for other parts of the PCI core.


> > Agreed, ethtool and sysfs should affect the same flags.
> 
> Yeah, but.  Right now, if the setting is changed via sysfs, it doesn't modify
> the WoL setting as visible by ethtool.

> > I don't understand.  Do you mean there's no way to update the
> > _device's_ WoL setting when the sysfs attribute is changed?
> 
> There's no code for that, that's the problem.
> 
> > The device's WoL setting matters only at suspend time.  So the network
> > driver's suspend routine ought to test device_may_wakeup() to see
> > whether or not WoL should be enabled.  Maybe this can be centralized 
> > somewhere in the network stack.
> 
> Maybe.  The problem is people expect wakeup to work once WoL has been set
> with the help of ethtool and they expect it to work if the WoL is set by
> default.

It's not difficult in theory to tie together the WoL setting and the
wakeup flag:

	If ethtool changes the WoL setting, the driver's ioctl handler
	should make the corresponding change to the wakeup flag.

	If ethtool queries the WoL setting, the ioctl handler should
	check the wakeup flag.  If the flag is off, it should report 
	that WoL is disabled; if the flag is on, it should report that 
	WoL is enabled.  (The same check should be made in the suspend
	routine.)

> > And also IMO, enabling WoL by default is very questionable.  But that's 
> > a separate matter.
> 
> That's been a common practice for years in the network adapter land and I don't
> think we're able to change that now.  Besides, if the WoL is set to g by
> default, which also is common, that doesn't really lead to any problems.

All right, we can declare that network drivers are allowed to enable
WoL by default (like keyboard drivers).  There shouldn't be any problem
provided they initialize the wakeup setting before registering the
network interface, so that the initialization doesn't override any 
action by udev.

> > That's the real question.  Ideally, drivers won't touch should_wakeup.  
> > How do we get there from here?
> 
> The WoL problem is still in the way, exactly because it can be set using
> ethtool.
> 
> IMO, we should set should_wakeup if the WoL is set via ethtool.  We also should
> unset the WoL if should_wakeup is unset via sysfs (we're missing that piece
> right now).   Generally speaking, it should work transparently both ways.

As I described above.

> Now, if the driver's policy is to set WoL to g, for example, by default, how is
> this different from setting it via ethtool?

Well, clearly there's a difference if the user _doesn't_ run ethtool.  
Apart from that, it's okay.

Alan Stern

