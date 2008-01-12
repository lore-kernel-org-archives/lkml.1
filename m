Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbYALJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbYALJtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbYALJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:49:26 -0500
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:59745 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751620AbYALJtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:49:25 -0500
Date: Sat, 12 Jan 2008 10:49:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Shaohua Li" <shaohua.li@intel.com>, "Mike Houston" <mikeserv@bmts.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Elvis Pranskevichus" <el@prans.net>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       "Adam Belay" <ambx1@neo.rr.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Thomas Renninger" <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Message-ID: <20080112104921.4736d3be@hyperion.delvare>
In-Reply-To: <200801021130.56395.bjorn.helgaas@hp.com>
References: <Va0NwseF.1198618285.6089960.khali@gcu-squad.org>
	<200801021130.56395.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Sorry for the late answer.

On Wed, 2 Jan 2008 11:30:55 -0700, Bjorn Helgaas wrote:
> Even if the BIOS does not declare an IT87xxF as an independent device,
> there may be AML that uses the chip internally.  For example, the
> BIOS could declare a thermal zone with a _TMP method, and the _TMP
> method could use the IT87xxF to read the temperature.  In that case,
> the BIOS would still need to declare the IT87xxF resources so the OS
> doesn't place another device on top of it.

Thomas Renninger's patch set should handle this case. It's in -mm at the
moment and I guess we'll merge most of it in 2.6.25.

> (...) An easy way to do this
> is with a PNP0C02 "motherboard" device, which just says "these
> resources are in use, but the OS needn't attach a driver to this
> device."

How do I see if a given motherboard does this or not? For example I
have a motherboard here that says:

0290-029f : pnp 00:04

How do I know if this is a "PNP0C02 motherboard device" I am supposed
not to touch, or a device that I can attach a native hwmon driver to?
And more importantly, how does the it87 driver (or any other hwmon
driver) know about it? I'm all for updating the hwmon drivers to
cooperate better with PNP in order to prevent clashes between the BIOS
and the OS, but I just don't know how I am supposed to do that.

> > And what "collision" are you talking about? 
> 
> I meant the problem where we place two devices at the same address,
> causing one to stop working.  I wrote "even if it87 isn't present,"
> which is ambiguous -- I meant that we need something that works even
> when the it87 _driver_ isn't present.

I agree then. I don't think this has much to do with PNP though. What
this is calling for is a Super-I/O subsystem that detects the Super-I/O
and instantiate devices out of it. That way the drivers for these
devices (in particular hardware monitoring drivers, watchdog drivers,
some parport drivers...) would no longer need to instantiate their
devices themselves, thus matching the device driver model much better.
I've seen patches float around but so far I could never find the time
to look into them (and I fear it's unlikely to change anytime soon.)

> (...)
> Well, it's true that PNP does not need to describe ALL devices in the
> system.  However, it should describe all devices to which the OS should
> bind a driver.  The BIOS writer has the discretion to hide devices from
> the OS by omitting them from the ACPI namespace.  If he does that, his
> assumption is that the OS will ignore the device (but of course, he's
> thinking about a Plug-and-Play-compliant OS like Windows).

Even under Windows, I pretty much doubt that any monitoring application
cares about what the BIOS says. Motherboard vendor applications have
enough information about each board model to know what they can do or
not without asking the BIOS. Third-party applications probably just
poke at known I/O locations (pretty much like the Linux hwmon drivers
do) and hope for the best.

> (...)
> I think my patch to request only the ports actually used by the it87
> driver is sufficient to solve the current problem.  If we find that
> a BIOS neglects to reserve some of the ports decoded by the IT87xxF,
> we can add a PNP quirk to handle that.  But I'm not aware of any
> problems like that yet.

I'm not aware of such a problem either.

-- 
Jean Delvare
