Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXDPA5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXDPA5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXDPA5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:57:14 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:38468 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXDPA5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:57:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: Sun, 15 Apr 2007 18:57:02 -0600
User-Agent: KMail/1.9.5
Cc: "Jean Delvare" <khali@linux-fr.org>, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, "Chuck Ebbert" <cebbert@redhat.com>
References: <45D5EA88.7090300@redhat.com> <200704151431.41503.bjorn.helgaas@hp.com> <68676e00704151359g18bf6935wcb2144bcbcf4edd2@mail.gmail.com>
In-Reply-To: <68676e00704151359g18bf6935wcb2144bcbcf4edd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151857.03115.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 14:59, Luca Tettamanti wrote:
> On 4/15/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > But I missed the details, such as the specific devices in question,
> > which ports they use, how they are described in ACPI, which AML
> > methods use those ports, and which non-ACPI drivers also use them.
> 
> The original report was about the temperature sensors of K8 cpus. It
> happens that ACPI reads the sensors while the linux driver is using it
> and gets garbage (and shut down the system). The problem is more
> generic though, and applies to all hardware monitoring chips for which
> a driver exists.

Yes, I saw that much, but that's not enough detail to craft a good
solution.

In the case of k8temp, the driver claims PCI devices with a certain
vendor and device ID.  PCI devices are mostly outside the scope of
ACPI.  There's a standard enumeration protocol, and a driver should
be able to claim any device it recognizes without fear of conflict.

I claim that an AML method that accesses a PCI device is
defective because the AML can't know whether a native driver
has claimed the device.

Sometimes the firmware can hide PCI devices so the OS
enumeration doesn't find them.  In that case, AML might
be able to safely use the PCI device, but the native
driver wouldn't be able to claim the device, so there
would be no conflict.  (Linux sometimes uses quirks to
"unhide" things like this, which could lead to a conflict
of our own making.)

I suspect that other sensor drivers may just probe for devices
at "known" addresses hard-coded in the driver.  This is a
problem because the ACPI model is that the OS learns about
all built-in devices via the ACPI namespace.  If it isn't
in the namespace, it shouldn't exist as far as the OS is
concerned.

So we could easily have the situation where ACPI uses a
sensor and does not expose it to the OS in the namespace.
In that case, the firmware expectation is that the OS
won't touch the device.  If the OS pokes around at the
magic addresses and happens to trip over the device, we
just made ourselves a problem.

> > It also sounds like the non-ACPI drivers provide much more
> > functionality than ACPI exposes.  I'd like to understand this,
> > too, because an  obvious way to solve the problem would be to
> > drop the non-ACPI drivers.
> 
> Problem is that ACPI may access the sensors anyway (e.g. via SMM).

If ACPI accesses sensors but there is no native driver, there
should be no conflict.

> > Is this extra functionality available
> > on Windows?  If so, do we know whether Windows uses non-ACPI drivers
> > or whether they have some smarter way to use ACPI?
> 
> Usually ACPI exposes 1 or 2 temperature readings (CPU and
> motherboard), while the hw driver can also provide fans and voltages
> measurements.
> 
> Vendors usually provides a monitoring utility for Win that also
> exposes these information. It's not known whether there's a way to
> avoid conflicting accesses between ACPI and the raw driver; it's
> possible that it's vendor-specific and not documented.

I'd be surprised if Windows provided interfaces to coordinate
between two drivers.  My impression is that they really want
to have a single owner for a piece of hardware.  It would be
interesting to figure out how these monitoring utilities work.
Maybe the monitor and the AML both go through an embedded
controller driver and coordinate that way?

Bjorn
