Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYABSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYABSbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYABSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:31:10 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9238 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYABSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:31:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Date: Wed, 2 Jan 2008 11:30:55 -0700
User-Agent: KMail/1.9.6
Cc: "Shaohua Li" <shaohua.li@intel.com>, "Mike Houston" <mikeserv@bmts.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Elvis Pranskevichus" <el@prans.net>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       "Adam Belay" <ambx1@neo.rr.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Thomas Renninger" <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <Va0NwseF.1198618285.6089960.khali@gcu-squad.org>
In-Reply-To: <Va0NwseF.1198618285.6089960.khali@gcu-squad.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801021130.56395.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 December 2007 02:31:26 pm Jean Delvare wrote:
> Le 23/12/2007, "Bjorn Helgaas" <bjorn.helgaas@hp.com> a écrit:
> >On Sunday 23 December 2007 2:28:05 am Jean Delvare wrote:
> >> The problem is that the it87 driver is used on a variety of motherboards,
> >> some where the hardware monitoring device I/O ports are reserved by the
> >> BIOS, some where they aren't. How am I supposed to deal with this?
> >
> >I assume you mean some boards describe those ports in ACPI, and some
> >don't?
> 
> Yes, that's what I meant.
> 
> >(...) I think the ideal solution would be to figure out how the
> >BIOS writers intended the device to be used, and do that.  But the
> >documentation may be lacking, and it degenerates into an OEM-specific
> >mess.  Second-best seems like a PNP quirk that pokes enough to determine
> >that a Super I/O device is present, and then reserves resources for
> >it.  Then we avoid the collision even if it87 isn't present.
> 
> I'm not sure what you mean here exactly. We have two different cases:
> either the ACPI code did declare the PNP device, or it did not. How do
> you unify both?

Even if the BIOS does not declare an IT87xxF as an independent device,
there may be AML that uses the chip internally.  For example, the
BIOS could declare a thermal zone with a _TMP method, and the _TMP
method could use the IT87xxF to read the temperature.  In that case,
the BIOS would still need to declare the IT87xxF resources so the OS
doesn't place another device on top of it.  An easy way to do this
is with a PNP0C02 "motherboard" device, which just says "these
resources are in use, but the OS needn't attach a driver to this
device."

> And what "collision" are you talking about? 

I meant the problem where we place two devices at the same address,
causing one to stop working.  I wrote "even if it87 isn't present,"
which is ambiguous -- I meant that we need something that works even
when the it87 _driver_ isn't present.

> >> PCI is an entirely different beast. With PCI you know the PCI device ID
> >> that is associated with the resources, and for a given device, the
> >> resources are always declared (if standard BARs are used) or never
> >> declared; there's no "may be". So it's much easier to handle the
> >> resources properly.
> >
> >That's the way PNP is supposed to work, too (more about this below).
> 
> Not really. PNP devices may or may not be declared. PCI devices are
> always declared. This is a fundamental difference. I'm also not sure
> about the PNP IDs, see below.

Well, it's true that PNP does not need to describe ALL devices in the
system.  However, it should describe all devices to which the OS should
bind a driver.  The BIOS writer has the discretion to hide devices from
the OS by omitting them from the ACPI namespace.  If he does that, his
assumption is that the OS will ignore the device (but of course, he's
thinking about a Plug-and-Play-compliant OS like Windows).

> >> That's not really safe, no. They may overlap with other device resources
> >> and prevent those drivers from loading.
> >
> >True.  If that happens, I think we definitely need some kind of DMI-
> >based quirk to fix the resources.  My points are (a) the quirk needs
> >to be at the PNP level; it can't be in a driver, and (b) I'm lazy and
> >would wait until a problem happens before implementing it, because I
> >know so little about PNP and the specific board, and by waiting, there's
> >a chance I'll learn enough to avoid a mistake :-)
> 
> But we _do_ have a problem to solve! That's what started this thread.
> And we need to solve it before 2.6.24 is released. I'd rather (try to)
> do the right thing now rather than going in one direction today and
> doing something different next month.

I think my patch to request only the ports actually used by the it87
driver is sufficient to solve the current problem.  If we find that
a BIOS neglects to reserve some of the ports decoded by the IT87xxF,
we can add a PNP quirk to handle that.  But I'm not aware of any
problems like that yet.

> >it87 doesn't fit the model very well because usually the BIOS
> >doesn't describe the device explicitly.  I think the expectation
> >is that the OS will get sensor readings some other way, such as
> >by evaluating ACPI "_TMP" methods, or by using some OEM-specific
> >ACPI device.
> 
> If the IT87xxF device is declared, will it always the same PNP ID on
> every system? I fear that the answer is no, in which case I see no
> simple way to implement the it87 driver as a PNP driver.

PNP drivers can claim multiple PNP IDs, e.g., drivers/serial/8250_pnp.c
recognizes many IDs for 16550-compatible UARTs.  But I doubt that
any BIOS actually describes an IT87xxF explicitly.

Bjorn
