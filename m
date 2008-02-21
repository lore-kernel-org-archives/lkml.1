Return-Path: <linux-kernel-owner+w=401wt.eu-S935049AbYBUBBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049AbYBUBBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763432AbYBUBBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:01:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbYBUBBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:01:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 01:59:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Alexey Starikovskiy <aystarik@gmail.com>,
       Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802210113.05733.rjw@sisk.pl> <alpine.LFD.1.00.0802201617050.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201617050.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210159.11388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Linus Torvalds wrote:
> 
> On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > > Secondly, the one that people should use ("pci_choose_state()") doesn't 
> > > actually do what you claim it does. It does all kinds of wrong things, and 
> > > doesn't even take the target state into account at all. So look again.
> > 
> > Well, if platform_pci_choose_state() is defined, pci_choose_state() returns
> > its result and on ACPI systems that points to acpi_pci_choose_state(), so in
> > fact it does what I said (apart from the error path). 
> 
> Did you check closer?

Yes, I did.

> I repeat: acpi_pci_choose_state() (when called from pci_choose_state()) 
> doesn't even look at the target 'state'. It just blindly assumes that you 
> want the deepest sleep-state you can have.

acpi_pm_device_sleep_state() (that is called by acpi_pci_choose_state())
takes the target state directly from the ACPI layer.

We just want to get rid of the argument passed to ->suspend() eventually, but
there may be many _suspend_ states available (eg. "mem" and "standby") and
for each of them there may be different constraints on the device's state.  We
have to tell the driver which device states are possible in the target system
sleep state.  Right now we arbitrarily choose the one with the lowest power
usage - for given target system sleep state.

> Which happens to be correct for normal suspend, but means that if you want 
> to test other states (through '/sys/devices/.../power'), that sounds 
> broken.

This interface is not available any more (ie. there's only "wakeup" in
/sys/devices/.../power).

> I didn't check any closer, but go check it yourself. The short and sweet: 
> acpi_pci_choose_state() totally ignores its 'state' argument. Do you 
> really think that's correct?

Yes, I do.

> But yes, "pci_choose_state()' effectively does that too, apart from
> PM_EVENT_ON, which is never used. 
> 
> (But the whole and only point of pci_choose_state() was to do the 
> PM_EVENT_FREEZE thing differently, which it doesn't do, so I think the 
> real issue here is that the interface is really rather mis-designed)

You're wrong, sorry.  With PM_EVENT_FREEZE it wouldn't even be necessary.
It's there, because potentially there are many possibilities with
PM_EVENT_SUSPEND and in fact it shouldn't even be used with
PM_EVENT_FREEZE.

All of this is more or less orthogonal to the issue at hand, which boils down
to the fact that we use the _suspend_ callbacks for hibernation and we
shouldn't be doing that.

Thanks,
Rafael
