Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0CEV5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:57:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0CEV5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:57:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with remote-wakeup settings
Date: Fri, 5 Mar 2010 22:59:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-input@vger.kernel.org, linux-hotplug@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003051546370.1384-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003051546370.1384-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003052259.30365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 March 2010, Alan Stern wrote:
> On Fri, 5 Mar 2010, Rafael J. Wysocki wrote:
> 
> > On Friday 05 March 2010, Alan Stern wrote:
> > > The way we implement remote wakeup has got some problems.
> > > 
> > > Here's a brief summary of the way it currently works.  Each dev->power
> > > structure contains two bitflags: can_wakeup and should_wakeup.
> > > 
> > > 	The can_wakeup flag indicates whether the device is _capable_
> > > 	of issuing wakeup requests; it is supposed to be set by the
> > > 	driver.
> > 
> > No, it is not.  Perhaps that was the original idea, but we don't use it this
> > way, at least not for PCI devices.  It actually is set by the subsystem (the
> > PCI bus type in this particular case) depending on whether or not the device
> > is capable of waking up the system.
> > 
> > The reason is that for PCI the information needed to decide belongs to the
> > PCI core rather than to the driver.
> 
> Wherever I wrote "driver", interpret it as meaning "driver or
> subsystem".  You're right, in many or most cases can_wakeup is set by
> the subsystem and not the driver.

OK

> > > 	The should_wakeup flag indicates whether the device should be
> > > 	_allowed_ to issue wakeup requests.  This is a policy decision
> > > 	which generally should be left up to userspace, through the
> > > 	/sys/devices/.../power/wakeup sysfs attribute.
> > 
> > That is supposed to work more-or-less this way, although there's the exception
> > of some network adapters that enable WoL by default _if_ the device can wake up
> > (ie. its can_wakeup flag is set by the PCI core).  For the network adapters
> > there's an alternative way to set this via ethtool and it should be in
> > agreement with the sysfs setting.
> 
> Agreed, ethtool and sysfs should affect the same flags.

Yeah, but.  Right now, if the setting is changed via sysfs, it doesn't modify
the WoL setting as visible by ethtool.

> > > There are various routines defined in include/linux/pm_wakeup.h for
> > > manipulating these flags.  In particular, device_may_wakeup() tells
> > > whether or not the device's wakeup facility should be enabled by the
> > > driver's suspend routine when a system sleep starts.  It returns true
> > > only when both flags are set.
> > 
> > Right.
> > 
> > > (Wakeup settings during runtime suspend are a different matter; I'm not
> > > going to discuss them here.)
> > 
> > OK
> > 
> > > The first problem is that device_initialize() calls 
> > > device_init_wakeup(), setting both flags to 0.  This is simply a 
> > > mistake.  For one thing, the bits should have been initialized to 0 
> > > when the device structure was kzalloc'ed.  For another, it means that 
> > > drivers can't usefully set the can_wakeup flag before doing either 
> > > device_initialize() or device_register().
> > 
> > For PCI devices can_wakeup is set by the PCI core and drivers shouldn't really
> > modify it, because it is the source of information about the device's
> > capability to wake up _for_ _them_.
> 
> So the problem is that subsystems can't usefully set the can_wakeup 
> flag before doing either device_initialize() or device_register().  
> This can be fixed easily by removing the call in device_initialize().

PCI depends on the flag being unset when pci_pm_init(dev) is called.

If that's still valid after removing the call in device_initialize(), I'm fine
with the removal.

> > > The next problem has to do with the sysfs interface.  The power/wakeup 
> > > attribute file is implemented to contain either "enabled" or "disabled" 
> > > (according to the should_wakeup flag) if can_wakeup is set, and to be 
> > > empty if can_wakeup is clear.  Userspace can write "enabled" or 
> > > "disabled" to the file to set or clear the should_wakeup flag.
> > > 
> > > This is bad, because it means the should_wakeup setting is invisible 
> > > when can_wakeup is off.  Userspace certainly will want to affect the 
> > > should_wakeup flag at times when can_wakeup is off (for example, before 
> > > the device has finished binding to its driver).
> > 
> > Well, the network adapters mentioned above are a bit of a problem here,
> > because they'd have to be reworked to look at should_wakeup before enabling
> > WoL by default.
> 
> IMO they _should_ test device_may_wakeup() before setting WoL.  That's 
> its whole purpose.
> 
> And also IMO, enabling WoL by default is very questionable.  But that's 
> a separate matter.

That's been a common practice for years in the network adapter land and I don't
think we're able to change that now.  Besides, if the WoL is set to g by
default, which also is common, that doesn't really lead to any problems.

> > Apart from that, changing the interface as proposed if fine by me.
> > 
> > 
> > > The third problem concerns the initial or default should_wakeup
> > > setting.  There isn't any coherent thought about what value the flag 
> > > should have before userspace takes control of it.
> > > 
> > > In many cases setting a default value isn't feasible.  Only the driver
> > > is in a position to know whether or not the device should be allowed to
> > > issue wakeup requests, but by the time the driver binds to the device,
> > > the power/wakeup attribute has already been exposed through sysfs.  
> > > Any change the driver makes might therefore overwrite the user's
> > > preference.  Hence drivers should not be allowed to change the
> > > should_wakeup flag.  Unfortunately many drivers do exactly that, as
> > > can be seen by searching for "device_set_wakeup_enable" or
> > > "device_init_wakeup".
> > > 
> > > In principle, the decision about setting should_wakeup ought to be left
> > > entirely up to userspace.
> > 
> > I agree in general, but there's the question whether or not the sysfs setting
> > should be tied to the WoL setting done via ethtool.  On the one hand it
> > shouldn't, because we have no means to update the driver's settings (ie. WoL)
> > if the sysfs attribute is set.
> 
> I don't understand.  Do you mean there's no way to update the
> _device's_ WoL setting when the sysfs attribute is changed?

There's no code for that, that's the problem.

> The device's WoL setting matters only at suspend time.  So the network
> driver's suspend routine ought to test device_may_wakeup() to see
> whether or not WoL should be enabled.  Maybe this can be centralized 
> somewhere in the network stack.

Maybe.  The problem is people expect wakeup to work once WoL has been set
with the help of ethtool and they expect it to work if the WoL is set by
default.

> >  On the other hand it should, because the users
> > expect that to happen (yes, they do).
> 
> And so do I!
> 
> > > In practice, userspace doesn't do a very good job of carrying out this
> > > decision.  Programs like udev or hal ought to impose useful settings, but
> > > as far as I know, they do not.
> > > 
> > > And then what about systems that don't have udev?  Presumably embedded
> > > systems can be trusted to set up the wakeup flags appropriately for
> > > their own needs.  Is there a significant number of other systems
> > > without udev?  And even if there isn't, the necessary changes to udev
> > > would take a while to percolate out.
> > > 
> > > So we have a situation where the kernel is defining policy which should
> > > be set by userspace, and doing so in a way which would often override
> > > the user's settings.  Clearly this isn't good.  The only sane approach
> > > I can think of is for the kernel never to change should_wakeup --
> > > always leave it set to 0 until userspace changes it.  (There could be a
> > > few exceptions for devices which everyone always expects to be
> > > wakeup-enabled, such as power buttons and keyboards.)  But then of
> > > course we would have the problem that in today's distributions,
> > > userspace never does change it.
> > > 
> > > The lack of a proper design for all this has already started to cause 
> > > problems.  There are bug reports about systems failing to suspend 
> > > because some device, enabled for remote wakeup when it shouldn't be,
> > > sends a wakeup request as soon as it gets suspended.  One example of 
> > > such a bug report is
> > > 
> > > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/515109
> > > 
> > > What do people think?
> > 
> > Hard to say what's the best approach here in general.
> > 
> > If we unset should_wakeup by default for all devices, the users of some drivers
> > (mostly network ones) expecting wakeup to be enabled by default will report
> > regressions.  If we don't unset it for all devices, we'll need to do that
> > individually for the drivers where there are known bad devices.
> > 
> > I guess it's better if drivers don't set should_wakeup if unsure, but of course
> > that's impossible to enforce.
> 
> That's the real question.  Ideally, drivers won't touch should_wakeup.  
> How do we get there from here?

The WoL problem is still in the way, exactly because it can be set using
ethtool.

IMO, we should set should_wakeup if the WoL is set via ethtool.  We also should
unset the WoL if should_wakeup is unset via sysfs (we're missing that piece
right now).   Generally speaking, it should work transparently both ways.

Now, if the driver's policy is to set WoL to g, for example, by default, how is
this different from setting it via ethtool?

Rafael
