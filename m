Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXDOJm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXDOJm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXDOJm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:42:56 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:2035 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468AbXDOJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:42:55 -0400
Date: Sun, 15 Apr 2007 11:41:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070415114159.05026483@hyperion.delvare>
In-Reply-To: <200704131459.45867.bjorn.helgaas@hp.com>
References: <45D5EA88.7090300@redhat.com>
	<200704131218.44045.bjorn.helgaas@hp.com>
	<20070413200746.GD28264@elf.ucw.cz>
	<200704131459.45867.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Fri, 13 Apr 2007 14:59:45 -0600, Bjorn Helgaas wrote:
> On Friday 13 April 2007 14:07, Pavel Machek wrote:
> > > > ... The primary issue is the concurrent access
> > > > to resources, which cause lots of trouble which are hard to investigate.
> > > > If ACPI reserves the ports, then the SMBus or hardware monitoring
> > > > drivers (or any other conflicting driver) will cleanly fail to load,
> > > > which would be a move in the right direction. ...
> > > > 
> > > > So, can ACPI actually reserve the ports it accesses?
> > > 
> > > Sorry to join this discussion so late.
> > > 
> > > ACPI tells us the resources used by devices.  Today, we don't
> > > reserve
> > 
> > Problem seems to be that ACPI does _not_ tell us which ports it
> > accesses from AML code.
> 
> I think that would violate at least the spirit of the ACPI spec.
> The example in section 11.6 of the ACPI 3.0 spec shows a _TMP
> method that runs an EC method to read the temp, and the EC ioport
> usage is correctly declared in the EC device's _CRS method.
> 
> Of course, there are always BIOS defects.  But if we could make a
> case that a BIOS that doesn't declare the resources used by the AML
> is defective, we could add quirks to reserve the undeclared resources.

Only realistic if the list of systems needing a quirk is small. Do you
think that would be the case?

> > But we already found a lock we can take; AFAICT we know how to solve
> > this problem.

We even have two solutions, but both have drawbacks.

The AML lock solution has performance issue. It could be improved with a
better semaphore primitive, but that needs to be implemented first. It
also requires to modify all drivers ACPI might conflict with, and
that's a rather long list.

Rudolf Marek's port forwarding idea should perform better, and might
also be useful for other problems than ACPI vs. regular drivers,
however it makes resources bigger, and requires to modify the same long
list of drivers, and with specific code for every driver. I'm not sure
that it will be possible for all driver in practice, as this more or
less requires to forecast the I/O access pattern of ACPI.

> This might solve it, but doesn't seem like a clean way to do it.
> I don't like the idea of sharing a lock between drivers and ACPI.
> k8temp happens to be x86-dependent, so we'll always have ACPI, but
> in principle, we could have the same problem with an arch-independent
> PCI driver that only has ACPI on x86 and ia64 platforms.

We can protect the additional driver code with #ifdef CONFIG_ACPI, as I
did in my proof-of-concept. Not particularly elegant, granted, but it
should work.

If something cleaner can be done, I'm all for it. Could you please
propose an implementation of your idea? It doesn't need to be perfect,
but I would like to see what it would look like.

> (BTW, if Chuck's problem was solved by the BIOS update, I assume
> there *is* another instance of the problem that we're trying to
> solve with this lock.)

Yes, there are several other systems out there which are known to be
affected by the problem. And probably many others where ACPI access I/O
ports reserved by regular drivers and we are simply lucky that nothing
bad happens. My desktop system has such a motherboard (Jetway K8M8MS).
But SMP alternatives are becoming more popular, so we might start
seeing more problems in practice in a near future.

-- 
Jean Delvare
